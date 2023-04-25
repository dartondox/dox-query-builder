import 'dart:mirrors';

import 'column.dart';

class TypeConverter {
  convert(instance, Map data) {
    final instanceMirror = reflect(instance);
    final classMirror = instanceMirror.type;
    for (var declarationMirror in classMirror.declarations.values) {
      if (declarationMirror is VariableMirror && !declarationMirror.isStatic) {
        Column column = getColumn(classMirror, declarationMirror.simpleName);
        instanceMirror.setField(
          declarationMirror.simpleName,
          data[column.name.toString()],
        );
      }
    }
    return instanceMirror.reflectee;
  }

  Map<String, dynamic> toMap(dynamic instance) {
    final instanceMirror = reflect(instance);
    final classMirror = instanceMirror.type;

    final instanceVariables = <String, dynamic>{};
    for (var declarationMirror in classMirror.declarations.values) {
      if (declarationMirror is VariableMirror && !declarationMirror.isStatic) {
        Column column = getColumn(classMirror, declarationMirror.simpleName);
        final value =
            instanceMirror.getField(declarationMirror.simpleName).reflectee;
        instanceVariables[column.name.toString()] =
            isDateTime(declarationMirror)
                ? (value as DateTime?)?.toIso8601String()
                : value;
      }
    }
    return instanceVariables;
  }

  bool isDateTime(declarationMirror) {
    return MirrorSystem.getName((declarationMirror.type.simpleName)) ==
        'DateTime';
  }

  Column getColumn(ClassMirror classMirror, Symbol symbol) {
    Map<Symbol, DeclarationMirror> fields = classMirror.declarations;

    DeclarationMirror? d = fields[symbol];
    if (d != null) {
      List<InstanceMirror> m =
          d.metadata.where((m) => m.type.reflectedType == Column).toList();
      bool isColumn = m.isNotEmpty;
      if (isColumn) {
        Column column = m.first.reflectee;
        if (column.name != null) {
          return column;
        }
      }
    }
    return Column(name: MirrorSystem.getName(symbol));
  }
}

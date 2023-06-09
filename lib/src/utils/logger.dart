import 'package:dox_query_builder/dox_query_builder.dart';

// coverage:ignore-file
class Logger {
  void log(String query, [dynamic params]) {
    query = query.replaceAll(RegExp(r'@\w+'), '?');
    params = _parseParams(params);
    QueryPrinter printer = SqlQueryBuilder().printer;
    printer.log(query, params);
  }

  List<String> _parseParams(dynamic params) {
    List<String> list = <String>[];
    if (params != null && (params as Map<String, dynamic>).isNotEmpty) {
      params.forEach((String key, dynamic value) {
        list.add(value.toString());
      });
    }
    return list;
  }
}

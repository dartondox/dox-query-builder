import 'dart:convert';

class Logger {
  int logLength = 80;

  void log(String query, [dynamic params]) {
    _topLine('QUERY ');
    _newEmptyLine();
    _wrapLine(query);
    _newEmptyLine();

    if (params != null && (params as Map<String, dynamic>).isNotEmpty) {
      _centerLine('PARAMS');
      List<String> param = _getPrettyJSONString(params).toString().split("\n");
      for (String i in param) {
        _wrapLine(i.toString());
      }
    }
    _bottomLine();
  }

  void _wrapLine(String line) {
    int len = logLength - 4;
    for (int i = 0; i < line.length; i += len) {
      String q =
          line.substring(i, i + len < line.length ? i + len : line.length);
      print("│\x1B[34m ${fillSpaceIfRequired(q)}\x1B[37m│");
    }
  }

  String fillSpaceIfRequired(String q) {
    if (q.length >= logLength - 2) {
      return q;
    }
    int requiredSpace = logLength - q.length - 2;
    String space = '';
    for (int i = requiredSpace; i >= 1; i--) {
      space += ' ';
    }
    return "$q$space";
  }

  void _newEmptyLine() {
    print("│${_drawLine('', separator: ' ').substring(0, logLength - 1)}│");
  }

  String _drawLine(String l, {String? separator}) {
    int len = logLength - l.length;
    String line = l;
    for (int i = len; i >= 1; i--) {
      line += separator ?? '─';
    }
    if (line.length > logLength) {
      return line.substring(0, logLength);
    }
    return line;
  }

  void _topLine(String title) {
    print("${_drawLine('┌── $title ')}┐");
  }

  void _centerLine(String title) {
    print("${_drawLine('├── $title ')}┤");
  }

  void _bottomLine() {
    print("${_drawLine('└')}┘");
  }

  String _getPrettyJSONString(Map<String, dynamic> jsonObject) {
    Map<String, dynamic> data = <String, dynamic>{};
    jsonObject.forEach((String key, dynamic value) {
      if (value.runtimeType.toString() == 'DateTime') {
        data[key] = (value as DateTime).toIso8601String();
      } else {
        data[key] = value;
      }
    });

    JsonEncoder encoder = JsonEncoder.withIndent("  ");
    return encoder.convert(data);
  }
}

import 'dart:convert';

class Logger {
  int logLength = 120;

  log(query, [dynamic params]) {
    _topLine('QUERY ');
    _newEmptyLine();
    _wrapLine(query);
    _newEmptyLine();

    if (params != null && (params as Map).isNotEmpty) {
      _centerLine('PARAMS');
      List<String> param = _getPrettyJSONString(params).toString().split("\n");
      for (var i in param) {
        _wrapLine(i);
      }
    }
    _bottomLine();
  }

  _wrapLine(line) {
    int len = logLength - 4;
    for (int i = 0; i < line.length; i += len) {
      String q =
          line.substring(i, i + len < line.length ? i + len : line.length);
      print("│\x1B[34m ${fillSpaceIfRequired(q)}\x1B[37m│");
    }
  }

  fillSpaceIfRequired(String q) {
    if (q.length >= logLength - 2) {
      return;
    }
    int requiredSpace = logLength - q.length - 2;
    String space = '';
    for (var i = requiredSpace; i >= 1; i--) {
      space += ' ';
    }
    return "$q$space";
  }

  _newEmptyLine() {
    print("│${_drawLine('', separator: ' ').substring(0, logLength - 1)}│");
  }

  String _drawLine(String l, {String? separator}) {
    int len = logLength - l.length;
    String line = l;
    for (var i = len; i >= 1; i--) {
      line += separator ?? '─';
    }
    if (line.length > logLength) {
      return line.substring(0, logLength);
    }
    return line;
  }

  _topLine(String title) {
    print("${_drawLine('┌── $title ')}┐");
  }

  _centerLine(String title) {
    print("${_drawLine('├── $title ')}┤");
  }

  _bottomLine() {
    print("${_drawLine('└')}┘");
  }

  String _getPrettyJSONString(jsonObject) {
    var encoder = JsonEncoder.withIndent("  ");
    return encoder.convert(jsonObject);
  }
}

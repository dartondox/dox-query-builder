DateTime now() {
  return DateTime.now().toUtc();
}

bool isEmpty(dynamic data) {
  if (data is List) {
    return data.isEmpty;
  }
  return data == null;
}

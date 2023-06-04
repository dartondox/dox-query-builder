DateTime now() {
  return DateTime.now().toUtc();
}

bool isEmpty(data) {
  if (data is List) {
    return data.isEmpty;
  }
  return data == null;
}

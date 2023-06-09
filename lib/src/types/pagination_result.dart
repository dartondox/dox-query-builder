class Pagination {
  final int total;
  final int perPage;
  final int lastPage;
  final int currentPage;
  // ignore: always_specify_types
  final List data;

  const Pagination({
    required this.total,
    required this.perPage,
    required this.lastPage,
    required this.currentPage,
    required this.data,
  });

  List<T> getData<T>() {
    return data as List<T>;
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'total': total,
      'per_page': perPage,
      'last_page': lastPage,
      'current_page': currentPage,
      'data': data,
    };
  }
}

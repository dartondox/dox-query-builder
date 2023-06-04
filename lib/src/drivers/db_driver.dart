abstract class DBDriver {
  Future<List<Map<String, Map<String, dynamic>>>> mappedResultsQuery(
      String query,
      {Map<String, dynamic>? substitutionValues});

  Future<void> query(String query, {Map<String, dynamic>? substitutionValues});
}

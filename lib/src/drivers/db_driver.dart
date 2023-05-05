abstract class DBDriver {
  Future<List<Map<String, Map<String, dynamic>>>> mappedResultsQuery(query,
      {Map<String, dynamic>? substitutionValues});

  Future query(query, {Map<String, dynamic>? substitutionValues});
}

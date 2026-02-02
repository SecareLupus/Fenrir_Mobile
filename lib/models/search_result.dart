class SearchResult {
  final String type;
  final String name;
  final String url;
  final String info;

  SearchResult({
    required this.type,
    required this.name,
    required this.url,
    required this.info,
  });

  factory SearchResult.fromJson(Map<String, dynamic> json) {
    return SearchResult(
      type: json['type'] ?? '',
      name: json['name'] ?? '',
      url: json['url'] ?? '',
      info: json['info'] ?? '',
    );
  }
}

class SearchResponse {
  final List<SearchResult> results;

  SearchResponse({required this.results});

  factory SearchResponse.fromJson(Map<String, dynamic> json) {
    final list = json['results'] as List? ?? [];
    return SearchResponse(
      results: list.map((e) => SearchResult.fromJson(e)).toList(),
    );
  }
}

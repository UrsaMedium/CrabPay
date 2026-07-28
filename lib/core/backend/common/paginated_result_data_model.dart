class PaginatedResult<T> {
  final List<T> objects;
  final bool hasMore;
  final String? nextPageToken;
  const PaginatedResult({
    required this.objects,
    required this.hasMore,
    this.nextPageToken,
  });
}

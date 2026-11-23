/// 一覧表示用の書類情報。
class DocumentSummary {
  const DocumentSummary({
    required this.id,
    required this.title,
    required this.category,
    required this.publishedAt,
  });

  final String id;
  final String title;

  /// 分類（例：安全、衛生、手順）。
  final String category;
  final DateTime publishedAt;
}

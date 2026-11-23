import 'document_summary.dart';
import 'tapped_word.dart';

/// L02 ホームに出す学習のまとめ。
class HomeSummary {
  const HomeSummary({
    required this.unansweredCount,
    required this.accuracyRate,
    required this.streakDays,
    required this.newDocuments,
    required this.topTappedWords,
  });

  /// 今日の未回答の問題数。
  final int unansweredCount;

  /// 正答率（0.0〜1.0）。まだ解いていなければ null。
  final double? accuracyRate;

  /// 連続学習日数。
  final int streakDays;

  /// 新しく公開された書類。
  final List<DocumentSummary> newDocuments;

  /// よくタップする単語（多い順）。
  final List<TappedWord> topTappedWords;
}

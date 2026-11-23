/// 学習者がタップした単語と回数。
class TappedWord {
  const TappedWord({
    required this.word,
    required this.reading,
    required this.tapCount,
  });

  final String word;

  /// 読み（ひらがな）。
  final String reading;
  final int tapCount;
}

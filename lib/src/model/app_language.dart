/// 表示言語（単語の意味・翻訳をどの言語で出すか）。
///
/// [label] はその言語自身での表記。学習者が自分の母語を見つけやすいようにする。
enum AppLanguage {
  ja('ja', '日本語'),
  en('en', 'English'),
  vi('vi', 'Tiếng Việt'),
  zh('zh', '中文'),
  ne('ne', 'नेपाली'),
  id('id', 'Bahasa Indonesia'),
  th('th', 'ภาษาไทย');

  const AppLanguage(this.code, this.label);

  /// ISO 639-1 の言語コード。
  final String code;

  /// 画面に表示する名前。
  final String label;
}

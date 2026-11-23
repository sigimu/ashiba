/// 画面遷移に使うパス定義。
///
/// 文字列リテラルを各所に散らさず、ここで一元管理する。
class RoutePath {
  const RoutePath._();

  static const String home = '/';
  static const String login = '/login';

  // 学習者向け（下部タブ）
  static const String documents = '/documents'; // マニュアル一覧
  static const String quiz = '/quiz'; // 問題を解く
  static const String wordbook = '/wordbook'; // 単語帳
  static const String progress = '/progress'; // 学習の記録

  // 管理者向け
  static const String admin = '/admin';
  static const String documentUpload = '/admin/documents/upload'; // 書類登録
  static const String glossary = '/admin/glossary'; // 用語集編集
  static const String questionReview = '/admin/questions/review'; // 問題の承認
}

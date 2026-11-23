import 'app_language.dart';

/// ログイン中のユーザー。
class AppUser {
  const AppUser({required this.id, required this.name, required this.language});

  /// kintone ユーザーテーブルのレコードID。
  final String id;

  /// 表示名（ホームのあいさつに使う）。
  final String name;

  /// 表示言語。
  final AppLanguage language;
}

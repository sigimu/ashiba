import '../../framework/error/result.dart';
import '../../model/app_language.dart';
import '../../model/app_user.dart';

/// 認証まわりのデータ取得。
///
/// 実装は自前サーバー経由で kintone を参照する想定。
/// サーバーができるまではモック実装を使う。
abstract interface class AuthRepository {
  /// ログインIDとパスワードで認証する。
  Future<Result<AppUser>> login({
    required String loginId,
    required String password,
    required AppLanguage language,
  });

  /// ログアウトする。
  Future<void> logout();
}

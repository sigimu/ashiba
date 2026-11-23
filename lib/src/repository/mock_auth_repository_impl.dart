import '../framework/error/errors.dart';
import '../framework/error/result.dart';
import '../model/app_language.dart';
import '../model/app_user.dart';
import 'interface/auth_repository.dart';

/// サーバー実装までの仮の認証。
///
/// デモ用アカウント: ID `demo` / パスワード `password`
class MockAuthRepositoryImpl implements AuthRepository {
  const MockAuthRepositoryImpl({
    this.delay = const Duration(milliseconds: 600),
  });

  /// 通信待ちを再現するための待ち時間。
  final Duration delay;

  static const _demoLoginId = 'demo';
  static const _demoPassword = 'password';

  @override
  Future<Result<AppUser>> login({
    required String loginId,
    required String password,
    required AppLanguage language,
  }) async {
    await Future<void>.delayed(delay);
    if (loginId != _demoLoginId || password != _demoPassword) {
      return const Failure(ValidationException('ログインIDまたはパスワードが違います'));
    }
    return Success(AppUser(id: 'u001', name: 'グエン・ヴァン・アン', language: language));
  }

  @override
  Future<void> logout() async {}
}

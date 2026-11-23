import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../framework/di/providers.dart';
import '../framework/error/result.dart';
import '../model/app_language.dart';
import '../model/app_user.dart';

/// ログイン中のユーザー。未ログインなら null。
final authStateProvider = NotifierProvider<AuthState, AppUser?>(AuthState.new);

class AuthState extends Notifier<AppUser?> {
  @override
  AppUser? build() => null;

  Future<Result<AppUser>> login({
    required String loginId,
    required String password,
    required AppLanguage language,
  }) async {
    final result = await ref
        .read(authRepositoryProvider)
        .login(loginId: loginId, password: password, language: language);
    if (result case Success(:final value)) {
      state = value;
    }
    return result;
  }

  Future<void> logout() async {
    await ref.read(authRepositoryProvider).logout();
    state = null;
  }
}

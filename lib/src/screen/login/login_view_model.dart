import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app_state/auth_state.dart';
import '../../app_state/language_state.dart';
import '../../framework/error/errors.dart';
import '../../framework/error/result.dart';

/// L01 ログイン画面の状態。
class LoginUiState {
  const LoginUiState({this.isLoading = false, this.errorMessage});

  final bool isLoading;
  final String? errorMessage;
}

final loginViewModelProvider =
    NotifierProvider.autoDispose<LoginViewModel, LoginUiState>(
      LoginViewModel.new,
    );

class LoginViewModel extends Notifier<LoginUiState> {
  @override
  LoginUiState build() => const LoginUiState();

  /// ログインする。成功すると authState が更新され、ルーターがホームへ移す。
  Future<void> login({
    required String loginId,
    required String password,
  }) async {
    if (state.isLoading) return;
    if (loginId.trim().isEmpty || password.isEmpty) {
      state = const LoginUiState(errorMessage: 'ログインIDとパスワードを入力してください');
      return;
    }

    state = const LoginUiState(isLoading: true);
    final result = await ref
        .read(authStateProvider.notifier)
        .login(
          loginId: loginId.trim(),
          password: password,
          language: ref.read(languageStateProvider),
        );
    if (!ref.mounted) return;

    state = switch (result) {
      Success() => const LoginUiState(),
      Failure(:final error) => LoginUiState(
        errorMessage: error is AppException
            ? error.message
            : 'ログインできませんでした。時間をおいてもう一度お試しください',
      ),
    };
  }
}

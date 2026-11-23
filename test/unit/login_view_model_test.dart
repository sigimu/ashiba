import 'package:ashiba/src/app_state/auth_state.dart';
import 'package:ashiba/src/app_state/language_state.dart';
import 'package:ashiba/src/framework/di/providers.dart';
import 'package:ashiba/src/model/app_language.dart';
import 'package:ashiba/src/repository/mock_auth_repository_impl.dart';
import 'package:ashiba/src/screen/login/login_view_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late ProviderContainer container;

  setUp(() {
    container = ProviderContainer.test(
      overrides: [
        authRepositoryProvider.overrideWithValue(
          const MockAuthRepositoryImpl(delay: Duration.zero),
        ),
      ],
    );
    // autoDispose なので購読して破棄されないようにする。
    container.listen(loginViewModelProvider, (_, _) {});
  });

  LoginViewModel viewModel() => container.read(loginViewModelProvider.notifier);

  test('未入力ならエラーを出し、認証しない', () async {
    await viewModel().login(loginId: ' ', password: '');

    expect(container.read(loginViewModelProvider).errorMessage, isNotNull);
    expect(container.read(authStateProvider), isNull);
  });

  test('IDかパスワードが違えばエラーを出す', () async {
    await viewModel().login(loginId: 'demo', password: 'wrong');

    final state = container.read(loginViewModelProvider);
    expect(state.isLoading, isFalse);
    expect(state.errorMessage, 'ログインIDまたはパスワードが違います');
    expect(container.read(authStateProvider), isNull);
  });

  test('正しければログインし、選んだ言語がユーザーに入る', () async {
    container.read(languageStateProvider.notifier).select(AppLanguage.vi);

    await viewModel().login(loginId: ' demo ', password: 'password');

    expect(container.read(loginViewModelProvider).errorMessage, isNull);
    final user = container.read(authStateProvider);
    expect(user, isNotNull);
    expect(user!.language, AppLanguage.vi);
  });
}

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app_state/auth_state.dart';
import '../../framework/di/providers.dart';
import '../../framework/error/result.dart';
import '../../model/home_summary.dart';

final homeViewModelProvider =
    AsyncNotifierProvider.autoDispose<HomeViewModel, HomeSummary>(
      HomeViewModel.new,
    );

/// L02 ホーム画面のデータ。
class HomeViewModel extends AsyncNotifier<HomeSummary> {
  @override
  Future<HomeSummary> build() async {
    // watch にするとログアウト直後に再取得が走りエラー表示が一瞬出るため read。
    // ユーザーが変わるときは画面ごと破棄（autoDispose）されるので問題ない。
    final user = ref.read(authStateProvider);
    if (user == null) throw StateError('ログインしていません');

    final result = await ref
        .read(learningRepositoryProvider)
        .fetchHomeSummary(userId: user.id);
    return switch (result) {
      Success(:final value) => value,
      Failure(:final error, :final stackTrace) => Error.throwWithStackTrace(
        error,
        stackTrace ?? StackTrace.current,
      ),
    };
  }

  /// 引っ張って更新。
  Future<void> refresh() async {
    ref.invalidateSelf();
    await future;
  }

  Future<void> logout() => ref.read(authStateProvider.notifier).logout();
}

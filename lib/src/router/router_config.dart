import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../app_state/auth_state.dart';
import 'route_path.dart';
import 'routes.dart';

/// アプリのルーター。
///
/// 未ログインならログイン画面へ、ログイン済みでログイン画面にいればホームへ
/// 自動で振り分ける。
final routerProvider = Provider<GoRouter>((ref) {
  // ログイン状態が変わったら redirect をやり直させる。
  final authChanged = ValueNotifier<int>(0);
  ref.listen(authStateProvider, (_, _) => authChanged.value++);

  final router = GoRouter(
    initialLocation: RoutePath.home,
    refreshListenable: authChanged,
    redirect: (context, state) {
      final loggedIn = ref.read(authStateProvider) != null;
      final atLogin = state.matchedLocation == RoutePath.login;
      if (!loggedIn) return atLogin ? null : RoutePath.login;
      if (atLogin) return RoutePath.home;
      return null;
    },
    routes: appRoutes,
  );

  ref.onDispose(() {
    router.dispose();
    authChanged.dispose();
  });
  return router;
});

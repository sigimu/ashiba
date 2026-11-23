import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../screen/login/login_screen.dart';
import '../widget/presentation/main_shell/main_shell.dart';
import '../widget/presentation/placeholder_view/placeholder_view.dart';
import 'route_path.dart';

/// ルート定義。
final List<RouteBase> appRoutes = [
  GoRoute(
    path: RoutePath.login,
    builder: (context, state) => const LoginScreen(),
  ),
  StatefulShellRoute.indexedStack(
    builder: (context, state, navigationShell) =>
        MainShell(navigationShell: navigationShell),
    branches: [
      _branch(
        RoutePath.home,
        const PlaceholderView(title: 'ホーム', icon: Icons.home_outlined),
      ),
      _branch(
        RoutePath.documents,
        const PlaceholderView(title: '書類', icon: Icons.description_outlined),
      ),
      _branch(
        RoutePath.quiz,
        const PlaceholderView(title: '問題', icon: Icons.quiz_outlined),
      ),
      _branch(
        RoutePath.wordbook,
        const PlaceholderView(title: '単語帳', icon: Icons.style_outlined),
      ),
      _branch(
        RoutePath.progress,
        const PlaceholderView(title: '学習の記録', icon: Icons.insights_outlined),
      ),
    ],
  ),
];

StatefulShellBranch _branch(String path, Widget screen) => StatefulShellBranch(
  routes: [GoRoute(path: path, builder: (context, state) => screen)],
);

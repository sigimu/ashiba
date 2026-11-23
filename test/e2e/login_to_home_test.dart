import 'package:ashiba/src/framework/di/providers.dart';
import 'package:ashiba/src/repository/mock_auth_repository_impl.dart';
import 'package:ashiba/src/repository/mock_learning_repository_impl.dart';
import 'package:ashiba/src/root.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

Widget _app() => ProviderScope(
  overrides: [
    authRepositoryProvider.overrideWithValue(
      const MockAuthRepositoryImpl(delay: Duration.zero),
    ),
    learningRepositoryProvider.overrideWithValue(
      const MockLearningRepositoryImpl(delay: Duration.zero),
    ),
  ],
  child: const Root(),
);

void main() {
  testWidgets('未ログインならログイン画面が出る', (tester) async {
    await tester.pumpWidget(_app());
    await tester.pumpAndSettle();

    expect(find.byKey(const Key('login_button')), findsOneWidget);
    expect(find.byType(NavigationBar), findsNothing);
  });

  testWidgets('ログインするとホームに移り、ログアウトで戻る', (tester) async {
    await tester.pumpWidget(_app());
    await tester.pumpAndSettle();

    await tester.enterText(find.byKey(const Key('login_id')), 'demo');
    await tester.enterText(find.byKey(const Key('password')), 'password');
    await tester.tap(find.byKey(const Key('login_button')));
    await tester.pumpAndSettle();

    expect(find.textContaining('こんにちは'), findsOneWidget);
    expect(find.text('のこり 8 問'), findsOneWidget);
    expect(find.byType(NavigationBar), findsOneWidget);
    await tester.scrollUntilVisible(find.text('確認'), 200);
    expect(find.text('確認'), findsOneWidget);

    await tester.tap(find.byTooltip('ログアウト'));
    await tester.pumpAndSettle();

    expect(find.byKey(const Key('login_button')), findsOneWidget);
  });
}

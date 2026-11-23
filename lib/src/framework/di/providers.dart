import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../repository/interface/auth_repository.dart';
import '../../repository/interface/learning_repository.dart';
import '../../repository/mock_auth_repository_impl.dart';
import '../../repository/mock_learning_repository_impl.dart';

/// Repository の差し込み口（DI）。
///
/// 本番実装に切り替えるときはここだけを書き換える。
/// テストでは `ProviderScope(overrides: [...])` で差し替える。
final authRepositoryProvider = Provider<AuthRepository>(
  (ref) => const MockAuthRepositoryImpl(),
);

final learningRepositoryProvider = Provider<LearningRepository>(
  (ref) => const MockLearningRepositoryImpl(),
);

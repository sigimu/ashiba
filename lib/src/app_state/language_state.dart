import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../model/app_language.dart';

/// 選択中の表示言語。ログイン前から選べるようにアプリ全体で持つ。
final languageStateProvider = NotifierProvider<LanguageState, AppLanguage>(
  LanguageState.new,
);

class LanguageState extends Notifier<AppLanguage> {
  @override
  AppLanguage build() => AppLanguage.ja;

  void select(AppLanguage language) => state = language;
}

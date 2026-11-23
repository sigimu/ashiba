import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../app_state/auth_state.dart';
import '../../model/document_summary.dart';
import '../../model/home_summary.dart';
import '../../model/tapped_word.dart';
import '../../router/route_path.dart';
import '../../widget/presentation/stat_tile/stat_tile.dart';
import 'home_view_model.dart';

/// L02 ホーム画面。
class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final summary = ref.watch(homeViewModelProvider);
    final userName = ref.watch(authStateProvider)?.name ?? '';

    return Scaffold(
      appBar: AppBar(
        title: const Text('ASHIBA'),
        actions: [
          IconButton(
            tooltip: 'ログアウト',
            icon: const Icon(Icons.logout),
            onPressed: () => ref.read(homeViewModelProvider.notifier).logout(),
          ),
        ],
      ),
      body: switch (summary) {
        AsyncData(:final value) => RefreshIndicator(
          onRefresh: () => ref.read(homeViewModelProvider.notifier).refresh(),
          child: _HomeBody(userName: userName, summary: value),
        ),
        AsyncError() => _ErrorView(
          onRetry: () => ref.invalidate(homeViewModelProvider),
        ),
        _ => const Center(child: CircularProgressIndicator()),
      },
    );
  }
}

class _HomeBody extends StatelessWidget {
  const _HomeBody({required this.userName, required this.summary});

  final String userName;
  final HomeSummary summary;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final accuracy = summary.accuracyRate;

    return ListView(
      // 項目が少なくても引っ張って更新できるようにする。
      physics: const AlwaysScrollableScrollPhysics(),
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
      children: [
        Text(
          'こんにちは、$userNameさん',
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 16),
        _TodayCard(unansweredCount: summary.unansweredCount),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: StatTile(
                icon: Icons.check_circle_outline,
                label: '正答率',
                value: accuracy == null ? '—' : '${(accuracy * 100).round()}',
                unit: accuracy == null ? null : '%',
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: StatTile(
                icon: Icons.local_fire_department_outlined,
                label: '連続学習',
                value: '${summary.streakDays}',
                unit: '日',
              ),
            ),
          ],
        ),
        const SizedBox(height: 24),
        _SectionHeader(
          title: '新しい書類',
          onMore: () => context.go(RoutePath.documents),
        ),
        if (summary.newDocuments.isEmpty)
          const _EmptyText('新しい書類はありません')
        else
          Card(
            clipBehavior: Clip.antiAlias,
            child: Column(
              children: [
                for (final (i, doc) in summary.newDocuments.indexed) ...[
                  if (i > 0) const Divider(height: 1),
                  _DocumentTile(document: doc),
                ],
              ],
            ),
          ),
        const SizedBox(height: 24),
        _SectionHeader(
          title: 'よくタップする単語',
          onMore: () => context.go(RoutePath.wordbook),
        ),
        if (summary.topTappedWords.isEmpty)
          const _EmptyText('まだタップした単語はありません')
        else
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              for (final word in summary.topTappedWords.take(3))
                _WordChip(word: word),
            ],
          ),
      ],
    );
  }
}

/// 今日の学習（未回答数と「続きから」）。
class _TodayCard extends StatelessWidget {
  const _TodayCard({required this.unansweredCount});

  final int unansweredCount;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final done = unansweredCount == 0;

    return Card(
      color: colorScheme.primaryContainer,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '今日の学習',
              style: textTheme.labelLarge?.copyWith(
                color: colorScheme.onPrimaryContainer,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              done ? '今日の問題はすべて終わりました' : 'のこり $unansweredCount 問',
              style: textTheme.headlineSmall?.copyWith(
                color: colorScheme.onPrimaryContainer,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 16),
            FilledButton.icon(
              onPressed: done ? null : () => context.go(RoutePath.quiz),
              icon: const Icon(Icons.play_arrow),
              label: const Text('続きから'),
            ),
          ],
        ),
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({required this.title, required this.onMore});

  final String title;
  final VoidCallback onMore;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Expanded(
            child: Text(
              title,
              style: Theme.of(context).textTheme.titleMedium
                  ?.copyWith(fontWeight: FontWeight.w700),
            ),
          ),
          TextButton(onPressed: onMore, child: const Text('すべて見る')),
        ],
      ),
    );
  }
}

class _DocumentTile extends StatelessWidget {
  const _DocumentTile({required this.document});

  final DocumentSummary document;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final date = document.publishedAt;
    return ListTile(
      leading: CircleAvatar(
        backgroundColor: colorScheme.secondaryContainer,
        foregroundColor: colorScheme.onSecondaryContainer,
        child: const Icon(Icons.description_outlined),
      ),
      title: Text(document.title),
      subtitle: Text('${document.category}・${date.month}月${date.day}日 公開'),
      trailing: const Icon(Icons.chevron_right),
      // 書類閲覧（L04）ができたら書類IDで直接開く。
      onTap: () => context.go(RoutePath.documents),
    );
  }
}

class _WordChip extends StatelessWidget {
  const _WordChip({required this.word});

  final TappedWord word;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              word.reading,
              style: theme.textTheme.labelSmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
            Text(
              word.word,
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
            Text('${word.tapCount}回', style: theme.textTheme.bodySmall),
          ],
        ),
      ),
    );
  }
}

class _EmptyText extends StatelessWidget {
  const _EmptyText(this.text);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Text(
        text,
        style: TextStyle(color: Theme.of(context).colorScheme.onSurfaceVariant),
      ),
    );
  }
}

class _ErrorView extends StatelessWidget {
  const _ErrorView({required this.onRetry});

  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text('読み込めませんでした'),
          const SizedBox(height: 12),
          OutlinedButton(onPressed: onRetry, child: const Text('もう一度')),
        ],
      ),
    );
  }
}

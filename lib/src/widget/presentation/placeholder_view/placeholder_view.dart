import 'package:flutter/material.dart';

/// まだ作っていない画面の仮表示。
class PlaceholderView extends StatelessWidget {
  const PlaceholderView({super.key, required this.title, required this.icon});

  final String title;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 48, color: theme.colorScheme.outline),
            const SizedBox(height: 12),
            Text('準備中です', style: theme.textTheme.titleMedium),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';

class SectionHeader extends StatelessWidget {
  final String title;
  final String? subtitle;

  const SectionHeader({super.key, required this.title, this.subtitle});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: theme.textTheme.headlineMedium),
        if ((subtitle ?? '').trim().isNotEmpty) ...[
          const SizedBox(height: 8),
          Text(subtitle!, style: theme.textTheme.bodyLarge),
        ],
        const SizedBox(height: 12),
        Divider(color: theme.colorScheme.outlineVariant, height: 1),
      ],
    );
  }
}

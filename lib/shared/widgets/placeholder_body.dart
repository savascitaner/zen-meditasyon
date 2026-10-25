import 'package:flutter/material.dart';

import '../../core/theme/app_spacing.dart';

/// Shared body for the not-yet-built tab screens.
class PlaceholderBody extends StatelessWidget {
  const PlaceholderBody({required this.message, super.key});

  final String message;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Text(
          message,
          textAlign: TextAlign.center,
          style: theme.textTheme.bodyLarge?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
      ),
    );
  }
}

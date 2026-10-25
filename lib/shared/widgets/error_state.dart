import 'package:flutter/material.dart';

import '../../l10n/app_localizations.dart';
import 'empty_state.dart';

/// Friendly load-failure message with a retry button.
class ErrorState extends StatelessWidget {
  const ErrorState({required this.onRetry, super.key});

  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return EmptyState(
      icon: Icons.cloud_off_outlined,
      title: l10n.errorTitle,
      message: l10n.errorMessage,
      actionLabel: l10n.retry,
      onAction: onRetry,
    );
  }
}

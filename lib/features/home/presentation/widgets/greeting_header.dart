import 'package:flutter/material.dart';

import '../../../../l10n/app_localizations.dart';

/// Time-of-day greeting at the top of the Today screen.
class GreetingHeader extends StatelessWidget {
  const GreetingHeader({required this.now, super.key});

  final DateTime now;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final text = switch (now.hour) {
      >= 5 && < 12 => l10n.greetingMorning,
      >= 12 && < 18 => l10n.greetingAfternoon,
      _ => l10n.greetingEvening,
    };
    return Semantics(
      header: true,
      child: Text(text, style: Theme.of(context).textTheme.headlineMedium),
    );
  }
}

import 'package:flutter/material.dart';

import '../../../l10n/app_localizations.dart';
import '../../../shared/widgets/placeholder_body.dart';

/// Stand-in for the audio player, which arrives in a later task.
class PlayerPlaceholderScreen extends StatelessWidget {
  const PlayerPlaceholderScreen({required this.meditationId, super.key});

  final String meditationId;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Scaffold(
      appBar: AppBar(title: Text(l10n.playerTitle)),
      body: PlaceholderBody(message: l10n.playerPlaceholder),
    );
  }
}

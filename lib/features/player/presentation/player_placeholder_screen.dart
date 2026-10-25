import 'package:flutter/material.dart';

import '../../../l10n/app_localizations.dart';
import '../../../shared/widgets/placeholder_body.dart';

/// Stand-in for the audio player, which arrives in a later task.
//
// TODO(Görev 9): This route can be opened directly (/player/:id), so the
// premium check in MeditationDetailScreen is not enough. When this screen
// plays audio, refuse premium content here too, or enforce it in the
// repository or entitlement layer.
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

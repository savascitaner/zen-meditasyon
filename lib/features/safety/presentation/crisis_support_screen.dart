import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/l10n/locale_controller.dart';
import '../../../core/platform/platform_providers.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../l10n/app_localizations.dart';
import 'safety_providers.dart';

/// Points to real help: the local emergency number first, then the help
/// lines for the device's region, then a worldwide directory.
///
/// Asks no questions, makes no assessment and stores nothing.
class CrisisSupportScreen extends ConsumerWidget {
  const CrisisSupportScreen({super.key});

  Future<void> _open(BuildContext context, WidgetRef ref, Uri uri) async {
    final l10n = AppLocalizations.of(context);
    final messenger = ScaffoldMessenger.of(context);
    var opened = false;
    try {
      opened = await ref.read(externalLauncherProvider)(uri);
    } catch (_) {
      opened = false;
    }
    if (!opened) {
      messenger.showSnackBar(SnackBar(content: Text(l10n.crisisOpenFailed)));
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final guide = ref.watch(crisisGuideProvider);
    final language = ref.watch(localeControllerProvider).languageCode;

    return Scaffold(
      appBar: AppBar(title: Text(l10n.crisisTitle)),
      body: ListView(
        padding: const EdgeInsets.all(AppSpacing.lg),
        children: [
          Semantics(
            liveRegion: false,
            child: Text(
              l10n.crisisImmediate,
              style: theme.textTheme.titleLarge,
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          Text(
            l10n.crisisIntro,
            style: theme.textTheme.bodyLarge?.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          if (!guide.isKnownRegion)
            Text(
              l10n.crisisUnknownRegion,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
          for (final resource in guide.resources) ...[
            _ResourceCard(
              name: resource.name(language),
              number: resource.displayNumber,
              semanticsLabel: l10n.crisisCallSemantics(
                resource.name(language),
                resource.displayNumber,
              ),
              onTap: () => _open(
                context,
                ref,
                Uri(scheme: 'tel', path: resource.dialNumber),
              ),
            ),
            const SizedBox(height: AppSpacing.sm),
          ],
          const SizedBox(height: AppSpacing.md),
          Card(
            child: ListTile(
              minTileHeight: AppSpacing.minTouchTarget,
              leading: const Icon(Icons.public),
              title: Text(l10n.crisisDirectoryTitle),
              subtitle: Text(l10n.crisisDirectorySubtitle),
              trailing: const Icon(Icons.open_in_new),
              onTap: () => _open(context, ref, guide.directory),
            ),
          ),
        ],
      ),
    );
  }
}

class _ResourceCard extends StatelessWidget {
  const _ResourceCard({
    required this.name,
    required this.number,
    required this.semanticsLabel,
    required this.onTap,
  });

  final String name;
  final String number;
  final String semanticsLabel;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Semantics(
      button: true,
      label: semanticsLabel,
      excludeSemantics: true,
      onTap: onTap,
      child: Card(
        child: InkWell(
          borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.md),
            child: Row(
              children: [
                const Icon(Icons.call_outlined, color: AppColors.accent),
                const SizedBox(width: AppSpacing.md),
                Expanded(child: Text(name, style: theme.textTheme.titleMedium)),
                const SizedBox(width: AppSpacing.md),
                Text(
                  number,
                  style: theme.textTheme.titleLarge?.copyWith(
                    color: AppColors.accent,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/l10n/locale_controller.dart';
import '../../../core/router/route_names.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../l10n/app_localizations.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final locale = ref.watch(localeControllerProvider);

    return Scaffold(
      appBar: AppBar(title: Text(l10n.navProfile)),
      body: ListView(
        padding: const EdgeInsets.all(AppSpacing.lg),
        children: [
          Text(l10n.languageSectionTitle, style: theme.textTheme.titleMedium),
          const SizedBox(height: AppSpacing.sm),
          SegmentedButton<String>(
            showSelectedIcon: false,
            segments: [
              ButtonSegment(value: 'en', label: Text(l10n.languageEnglish)),
              ButtonSegment(value: 'tr', label: Text(l10n.languageTurkish)),
            ],
            selected: {locale.languageCode},
            onSelectionChanged: (selection) => ref
                .read(localeControllerProvider.notifier)
                .setLocale(Locale(selection.first)),
          ),
          const SizedBox(height: AppSpacing.lg),
          ListTile(
            contentPadding: EdgeInsets.zero,
            minTileHeight: AppSpacing.minTouchTarget,
            leading: const Icon(Icons.favorite_border),
            title: Text(l10n.favoritesTitle),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => context.push(RouteNames.favoritesPath),
          ),
          const SizedBox(height: AppSpacing.lg),
          Text(
            l10n.profilePlaceholder,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }
}

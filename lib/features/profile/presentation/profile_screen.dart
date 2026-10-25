import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/l10n/locale_controller.dart';
import '../../../core/platform/platform_providers.dart';
import '../../../core/router/route_names.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../l10n/app_localizations.dart';
import '../../../shared/widgets/zen_background.dart';
import '../../reminders/presentation/reminder_settings_tile.dart';
import 'profile_providers.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  Future<void> _export(BuildContext context, WidgetRef ref) async {
    final messenger = ScaffoldMessenger.of(context);
    final failed = AppLocalizations.of(context).dataExportFailed;
    // iPad anchors the share sheet to the tapped row.
    final box = context.findRenderObject() as RenderBox?;
    final origin = box != null && box.hasSize
        ? box.localToGlobal(Offset.zero) & box.size
        : null;
    try {
      final json = await ref.read(userDataServiceProvider).exportJson();
      final day = DateTime.now().toIso8601String().substring(0, 10);
      await ref.read(fileSharerProvider)(
        fileName: 'ensora-data-$day.json',
        json: json,
        origin: origin,
      );
    } catch (_) {
      messenger.showSnackBar(SnackBar(content: Text(failed)));
    }
  }

  Future<void> _confirmDelete(BuildContext context, WidgetRef ref) async {
    final l10n = AppLocalizations.of(context);
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(l10n.dataDeleteConfirmTitle),
        content: Text(l10n.dataDeleteConfirmBody),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(false),
            child: Text(l10n.dataDeleteCancel),
          ),
          TextButton(
            style: TextButton.styleFrom(
              foregroundColor: Theme.of(dialogContext).colorScheme.error,
            ),
            onPressed: () => Navigator.of(dialogContext).pop(true),
            child: Text(l10n.dataDeleteConfirm),
          ),
        ],
      ),
    );
    if (confirmed != true) return;
    await ref.read(eraseUserDataProvider)();
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final locale = ref.watch(localeControllerProvider);

    return ZenBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
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
            const ReminderSettingsTile(),
            const SizedBox(height: AppSpacing.md),
            ListTile(
              contentPadding: EdgeInsets.zero,
              minTileHeight: AppSpacing.minTouchTarget,
              leading: const Icon(Icons.favorite_border),
              title: Text(l10n.favoritesTitle),
              trailing: const Icon(Icons.chevron_right),
              onTap: () => context.push(RouteNames.favoritesPath),
            ),
            ListTile(
              contentPadding: EdgeInsets.zero,
              minTileHeight: AppSpacing.minTouchTarget,
              leading: const Icon(Icons.spa_outlined),
              title: Text(l10n.crisisTitle),
              trailing: const Icon(Icons.chevron_right),
              onTap: () => context.push(RouteNames.crisisSupportPath),
            ),
            ListTile(
              contentPadding: EdgeInsets.zero,
              minTileHeight: AppSpacing.minTouchTarget,
              leading: const Icon(Icons.info_outline),
              title: Text(l10n.profileAbout),
              trailing: const Icon(Icons.chevron_right),
              onTap: () => context.push(RouteNames.aboutPath),
            ),
            const SizedBox(height: AppSpacing.lg),
            Text(l10n.profileDataSection, style: theme.textTheme.titleMedium),
            const SizedBox(height: AppSpacing.sm),
            Builder(
              builder: (tileContext) => ListTile(
                contentPadding: EdgeInsets.zero,
                minTileHeight: AppSpacing.minTouchTarget,
                leading: const Icon(Icons.ios_share),
                title: Text(l10n.profileExportData),
                subtitle: Text(l10n.profileExportDataSubtitle),
                onTap: () => _export(tileContext, ref),
              ),
            ),
            ListTile(
              contentPadding: EdgeInsets.zero,
              minTileHeight: AppSpacing.minTouchTarget,
              leading: Icon(
                Icons.delete_outline,
                color: theme.colorScheme.error,
              ),
              title: Text(
                l10n.profileDeleteData,
                style: TextStyle(color: theme.colorScheme.error),
              ),
              subtitle: Text(l10n.profileDeleteDataSubtitle),
              onTap: () => _confirmDelete(context, ref),
            ),
          ],
        ),
      ),
    );
  }
}

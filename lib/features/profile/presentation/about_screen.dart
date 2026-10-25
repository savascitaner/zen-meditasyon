import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/platform/platform_providers.dart';
import '../../../core/router/route_names.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../l10n/app_localizations.dart';
import '../../safety/presentation/safety_notice_sheet.dart';

/// App version, the safety note and the legal links.
class AboutScreen extends ConsumerWidget {
  const AboutScreen({super.key});

  static final privacyUri = Uri.parse('https://ensora.app/privacy');
  static final termsUri = Uri.parse('https://ensora.app/terms');

  Future<void> _open(BuildContext context, WidgetRef ref, Uri uri) async {
    final messenger = ScaffoldMessenger.of(context);
    final message = AppLocalizations.of(context).linkOpenFailed;
    var opened = false;
    try {
      opened = await ref.read(externalLauncherProvider)(uri);
    } catch (_) {
      opened = false;
    }
    if (!opened) messenger.showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final version = ref.watch(appVersionProvider).value;

    return Scaffold(
      appBar: AppBar(title: Text(l10n.aboutTitle)),
      body: ListView(
        padding: const EdgeInsets.all(AppSpacing.lg),
        children: [
          Text(l10n.appTitle, style: theme.textTheme.headlineMedium),
          const SizedBox(height: AppSpacing.sm),
          Text(
            l10n.aboutDisclaimer,
            style: theme.textTheme.bodyLarge?.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          ListTile(
            contentPadding: EdgeInsets.zero,
            minTileHeight: AppSpacing.minTouchTarget,
            leading: const Icon(Icons.info_outline),
            title: Text(l10n.aboutVersion),
            trailing: Text(version ?? '', style: theme.textTheme.bodyLarge),
          ),
          ListTile(
            contentPadding: EdgeInsets.zero,
            minTileHeight: AppSpacing.minTouchTarget,
            leading: const Icon(Icons.spa_outlined),
            title: Text(l10n.aboutSafetyNote),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => showSafetyNoticeSheet(context),
          ),
          ListTile(
            contentPadding: EdgeInsets.zero,
            minTileHeight: AppSpacing.minTouchTarget,
            leading: const Icon(Icons.favorite_border),
            title: Text(l10n.crisisTitle),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => context.push(RouteNames.crisisSupportPath),
          ),
          ListTile(
            contentPadding: EdgeInsets.zero,
            minTileHeight: AppSpacing.minTouchTarget,
            leading: const Icon(Icons.privacy_tip_outlined),
            title: Text(l10n.aboutPrivacyPolicy),
            trailing: const Icon(Icons.open_in_new),
            onTap: () => _open(context, ref, privacyUri),
          ),
          ListTile(
            contentPadding: EdgeInsets.zero,
            minTileHeight: AppSpacing.minTouchTarget,
            leading: const Icon(Icons.description_outlined),
            title: Text(l10n.aboutTerms),
            trailing: const Icon(Icons.open_in_new),
            onTap: () => _open(context, ref, termsUri),
          ),
        ],
      ),
    );
  }
}

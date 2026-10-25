import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/router/route_names.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../l10n/app_localizations.dart';
import 'safety_providers.dart';

/// Shows the safety note as a bottom sheet. Resolves when it is closed.
///
/// "Find support" opens the crisis screen. The note states facts and asks no
/// questions; nothing about the choice is stored.
Future<void> showSafetyNoticeSheet(BuildContext context) {
  return showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    useSafeArea: true,
    showDragHandle: true,
    builder: (sheetContext) => const _SafetyNoticeSheet(),
  );
}

class _SafetyNoticeSheet extends StatelessWidget {
  const _SafetyNoticeSheet();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(
          AppSpacing.lg,
          0,
          AppSpacing.lg,
          AppSpacing.lg,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Icon(
              Icons.spa_outlined,
              size: AppSpacing.xl,
              color: AppColors.accent,
              semanticLabel: '',
            ),
            const SizedBox(height: AppSpacing.md),
            Semantics(
              header: true,
              child: Text(
                l10n.safetyNoticeTitle,
                style: theme.textTheme.headlineSmall,
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: AppSpacing.md),
            Text(
              l10n.safetyNoticeBody,
              style: theme.textTheme.bodyLarge?.copyWith(
                color: AppColors.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppSpacing.lg),
            FilledButton(
              style: FilledButton.styleFrom(
                minimumSize: const Size.fromHeight(AppSpacing.minTouchTarget),
              ),
              onPressed: () => Navigator.of(context).pop(),
              child: Text(l10n.safetyNoticeGotIt),
            ),
            const SizedBox(height: AppSpacing.sm),
            TextButton(
              style: TextButton.styleFrom(
                minimumSize: const Size.fromHeight(AppSpacing.minTouchTarget),
              ),
              onPressed: () {
                final router = GoRouter.of(context);
                Navigator.of(context).pop();
                router.push(RouteNames.crisisSupportPath);
              },
              child: Text(l10n.safetyNoticeSupport),
            ),
          ],
        ),
      ),
    );
  }
}

/// Shows the safety note once, the first time the app is open after
/// onboarding. The "seen" flag is saved as the sheet appears, so it never
/// returns, even if the app is closed with the sheet open. Profile > About
/// opens it again at any time.
class SafetyNoticeGate extends ConsumerStatefulWidget {
  const SafetyNoticeGate({required this.child, super.key});

  final Widget child;

  @override
  ConsumerState<SafetyNoticeGate> createState() => _SafetyNoticeGateState();
}

class _SafetyNoticeGateState extends ConsumerState<SafetyNoticeGate> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted || ref.read(safetyNoticeSeenProvider)) return;
      ref.read(safetyNoticeSeenProvider.notifier).markSeen();
      showSafetyNoticeSheet(context);
    });
  }

  @override
  Widget build(BuildContext context) => widget.child;
}

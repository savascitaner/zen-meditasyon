import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/router/route_names.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../l10n/app_localizations.dart';
import '../../../shared/extensions/localized_text_x.dart';
import '../../../shared/widgets/cover_art.dart';
import '../../../shared/widgets/empty_state.dart';
import '../domain/player_state.dart';
import 'player_controller.dart';
import 'session_complete_sheet.dart';
import 'widgets/breathing_circle.dart';
import 'widgets/progress_ring.dart';

// TODO(Görev 9): This route can be opened directly (/player/:id), so the
// premium check in MeditationDetailScreen is not enough. Refuse premium
// content here too, or enforce it in the repository or entitlement layer.
/// Plays one meditation with a breathing circle, progress ring and controls.
class PlayerScreen extends ConsumerWidget {
  const PlayerScreen({required this.meditationId, super.key});

  final String meditationId;

  void _close(BuildContext context) {
    if (context.canPop()) {
      context.pop();
    } else {
      context.go(RouteNames.homePath);
    }
  }

  Future<void> _showCompleteSheet(BuildContext context, WidgetRef ref) async {
    final action = await showSessionCompleteSheet(context);
    if (!context.mounted) return;
    switch (action) {
      case SessionCompleteAction.done:
        _close(context);
      case SessionCompleteAction.replay:
        ref
            .read(playerControllerProvider(meditationId).notifier)
            .togglePlayPause();
      case null:
        break;
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final provider = playerControllerProvider(meditationId);
    final state = ref.watch(provider);

    ref.listen(provider, (previous, next) {
      if (previous?.completedSession == null && next.completedSession != null) {
        _showCompleteSheet(context, ref);
      }
    });

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.keyboard_arrow_down),
          tooltip: l10n.playerClose,
          onPressed: () => _close(context),
        ),
      ),
      body: switch (state.status) {
        PlayerStatus.loading => const Center(
          child: CircularProgressIndicator(),
        ),
        PlayerStatus.error => _ErrorBody(
          error: state.error,
          onRetry: ref.read(provider.notifier).retry,
        ),
        _ => _PlayerBody(state: state, controller: ref.read(provider.notifier)),
      },
    );
  }
}

class _ErrorBody extends StatelessWidget {
  const _ErrorBody({required this.error, required this.onRetry});

  final PlayerError? error;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    if (error == PlayerError.notFound) {
      return EmptyState(
        icon: Icons.search_off,
        title: l10n.detailNotFoundTitle,
        message: l10n.detailNotFoundMessage,
      );
    }
    return EmptyState(
      icon: Icons.volume_off_outlined,
      title: l10n.playerUnavailableTitle,
      message: l10n.playerUnavailableMessage,
      actionLabel: l10n.retry,
      onAction: onRetry,
    );
  }
}

class _PlayerBody extends StatelessWidget {
  const _PlayerBody({required this.state, required this.controller});

  static const double maxRingSize = 280;
  static const double coverRatio = 0.6;

  final PlayerState state;
  final PlayerController controller;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context);
    // The screen is only built once the meditation has loaded.
    final meditation = state.meditation!;

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
        child: Column(
          children: [
            Text(
              meditation.title.of(context),
              style: theme.textTheme.headlineSmall,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppSpacing.xs),
            Text(
              l10n.detailNarratedBy(meditation.narrator),
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
            Expanded(
              child: LayoutBuilder(
                builder: (context, constraints) {
                  // Shrinks on small screens instead of overflowing.
                  final ring = math.min(
                    maxRingSize,
                    math.min(constraints.maxWidth, constraints.maxHeight),
                  );
                  final cover = ring * coverRatio;
                  return Center(
                    child: ExcludeSemantics(
                      child: ProgressRing(
                        progress: state.progress,
                        size: ring,
                        child: BreathingCircle(
                          active: state.isPlaying,
                          size: ring - ProgressRing.strokeWidth * 4,
                          child: SizedBox.square(
                            dimension: cover,
                            child: CoverArt(
                              seed: meditation.id,
                              imageSource: meditation.coverImage,
                              borderRadius: BorderRadius.circular(cover),
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            Text(
              l10n.playerRemaining(_formatDuration(state.remaining)),
              style: theme.textTheme.titleMedium?.copyWith(
                color: AppColors.textSecondary,
                fontFeatures: const [FontFeature.tabularFigures()],
              ),
            ),
            const SizedBox(height: AppSpacing.lg),
            _Controls(state: state, controller: controller),
            const SizedBox(height: AppSpacing.xl),
          ],
        ),
      ),
    );
  }
}

class _Controls extends StatelessWidget {
  const _Controls({required this.state, required this.controller});

  static const double playButtonSize = 72;

  final PlayerState state;
  final PlayerController controller;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final playing = state.isPlaying;
    final ended = state.status == PlayerStatus.ended;

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _SkipButton(
          icon: Icons.replay,
          tooltip: l10n.playerBack15,
          onPressed: controller.skipBack,
        ),
        const SizedBox(width: AppSpacing.lg),
        IconButton.filled(
          iconSize: AppSpacing.xl,
          style: IconButton.styleFrom(
            fixedSize: const Size.square(playButtonSize),
          ),
          tooltip: playing
              ? l10n.playerPause
              : ended
              ? l10n.playerReplay
              : l10n.playerPlay,
          icon: Icon(
            playing
                ? Icons.pause
                : ended
                ? Icons.replay
                : Icons.play_arrow,
          ),
          onPressed: controller.togglePlayPause,
        ),
        const SizedBox(width: AppSpacing.lg),
        _SkipButton(
          icon: Icons.refresh,
          tooltip: l10n.playerForward15,
          onPressed: controller.skipForward,
        ),
      ],
    );
  }
}

/// A 15 second skip button: a circular arrow with "15" in the middle.
class _SkipButton extends StatelessWidget {
  const _SkipButton({
    required this.icon,
    required this.tooltip,
    required this.onPressed,
  });

  static const double iconSize = 40;

  final IconData icon;
  final String tooltip;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final label = Theme.of(context).textTheme.labelSmall;
    return IconButton(
      tooltip: tooltip,
      constraints: const BoxConstraints.tightFor(
        width: AppSpacing.minTouchTarget,
        height: AppSpacing.minTouchTarget,
      ),
      iconSize: iconSize,
      onPressed: onPressed,
      icon: Stack(
        alignment: Alignment.center,
        children: [
          Icon(icon, size: iconSize),
          Text('15', style: label),
        ],
      ),
    );
  }
}

String _formatDuration(Duration duration) {
  final minutes = duration.inMinutes;
  final seconds = (duration.inSeconds % 60).toString().padLeft(2, '0');
  return '$minutes:$seconds';
}

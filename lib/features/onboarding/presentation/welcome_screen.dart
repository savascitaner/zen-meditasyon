import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../core/router/route_names.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../l10n/app_localizations.dart';
import 'widgets/calm_orb.dart';
import 'widgets/staggered_entrance.dart';

/// First screen of the app: a slowly breathing glow, the Ensora name and one
/// action. Its text settles in piece by piece, or appears at once when the
/// system asks to reduce motion.
///
/// The content scrolls when it does not fit, so large text sizes never
/// overflow on small screens.
class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  static const entranceDuration = Duration(milliseconds: 1600);

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _entrance = AnimationController(
    vsync: this,
    duration: WelcomeScreen.entranceDuration,
  );
  late final CurvedAnimation _orbFade = CurvedAnimation(
    parent: _entrance,
    curve: const Interval(0, 0.6, curve: Curves.easeOut),
  );

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (MediaQuery.disableAnimationsOf(context)) {
      _entrance.value = 1;
    } else if (_entrance.isDismissed) {
      _entrance.forward();
    }
  }

  @override
  void dispose() {
    _orbFade.dispose();
    _entrance.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);

    return Scaffold(
      body: DecoratedBox(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [AppColors.surface, AppColors.background],
          ),
        ),
        child: SafeArea(
          child: LayoutBuilder(
            builder: (context, constraints) => SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
              child: ConstrainedBox(
                // Fill the screen when content is short, so it stays centred.
                constraints: BoxConstraints(minHeight: constraints.maxHeight),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Center(
                      child: FadeTransition(
                        opacity: _orbFade,
                        // Smaller on short screens, so the action stays in view.
                        child: CalmOrb(
                          size: math.min(
                            MediaQuery.sizeOf(context).shortestSide * 0.8,
                            constraints.maxHeight * 0.4,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: AppSpacing.lg),
                    StaggeredEntrance(
                      animation: _entrance,
                      start: 0.2,
                      end: 0.7,
                      child: Semantics(
                        header: true,
                        child: Text(
                          l10n.appTitle,
                          textAlign: TextAlign.center,
                          style: theme.textTheme.displaySmall?.copyWith(
                            letterSpacing: 2,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: AppSpacing.md),
                    StaggeredEntrance(
                      animation: _entrance,
                      start: 0.35,
                      end: 0.85,
                      child: Text(
                        l10n.welcomeTagline,
                        textAlign: TextAlign.center,
                        style: theme.textTheme.bodyLarge?.copyWith(
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ),
                    const SizedBox(height: AppSpacing.xl),
                    StaggeredEntrance(
                      animation: _entrance,
                      start: 0.5,
                      child: FilledButton(
                        style: FilledButton.styleFrom(
                          minimumSize: const Size.fromHeight(
                            AppSpacing.minTouchTarget + AppSpacing.sm,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(
                              AppSpacing.radiusLg,
                            ),
                          ),
                        ),
                        onPressed: () =>
                            context.goNamed(RouteNames.onboardingSurvey),
                        child: Text(l10n.welcomeGetStarted),
                      ),
                    ),
                    const SizedBox(height: AppSpacing.md),
                    StaggeredEntrance(
                      animation: _entrance,
                      start: 0.6,
                      child: Text(
                        l10n.welcomeDisclaimer,
                        textAlign: TextAlign.center,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ),
                    const SizedBox(height: AppSpacing.lg),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../l10n/app_localizations.dart';
import '../domain/onboarding_profile.dart';
import 'onboarding_controller.dart';
import 'widgets/option_card.dart';

/// Two gentle questions, one per step: how the user has been feeling and how
/// familiar they are with meditation.
///
/// Every answer is saved as soon as it is picked. Finishing or skipping marks
/// onboarding complete, and the router then opens Explore.
class SurveyScreen extends ConsumerStatefulWidget {
  const SurveyScreen({super.key});

  static const stepCount = 2;

  @override
  ConsumerState<SurveyScreen> createState() => _SurveyScreenState();
}

class _SurveyScreenState extends ConsumerState<SurveyScreen> {
  int _step = 0;

  bool get _isLastStep => _step == SurveyScreen.stepCount - 1;

  void _back() {
    if (_step > 0) {
      setState(() => _step--);
    } else {
      context.pop();
    }
  }

  void _next() {
    if (_isLastStep) {
      ref.read(onboardingControllerProvider.notifier).complete();
    } else {
      setState(() => _step++);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final profile = ref.watch(onboardingControllerProvider);
    final controller = ref.read(onboardingControllerProvider.notifier);
    final answered = switch (_step) {
      0 => profile.stressLevel != null,
      _ => profile.experience != null,
    };
    final reduceMotion = MediaQuery.disableAnimationsOf(context);

    return PopScope(
      // Swiping back on iOS steps back through the questions first.
      canPop: _step == 0,
      onPopInvokedWithResult: (didPop, _) {
        if (!didPop) _back();
      },
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios_new),
            tooltip: l10n.surveyBack,
            onPressed: _back,
          ),
          title: Text(
            l10n.surveyStepOf(_step + 1, SurveyScreen.stepCount),
            style: theme.textTheme.labelLarge?.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
          centerTitle: true,
          actions: [
            TextButton(
              onPressed: controller.complete,
              child: Text(l10n.surveySkip),
            ),
          ],
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(AppSpacing.xs),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
              child: TweenAnimationBuilder<double>(
                tween: Tween(end: (_step + 1) / SurveyScreen.stepCount),
                duration: reduceMotion
                    ? Duration.zero
                    : const Duration(milliseconds: 400),
                curve: Curves.easeInOut,
                builder: (context, value, _) => ClipRRect(
                  borderRadius: BorderRadius.circular(AppSpacing.xs),
                  child: LinearProgressIndicator(
                    value: value,
                    minHeight: AppSpacing.xs,
                    color: AppColors.accent,
                    backgroundColor: AppColors.surfaceHigh,
                  ),
                ),
              ),
            ),
          ),
        ),
        body: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: AnimatedSwitcher(
                  duration: reduceMotion
                      ? Duration.zero
                      : const Duration(milliseconds: 350),
                  switchInCurve: Curves.easeOut,
                  switchOutCurve: Curves.easeIn,
                  child: switch (_step) {
                    0 => _Question<StressLevel>(
                      key: const ValueKey('stress'),
                      title: l10n.surveyStressTitle,
                      subtitle: l10n.surveyStressSubtitle,
                      options: _stressOptions(l10n),
                      selected: profile.stressLevel,
                      onSelected: controller.selectStressLevel,
                    ),
                    _ => _Question<MeditationExperience>(
                      key: const ValueKey('experience'),
                      title: l10n.surveyExperienceTitle,
                      subtitle: l10n.surveyExperienceSubtitle,
                      options: _experienceOptions(l10n),
                      selected: profile.experience,
                      onSelected: controller.selectExperience,
                    ),
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(
                  AppSpacing.lg,
                  AppSpacing.sm,
                  AppSpacing.lg,
                  AppSpacing.lg,
                ),
                child: FilledButton(
                  style: FilledButton.styleFrom(
                    minimumSize: const Size.fromHeight(
                      AppSpacing.minTouchTarget + AppSpacing.sm,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
                    ),
                  ),
                  onPressed: answered ? _next : null,
                  child: Text(
                    _isLastStep ? l10n.surveyFinish : l10n.surveyContinue,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  static List<_Option<StressLevel>> _stressOptions(AppLocalizations l10n) => [
    _Option(
      StressLevel.calm,
      Icons.spa_outlined,
      l10n.stressCalmTitle,
      l10n.stressCalmSubtitle,
    ),
    _Option(
      StressLevel.slightlyTense,
      Icons.air,
      l10n.stressSlightlyTenseTitle,
      l10n.stressSlightlyTenseSubtitle,
    ),
    _Option(
      StressLevel.stressed,
      Icons.waves,
      l10n.stressStressedTitle,
      l10n.stressStressedSubtitle,
    ),
    _Option(
      StressLevel.overwhelmed,
      Icons.cloud_outlined,
      l10n.stressOverwhelmedTitle,
      l10n.stressOverwhelmedSubtitle,
    ),
  ];

  static List<_Option<MeditationExperience>> _experienceOptions(
    AppLocalizations l10n,
  ) => [
    _Option(
      MeditationExperience.newcomer,
      Icons.eco_outlined,
      l10n.experienceNewcomerTitle,
      l10n.experienceNewcomerSubtitle,
    ),
    _Option(
      MeditationExperience.someExperience,
      Icons.local_florist_outlined,
      l10n.experienceSomeTitle,
      l10n.experienceSomeSubtitle,
    ),
    _Option(
      MeditationExperience.regular,
      Icons.self_improvement,
      l10n.experienceRegularTitle,
      l10n.experienceRegularSubtitle,
    ),
  ];
}

class _Option<T> {
  const _Option(this.value, this.icon, this.title, this.subtitle);

  final T value;
  final IconData icon;
  final String title;
  final String subtitle;
}

class _Question<T> extends StatelessWidget {
  const _Question({
    required this.title,
    required this.subtitle,
    required this.options,
    required this.selected,
    required this.onSelected,
    super.key,
  });

  final String title;
  final String subtitle;
  final List<_Option<T>> options;
  final T? selected;
  final ValueChanged<T> onSelected;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return ListView(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.lg,
        vertical: AppSpacing.lg,
      ),
      children: [
        Semantics(
          header: true,
          child: Text(title, style: theme.textTheme.headlineMedium),
        ),
        const SizedBox(height: AppSpacing.sm),
        Text(
          subtitle,
          style: theme.textTheme.bodyLarge?.copyWith(
            color: AppColors.textSecondary,
          ),
        ),
        const SizedBox(height: AppSpacing.lg),
        for (final option in options) ...[
          OptionCard(
            icon: option.icon,
            title: option.title,
            subtitle: option.subtitle,
            selected: option.value == selected,
            onTap: () => onSelected(option.value),
          ),
          const SizedBox(height: AppSpacing.sm + AppSpacing.xs),
        ],
      ],
    );
  }
}

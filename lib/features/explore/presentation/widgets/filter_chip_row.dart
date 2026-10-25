import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';

/// One choice in a [FilterChipRow].
class FilterChipOption<T> {
  const FilterChipOption({required this.value, required this.label});

  final T value;
  final String label;
}

/// Horizontally scrolling row of single-select chips.
///
/// Tapping the selected chip again leaves it selected; every row starts with
/// an "all" option instead.
class FilterChipRow<T> extends StatelessWidget {
  const FilterChipRow({
    required this.semanticsLabel,
    required this.options,
    required this.selected,
    required this.onSelected,
    this.glow = true,
    super.key,
  });

  final String semanticsLabel;
  final List<FilterChipOption<T>> options;
  final T selected;
  final ValueChanged<T> onSelected;

  /// Whether the selected chip glows. Secondary rows turn it off so only one
  /// row draws the eye.
  final bool glow;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      container: true,
      label: semanticsLabel,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        // Lets the glow spill past the row instead of being cut off.
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.gutter),
        clipBehavior: Clip.none,
        child: Row(
          children: [
            for (final option in options)
              Padding(
                padding: const EdgeInsets.only(right: AppSpacing.sm),
                child: GlowChip(
                  label: option.label,
                  selected: option.value == selected,
                  glow: glow,
                  onTap: () => onSelected(option.value),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

/// Pill-shaped choice chip. Selected: violet fill with a soft glow and a
/// bolder label. Idle: a faint glass pill that melts into the background.
class GlowChip extends StatelessWidget {
  const GlowChip({
    required this.label,
    required this.selected,
    required this.onTap,
    this.glow = true,
    super.key,
  });

  static const double pillHeight = 36;

  final String label;
  final bool selected;
  final VoidCallback onTap;
  final bool glow;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final duration = MediaQuery.disableAnimationsOf(context)
        ? Duration.zero
        : const Duration(milliseconds: 280);
    final solid = MediaQuery.highContrastOf(context);
    final radius = BorderRadius.circular(AppSpacing.radiusPill);

    final labelStyle = theme.textTheme.labelLarge!.copyWith(
      color: selected ? AppColors.onChipSelected : AppColors.textSecondary,
      // A second cue besides colour for the selected chip.
      fontWeight: selected ? FontWeight.w600 : FontWeight.w500,
    );

    return Semantics(
      button: true,
      selected: selected,
      inMutuallyExclusiveGroup: true,
      label: label,
      excludeSemantics: true,
      onTap: onTap,
      child: ConstrainedBox(
        // The pill is shorter than 48dp; the tap area is not.
        constraints: const BoxConstraints(
          minHeight: AppSpacing.minTouchTarget,
          minWidth: AppSpacing.minTouchTarget,
        ),
        child: InkWell(
          onTap: onTap,
          customBorder: const StadiumBorder(),
          splashFactory: NoSplash.splashFactory,
          highlightColor: Colors.transparent,
          child: Center(
            widthFactor: 1,
            child: AnimatedContainer(
              duration: duration,
              curve: Curves.easeOutCubic,
              constraints: const BoxConstraints(minHeight: pillHeight),
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.md,
                vertical: AppSpacing.sm,
              ),
              decoration: BoxDecoration(
                borderRadius: radius,
                color: selected
                    ? AppColors.chipSelected
                    : solid
                    ? AppColors.surface
                    : AppColors.chipIdleFill,
                border: Border.all(
                  color: selected
                      ? AppColors.chipSelected
                      : solid
                      ? AppColors.outline
                      : AppColors.chipIdleBorder,
                  width: 0.75,
                ),
                boxShadow: selected && glow
                    ? const [
                        BoxShadow(
                          color: AppColors.chipGlow,
                          blurRadius: 18,
                          spreadRadius: -2,
                        ),
                      ]
                    : const [],
              ),
              child: AnimatedDefaultTextStyle(
                duration: duration,
                style: labelStyle,
                child: Text(label, maxLines: 1),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

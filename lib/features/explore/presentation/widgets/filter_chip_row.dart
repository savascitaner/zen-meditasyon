import 'package:flutter/material.dart';

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
    super.key,
  });

  final String semanticsLabel;
  final List<FilterChipOption<T>> options;
  final T selected;
  final ValueChanged<T> onSelected;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      container: true,
      label: semanticsLabel,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
        child: Row(
          children: [
            for (final option in options)
              Padding(
                padding: const EdgeInsets.only(right: AppSpacing.sm),
                child: ChoiceChip(
                  label: Text(option.label),
                  selected: option.value == selected,
                  // Keeps the chip's tap area at least 48x48.
                  materialTapTargetSize: MaterialTapTargetSize.padded,
                  onSelected: (_) => onSelected(option.value),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

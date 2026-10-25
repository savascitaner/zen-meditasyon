import 'package:flutter/material.dart';

import '../../../../l10n/app_localizations.dart';
import '../../../content/domain/models/meditation.dart';
import 'filter_chip_row.dart';

/// Maximum-length filter using the steps in [meditationDurationOptions].
class DurationFilter extends StatelessWidget {
  const DurationFilter({
    required this.selectedMinutes,
    required this.onSelected,
    super.key,
  });

  /// Null when any length is allowed.
  final int? selectedMinutes;
  final ValueChanged<int?> onSelected;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return FilterChipRow<int?>(
      semanticsLabel: l10n.exploreDurationFilterLabel,
      selected: selectedMinutes,
      onSelected: onSelected,
      glow: false,
      options: [
        FilterChipOption(value: null, label: l10n.exploreAnyDuration),
        for (final minutes in meditationDurationOptions)
          FilterChipOption(
            value: minutes,
            label: l10n.exploreDurationUpTo(minutes),
          ),
      ],
    );
  }
}

import 'package:flutter/material.dart';

import '../../../../l10n/app_localizations.dart';
import '../../../../shared/extensions/localized_text_x.dart';
import '../../../content/domain/models/category.dart';
import 'filter_chip_row.dart';

/// Category filter: "All" followed by every category.
class CategoryChips extends StatelessWidget {
  const CategoryChips({
    required this.categories,
    required this.selectedId,
    required this.onSelected,
    super.key,
  });

  final List<Category> categories;

  /// Null when "All" is selected.
  final String? selectedId;
  final ValueChanged<String?> onSelected;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return FilterChipRow<String?>(
      semanticsLabel: l10n.exploreCategoryFilterLabel,
      selected: selectedId,
      onSelected: onSelected,
      options: [
        FilterChipOption(value: null, label: l10n.exploreAllCategories),
        for (final category in categories)
          FilterChipOption(
            value: category.id,
            label: category.title.of(context),
          ),
      ],
    );
  }
}

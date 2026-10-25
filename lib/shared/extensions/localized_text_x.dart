import 'package:flutter/widgets.dart';

import '../../features/content/domain/models/localized_text.dart';

extension LocalizedTextX on LocalizedText {
  /// The text in the app's current language.
  String of(BuildContext context) =>
      resolve(Localizations.localeOf(context).languageCode);
}

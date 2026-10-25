import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/l10n/locale_controller.dart';
import '../domain/crisis_resources.dart';

/// Region used to pick help lines: the country of the device's region
/// setting. Read once; the user can change it only in iOS Settings.
final crisisGuideProvider = Provider<CrisisGuide>(
  (ref) => crisisGuideFor(ref.watch(deviceLocaleProvider).countryCode),
);

final safetyNoticeSeenProvider = NotifierProvider<SafetyNoticeSeen, bool>(
  SafetyNoticeSeen.new,
);

/// Whether the safety note has already been shown once after onboarding.
class SafetyNoticeSeen extends Notifier<bool> {
  static const storageKey = 'safety_notice_seen_v1';

  @override
  bool build() =>
      ref.watch(sharedPreferencesProvider).getBool(storageKey) ?? false;

  Future<void> markSeen() async {
    state = true;
    await ref.read(sharedPreferencesProvider).setBool(storageKey, true);
  }
}

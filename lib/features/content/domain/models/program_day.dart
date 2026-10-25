import 'package:freezed_annotation/freezed_annotation.dart';

import 'localized_text.dart';

part 'program_day.freezed.dart';
part 'program_day.g.dart';

@freezed
abstract class ProgramDay with _$ProgramDay {
  const factory ProgramDay({
    required int dayNumber,
    required String meditationId,
    required LocalizedText note,
  }) = _ProgramDay;

  factory ProgramDay.fromJson(Map<String, dynamic> json) =>
      _$ProgramDayFromJson(json);
}

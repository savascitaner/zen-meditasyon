import 'package:freezed_annotation/freezed_annotation.dart';

import 'localized_text.dart';
import 'program_day.dart';

part 'program.freezed.dart';
part 'program.g.dart';

@freezed
abstract class Program with _$Program {
  const factory Program({
    required String id,
    required LocalizedText title,
    required LocalizedText description,
    @Default(30) int totalDays,
    required List<ProgramDay> days,
    @Default(false) bool isPremium,
  }) = _Program;

  factory Program.fromJson(Map<String, dynamic> json) =>
      _$ProgramFromJson(json);
}

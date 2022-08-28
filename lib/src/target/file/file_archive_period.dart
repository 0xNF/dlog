import 'package:json_annotation/json_annotation.dart';

enum FileArchivePeriod {
  /// Don't archive based on time.
  @JsonValue('None')
  none,

  /// AddToArchive every year.
  @JsonValue('Year')
  year,

  /// AddToArchive every month.
  @JsonValue('Month')
  month,

  /// AddToArchive daily.
  @JsonValue('Day')
  day,

  /// AddToArchive every hour.
  @JsonValue('Hour')
  hour,

  /// AddToArchive every minute.
  @JsonValue('Minute')
  minute,

  /// AddToArchive every Sunday.
  @JsonValue('Sunday')
  sunday,

  /// AddToArchive every Monday.
  @JsonValue('Monday')
  monday,

  /// AddToArchive every Tuesday.
  @JsonValue('Tuesday')
  tuesday,

  /// AddToArchive every Wednesday.
  @JsonValue('Wednesday')
  wednesday,

  /// AddToArchive every Thursday.
  @JsonValue('Thursday')
  thursday,

  /// AddToArchive every Friday.
  @JsonValue('Friday')
  friday,

  /// AddToArchive every Saturday.
  @JsonValue('Saturday')
  saturday,
}

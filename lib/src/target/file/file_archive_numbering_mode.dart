import 'package:json_annotation/json_annotation.dart';

enum ArchiveNumberingMode {
  /// Rolling style numbering (the most recent is always #0 then #1, ..., #N).
  @JsonValue("Rolling")
  rolling,

  /// Sequence style numbering. The most recent archive has the highest number.
  @JsonValue("Sequence")
  sequence,

  /// Date style numbering. The date is formatted according to the value of archiveDateFormat.
  @JsonValue("Date")
  date,

  /// ombination of Date and Sequence.
  /// Archives will be stamped with the prior period (Year, Month, Day) datetime.
  /// The most recent archive has the highest number (in combination with the date).
  /// The date is formatted according to the value of archiveDateFormat.
  @JsonValue("DateAndSequence")
  dateAndSequence,
}

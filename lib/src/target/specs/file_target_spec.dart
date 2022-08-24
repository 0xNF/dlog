import 'package:flog3/src/layout/layout_spec.dart';
import 'package:flog3/src/target/specs/console_target_spec.dart';
import 'package:flog3/src/target/specs/target_spec.dart';
import 'package:flog3/src/target/specs/target_type.dart';
import 'package:json_annotation/json_annotation.dart';
import 'dart:convert';

part 'file_target_spec.g.dart';

@JsonSerializable()
class FileTargetSpec extends TargetSpec {
  static const kind = TargetType.file;

  ///  File encoding name like "utf-8", "ascii" or "utf-16"
  @JsonKey(name: "encoding", fromJson: encodingFromJson, toJson: encodingToJson)
  final Encoding encoding;

  @JsonKey(name: "lineEnding")
  final LineEnding lineEnding;

  ///  Indicates whether to write BOM (byte order mark) in created files.
  @JsonKey(name: "writeBom")
  final bool writeBOM;

  /// Name of the file to write to
  ///
  /// This FileName string is a layout which may include instances of layout renderers. This lets you use a single target to write to multiple files.
  ///
  /// The following value makes NLog write logging events to files based on the log level in the directory where the application runs. `${basedir}/${level}.log`
  ///
  /// ll Debug messages will go to `Debug.log`, all Info messages will go to `Info.log` and so on.
  @JsonKey(name: "fileName")
  final String fileName;

  /// Indicates whether to enable log file(s) to be deleted.
  ///
  /// The FileTarget will periodically verify if the file has been deleted and must be recreated.
  @JsonKey(name: "enableFileDelete")
  final bool enableFileDelete;

  ///  Indicates whether to create directories if they don't exist.
  @JsonKey(name: "createDirs")
  final bool createDirs;

  /// Indicates whether to replace file contents on each write instead of appending log message at the end.
  @JsonKey(name: "replaceFileContentsOnEachWrite")
  final bool replaceFileContentsOnEachWrite;

  ///  Indicates whether to delete old log file on startup. Boolean Default: False. This option works only when the "FileName" parameter denotes a single file.
  final bool deleteOldFileOnStartup;

  /// Size in bytes above which log files will be automatically archived
  final int? archiveAboveSize;

  /// Maximum number of archive files that should be kept. If maxArchiveFiles is less or equal to 0, old files aren't deleted Integer Default: 0
  final int maxArchiveFiles;

  /// Maximum age of archive files that should be kept. Has no effect when archiveNumbering is Rolling. If maxArchiveDays is less or equal to 0, old files aren't deleted Integer Default: 0
  final int maxArchiveDays;

  /// Name of the file to be used for an archive.
  /// It may contain a special placeholder {###} that will be replaced with a sequence of numbers depending on the archiving strategy.
  ///
  /// The number of hash characters used determines the number of numerical digits to be used for numbering files.
  final String? archiveFileName;

  /// Way file archives are numbered.
  final ArchiveNumbering archiveNumbering;

  /// ndicates whether to automatically archive log files every time the specified time passes.
  final ArchiveEvery archiveEvery;

  ///  Archive old log file on startup
  final bool archiveOldFileOnStartup;

  ///  File size threshold to archive old log file on startup.
  ///  Default value is 0 which means that the file is archived as soon as archiveOldFileOnStartup is enabled.
  final int archiveOldFileOnStartupAboveSize;

  /// Indicates whether to compress the archive files into the zip files.
  final bool enableArchiveFileCompression;

  FileTargetSpec({
    required super.name,
    super.layout,
    super.footer,
    super.header,
    super.type = TargetType.file,
    this.encoding = const Utf8Codec(),
    this.lineEnding = LineEnding.platform,
    this.writeBOM = false,
    required this.fileName,
    this.enableFileDelete = true,
    this.createDirs = true,
    this.replaceFileContentsOnEachWrite = false,
    this.archiveAboveSize,
    this.deleteOldFileOnStartup = false,
    this.maxArchiveFiles = 0,
    this.maxArchiveDays = 0,
    this.archiveFileName,
    this.archiveNumbering = ArchiveNumbering.sequence,
    this.archiveEvery = ArchiveEvery.none,
    this.archiveOldFileOnStartup = false,
    this.archiveOldFileOnStartupAboveSize = 0,
    this.enableArchiveFileCompression = false,
  });

  Map<String, dynamic> toJson() => _$FileTargetSpecToJson(this);
  factory FileTargetSpec.fromJson(Map<String, dynamic> json) => _$FileTargetSpecFromJson(json);
}

enum ArchiveNumbering {
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

enum ArchiveEvery {
  /// Archive daily.
  @JsonValue("Day")
  day,

  /// Archive hourly.
  @JsonValue("hour")
  hour,

  /// Archive every minute.
  @JsonValue("Day")
  minute,

  /// Archive every month.
  @JsonValue("Month")
  month,

  /// Archive yearly.
  @JsonValue("Year")
  year,

  /// Archive every Sunday.
  @JsonValue("Sunday")
  sunday,

  /// Archive every Monday.
  @JsonValue("Monday")
  monday,

  /// Archive every Tuesday.
  @JsonValue("Tuesday")
  tuesday,

  /// Archive every Wednesday.
  @JsonValue("Wednesday")
  wednesday,

  /// Archive every Thursday.
  @JsonValue("Thursday")
  thursday,

  /// Archive every Friday.
  @JsonValue("Friday")
  friday,

  /// Archive every Saturday.
  @JsonValue("Saturday")
  saturday,

  /// Never archive
  @JsonValue("None")
  none,
}

enum LineEnding {
  @JsonValue("CR")
  cr,
  @JsonValue("CRLF")
  crLf,
  @JsonValue("LF")
  lf,
  @JsonValue("Default")
  platform,
  @JsonValue("None")
  none,
}

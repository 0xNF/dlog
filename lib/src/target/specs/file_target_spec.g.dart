// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'file_target_spec.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FileTargetSpec _$FileTargetSpecFromJson(Map<String, dynamic> json) {
  $checkKeys(
    json,
    requiredKeys: const ['name', 'type'],
  );
  return FileTargetSpec(
    name: json['name'] as String,
    layout: json['layout'] as String? ??
        r"${longdate}|${level:uppercase=true}|${loggerName}|${message:withexception=true}|${eventProperties}",
    type: $enumDecodeNullable(_$TargetTypeEnumMap, json['type']) ??
        TargetType.file,
    encoding: json['encoding'] == null
        ? const Utf8Codec()
        : encodingFromJson(json['encoding'] as String),
    lineEnding: $enumDecodeNullable(_$LineEndingEnumMap, json['lineEnding']) ??
        LineEnding.platform,
    writeBOM: json['writeBom'] as bool? ?? false,
    fileName: json['fileName'] as String,
    enableFileDelete: json['enableFileDelete'] as bool? ?? true,
    createDirs: json['createDirs'] as bool? ?? true,
    replaceFileContentsOnEachWrite:
        json['replaceFileContentsOnEachWrite'] as bool? ?? false,
    archiveAboveSize: json['archiveAboveSize'] as int?,
    deleteOldFileOnStartup: json['deleteOldFileOnStartup'] as bool? ?? false,
    maxArchiveFiles: json['maxArchiveFiles'] as int? ?? 0,
    maxArchiveDays: json['maxArchiveDays'] as int? ?? 0,
    archiveFileName: json['archiveFileName'] as String?,
    archiveNumbering: $enumDecodeNullable(
            _$ArchiveNumberingEnumMap, json['archiveNumbering']) ??
        ArchiveNumbering.sequence,
    archiveEvery:
        $enumDecodeNullable(_$ArchiveEveryEnumMap, json['archiveEvery']) ??
            ArchiveEvery.none,
    archiveOldFileOnStartup: json['archiveOldFileOnStartup'] as bool? ?? false,
    archiveOldFileOnStartupAboveSize:
        json['archiveOldFileOnStartupAboveSize'] as int? ?? 0,
    enableArchiveFileCompression:
        json['enableArchiveFileCompression'] as bool? ?? false,
  );
}

Map<String, dynamic> _$FileTargetSpecToJson(FileTargetSpec instance) =>
    <String, dynamic>{
      'name': instance.name,
      'type': _$TargetTypeEnumMap[instance.type]!,
      'layout': instance.layout,
      'encoding': encodingToJson(instance.encoding),
      'lineEnding': _$LineEndingEnumMap[instance.lineEnding]!,
      'writeBom': instance.writeBOM,
      'fileName': instance.fileName,
      'enableFileDelete': instance.enableFileDelete,
      'createDirs': instance.createDirs,
      'replaceFileContentsOnEachWrite': instance.replaceFileContentsOnEachWrite,
      'deleteOldFileOnStartup': instance.deleteOldFileOnStartup,
      'archiveAboveSize': instance.archiveAboveSize,
      'maxArchiveFiles': instance.maxArchiveFiles,
      'maxArchiveDays': instance.maxArchiveDays,
      'archiveFileName': instance.archiveFileName,
      'archiveNumbering': _$ArchiveNumberingEnumMap[instance.archiveNumbering]!,
      'archiveEvery': _$ArchiveEveryEnumMap[instance.archiveEvery]!,
      'archiveOldFileOnStartup': instance.archiveOldFileOnStartup,
      'archiveOldFileOnStartupAboveSize':
          instance.archiveOldFileOnStartupAboveSize,
      'enableArchiveFileCompression': instance.enableArchiveFileCompression,
    };

const _$TargetTypeEnumMap = {
  TargetType.console: 'Console',
  TargetType.file: 'File',
  TargetType.network: 'Network',
  TargetType.nil: 'Null',
};

const _$LineEndingEnumMap = {
  LineEnding.cr: 'CR',
  LineEnding.crLf: 'CRLF',
  LineEnding.lf: 'LF',
  LineEnding.platform: 'Default',
  LineEnding.none: 'None',
};

const _$ArchiveNumberingEnumMap = {
  ArchiveNumbering.rolling: 'Rolling',
  ArchiveNumbering.sequence: 'Sequence',
  ArchiveNumbering.date: 'Date',
  ArchiveNumbering.dateAndSequence: 'DateAndSequence',
};

const _$ArchiveEveryEnumMap = {
  ArchiveEvery.day: 'Day',
  ArchiveEvery.hour: 'hour',
  ArchiveEvery.minute: 'Day',
  ArchiveEvery.month: 'Month',
  ArchiveEvery.year: 'Year',
  ArchiveEvery.sunday: 'Sunday',
  ArchiveEvery.monday: 'Monday',
  ArchiveEvery.tuesday: 'Tuesday',
  ArchiveEvery.wednesday: 'Wednesday',
  ArchiveEvery.thursday: 'Thursday',
  ArchiveEvery.friday: 'Friday',
  ArchiveEvery.saturday: 'Saturday',
  ArchiveEvery.none: 'None',
};

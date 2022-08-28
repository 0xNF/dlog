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
    layout: json['layout'] == null
        ? null
        : LayoutSpec.fromJson(json['layout'] as Map<String, dynamic>),
    footer: json['footer'] == null
        ? null
        : LayoutSpec.fromJson(json['footer'] as Map<String, dynamic>),
    header: json['header'] == null
        ? null
        : LayoutSpec.fromJson(json['header'] as Map<String, dynamic>),
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
            _$ArchiveNumberingModeEnumMap, json['archiveNumbering']) ??
        ArchiveNumberingMode.sequence,
    archiveEvery:
        $enumDecodeNullable(_$FileArchivePeriodEnumMap, json['archiveEvery']) ??
            FileArchivePeriod.none,
    archiveOldFileOnStartup: json['archiveOldFileOnStartup'] as bool? ?? false,
    archiveOldFileOnStartupAboveSize:
        json['archiveOldFileOnStartupAboveSize'] as int? ?? 0,
    enableArchiveFileCompression:
        json['enableArchiveFileCompression'] as bool? ?? false,
    keepFileOpen: json['keepFileOpen'] as bool? ?? true,
    autoFlush: json['autoFlush'] as bool? ?? true,
    openFileCacheSize: json['openFileCacheSize'] as int? ?? 5,
    openFileCacheTimeout: json['openFileCacheTimeout'] as int? ?? 10,
    openFileFlushTimeout: json['openFileFlushTimeout'] as int? ?? 10,
    bufferSize: json['bufferSize'] as int? ?? 32768,
    discardAll: json['discardAll'] as bool? ?? false,
    writeFooterOnArchivingOnly:
        json['writeFooterOnArchivingOnly'] as bool? ?? false,
    forceManaged: json['forceManaged'] as bool? ?? true,
  );
}

Map<String, dynamic> _$FileTargetSpecToJson(FileTargetSpec instance) =>
    <String, dynamic>{
      'name': instance.name,
      'type': _$TargetTypeEnumMap[instance.type]!,
      'layout': instance.layout,
      'footer': instance.footer,
      'header': instance.header,
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
      'archiveNumbering':
          _$ArchiveNumberingModeEnumMap[instance.archiveNumbering]!,
      'archiveEvery': _$FileArchivePeriodEnumMap[instance.archiveEvery]!,
      'archiveOldFileOnStartup': instance.archiveOldFileOnStartup,
      'archiveOldFileOnStartupAboveSize':
          instance.archiveOldFileOnStartupAboveSize,
      'enableArchiveFileCompression': instance.enableArchiveFileCompression,
      'keepFileOpen': instance.keepFileOpen,
      'autoFlush': instance.autoFlush,
      'openFileCacheSize': instance.openFileCacheSize,
      'openFileCacheTimeout': instance.openFileCacheTimeout,
      'openFileFlushTimeout': instance.openFileFlushTimeout,
      'bufferSize': instance.bufferSize,
      'discardAll': instance.discardAll,
      'writeFooterOnArchivingOnly': instance.writeFooterOnArchivingOnly,
      'forceManaged': instance.forceManaged,
    };

const _$TargetTypeEnumMap = {
  TargetType.console: 'Console',
  TargetType.coloredConsole: 'ColoredConsole',
  TargetType.file: 'File',
  TargetType.network: 'Network',
  TargetType.debug: 'Debug',
  TargetType.nil: 'Null',
};

const _$LineEndingEnumMap = {
  LineEnding.cr: 'CR',
  LineEnding.crLf: 'CRLF',
  LineEnding.lf: 'LF',
  LineEnding.platform: 'Default',
  LineEnding.none: 'None',
};

const _$ArchiveNumberingModeEnumMap = {
  ArchiveNumberingMode.rolling: 'Rolling',
  ArchiveNumberingMode.sequence: 'Sequence',
  ArchiveNumberingMode.date: 'Date',
  ArchiveNumberingMode.dateAndSequence: 'DateAndSequence',
};

const _$FileArchivePeriodEnumMap = {
  FileArchivePeriod.none: 'None',
  FileArchivePeriod.year: 'Year',
  FileArchivePeriod.month: 'Month',
  FileArchivePeriod.day: 'Day',
  FileArchivePeriod.hour: 'Hour',
  FileArchivePeriod.minute: 'Minute',
  FileArchivePeriod.sunday: 'Sunday',
  FileArchivePeriod.monday: 'Monday',
  FileArchivePeriod.tuesday: 'Tuesday',
  FileArchivePeriod.wednesday: 'Wednesday',
  FileArchivePeriod.thursday: 'Thursday',
  FileArchivePeriod.friday: 'Friday',
  FileArchivePeriod.saturday: 'Saturday',
};

// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'colored_console_target_spec.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ColoredConsoleTargetSpec _$ColoredConsoleTargetSpecFromJson(
    Map<String, dynamic> json) {
  $checkKeys(
    json,
    requiredKeys: const ['name', 'type'],
  );
  return ColoredConsoleTargetSpec(
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
        TargetType.console,
    encoding: json['encoding'] == null
        ? const Utf8Codec()
        : encodingFromJson(json['encoding'] as String),
    useStdErr: json['stdErr'] as bool? ?? false,
    detectConsoleAvailable: json['detectConsoleAvailable'] as bool? ?? false,
    useDefaultRowHighlightingRules:
        json['useDefaultRowHighlightingRules'] as bool? ?? true,
    rowHighlightingRules: (json['rowHighlightingRules'] as List<dynamic>?)
            ?.map((e) => HiighlightRow.fromJson(e as Map<String, dynamic>))
            .toList() ??
        const [],
    wordHighlightingRules: (json['wordHighlightingRules'] as List<dynamic>?)
            ?.map((e) => HighlightWord.fromJson(e as Map<String, dynamic>))
            .toList() ??
        const [],
    detectOutputRedirected: json['detectOutputRedirected'] as bool? ?? true,
    enableANSIOutput: json['enableANSIOutput'] as bool? ?? false,
    autoFlush: json['autoFlush'] as bool? ?? false,
  );
}

Map<String, dynamic> _$ColoredConsoleTargetSpecToJson(
        ColoredConsoleTargetSpec instance) =>
    <String, dynamic>{
      'name': instance.name,
      'type': _$TargetTypeEnumMap[instance.type]!,
      'layout': instance.layout,
      'footer': instance.footer,
      'header': instance.header,
      'encoding': encodingToJson(instance.encoding),
      'stdErr': instance.useStdErr,
      'detectConsoleAvailable': instance.detectConsoleAvailable,
      'rowHighlightingRules': instance.rowHighlightingRules,
      'useDefaultRowHighlightingRules': instance.useDefaultRowHighlightingRules,
      'wordHighlightingRules': instance.wordHighlightingRules,
      'detectOutputRedirected': instance.detectOutputRedirected,
      'enableANSIOutput': instance.enableANSIOutput,
      'autoFlush': instance.autoFlush,
    };

const _$TargetTypeEnumMap = {
  TargetType.console: 'Console',
  TargetType.coloredConsole: 'ColoredConsole',
  TargetType.file: 'File',
  TargetType.network: 'Network',
  TargetType.debug: 'Debug',
  TargetType.nil: 'Null',
};

HiighlightRow _$HiighlightRowFromJson(Map<String, dynamic> json) =>
    HiighlightRow(
      backgroundColor:
          $enumDecodeNullable(_$ConsoleColorEnumMap, json['backgroundColor']) ??
              ConsoleColor.noChange,
      foregroundColor:
          $enumDecodeNullable(_$ConsoleColorEnumMap, json['foregroundColor']) ??
              ConsoleColor.noChange,
      condition: json['condition'] as String,
    );

Map<String, dynamic> _$HiighlightRowToJson(HiighlightRow instance) =>
    <String, dynamic>{
      'backgroundColor': _$ConsoleColorEnumMap[instance.backgroundColor]!,
      'foregroundColor': _$ConsoleColorEnumMap[instance.foregroundColor]!,
      'condition': instance.condition,
    };

const _$ConsoleColorEnumMap = {
  ConsoleColor.noChange: 'NoChange',
  ConsoleColor.black: 'Black',
  ConsoleColor.blue: 'Blue',
  ConsoleColor.cyan: 'Cyan',
  ConsoleColor.darkBlue: 'DarkBlue',
  ConsoleColor.darkCyan: 'DarkCyan',
  ConsoleColor.darkGrey: 'DarkGrey',
  ConsoleColor.darkGreen: 'DarkGreen',
  ConsoleColor.darkMagenta: 'DarkMagenta',
  ConsoleColor.darkRed: 'DarkRed',
  ConsoleColor.darkYellow: 'DarkYellow',
  ConsoleColor.grey: 'Grey',
  ConsoleColor.green: 'Green',
  ConsoleColor.magenta: 'Magenta',
  ConsoleColor.red: 'Red',
  ConsoleColor.white: 'White',
  ConsoleColor.yellow: 'Yellow',
};

HighlightWord _$HighlightWordFromJson(Map<String, dynamic> json) =>
    HighlightWord(
      backgroundColor:
          $enumDecodeNullable(_$ConsoleColorEnumMap, json['backgroundColor']) ??
              ConsoleColor.noChange,
      foregroundColor:
          $enumDecodeNullable(_$ConsoleColorEnumMap, json['foregroundColor']) ??
              ConsoleColor.noChange,
      text: json['text'] as String?,
      regex: json['regex'] as String?,
      ignoreCase: json['ignoreCase'] as bool? ?? false,
      wholeWords: json['wholeWords'] as bool? ?? false,
      condition: json['condition'] == null
          ? null
          : ConditionExpression.fromJson(
              json['condition'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$HighlightWordToJson(HighlightWord instance) =>
    <String, dynamic>{
      'backgroundColor': _$ConsoleColorEnumMap[instance.backgroundColor]!,
      'foregroundColor': _$ConsoleColorEnumMap[instance.foregroundColor]!,
      'condition': instance.condition,
      'text': instance.text,
      'regex': instance.regex,
      'ignoreCase': instance.ignoreCase,
      'wholeWords': instance.wholeWords,
    };

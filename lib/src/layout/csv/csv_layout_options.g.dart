// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'csv_layout_options.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CSVLayoutOptions _$CSVLayoutOptionsFromJson(Map<String, dynamic> json) =>
    CSVLayoutOptions(
      quoting: $enumDecodeNullable(_$QuoteEnumEnumMap, json['quoting']) ??
          QuoteEnum.auto,
      withHeader: json['withHeader'] as bool? ?? true,
      customColumnDelimiter: json['customColumnDelimiter'] as String? ?? ",",
      delimeter:
          $enumDecodeNullable(_$DelimeterEnumEnumMap, json['delimeter']) ??
              DelimeterEnum.auto,
      columns: (json['columns'] as List<dynamic>?)
              ?.map((e) => CSVColumn.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [
            CSVColumn(name: "Time", layout: r'${longdate}'),
            CSVColumn(name: "Level", layout: r'${level}'),
            CSVColumn(name: "Logger", layout: r'${loggername}'),
            CSVColumn(name: "Message", layout: r'${message}')
          ],
      quoteChar: json['quoteChar'] as String? ?? '"',
    );

Map<String, dynamic> _$CSVLayoutOptionsToJson(CSVLayoutOptions instance) =>
    <String, dynamic>{
      'quoting': _$QuoteEnumEnumMap[instance.quoting]!,
      'withHeader': instance.withHeader,
      'customColumnDelimiter': instance.customColumnDelimiter,
      'delimeter': _$DelimeterEnumEnumMap[instance.delimeter]!,
      'columns': instance.columns,
      'quoteChar': instance.quoteChar,
    };

const _$QuoteEnumEnumMap = {
  QuoteEnum.auto: 'Auto',
  QuoteEnum.all: 'All',
  QuoteEnum.none: 'None',
};

const _$DelimeterEnumEnumMap = {
  DelimeterEnum.auto: 'Auto',
  DelimeterEnum.comma: 'Comma',
  DelimeterEnum.custom: 'custom',
  DelimeterEnum.pipe: 'Pipe',
  DelimeterEnum.semicolon: 'Semicolon',
  DelimeterEnum.space: 'Space',
  DelimeterEnum.tab: 'Tab',
};

CSVColumn _$CSVColumnFromJson(Map<String, dynamic> json) => CSVColumn(
      name: json['name'] as String,
      layout: json['layout'] as String,
      quoting: $enumDecodeNullable(_$QuoteEnumEnumMap, json['quoting']),
    );

Map<String, dynamic> _$CSVColumnToJson(CSVColumn instance) => <String, dynamic>{
      'name': instance.name,
      'layout': instance.layout,
      'quoting': _$QuoteEnumEnumMap[instance.quoting],
    };

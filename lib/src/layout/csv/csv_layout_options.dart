import 'package:flog3/src/layout/options/layout_spec_options.dart';
import 'package:json_annotation/json_annotation.dart';

part 'csv_layout_options.g.dart';

@JsonSerializable()
class CSVLayoutOptions implements LayoutSpecOptions {
  /// Default Quoting mode for columns. Default: Auto
  final QuoteEnum quoting;

  ///  Indicates whether CSV should include header. Default true
  final bool withHeader;

  ///  Custom column delimiter value (valid when ColumnDelimiter is set to Custom).
  final String customColumnDelimiter;

  /// Column delimiter. Default: Auto
  final DelimeterEnum delimeter;

  final List<CSVColumn> columns;

  /// Quote Character. Default: "
  final String quoteChar;

  const CSVLayoutOptions({
    this.quoting = QuoteEnum.auto,
    this.withHeader = true,
    this.customColumnDelimiter = ",",
    this.delimeter = DelimeterEnum.auto,
    this.columns = const [],
    this.quoteChar = '"',
  });

  Map<String, dynamic> toJson() => _$CSVLayoutOptionsToJson(this);
  factory CSVLayoutOptions.fromJson(Map<String, dynamic> json) => _$CSVLayoutOptionsFromJson(json);
}

@JsonSerializable()
class CSVColumn {
  /// Name of the column.
  final String name;

  ///  Layout of the column.
  final String layout;

  /// Column specific override of the default column quoting (Ex. for column with multiline exception-output)
  final QuoteEnum? quoting;

  CSVColumn({
    required this.name,
    required this.layout,
    this.quoting,
  });

  Map<String, dynamic> toJson() => _$CSVColumnToJson(this);
  factory CSVColumn.fromJson(Map<String, dynamic> json) => _$CSVColumnFromJson(json);
}

enum QuoteEnum {
  /// Quote only whose values contain the quote symbol, the separator or newlines (Slow)
  @JsonValue("Auto")
  auto,

  /// All - Quote all column. Useful for data known to be multiline such as Exception-ToString (Fast)
  @JsonValue("All")
  all,

  /// Nothing - Quote nothing (Very Fast)
  @JsonValue("None")
  none,
}

enum DelimeterEnum {
  ///  Automatically detect from regional settings
  @JsonValue("Auto")
  auto,

  /// Comma (ASCII 44) (,)
  @JsonValue("Comma")
  comma,

  /// Custom string, specified by the [CustomDelimiter]
  custom,

  /// Pipe character (ASCII 124) (|)
  @JsonValue("Pipe")
  pipe,

  /// Semicolon (ASCII 59) (;)
  @JsonValue("Semicolon")
  semicolon,

  ///Space character (ASCII 32) ( )
  @JsonValue("Space")
  space,

  /// Tab character (ASCII 9) (\t)
  @JsonValue("Tab")
  tab,
}

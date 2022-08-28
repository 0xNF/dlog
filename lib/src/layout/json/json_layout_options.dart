import 'package:flog3/src/layout/options/layout_spec_options.dart';
import 'package:json_annotation/json_annotation.dart';

part 'json_layout_options.g.dart';

const List<JSONAttribute> _defaultAttributes = [
  JSONAttribute(name: "Time", layout: r"${longdate}"),
  JSONAttribute(name: "Level", layout: r"${level}"),
  JSONAttribute(name: "Logger", layout: r"${loggername}"),
  JSONAttribute(name: "Message", layout: r"${message}"),
  JSONAttribute(name: "EventProperties", layout: "\${all-event-properties}"),
];

@JsonSerializable()
class JSONLayoutOptions implements LayoutSpecOptions {
  @JsonKey(name: "attributes")
  final List<JSONAttribute> attributes;

  /// Enable to suppress extra spaces in the output JSON. Default = false.
  @JsonKey(name: "suppressSpaces")
  final bool suppressSpaces;

  /// When no json-attributes, then it should still render empty object-value {}. Default = true.
  @JsonKey(name: "renderEmptyObject")
  final bool renderEmptyObject;

  /// Include all events properties of a logevent? Default = false.
  @JsonKey(name: "includeEventProperties")
  final bool includeEventProperties;

  ///  Names which properties to exclude.
  ///  Only used when includeEventProperties is true. Case insensitive.
  ///  Default empty.
  @JsonKey(name: "excludeProperties")
  final List<String> excludeProperties;

  /// Exclude event properties with value null or empty. Default = true
  @JsonKey(name: "excludeEmptyProperties")
  final bool excludeEmptyProperties;

  /// escape non-ascii characters? Default true.
  @JsonKey(name: "escapeUnicode")
  final bool escapeUnicode;

  /// How far should the JSON serializer follow object references before backing off.
  /// Default 1 (0 = No object reflection)
  @JsonKey(name: "maxRecursionLimit")
  final int maxRecursionLimit;

  /// Should forward slashes be escaped?
  /// If true, / will be converted to \/.
  /// Default = false.
  @JsonKey(name: "escapeForwardSlash")
  final bool escapeForwardSlash;

  const JSONLayoutOptions({
    this.attributes = _defaultAttributes,
    this.suppressSpaces = false,
    this.renderEmptyObject = true,
    this.includeEventProperties = false,
    this.excludeProperties = const [],
    this.excludeEmptyProperties = true,
    this.escapeUnicode = true,
    this.maxRecursionLimit = 1,
    this.escapeForwardSlash = false,
  });

  Map<String, dynamic> toJson() => _$JSONLayoutOptionsToJson(this);
  factory JSONLayoutOptions.fromJson(Map<String, dynamic> json) => _$JSONLayoutOptionsFromJson(json);
}

@JsonSerializable()
class JSONAttribute {
  /// Required. The name of the JSON-key
  @JsonKey(name: "name")
  final String name;

  /// The layout for the JSON-value (Can be a nested JsonLayout)
  /// TODO(nf): nested layouts not actually supported via this data structure...
  /// TODO(nf): maybe parse the string into any kind of Layout type and allow any kind of recursive nesting anywhere (also for csv/simple/etc)
  @JsonKey(name: "layout")
  final String layout;

  /// Enable or disable JSON encoding for the attribute. Default = true
  @JsonKey(name: "encode")
  final bool encode;

  /// Escape unicode-characters (non-ascii) using \u. Default = true
  @JsonKey(name: "escapeUnicode")
  final bool escapeUnicode;

  /// Include attribute when Layout output is empty. Default = false
  @JsonKey(name: "includeEmptyValue")
  final bool includeEmptyValue;

  /// Should forward slashes also be escaped. Default = false,
  @JsonKey(name: "escapeForwardSlash")
  final bool escapeForwardSlash;

  const JSONAttribute({
    required this.name,
    required this.layout,
    this.encode = true,
    this.escapeUnicode = true,
    this.includeEmptyValue = false,
    this.escapeForwardSlash = false,
  });

  Map<String, dynamic> toJson() => _$JSONAttributeToJson(this);
  factory JSONAttribute.fromJson(Map<String, dynamic> json) => _$JSONAttributeFromJson(json);
}

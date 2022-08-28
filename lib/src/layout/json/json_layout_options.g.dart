// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'json_layout_options.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

JSONLayoutOptions _$JSONLayoutOptionsFromJson(Map<String, dynamic> json) =>
    JSONLayoutOptions(
      attributes: (json['attributes'] as List<dynamic>?)
              ?.map((e) => JSONAttribute.fromJson(e as Map<String, dynamic>))
              .toList() ??
          _defaultAttributes,
      suppressSpaces: json['suppressSpaces'] as bool? ?? false,
      renderEmptyObject: json['renderEmptyObject'] as bool? ?? true,
      includeEventProperties: json['includeEventProperties'] as bool? ?? false,
      excludeProperties: (json['excludeProperties'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      excludeEmptyProperties: json['excludeEmptyProperties'] as bool? ?? true,
      escapeUnicode: json['escapeUnicode'] as bool? ?? true,
      maxRecursionLimit: json['maxRecursionLimit'] as int? ?? 1,
      escapeForwardSlash: json['escapeForwardSlash'] as bool? ?? false,
    );

Map<String, dynamic> _$JSONLayoutOptionsToJson(JSONLayoutOptions instance) =>
    <String, dynamic>{
      'attributes': instance.attributes,
      'suppressSpaces': instance.suppressSpaces,
      'renderEmptyObject': instance.renderEmptyObject,
      'includeEventProperties': instance.includeEventProperties,
      'excludeProperties': instance.excludeProperties,
      'excludeEmptyProperties': instance.excludeEmptyProperties,
      'escapeUnicode': instance.escapeUnicode,
      'maxRecursionLimit': instance.maxRecursionLimit,
      'escapeForwardSlash': instance.escapeForwardSlash,
    };

JSONAttribute _$JSONAttributeFromJson(Map<String, dynamic> json) =>
    JSONAttribute(
      name: json['name'] as String,
      layout: json['layout'] as String,
      encode: json['encode'] as bool? ?? true,
      escapeUnicode: json['escapeUnicode'] as bool? ?? true,
      includeEmptyValue: json['includeEmptyValue'] as bool? ?? false,
      escapeForwardSlash: json['escapeForwardSlash'] as bool? ?? false,
    );

Map<String, dynamic> _$JSONAttributeToJson(JSONAttribute instance) =>
    <String, dynamic>{
      'name': instance.name,
      'layout': instance.layout,
      'encode': instance.encode,
      'escapeUnicode': instance.escapeUnicode,
      'includeEmptyValue': instance.includeEmptyValue,
      'escapeForwardSlash': instance.escapeForwardSlash,
    };

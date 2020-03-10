// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'NetworkItem.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

NetworkItem _$NetworkItemFromJson(Map<String, dynamic> json) {
  return NetworkItem(
    json['a'] as int,
    json['b'] == null ? null : Uri.parse(json['b'] as String),
    json['c'] as String,
    json['d'] as String,
    json['e'] as String,
    json['f'] as String,
    json['g'] as String,
    json['h'] as int,
    json['i'] as int,
    _dateTimeFromEpochMs(json['j'] as int),
  );
}

Map<String, dynamic> _$NetworkItemToJson(NetworkItem instance) =>
    <String, dynamic>{
      'a': instance.id,
      'b': instance.url?.toString(),
      'c': instance.method,
      'd': instance.requestHeaders,
      'e': instance.requestBody,
      'f': instance.responseHeaders,
      'g': instance.responseBody,
      'h': instance.responseCode,
      'i': instance.time,
      'j': _dateTimeToEpochMs(instance.timestamp),
    };

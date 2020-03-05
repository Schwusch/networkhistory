import 'package:json_annotation/json_annotation.dart';

part 'NetworkItem.g.dart';

@JsonSerializable()
class NetworkItem {
  @JsonKey(name: 'a')
  final int id;
  @JsonKey(name: 'b')
  final String url;
  @JsonKey(name: 'c')
  final String method;
  @JsonKey(name: 'd')
  final String requestHeaders;
  @JsonKey(name: 'e')
  final String requestBody;
  @JsonKey(name: 'f')
  final String responseHeaders;
  @JsonKey(name: 'g')
  final String responseBody;
  @JsonKey(name: 'h')
  final int responseCode;
  @JsonKey(name: 'i')
  final int time;
  @JsonKey(name: 'j')
  final int timestamp;

  NetworkItem(
    this.id,
    this.url,
    this.method,
    this.requestHeaders,
    this.requestBody,
    this.responseHeaders,
    this.responseBody,
    this.responseCode,
    this.time,
    this.timestamp,
  );

  factory NetworkItem.fromJson(Map<String, dynamic> json) => _$NetworkItemFromJson(json);

  Map<String, dynamic> toJson() => _$NetworkItemToJson(this);
}
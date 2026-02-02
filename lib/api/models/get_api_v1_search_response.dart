// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:json_annotation/json_annotation.dart';

import 'results.dart';

part 'get_api_v1_search_response.g.dart';

@JsonSerializable()
class GetApiV1SearchResponse {
  const GetApiV1SearchResponse({
    this.results,
  });
  
  factory GetApiV1SearchResponse.fromJson(Map<String, Object?> json) => _$GetApiV1SearchResponseFromJson(json);
  
  final List<Results>? results;

  Map<String, Object?> toJson() => _$GetApiV1SearchResponseToJson(this);
}

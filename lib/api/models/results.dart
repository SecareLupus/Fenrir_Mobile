// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:json_annotation/json_annotation.dart';

part 'results.g.dart';

@JsonSerializable()
class Results {
  const Results({
    this.type,
    this.name,
    this.url,
    this.info,
  });
  
  factory Results.fromJson(Map<String, Object?> json) => _$ResultsFromJson(json);
  
  final String? type;
  final String? name;
  final String? url;
  final String? info;

  Map<String, Object?> toJson() => _$ResultsToJson(this);
}

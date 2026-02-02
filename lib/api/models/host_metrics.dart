// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:json_annotation/json_annotation.dart';

part 'host_metrics.g.dart';

@JsonSerializable()
class HostMetrics {
  const HostMetrics({
    this.heartbeats,
    this.load1,
    this.load5,
    this.load15,
    this.activeSsh,
  });
  
  factory HostMetrics.fromJson(Map<String, Object?> json) => _$HostMetricsFromJson(json);
  
  final int? heartbeats;
  @JsonKey(name: 'load_1')
  final num? load1;
  @JsonKey(name: 'load_5')
  final num? load5;
  @JsonKey(name: 'load_15')
  final num? load15;
  @JsonKey(name: 'active_ssh')
  final int? activeSsh;

  Map<String, Object?> toJson() => _$HostMetricsToJson(this);
}

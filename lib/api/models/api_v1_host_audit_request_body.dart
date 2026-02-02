// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:json_annotation/json_annotation.dart';

part 'api_v1_host_audit_request_body.g.dart';

@JsonSerializable()
class ApiV1HostAuditRequestBody {
  const ApiV1HostAuditRequestBody({
    this.event,
    this.metadata,
  });
  
  factory ApiV1HostAuditRequestBody.fromJson(Map<String, Object?> json) => _$ApiV1HostAuditRequestBodyFromJson(json);
  
  final String? event;
  final String? metadata;

  Map<String, Object?> toJson() => _$ApiV1HostAuditRequestBodyToJson(this);
}

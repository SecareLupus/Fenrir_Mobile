// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:json_annotation/json_annotation.dart';

part 'api_v1_host_renew_request_body.g.dart';

@JsonSerializable()
class ApiV1HostRenewRequestBody {
  const ApiV1HostRenewRequestBody({
    required this.pubkey,
  });
  
  factory ApiV1HostRenewRequestBody.fromJson(Map<String, Object?> json) => _$ApiV1HostRenewRequestBodyFromJson(json);
  
  /// SSH public key to sign
  final String pubkey;

  Map<String, Object?> toJson() => _$ApiV1HostRenewRequestBodyToJson(this);
}

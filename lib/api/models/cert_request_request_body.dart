// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:json_annotation/json_annotation.dart';

part 'cert_request_request_body.g.dart';

@JsonSerializable()
class CertRequestRequestBody {
  const CertRequestRequestBody({
    required this.pubkey,
    this.ttl,
    this.principals,
  });
  
  factory CertRequestRequestBody.fromJson(Map<String, Object?> json) => _$CertRequestRequestBodyFromJson(json);
  
  /// SSH public key to sign
  final String pubkey;

  /// Requested TTL in seconds (subject to policy)
  final int? ttl;

  /// Comma-separated principals (Admins only)
  final String? principals;

  Map<String, Object?> toJson() => _$CertRequestRequestBodyToJson(this);
}

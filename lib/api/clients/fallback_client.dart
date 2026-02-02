// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'dart:convert';
import 'dart:typed_data';
import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

import '../models/api_v1_host_audit_request_body.dart';
import '../models/api_v1_host_renew_request_body.dart';
import '../models/arch.dart';
import '../models/cert_request_request_body.dart';
import '../models/get_api_v1_search_response.dart';
import '../models/host_metrics.dart';

part 'fallback_client.g.dart';

@RestApi()
abstract class FallbackClient {
  factory FallbackClient(Dio dio, {String? baseUrl}) = _FallbackClient;

  /// Health Check
  @GET('/api/v1/health')
  Future<String> getApiV1Health();

  /// Get User CA Public Key
  @GET('/api/v1/ca/user')
  Future<String> getApiV1CaUser();

  /// Get Host CA Public Key
  @GET('/api/v1/ca/host')
  Future<String> getApiV1CaHost();

  /// Get Key Revocation List (KRL)
  @GET('/krl')
  @DioResponseType(ResponseType.stream)
  Stream<String> getKrl();

  /// Request User Certificate
  @FormUrlEncoded()
  @POST('/cert/request')
  Future<String> postCertRequest({
    @Body() CertRequestRequestBody? body,
  });

  /// Retrieve Approved Certificate.
  ///
  /// [id] - ID of the certificate request.
  @GET('/cert/pickup')
  Future<String> getCertPickup({
    @Query('id') required int id,
  });

  /// Renew Host Certificate.
  ///
  /// Supports both Host API Key and Proof-of-Possession (PoP) authentication.
  @FormUrlEncoded()
  @POST('/api/v1/host/renew')
  Future<String> postApiV1HostRenew({
    @Body() ApiV1HostRenewRequestBody? body,
  });

  /// List Users (Admin Only)
  @GET('/admin/users')
  Future<void> getAdminUsers();

  /// List Groups (Admin Only)
  @GET('/admin/groups')
  Future<void> getAdminGroups();

  /// Global Search.
  ///
  /// Unified search across Hosts, Users, and Audit Logs.
  ///
  /// [q] - Search query string.
  @GET('/api/v1/search')
  Future<GetApiV1SearchResponse> getApiV1Search({
    @Query('q') required String q,
  });

  /// Report Host Metrics
  @POST('/api/v1/host/report')
  Future<void> postApiV1HostReport({
    @Body() HostMetrics? body,
  });

  /// Log Host Audit Event
  @POST('/api/v1/host/audit')
  Future<void> postApiV1HostAudit({
    @Body() ApiV1HostAuditRequestBody? body,
  });

  /// Download PAM Module Binary.
  ///
  /// [arch] - Target architecture.
  @GET('/api/v1/ca/pam/binary')
  @DioResponseType(ResponseType.stream)
  Stream<String> getApiV1CaPamBinary({
    @Query('arch') Arch? arch,
  });

  /// Prometheus Metrics
  @GET('/metrics')
  Future<String> getMetrics();

  /// Security Posture Dashboard
  @GET('/admin/security')
  Future<void> getAdminSecurity();
}

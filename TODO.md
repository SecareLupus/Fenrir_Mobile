# Fenrir Mobile Roadmap

This document tracks the development phases of the Fenrir Mobile Admin Platform.

## [ ] Phase 1: Foundation & Core Connectivity

_Goal: Establish a secure, authenticated connection to the Fenrir backend and finalize the base infrastructure._

- [ ] **OIDC Authentication Finalization**
  - [ ] Implement refresh token logic for persistent sessions.
  - [ ] Add session timeout handling.
- [ ] **Secure Data Persistence**
  - [ ] Integrate `flutter_secure_storage` for OIDC tokens.
  - [ ] Store backend configuration (Issuer URL, Client ID) securely.
- [ ] **API Layer Integration**
  - [ ] Finalize the REST client based on `openapi.yaml`.
  - [ ] Implement `Health Check` integration.
  - [ ] Add centralized error handling for API calls.
- [ ] **Biometric Security**
  - [ ] Ensure biometric lock (FaceID/Fingerprint) works reliably across app restarts.

## [ ] Phase 2: Fleet Health & Monitoring (NOC)

_Goal: Provide real-time visibility into the health and security posture of the fleet._

- [ ] **Real-time Metrics Dashboard**
  - [ ] Implement Gauges/Charts for `load_1`, `active_ssh`, and heartbeats.
  - [ ] Connect to `/metrics` or `/api/v1/host/report` endpoints.
- [ ] **Host Inventory management**
  - [ ] Create search-enabled list view for all registered hosts.
  - [ ] Display `last_seen` status and host metadata.
- [ ] **Security Posture Visualization**
  - [ ] UI for the `/admin/security` metrics.
  - [ ] Visual indicators (Red/Yellow/Green) for fleet-wide security status.

## [ ] Phase 3: Security Operations

_Goal: Enable administrators to perform critical security actions directly from their mobile devices._

- [ ] **Certificate Approvals**
  - [ ] Implement "Approvals" tab to list pending `/cert/request` items.
  - [ ] Add Approve/Reject actions with optional justification.
- [ ] **Push Notifications**
  - [ ] Integrate Firebase Cloud Messaging (FCM) or similar for high-priority alerts.
  - [ ] Push notifications for new certificate requests or offline host alerts.
- [ ] **KRL & Revocation**
  - [ ] Display status of the Key Revocation List (KRL).
  - [ ] (Optional) Initiate revocation requests for compromised keys.

## [ ] Phase 4: Advanced Administration & Audit

_Goal: Full management capabilities and deep visibility into system events._

- [ ] **Identity & Access Management**
  - [ ] List users and groups via `/admin/users` and `/admin/groups`.
  - [ ] View detailed user permissions and assigned keys.
- [ ] **Global Audit Search**
  - [ ] Implement advanced search for audit logs via `/api/v1/search`.
  - [ ] Filter audit events by host, user, or event type.
- [ ] **Advanced Settings & Configuration**
  - [ ] Multi-server profile support (Switching between homelab, staging, prod).
  - [ ] Logging level configuration and debug export.
- [ ] **Final Polish & UX**
  - [ ] Dark mode refinements.
  - [ ] Smooth transitions and haptic feedback for critical actions.

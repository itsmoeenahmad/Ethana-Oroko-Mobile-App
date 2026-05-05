# AI Rules for Etana Oroko App (Backend Phase)

You are an expert Flutter and Dart Engineer working on the **Etana Oroko** Mobile Application.

Your goal is to complete a scalable, clean, and production-ready Firebase backend
for an already built UI, using Clean Architecture principles.

This is currently **Milestone 01 backend completion**.
Focus on correctness, data integrity, security, and maintainability.

---

# Current Phase (CRITICAL CONTEXT)

The UI setup is already completed.
Firebase project is already connected for Android and iOS via FlutterFire CLI.

Your default priority is now:

1. Backend/domain/data layer completion
2. Firebase correctness and security
3. End-to-end app flow reliability
4. Tests for backend and state logic

Do not redesign UI unless required to connect missing backend behavior.

---

# Project Overview

**App Name:** Etana Oroko
**Platform:** Flutter (Android & iOS)
**Architecture:** Clean Architecture (Feature-based)
**State Management:** Provider
**Dependency Injection:** GetIt
**Navigation:** GoRouter
**Backend:** Firebase
- Firebase Authentication
- Cloud Firestore

**Optional Infra:**
- Firebase Crashlytics (recommended)
- Firebase Analytics (optional)

**Local Storage:** Flutter Secure Storage (if required for small session flags only)
**Testing:** Unit + Widget tests (MVP scope)

---

# MVP Scope (STRICT)

You MUST ONLY focus on:

- Authentication (login/signup/logout/session)
- Social Feed (read/write Firestore posts)
- Basic authenticated app flow

Do NOT implement:

- Messaging
- Notifications
- Full comments/likes systems
- Advanced profile features
- Media upload pipeline
- Friend/follow graph

Keep logic simple, robust, and extensible.

---

# Non-Negotiable Architecture Rules

Project structure must remain:

lib/
├── main.dart
├── app/
├── core/
└── features/

Follow dependency direction only:

Presentation -> Domain <- Data

Domain layer must be pure Dart:

- No Flutter imports
- No Firebase SDK imports
- No platform code

Presentation must never call Firebase directly.
All Firebase operations must flow through:

UI -> Provider -> UseCase -> Repository -> Firebase Service/DataSource

---

# Backend-First Development Workflow

For each backend task, follow this exact order:

1. Define/update domain entity
2. Define/update repository interface in domain
3. Implement/extend Firebase data source/service in data/core
4. Implement repository in data layer
5. Add/adjust use cases in domain
6. Register dependencies in `app/injection_container.dart`
7. Wire provider to use cases (not repositories)
8. Add error mapping and logging
9. Add/adjust tests
10. Validate full flow on device/emulator

---

# Firebase Data Contracts (MVP)

## users collection

Document path: `users/{uid}`

Required fields:

- `uid` (string)
- `name` (string)
- `email` (string)
- `createdAt` (Timestamp)

Recommended optional fields:

- `updatedAt` (Timestamp)

## posts collection

Document path: `posts/{postId}`

Required fields:

- `id` (string, same as doc id)
- `userId` (string)
- `userName` (string)
- `content` (string)
- `createdAt` (Timestamp)

Recommended optional fields:

- `updatedAt` (Timestamp)

Rules:

- Use server timestamps where possible (`FieldValue.serverTimestamp()`)
- Keep field names stable and consistent
- Never silently change contracts without updating models/tests/rules

---

# Firestore Query and Write Rules

- Always paginate or limit feed reads (MVP: reasonable limit per fetch)
- Sort feed by `createdAt` descending
- Use converters or strongly typed model mapping
- Validate and trim post content before write
- Reject empty/invalid content in use case layer
- Ensure `id` is persisted consistently with document id
- Prefer batched writes/transactions only when truly needed

---

# Firestore Security Rules (MANDATORY)

Backend work is incomplete without secure rules.

Minimum security policy:

- Unauthenticated users cannot read/write protected data
- User can read/write only their own `users/{uid}` document
- Authenticated users can read posts
- Authenticated users can create posts only for themselves
- User can update/delete only their own posts
- Validate required fields and basic types in rules

Also ensure:

- Rules are checked into repo and versioned
- Rules are reviewed whenever schema changes
- Avoid permissive catch-all rules

---

# Firebase Auth Rules

- Use email/password auth for MVP
- On signup success:
  - Create auth user
  - Create corresponding `users/{uid}` Firestore document
- Keep auth state stream as single source for session status
- Handle common auth errors with friendly messages
- Never expose raw Firebase exception text directly to end users

---

# Error Handling and Mapping Rules

- Use `try-catch` at service/repository boundaries
- Map Firebase/Auth exceptions to app-level failure models/messages
- Return deterministic, user-friendly errors
- Never fail silently
- Include contextual logs via logger service
- Do not use `print()`

Recommended categories:

- Network failure
- Permission denied
- Not found
- Validation failure
- Unknown server/client failure

---

# Dependency Injection Rules

Use GetIt and register everything centrally.

- Providers: `registerFactory`
- Use cases: `registerLazySingleton`
- Repositories (as interfaces): `registerLazySingleton`
- Firebase services/data sources: `registerLazySingleton`

No manual instantiation inside widgets.
No hidden singleton creation outside DI.

---

# State Management Rules (Provider)

- Keep business logic in providers and use cases
- Providers call use cases only
- Keep provider state minimal and explicit:
  - loading
  - data
  - error
- No business logic in widgets
- Never use `setState()` for business state transitions

---

# main.dart Rules

`main.dart` must only:

- Initialize Flutter bindings
- Initialize Firebase
- Initialize dependencies
- Configure app-level system settings
- Run app widget

No feature logic in `main.dart`.

---

# Logging and Observability

- Use centralized logger service
- Add meaningful logs at repository/service boundaries
- Avoid logging sensitive information (passwords, tokens, personal secrets)
- If Crashlytics is enabled, record non-fatal exceptions at key failure points

---

# Testing Rules (Backend Phase)

Testing is mandatory for backend completion.

Add tests under:

- `test/features/authentication/`
- `test/features/feed/`

Minimum expectations:

1. Domain/use case unit tests
2. Repository tests with mocked Firebase services
3. Provider tests for loading/success/failure state transitions
4. Widget smoke tests for auth->feed happy path (basic)

Also test edge cases:

- Empty post content
- Permission denied
- Missing/invalid Firestore fields
- Network/unavailable scenario

---

# Code Quality Rules

- Follow Effective Dart
- Strict null safety
- Avoid `!` unless unavoidable and proven safe
- Use const constructors where possible
- Keep methods focused and small
- Use descriptive naming
- Keep public APIs documented when non-obvious

---

# Performance and Reliability Rules

- Keep async work outside widget build methods
- Use `ListView.builder` for feed rendering
- Avoid redundant Firestore listeners
- Cancel/dispose provider resources correctly
- Do not block UI thread with heavy processing

---

# Forbidden Practices

- Firebase calls directly in UI
- Business logic in widgets
- Hardcoded backend magic values scattered in presentation
- Broad permissive Firestore security rules
- Silent exception swallowing
- Unregistered dependencies created ad hoc

---

# Definition of Done (Backend Task)

A backend task is only done when all are true:

1. Clean architecture boundaries are respected
2. Firebase operation works on device/emulator
3. Errors are mapped and surfaced cleanly
4. Security rules are compatible with behavior
5. Tests added/updated and passing for affected logic
6. DI registrations updated

---

# Final Instruction

You are now in backend completion mode.

Prioritize:

- Firebase correctness
- Security rules
- Reliable auth/feed flows
- Clear architecture boundaries
- Test coverage for backend logic

Do not over-engineer.
Do not under-structure.
Ship maintainable, production-safe MVP backend code.

# Etana Oroko

> A modern, community-driven social networking app built end-to-end in **7–8 hours** — from Figma design to a production-ready Flutter app with full Firebase backend integration.

Etana Oroko brings the Oroko community together in a seamless digital space where users can sign in, share posts, like and comment on each other's content, and connect through a clean, real-time social feed. Built on **Flutter + Firebase**, the app is structured around **Clean Architecture** to grow from a solid MVP into a full-featured social ecosystem.

---

## Project Snapshot

| | |
|---|---|
| **Status** | Milestone 01 — MVP Delivered |
| **Delivery Time** | 7–8 hours (design → development → release) |
| **Platforms** | Android & iOS |
| **Version** | 1.0.0+1 |
| **Architecture** | Clean Architecture (Feature-based) |
| **Backend** | Firebase (Auth + Firestore) |

---

## Delivery Pipeline (End-to-End in 7–8 Hours)

1. **Design** — Crafted the full visual design and component spec in Figma (mirrored in `DESIGN.html` for reference).
2. **Theme System** — Translated the design into a Flutter theme: brand color palette (Brand Blue `#2563EB`), Poppins font family (Regular/Medium/SemiBold), text styles, shadows, and border radii.
3. **UI Build** — Implemented all 5 screens with custom widgets, animations, and responsive layouts.
4. **Firebase Setup** — Configured Firebase project, FlutterFire CLI for Android & iOS, enabled Email/Password and Google Sign-In, set up Cloud Firestore.
5. **Backend Integration** — Built the full Clean Architecture backend (domain → data → presentation) for Auth, Feed, and Profile features.
6. **Security** — Authored and deployed Firestore security rules with per-collection access policies.
7. **Distribution** — Packaged and released the Android APK via **Firebase App Distribution** for client review.
8. **Documentation** — Generated a branded technical PDF (`ETANA_OROKO_MVP.pdf`) covering everything delivered.

---

## Features (MVP)

### Authentication
- Email & password sign-in and account creation
- **Google Sign-In** (Android & iOS, with native iOS URL scheme configured)
- Auth-aware routing — auto-redirects logged-in users to the feed
- Comprehensive form validation (email format, password strength, name length, password match)
- All Firebase errors mapped to user-friendly messages

### Social Feed
- Paginated post list (newest first, limit 20 per fetch)
- Create posts with server-side timestamps
- Like / unlike with **optimistic UI** (instant feedback, batch-write on backend)
- Expandable comments section with real-time add
- Pull-to-refresh
- Empty and error states

### User Profile
- View own profile or any other user's profile (tap an avatar in the feed)
- Avatar with Google profile photo support and initial-based fallback
- Activity stats — total posts, total likes received, total comments
- User's post history with full like/comment functionality

---

## Tech Stack

### Framework & Language
- **Flutter** (Dart SDK ^3.11.0) with strict null safety

### Backend
- **Firebase Authentication** — `firebase_auth ^6.4.0`
- **Cloud Firestore** — `cloud_firestore ^6.3.0`
- **Firebase Core** — `firebase_core ^4.4.0`
- **Google Sign-In** — `google_sign_in ^7.2.0`

### Architecture & State
- **Clean Architecture** (Domain → Data ← Presentation)
- **Provider** (`^6.1.5+1`) for state management
- **GetIt** (`^9.2.1`) for dependency injection
- **GoRouter** (`^17.1.0`) for declarative, auth-aware navigation

### Supporting Packages
- `connectivity_plus ^7.0.0` — network monitoring
- `cached_network_image ^3.4.1` — image caching
- `flutter_secure_storage ^10.0.0` — secure local storage
- `flutter_svg ^2.2.3` — SVG rendering
- `image_picker ^1.2.1` — media selection
- `firebase_messaging ^16.1.1` — push (scaffolded for future use)
- `flutter_local_notifications ^20.1.0` — local notifications

---

## Architecture

The project follows strict Clean Architecture with a one-way dependency flow:

```
UI (Widgets) → Provider → Use Case → Repository (interface) → Data Source → Firebase
```

- **Domain layer** is pure Dart — no Flutter, Firebase, or platform imports
- **Presentation** never calls Firebase directly
- All Firebase access flows through dedicated wrapper services (`FirebaseAuthService`, `FirestoreService`)

### Project Structure

```
lib/
├── main.dart
├── app/
│   ├── app_bootstraps.dart        # Firebase + Google Sign-In + DI bootstrap
│   ├── etanaoroko_app.dart        # Root MaterialApp.router + theme
│   └── injection_container.dart   # GetIt registrations
├── core/
│   ├── config/                    # Responsive config
│   ├── constants/                 # App assets, constants
│   ├── enums/                     # App-wide enums
│   ├── errors/                    # Failure sealed classes
│   ├── extensions/                # Context, string, widget, responsive helpers
│   ├── providers/                 # Theme provider
│   ├── router/                    # GoRouter, route names, transitions
│   ├── services/
│   │   ├── firebase/              # Auth + Firestore wrappers
│   │   ├── logger/                # Logger service
│   │   ├── network/               # Connectivity service
│   │   ├── local storage/         # Secure storage wrapper
│   │   ├── image picker/          # Image picker service
│   │   └── notifications/         # Notification service
│   ├── theme/                     # Colors, fonts, text styles, shadows, borders
│   ├── utils/                     # System utils, validators
│   └── widgets/                   # Reusable widgets (animated, buttons, inputs, etc.)
└── features/
    ├── auth/
    │   ├── data/                  # Models, datasources, repository impls
    │   ├── domain/                # Entities, repository interfaces, use cases
    │   └── presentation/          # Providers, screens, widgets
    ├── feed/
    ├── profile/
    └── splash/
```

---

## Firestore Data Model

### `users/{uid}`
| Field | Type | Required |
|---|---|---|
| `uid` | string | yes |
| `name` | string | yes |
| `email` | string | yes |
| `photoUrl` | string | no |
| `createdAt` | Timestamp | yes |
| `updatedAt` | Timestamp | no |

### `posts/{postId}`
| Field | Type | Required |
|---|---|---|
| `id` | string | yes |
| `userId` | string | yes |
| `userName` | string | yes |
| `userPhotoUrl` | string | no |
| `content` | string | yes |
| `likesCount` | number | yes |
| `commentsCount` | number | yes |
| `createdAt` | Timestamp | yes |

### Sub-collections
- `posts/{postId}/likes/{uid}` — `userId`, `createdAt`
- `posts/{postId}/comments/{commentId}` — `id`, `userId`, `userName`, `userPhotoUrl`, `content`, `createdAt`

---

## Use Cases (14 Total)

**Authentication (5):** `SignInUseCase`, `SignInWithGoogleUseCase`, `CreateAccountUseCase`, `SignOutUseCase`, `GetAuthStateUseCase`

**Feed (6):** `GetPostsUseCase`, `CreatePostUseCase`, `ToggleLikeUseCase`, `GetCommentsUseCase`, `AddCommentUseCase`, `GetUserPostsUseCase`

**Profile (3):** `GetProfileUseCase`, `GetCurrentProfileUseCase`, `GetUserStatsUseCase`

---

## Security

All Firestore access is gated by versioned security rules in [`firestore.rules`](firestore.rules):

- **No unauthenticated access** to any data
- **Users collection** — owner-only writes; required-field validation
- **Posts** — authors-only edits; likes/comments counts updatable by any auth'd user (for like/comment batch writes)
- **Likes sub-collection** — `likeId == auth.uid` enforced (you can only like as yourself)
- **Comments sub-collection** — author-only edits/deletes; required-field validation
- **Default deny** — `match /{document=**} { allow read, write: if false; }`

Errors from Firebase are caught at the repository boundary and mapped to typed `Failure` classes (`AuthFailure`, `ServerFailure`, `NetworkFailure`, `ValidationFailure`) before reaching the UI.

---

## Navigation & Routing

| Path | Screen | Auth Required |
|---|---|---|
| `/splash` | Splash | No (checks auth state) |
| `/login` | Login | No |
| `/create-account` | Create Account | No |
| `/feed` | Feed | Yes |
| `/profile` | Profile | Yes |

GoRouter redirects:
- Not logged in + protected route → `/login`
- Logged in + auth page → `/feed`
- Splash handles its own auth-aware routing

---

## Design System

- **Font:** Poppins (Regular 400, Medium 500, SemiBold 600) — bundled in `assets/fonts/`
- **Primary Color:** Brand Blue `#2563EB`
- **Palette:** Brand 50/100/500/600/700/900 + slate-based surfaces and text
- **Responsive:** Mobile (360×800) and Tablet (800×1280) breakpoints

---

## Getting Started

### Prerequisites
- Flutter SDK ^3.11.0
- Firebase project with Email/Password + Google Sign-In enabled
- Android SHA-1 added to Firebase Console
- iOS reversed client ID added as URL scheme in Xcode

### Setup
```bash
# Install dependencies
flutter pub get

# Run on a connected device / emulator
flutter run
```

### Build a Release APK
```bash
flutter build apk --release
```

### Deploy Firestore Security Rules
```bash
firebase deploy --only firestore:rules
```

### Generate the Technical PDF
```bash
dart run tool/generate_milestone_pdf.dart
```

---

## What's NOT Included (Post-MVP)

These features are intentionally scoped out of Milestone 01 and planned for future milestones:

- Direct messaging / real-time chat
- Push notifications (FCM is scaffolded but not wired)
- Threaded comments and reaction system
- Profile editing (bio, photo upload)
- Media upload pipeline (images/videos in posts)
- Friend / follow graph
- Search and discovery
- Community groups (Clans, Villages)
- Event management
- Live streaming
- Integrated payments
- Dark mode (color stubs exist)
- Crashlytics / Analytics integration

---

## Documentation

- **`ETANA_OROKO_MVP.pdf`** — Branded technical document (cover + 11 content pages) detailing every layer of the MVP delivery
- **`BACKEND_INTEGRATION_PLAN.md`** — Full backend integration plan (architecture, schema, flows, files to create/modify)
- **`CLAUDE.md`** — Engineering rules and architecture constraints for the project
- **`firestore.rules`** — Versioned Firestore security rules
- **`DESIGN.html`** — Reference design spec (Figma export)

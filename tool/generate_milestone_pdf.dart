import 'dart:io';
import 'package:pdf/pdf.dart';
import 'package:flutter/material.dart';
import 'package:pdf/widgets.dart' as pw;

/// Etana Oroko - Milestone 01 MVP Document Generator
///
/// Uses Poppins font family and the app's brand color palette.
void main() async {
  // ── Fonts ──
  final regular = pw.Font.ttf(
    File(
      'assets/fonts/Poppins-Regular.ttf',
    ).readAsBytesSync().buffer.asByteData(),
  );
  final medium = pw.Font.ttf(
    File(
      'assets/fonts/Poppins-Medium.ttf',
    ).readAsBytesSync().buffer.asByteData(),
  );
  final semiBold = pw.Font.ttf(
    File(
      'assets/fonts/Poppins-SemiBold.ttf',
    ).readAsBytesSync().buffer.asByteData(),
  );

  // ── Brand Colors ──
  const brand600 = PdfColor.fromInt(0xFF2563EB); // primary
  const brand700 = PdfColor.fromInt(0xFF1D4ED8);
  const brand900 = PdfColor.fromInt(0xFF1E3A8A);
  const brand50 = PdfColor.fromInt(0xFFEFF6FF);
  const brand100 = PdfColor.fromInt(0xFFDBEAFE);
  const textPrimary = PdfColor.fromInt(0xFF0F172A);
  const textSecondary = PdfColor.fromInt(0xFF64748B);
  const border = PdfColor.fromInt(0xFFE2E8F0);
  const white = PdfColors.white;

  // ── Theme helpers ──
  final baseStyle = pw.TextStyle(
    font: regular,
    fontSize: 10,
    color: textPrimary,
  );
  final bodyStyle = baseStyle.copyWith(lineSpacing: 4);
  final smallStyle = baseStyle.copyWith(fontSize: 8.5, color: textSecondary);
  final labelStyle = pw.TextStyle(
    font: medium,
    fontSize: 9,
    color: textSecondary,
  );
  final h1Style = pw.TextStyle(font: semiBold, fontSize: 26, color: brand900);
  final h2Style = pw.TextStyle(font: semiBold, fontSize: 16, color: brand700);
  final h3Style = pw.TextStyle(font: semiBold, fontSize: 12, color: brand600);

  pw.Widget divider() => pw.Container(
    margin: const pw.EdgeInsets.symmetric(vertical: 10),
    height: 1,
    color: border,
  );

  pw.Widget sectionTitle(String text) => pw.Padding(
    padding: const pw.EdgeInsets.only(bottom: 8, top: 4),
    child: pw.Text(text, style: h2Style),
  );

  pw.Widget subTitle(String text) => pw.Padding(
    padding: const pw.EdgeInsets.only(bottom: 4, top: 8),
    child: pw.Text(text, style: h3Style),
  );

  pw.Widget bodyText(String text) => pw.Padding(
    padding: const pw.EdgeInsets.only(bottom: 4),
    child: pw.Text(text, style: bodyStyle),
  );

  pw.Widget bulletItem(String text) => pw.Padding(
    padding: const pw.EdgeInsets.only(left: 12, bottom: 3),
    child: pw.Row(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Container(
          width: 4,
          height: 4,
          margin: const pw.EdgeInsets.only(top: 4, right: 8),
          decoration: const pw.BoxDecoration(
            color: brand600,
            shape: pw.BoxShape.circle,
          ),
        ),
        pw.Expanded(child: pw.Text(text, style: bodyStyle)),
      ],
    ),
  );

  pw.Widget labelValue(String label, String value) => pw.Padding(
    padding: const pw.EdgeInsets.only(bottom: 3),
    child: pw.Row(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.SizedBox(width: 140, child: pw.Text(label, style: labelStyle)),
        pw.Expanded(child: pw.Text(value, style: bodyStyle)),
      ],
    ),
  );

  pw.Widget infoBox(List<pw.Widget> children) => pw.Container(
    padding: const pw.EdgeInsets.all(12),
    margin: const pw.EdgeInsets.only(bottom: 8),
    decoration: pw.BoxDecoration(
      color: brand50,
      border: pw.Border.all(color: brand100),
      borderRadius: pw.BorderRadius.circular(6),
    ),
    child: pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: children,
    ),
  );

  pw.Widget tableHeader(List<String> headers) => pw.Container(
    color: brand600,
    padding: const pw.EdgeInsets.symmetric(vertical: 6, horizontal: 8),
    child: pw.Row(
      children: headers
          .map(
            (h) => pw.Expanded(
              child: pw.Text(
                h,
                style: pw.TextStyle(font: semiBold, fontSize: 9, color: white),
              ),
            ),
          )
          .toList(),
    ),
  );

  pw.Widget tableRow(List<String> cells, {bool alt = false}) => pw.Container(
    color: alt ? brand50 : white,
    padding: const pw.EdgeInsets.symmetric(vertical: 5, horizontal: 8),
    decoration: pw.BoxDecoration(
      border: pw.Border(bottom: pw.BorderSide(color: border, width: 0.5)),
    ),
    child: pw.Row(
      children: cells
          .map((c) => pw.Expanded(child: pw.Text(c, style: smallStyle)))
          .toList(),
    ),
  );

  // ── Build PDF ──
  final pdf = pw.Document(theme: pw.ThemeData(defaultTextStyle: baseStyle));

  // ═══════════════════════════════════════════════
  // PAGE 1 - Cover
  // ═══════════════════════════════════════════════
  pdf.addPage(
    pw.Page(
      pageFormat: PdfPageFormat.a4,
      margin: const pw.EdgeInsets.all(0),
      build: (context) => pw.Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const pw.BoxDecoration(
          gradient: pw.LinearGradient(
            begin: pw.Alignment.topLeft,
            end: pw.Alignment.bottomRight,
            colors: [brand900, brand700, brand600],
          ),
        ),
        child: pw.Padding(
          padding: const pw.EdgeInsets.symmetric(horizontal: 60, vertical: 80),
          child: pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            mainAxisAlignment: pw.MainAxisAlignment.center,
            children: [
              pw.Text(
                'ETANA OROKO',
                style: pw.TextStyle(
                  font: semiBold,
                  fontSize: 42,
                  color: white,
                  letterSpacing: 3,
                ),
              ),
              pw.SizedBox(height: 8),
              pw.Container(width: 80, height: 4, color: white),
              pw.SizedBox(height: 24),
              pw.Text(
                'Milestone 01 - MVP Delivery',
                style: pw.TextStyle(
                  font: medium,
                  fontSize: 20,
                  color: brand100,
                ),
              ),
              pw.SizedBox(height: 60),
              pw.Text(
                'Technical Documentation',
                style: pw.TextStyle(
                  font: regular,
                  fontSize: 14,
                  color: brand100,
                ),
              ),
              pw.SizedBox(height: 6),
              pw.Text(
                'UI + Backend Integration + Security',
                style: pw.TextStyle(
                  font: regular,
                  fontSize: 12,
                  color: brand100,
                ),
              ),
              pw.SizedBox(height: 50),
              pw.Container(width: 200, height: 1, color: brand100),
              pw.SizedBox(height: 16),
              pw.Text(
                'Version 1.0.0',
                style: pw.TextStyle(
                  font: medium,
                  fontSize: 11,
                  color: brand100,
                ),
              ),
              pw.SizedBox(height: 4),
              pw.Text(
                'April 2026',
                style: pw.TextStyle(
                  font: regular,
                  fontSize: 11,
                  color: brand100,
                ),
              ),
              pw.SizedBox(height: 4),
              pw.Text(
                'Platform: Android & iOS',
                style: pw.TextStyle(
                  font: regular,
                  fontSize: 11,
                  color: brand100,
                ),
              ),
            ],
          ),
        ),
      ),
    ),
  );

  // ═══════════════════════════════════════════════
  // PAGE 2 - Table of Contents
  // ═══════════════════════════════════════════════
  pdf.addPage(
    pw.Page(
      pageFormat: PdfPageFormat.a4,
      margin: const pw.EdgeInsets.all(40),
      build: (context) => pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Text('Table of Contents', style: h1Style),
          divider(),
          ...[
            '1.  Project Overview',
            '2.  Technology Stack',
            '3.  Architecture & Project Structure',
            '4.  UI Screens Developed',
            '5.  Authentication - Backend Integration',
            '6.  Social Feed - Backend Integration',
            '7.  User Profile - Backend Integration',
            '8.  Firestore Data Schema',
            '9.  Use Cases Summary',
            '10. Dependency Injection',
            '11. Error Handling & Failure Mapping',
            '12. Firestore Security Rules',
            '13. App Navigation & Auth Routing',
            '14. Core Services & Utilities',
            '15. What Is NOT Included (Post-MVP)',
          ].map(
            (item) => pw.Padding(
              padding: const pw.EdgeInsets.symmetric(vertical: 5),
              child: pw.Text(item, style: bodyStyle),
            ),
          ),
        ],
      ),
    ),
  );

  // ═══════════════════════════════════════════════
  // PAGE 3 - Project Overview + Tech Stack
  // ═══════════════════════════════════════════════
  pdf.addPage(
    pw.Page(
      pageFormat: PdfPageFormat.a4,
      margin: const pw.EdgeInsets.all(40),
      build: (context) => pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          sectionTitle('1. Project Overview'),
          bodyText(
            'Etana Oroko is a community-driven social networking application designed to connect members through posts, interactions, and real-time communication in one unified platform.',
          ),
          pw.SizedBox(height: 4),
          bodyText(
            'This document covers Milestone 01 (MVP), which delivers a fully functional authentication flow, a social feed with posts/likes/comments, user profiles, and a secure Firebase backend - all built on Clean Architecture principles.',
          ),
          pw.SizedBox(height: 8),
          infoBox([
            labelValue('App Name', 'Etana Oroko'),
            labelValue('Version', '1.0.0+1'),
            labelValue('Platforms', 'Android & iOS'),
            labelValue('Milestone', '01 - MVP Delivery'),
          ]),

          divider(),

          sectionTitle('2. Technology Stack'),
          pw.SizedBox(height: 4),
          subTitle('Framework & Language'),
          bulletItem('Flutter (Dart) - cross-platform mobile development'),
          bulletItem('Dart SDK ^3.11.0 with strict null safety'),
          pw.SizedBox(height: 4),
          subTitle('Backend & Cloud'),
          bulletItem(
            'Firebase Authentication (Email/Password + Google Sign-In)',
          ),
          bulletItem('Cloud Firestore (NoSQL document database)'),
          bulletItem('Firebase Core ^4.4.0'),
          pw.SizedBox(height: 4),
          subTitle('Architecture & State'),
          bulletItem('Clean Architecture (Feature-based, 3-layer)'),
          bulletItem('Provider (^6.1.5) - State Management'),
          bulletItem('GetIt (^9.2.1) - Dependency Injection'),
          bulletItem('GoRouter (^17.1.0) - Declarative Navigation'),
          pw.SizedBox(height: 4),
          subTitle('Key Packages'),
          bulletItem('google_sign_in ^7.2.0 - Google OAuth'),
          bulletItem('connectivity_plus ^7.0.0 - Network monitoring'),
          bulletItem('cached_network_image ^3.4.1 - Image caching'),
          bulletItem('flutter_secure_storage ^10.0.0 - Secure local storage'),
          bulletItem('flutter_svg ^2.2.3 - SVG asset rendering'),
          pw.SizedBox(height: 4),
          subTitle('Design System'),
          bulletItem(
            'Poppins font family (Regular 400, Medium 500, SemiBold 600)',
          ),
          bulletItem('Custom color palette (Brand Blue #2563EB primary)'),
          bulletItem('Responsive design with mobile/tablet breakpoints'),
        ],
      ),
    ),
  );

  // ═══════════════════════════════════════════════
  // PAGE 4 - Architecture & Project Structure
  // ═══════════════════════════════════════════════
  pdf.addPage(
    pw.Page(
      pageFormat: PdfPageFormat.a4,
      margin: const pw.EdgeInsets.all(40),
      build: (context) => pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          sectionTitle('3. Architecture & Project Structure'),
          bodyText(
            'The application follows Clean Architecture with a strict 3-layer dependency rule: Presentation --> Domain <-- Data. The Domain layer is pure Dart with no Flutter or Firebase imports.',
          ),
          pw.SizedBox(height: 8),

          subTitle('Dependency Flow'),
          infoBox([
            pw.Text(
              'UI (Widgets) --> Provider --> Use Case --> Repository Interface --> Data Source --> Firebase',
              style: pw.TextStyle(font: medium, fontSize: 9, color: brand900),
            ),
          ]),

          subTitle('Project Directory Layout'),
          infoBox([
            pw.Text(
              'lib/\n'
              '  +-- main.dart\n'
              '  +-- app/\n'
              '  |     +-- app_bootstraps.dart\n'
              '  |     +-- etanaoroko_app.dart\n'
              '  |     +-- injection_container.dart\n'
              '  +-- core/\n'
              '  |     +-- config/           (responsive config)\n'
              '  |     +-- constants/        (app assets, constants)\n'
              '  |     +-- enums/            (app-wide enums)\n'
              '  |     +-- errors/           (failure sealed classes)\n'
              '  |     +-- extensions/       (context, string, widget, responsive)\n'
              '  |     +-- providers/        (theme provider)\n'
              '  |     +-- router/           (GoRouter, route names, transitions)\n'
              '  |     +-- services/         (firebase, logger, network, storage, etc.)\n'
              '  |     +-- theme/            (colors, fonts, text styles, shadows, borders)\n'
              '  |     +-- utils/            (system utils, validators)\n'
              '  |     +-- widgets/          (animated, buttons, cards, dialogs, inputs, etc.)\n'
              '  +-- features/\n'
              '        +-- auth/\n'
              '        |     +-- data/         (models, datasources, repositories)\n'
              '        |     +-- domain/       (entities, repositories, usecases)\n'
              '        |     +-- presentation/ (providers, screens, widgets)\n'
              '        +-- feed/\n'
              '        |     +-- data/         (models, datasources, repositories)\n'
              '        |     +-- domain/       (entities, repositories, usecases)\n'
              '        |     +-- presentation/ (providers, screens, widgets)\n'
              '        +-- profile/\n'
              '        |     +-- data/         (models, datasources, repositories)\n'
              '        |     +-- domain/       (entities, repositories, usecases)\n'
              '        |     +-- presentation/ (providers, screens, widgets)\n'
              '        +-- splash/\n'
              '              +-- presentation/ (screens, widgets)',
              style: pw.TextStyle(
                font: regular,
                fontSize: 7.5,
                color: textPrimary,
                lineSpacing: 3,
              ),
            ),
          ]),
        ],
      ),
    ),
  );

  // ═══════════════════════════════════════════════
  // PAGE 5 - UI Screens
  // ═══════════════════════════════════════════════
  pdf.addPage(
    pw.Page(
      pageFormat: PdfPageFormat.a4,
      margin: const pw.EdgeInsets.all(40),
      build: (context) => pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          sectionTitle('4. UI Screens Developed'),
          bodyText(
            'All screens were designed and built with custom widgets, animations, and the Poppins-based design system. Below is a summary of each screen delivered in the MVP.',
          ),
          pw.SizedBox(height: 8),

          subTitle('4.1 Splash Screen'),
          bulletItem('Animated brand logo with loading indicator'),
          bulletItem(
            'Auth-aware navigation: routes to Feed (if logged in) or Login (if not)',
          ),
          bulletItem('3-second display duration with fade transition'),

          subTitle('4.2 Login Screen'),
          bulletItem(
            'Email and password input fields with real-time validation',
          ),
          bulletItem('"Sign In" button with loading state'),
          bulletItem('"Continue with Google" button for Google OAuth sign-in'),
          bulletItem('"Create Account" navigation link'),
          bulletItem('Error display via snackbar with user-friendly messages'),

          subTitle('4.3 Create Account Screen'),
          bulletItem('Name, email, password, and confirm password fields'),
          bulletItem(
            'Comprehensive form validation (email format, password strength, match check)',
          ),
          bulletItem('"Create Account" button with loading state'),
          bulletItem('Success auto-redirects to Feed screen'),

          subTitle('4.4 Feed Screen'),
          bulletItem('Post list with pull-to-refresh and loading states'),
          bulletItem('Create post section with text input and post button'),
          bulletItem(
            'Each post card shows: author avatar (photo or initials), name, timestamp, content',
          ),
          bulletItem('Like toggle with optimistic UI update and count display'),
          bulletItem('Expandable comments section with reply input'),
          bulletItem('Empty state and error state handling'),
          bulletItem('App bar with profile navigation button'),

          subTitle('4.5 Profile Screen'),
          bulletItem('User avatar (Google photo or initial-based)'),
          bulletItem('Display name and email from Firestore'),
          bulletItem(
            'Activity stats: total posts, total likes received, total comments',
          ),
          bulletItem('User\'s posts list with like/comment actions'),
          bulletItem('Supports viewing own profile or another user\'s profile'),
        ],
      ),
    ),
  );

  // ═══════════════════════════════════════════════
  // PAGE 6 - Authentication Backend
  // ═══════════════════════════════════════════════
  pdf.addPage(
    pw.Page(
      pageFormat: PdfPageFormat.a4,
      margin: const pw.EdgeInsets.all(40),
      build: (context) => pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          sectionTitle('5. Authentication - Backend Integration'),
          bodyText(
            'Full Firebase Authentication integration with email/password and Google Sign-In support. The auth flow creates a Firestore user document on signup and validates credentials on login.',
          ),
          pw.SizedBox(height: 6),

          subTitle('Domain Layer'),
          bulletItem(
            'UserEntity - uid, name, email, photoUrl, createdAt, updatedAt',
          ),
          bulletItem(
            'AuthRepository (abstract interface) - single contract for all auth operations',
          ),
          bulletItem(
            '5 Use Cases: SignIn, SignInWithGoogle, CreateAccount, SignOut, GetAuthState',
          ),

          subTitle('Data Layer'),
          bulletItem(
            'UserModel - extends UserEntity with Firestore serialization (fromFirestore, toFirestore, fromFirebaseUser)',
          ),
          bulletItem(
            'AuthRemoteDataSource - wraps Firebase Auth + Firestore calls for user management',
          ),
          bulletItem(
            'AuthRepositoryImpl - implements AuthRepository with network checks and error mapping',
          ),

          subTitle('Presentation Layer'),
          bulletItem(
            'LoginProvider - manages sign-in state (loading, success, error) via use cases',
          ),
          bulletItem(
            'CreateAccountProvider - manages account creation state via use cases',
          ),
          bulletItem('Both providers are registered as factories in DI'),

          subTitle('Sign-In Flow'),
          infoBox([
            pw.Text(
              '1. User enters email + password --> form validation\n'
              '2. LoginProvider calls SignInUseCase\n'
              '3. Repository checks network --> calls Firebase Auth\n'
              '4. On success: fetches user doc from Firestore --> returns UserEntity\n'
              '5. Provider sets isSuccess --> UI navigates to /feed\n'
              '6. On failure: AuthFailure.fromCode() maps error --> snackbar message',
              style: smallStyle,
            ),
          ]),

          subTitle('Google Sign-In Flow'),
          infoBox([
            pw.Text(
              '1. User taps "Continue with Google"\n'
              '2. Native Google Sign-In dialog opens\n'
              '3. On consent: GoogleAuthCredential --> Firebase signInWithCredential\n'
              '4. Check if user doc exists in Firestore\n'
              '5. New user --> create doc with Google profile (name, email, photoUrl)\n'
              '6. Existing user --> fetch doc\n'
              '7. Provider sets isSuccess --> UI navigates to /feed',
              style: smallStyle,
            ),
          ]),

          subTitle('Create Account Flow'),
          infoBox([
            pw.Text(
              '1. User enters name + email + password + confirm password\n'
              '2. Form validation: name >=2 chars, valid email, password strength, match\n'
              '3. CreateAccountProvider calls CreateAccountUseCase\n'
              '4. Firebase Auth creates user --> updates displayName\n'
              '5. Creates Firestore doc: users/{uid} with serverTimestamp\n'
              '6. Provider sets isSuccess --> UI navigates to /feed',
              style: smallStyle,
            ),
          ]),
        ],
      ),
    ),
  );

  // ═══════════════════════════════════════════════
  // PAGE 7 - Feed Backend
  // ═══════════════════════════════════════════════
  pdf.addPage(
    pw.Page(
      pageFormat: PdfPageFormat.a4,
      margin: const pw.EdgeInsets.all(40),
      build: (context) => pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          sectionTitle('6. Social Feed - Backend Integration'),
          bodyText(
            'Complete Firestore-backed social feed with paginated posts, likes (sub-collection), and comments (sub-collection). Optimistic UI updates for likes ensure a responsive experience.',
          ),
          pw.SizedBox(height: 6),

          subTitle('Domain Layer'),
          bulletItem(
            'PostEntity - id, userId, userName, userPhotoUrl, content, createdAt, likesCount, commentsCount, isLiked',
          ),
          bulletItem(
            'CommentEntity - id, postId, userId, userName, userPhotoUrl, content, createdAt',
          ),
          bulletItem(
            'FeedRepository interface - getPosts, createPost, toggleLike, getComments, addComment, getUserPosts',
          ),
          bulletItem(
            '6 Use Cases: GetPosts, CreatePost, ToggleLike, GetComments, AddComment, GetUserPosts',
          ),

          subTitle('Data Layer'),
          bulletItem(
            'PostModel - extends PostEntity with Firestore serialization',
          ),
          bulletItem(
            'CommentModel - extends CommentEntity with Firestore serialization',
          ),
          bulletItem(
            'FeedRemoteDataSource - handles all Firestore queries and writes for feed',
          ),
          bulletItem(
            'FeedRepositoryImpl - implements FeedRepository with network checks, like-status resolution, error mapping',
          ),

          subTitle('Key Operations'),
          bulletItem(
            'Get Posts: Firestore query ordered by createdAt DESC, limit 20, with per-post like-status check',
          ),
          bulletItem(
            'Create Post: Auto-ID document with server timestamp, denormalized user data',
          ),
          bulletItem(
            'Toggle Like: Batch write - set/delete likes/{uid} sub-doc + increment/decrement likesCount',
          ),
          bulletItem(
            'Get Comments: Query posts/{postId}/comments ordered by createdAt ASC',
          ),
          bulletItem(
            'Add Comment: Batch write - add comment doc + increment commentsCount',
          ),

          subTitle('Feed Provider State Management'),
          infoBox([
            pw.Text(
              'FeedProvider manages:\n'
              '- List<PostEntity> _posts - cached feed data\n'
              '- bool _isLoading - loading indicator state\n'
              '- bool _isCreatingPost - post creation loading state\n'
              '- String? _errorMessage - latest error message\n\n'
              'Optimistic Like Toggle:\n'
              '1. Immediately toggle isLiked + adjust likesCount in local list\n'
              '2. Call ToggleLikeUseCase in background\n'
              '3. On failure: revert local state + show error snackbar',
              style: smallStyle,
            ),
          ]),
        ],
      ),
    ),
  );

  // ═══════════════════════════════════════════════
  // PAGE 8 - Profile Backend + Data Schema
  // ═══════════════════════════════════════════════
  pdf.addPage(
    pw.Page(
      pageFormat: PdfPageFormat.a4,
      margin: const pw.EdgeInsets.all(40),
      build: (context) => pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          sectionTitle('7. User Profile - Backend Integration'),
          bodyText(
            'Profile screen fetches user data from Firestore and computes activity statistics by aggregating the user\'s posts.',
          ),
          pw.SizedBox(height: 4),

          subTitle('Domain Layer'),
          bulletItem(
            'ProfileEntity - uid, name, email, photoUrl, bio, createdAt, updatedAt',
          ),
          bulletItem(
            'ProfileRepository interface - getUserProfile, getCurrentUserProfile, getUserStats',
          ),
          bulletItem('ProfileStats - totalPosts, totalLikes, totalComments'),
          bulletItem(
            '3 Use Cases: GetProfile, GetCurrentProfile, GetUserStats',
          ),

          subTitle('Data Layer'),
          bulletItem(
            'ProfileModel - extends ProfileEntity with Firestore serialization',
          ),
          bulletItem(
            'ProfileRemoteDataSource - fetches user documents and computes stats',
          ),
          bulletItem(
            'ProfileRepositoryImpl - implements ProfileRepository with network checks and error mapping',
          ),

          subTitle('Profile Provider'),
          bulletItem('Loads profile, stats, and user posts in parallel'),
          bulletItem(
            'Supports viewing own profile (no userId) or another user\'s profile (with userId)',
          ),
          bulletItem('Manages loading, data, and error states'),

          divider(),

          sectionTitle('8. Firestore Data Schema'),
          pw.SizedBox(height: 6),

          subTitle('Collection: users/{uid}'),
          tableHeader(['Field', 'Type', 'Required', 'Description']),
          tableRow(['uid', 'string', 'Yes', 'Same as document ID']),
          tableRow(['name', 'string', 'Yes', 'Display name'], alt: true),
          tableRow(['email', 'string', 'Yes', 'Email address']),
          tableRow([
            'photoUrl',
            'string',
            'No',
            'Google profile photo URL',
          ], alt: true),
          tableRow(['createdAt', 'Timestamp', 'Yes', 'Server timestamp']),
          tableRow([
            'updatedAt',
            'Timestamp',
            'No',
            'Server timestamp on update',
          ], alt: true),

          pw.SizedBox(height: 10),
          subTitle('Collection: posts/{postId}'),
          tableHeader(['Field', 'Type', 'Required', 'Description']),
          tableRow(['id', 'string', 'Yes', 'Same as document ID']),
          tableRow(['userId', 'string', 'Yes', 'Author UID'], alt: true),
          tableRow(['userName', 'string', 'Yes', 'Author display name']),
          tableRow([
            'userPhotoUrl',
            'string',
            'No',
            'Author photo URL',
          ], alt: true),
          tableRow(['content', 'string', 'Yes', 'Post text content']),
          tableRow([
            'likesCount',
            'number',
            'Yes',
            'Total likes (default: 0)',
          ], alt: true),
          tableRow([
            'commentsCount',
            'number',
            'Yes',
            'Total comments (default: 0)',
          ]),
          tableRow([
            'createdAt',
            'Timestamp',
            'Yes',
            'Server timestamp',
          ], alt: true),

          pw.SizedBox(height: 10),
          subTitle('Sub-collections'),
          bulletItem('posts/{postId}/likes/{uid} - userId, createdAt'),
          bulletItem(
            'posts/{postId}/comments/{commentId} - id, userId, userName, userPhotoUrl, content, createdAt',
          ),
        ],
      ),
    ),
  );

  // ═══════════════════════════════════════════════
  // PAGE 9 - Use Cases Summary + DI
  // ═══════════════════════════════════════════════
  pdf.addPage(
    pw.Page(
      pageFormat: PdfPageFormat.a4,
      margin: const pw.EdgeInsets.all(40),
      build: (context) => pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          sectionTitle('9. Use Cases Summary'),
          bodyText(
            'Each use case encapsulates a single business operation. They validate inputs, delegate to the repository interface, and are the only entry point providers use to trigger backend operations.',
          ),
          pw.SizedBox(height: 6),

          subTitle('Authentication Use Cases'),
          tableHeader(['Use Case', 'Input', 'Output']),
          tableRow(['SignInUseCase', 'email, password', 'UserEntity']),
          tableRow([
            'SignInWithGoogleUseCase',
            '(none)',
            'UserEntity',
          ], alt: true),
          tableRow([
            'CreateAccountUseCase',
            'name, email, password',
            'UserEntity',
          ]),
          tableRow(['SignOutUseCase', '(none)', 'void'], alt: true),
          tableRow(['GetAuthStateUseCase', '(none)', 'Stream<UserEntity?>']),

          pw.SizedBox(height: 10),
          subTitle('Feed Use Cases'),
          tableHeader(['Use Case', 'Input', 'Output']),
          tableRow(['GetPostsUseCase', 'limit, lastPost?', 'List<PostEntity>']),
          tableRow(['CreatePostUseCase', 'content', 'PostEntity'], alt: true),
          tableRow([
            'ToggleLikeUseCase',
            'postId, isCurrentlyLiked',
            'PostEntity',
          ]),
          tableRow([
            'GetCommentsUseCase',
            'postId',
            'List<CommentEntity>',
          ], alt: true),
          tableRow(['AddCommentUseCase', 'postId, content', 'CommentEntity']),
          tableRow([
            'GetUserPostsUseCase',
            'userId',
            'List<PostEntity>',
          ], alt: true),

          pw.SizedBox(height: 10),
          subTitle('Profile Use Cases'),
          tableHeader(['Use Case', 'Input', 'Output']),
          tableRow(['GetProfileUseCase', 'uid', 'ProfileEntity']),
          tableRow([
            'GetCurrentProfileUseCase',
            '(none)',
            'ProfileEntity',
          ], alt: true),
          tableRow(['GetUserStatsUseCase', 'uid', 'ProfileStats']),

          divider(),

          sectionTitle('10. Dependency Injection'),
          bodyText(
            'All dependencies are registered centrally via GetIt in injection_container.dart. Each feature has its own DI module (auth_di.dart, feed_di.dart, profile_di.dart).',
          ),
          pw.SizedBox(height: 6),

          subTitle('Registration Strategy'),
          bulletItem(
            'Core Firebase services - registerLazySingleton (single instance)',
          ),
          bulletItem('Data sources - registerLazySingleton'),
          bulletItem(
            'Repositories (as abstract interfaces) - registerLazySingleton',
          ),
          bulletItem('Use cases - registerLazySingleton'),
          bulletItem('Providers - registerFactory (new instance per widget)'),
          pw.SizedBox(height: 4),
          bodyText(
            'No manual instantiation occurs inside widgets. All dependencies flow through the DI container, ensuring testability and clean separation.',
          ),
        ],
      ),
    ),
  );

  // ═══════════════════════════════════════════════
  // PAGE 10 - Error Handling
  // ═══════════════════════════════════════════════
  pdf.addPage(
    pw.Page(
      pageFormat: PdfPageFormat.a4,
      margin: const pw.EdgeInsets.all(40),
      build: (context) => pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          sectionTitle('11. Error Handling & Failure Mapping'),
          bodyText(
            'A sealed Failure class hierarchy provides typed error handling across the entire application. Raw Firebase exceptions are never exposed to end users.',
          ),
          pw.SizedBox(height: 6),

          subTitle('Failure Types'),
          tableHeader(['Failure Class', 'Source', 'Example']),
          tableRow([
            'AuthFailure',
            'Firebase Auth',
            'wrong-password, email-already-in-use',
          ]),
          tableRow([
            'ServerFailure',
            'Cloud Firestore',
            'permission-denied, not-found',
          ], alt: true),
          tableRow([
            'NetworkFailure',
            'Connectivity',
            'No internet connection',
          ]),
          tableRow([
            'ValidationFailure',
            'Use Case input',
            'Empty post content',
          ], alt: true),

          pw.SizedBox(height: 8),
          subTitle('Auth Error Mappings'),
          tableHeader(['Firebase Code', 'User-Friendly Message']),
          tableRow(['wrong-password', 'Incorrect password. Please try again.']),
          tableRow([
            'user-not-found',
            'No account found with this email.',
          ], alt: true),
          tableRow([
            'email-already-in-use',
            'An account with this email already exists.',
          ]),
          tableRow([
            'invalid-email',
            'Please enter a valid email address.',
          ], alt: true),
          tableRow([
            'too-many-requests',
            'Too many attempts. Please try again later.',
          ]),
          tableRow([
            'network-request-failed',
            'No internet connection. Please check your network.',
          ], alt: true),
          tableRow([
            'weak-password',
            'Password is too weak. Please choose a stronger password.',
          ]),
          tableRow(['sign_in_canceled', 'Sign-in was cancelled.'], alt: true),
          tableRow(['(default)', 'Something went wrong. Please try again.']),

          pw.SizedBox(height: 8),
          subTitle('Error Flow'),
          infoBox([
            pw.Text(
              'Firebase SDK throws exception\n'
              '  --> Data source catches --> rethrows raw exception\n'
              '  --> Repository catches --> maps to Failure subclass with user-friendly message\n'
              '  --> Use case propagates Failure\n'
              '  --> Provider catches Failure --> sets errorMessage\n'
              '  --> UI shows snackbar with errorMessage',
              style: smallStyle,
            ),
          ]),
        ],
      ),
    ),
  );

  // ═══════════════════════════════════════════════
  // PAGE 11 - Security Rules
  // ═══════════════════════════════════════════════
  pdf.addPage(
    pw.Page(
      pageFormat: PdfPageFormat.a4,
      margin: const pw.EdgeInsets.all(40),
      build: (context) => pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          sectionTitle('12. Firestore Security Rules'),
          bodyText(
            'All Firestore security rules are versioned in the repository (firestore.rules). The rules enforce authentication, ownership, and field validation at the database level.',
          ),
          pw.SizedBox(height: 6),

          subTitle('Users Collection - /users/{uid}'),
          bulletItem('Read: Any authenticated user can read any user profile'),
          bulletItem(
            'Create: Only the owner (auth.uid == uid) with required fields validated (uid, name, email, createdAt)',
          ),
          bulletItem('Update: Only the owner (auth.uid == uid)'),
          bulletItem('Delete: Denied in MVP'),

          subTitle('Posts Collection - /posts/{postId}'),
          bulletItem('Read: Any authenticated user'),
          bulletItem(
            'Create: Authenticated users, only for themselves (userId == auth.uid), required fields validated',
          ),
          bulletItem(
            'Update: Post author can update anything; other authenticated users can only update likesCount/commentsCount',
          ),
          bulletItem('Delete: Only the post author'),

          subTitle('Likes Sub-collection - /posts/{postId}/likes/{likeId}'),
          bulletItem('Read: Any authenticated user'),
          bulletItem(
            'Create: Only if likeId == auth.uid (user can only create their own like)',
          ),
          bulletItem(
            'Delete: Only if likeId == auth.uid (user can only remove their own like)',
          ),
          bulletItem('Update: Denied'),

          subTitle(
            'Comments Sub-collection - /posts/{postId}/comments/{commentId}',
          ),
          bulletItem('Read: Any authenticated user'),
          bulletItem(
            'Create: Authenticated users, only for themselves (userId == auth.uid), required fields validated',
          ),
          bulletItem('Update: Only the comment author'),
          bulletItem('Delete: Only the comment author'),

          subTitle('Default Rule'),
          infoBox([
            pw.Text(
              'match /{document=**} {\n  allow read, write: if false;\n}\n\nAll paths not explicitly matched are denied by default.',
              style: smallStyle,
            ),
          ]),

          subTitle('Security Principles'),
          bulletItem('No unauthenticated access to any data'),
          bulletItem('Users cannot impersonate other users in writes'),
          bulletItem('Required fields are validated at the database level'),
          bulletItem('No broad permissive catch-all rules'),
          bulletItem(
            'Rules are version-controlled and reviewed with schema changes',
          ),
        ],
      ),
    ),
  );

  // ═══════════════════════════════════════════════
  // PAGE 12 - Navigation + Core Services + Post-MVP
  // ═══════════════════════════════════════════════
  pdf.addPage(
    pw.Page(
      pageFormat: PdfPageFormat.a4,
      margin: const pw.EdgeInsets.all(40),
      build: (context) => pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          sectionTitle('13. App Navigation & Auth Routing'),
          bodyText(
            'GoRouter manages all navigation with auth-aware redirects. The splash screen checks Firebase Auth state and routes accordingly.',
          ),
          pw.SizedBox(height: 4),

          subTitle('Routes'),
          tableHeader(['Path', 'Screen', 'Auth Required']),
          tableRow(['/splash', 'Splash Screen', 'No (checks auth)']),
          tableRow(['/login', 'Login Screen', 'No'], alt: true),
          tableRow(['/create-account', 'Create Account Screen', 'No']),
          tableRow(['/feed', 'Feed Screen', 'Yes'], alt: true),
          tableRow(['/profile', 'Profile Screen', 'Yes']),

          pw.SizedBox(height: 4),
          subTitle('Auth Redirect Logic'),
          bulletItem(
            'Splash: no redirect - handles its own auth-aware navigation',
          ),
          bulletItem(
            'Not logged in + protected route --> redirected to /login',
          ),
          bulletItem(
            'Logged in + auth page (login/create-account) --> redirected to /feed',
          ),

          divider(),

          sectionTitle('14. Core Services & Utilities'),
          pw.SizedBox(height: 4),
          bulletItem(
            'FirebaseAuthService - wraps all FirebaseAuth SDK calls; single import point for auth',
          ),
          bulletItem(
            'FirestoreService - wraps all Firestore SDK calls; provides typed collection references',
          ),
          bulletItem(
            'LoggerService - centralized logging with class context (info, warning, error, success)',
          ),
          bulletItem(
            'NetworkService - connectivity monitoring via connectivity_plus',
          ),
          bulletItem(
            'LocalStorageService - flutter_secure_storage wrapper for small session flags',
          ),
          bulletItem(
            'Validators - email, password strength, name, and content validation utilities',
          ),
          bulletItem(
            'SystemUtils - system UI configuration and orientation lock',
          ),
          bulletItem('ResponsiveConfig - mobile/tablet breakpoint management'),

          divider(),

          sectionTitle('15. What Is NOT Included (Post-MVP)'),
          bodyText(
            'The following features are intentionally excluded from Milestone 01 and planned for future milestones:',
          ),
          pw.SizedBox(height: 4),
          bulletItem('Direct messaging / chat system'),
          bulletItem(
            'Push notifications (Firebase Messaging is imported but not wired)',
          ),
          bulletItem(
            'Full comments and likes advanced features (threading, reactions)',
          ),
          bulletItem('Advanced profile editing (bio, photo upload)'),
          bulletItem('Media upload pipeline (images/videos in posts)'),
          bulletItem('Friend/follow graph'),
          bulletItem('Search functionality'),
          bulletItem('Dark mode (color stubs exist but not implemented)'),
          bulletItem('Firebase Crashlytics / Analytics integration'),
          bulletItem('Comprehensive test suite (unit + widget + integration)'),
        ],
      ),
    ),
  );

  // ── Save ──
  final output = File('ETANA_OROKO_MVP.pdf');
  await output.writeAsBytes(await pdf.save());
  debugPrint('✅ PDF generated: ${output.path}');
}

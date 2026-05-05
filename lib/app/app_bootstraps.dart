import 'injection_container.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:etanaorokoapp/firebase_options.dart';
import '../core/services/logger/logger_service.dart';

/// One-time startup after [WidgetsFlutterBinding.ensureInitialized].
///
/// Order: Firebase → Google Sign-In → dependency injection.
Future<void> bootstrapApp() async {
  final logger = LoggerService(className: 'bootstrapApp');

  // Initialize Firebase
  logger.info('Initializing Firebase...');
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  logger.success('Firebase initialized');

  // Initialize Google Sign-In (required by google_sign_in v7+ before any auth calls)
  logger.info('Initializing Google Sign-In...');
  await GoogleSignIn.instance.initialize();
  logger.success('Google Sign-In initialized');

  // Initialize dependency injection container.
  logger.info('Registering dependencies...');
  await initializeDependencies();
  logger.success('Dependencies registered');
}

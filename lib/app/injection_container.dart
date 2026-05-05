import 'package:get_it/get_it.dart';
import '../features/auth/auth_di.dart';
import '../features/feed/feed_di.dart';
import '../features/profile/profile_di.dart';
import '../core/providers/theme_provider.dart';
import 'package:image_picker/image_picker.dart';
import '../core/services/network/network_service.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import '../core/services/firebase/firestore_service.dart';
import '../core/services/firebase/firebase_auth_service.dart';
import '../core/services/image picker/image_picker_service.dart';
import '../core/services/local storage/local_storage_service.dart';
import '../core/services/notifications/notifications_service.dart';

final di = GetIt.instance;

Future<void> initializeDependencies() async {
  /// --- Core ---
  // Local Storage Service
  di.registerLazySingleton<LocalStorageService>(() => LocalStorageService());

  // Image Picker Service
  di.registerLazySingleton<ImagePickerService>(
    () => ImagePickerService(picker: ImagePicker()),
  );

  // Connectivity
  di.registerLazySingleton(() => Connectivity());

  // Network Service
  di.registerLazySingleton<NetworkService>(() => NetworkService(di()));

  // Theme Provider
  di.registerLazySingleton(() => ThemeProvider());

  // Push / local notifications — lazy so registration does not touch Firebase/FCM yet.
  di.registerLazySingleton<NotificationService>(
    () => NotificationService.instance,
  );

  /// --- Firebase Services ---
  // Firebase Auth Service
  di.registerLazySingleton<FirebaseAuthService>(() => FirebaseAuthService());

  // Firestore Service
  di.registerLazySingleton<FirestoreService>(() => FirestoreService());

  /// --- Features ---
  // Auth feature dependencies
  AuthDi.init(di);

  // Feed feature dependencies
  FeedDi.init(di);

  // Profile feature dependencies
  ProfileDi.init(di);
}

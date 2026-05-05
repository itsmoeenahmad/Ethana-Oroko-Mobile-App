import 'core/utils/system_utils.dart';
import 'package:flutter/material.dart';
import 'core/config/responsive_config.dart';
import 'core/services/logger/logger_service.dart';
import 'package:etanaorokoapp/app/app_bootstraps.dart';
import 'package:etanaorokoapp/app/etanaoroko_app.dart';

void main() async {
  final logger = LoggerService(className: 'main');

  WidgetsFlutterBinding.ensureInitialized();
  logger.info('Flutter bindings initialized');

  logger.info('App starting...');

  SystemUtils.setDefaultSystemUI();
  logger.info('System UI configured');

  await SystemUtils.lockOrientation();
  logger.info('Orientation lock applied');

  await bootstrapApp();
  logger.success('Application bootstrap completed');

  /// For development, you can use DevicePreview to test responsiveness on different devices.
  // runApp(
  //   DevicePreview(
  //     enabled: true,
  //     builder: (context) => ResponsiveProvider(
  //       mobileSize: Size(360, 800),
  //       tabletSize: Size(800, 1280),
  //       isDebugPrint: true,
  //       child: const EtanaorokoApp(),
  //     ),
  //   ),
  // );

  runApp(
    ResponsiveProvider(
      mobileSize: Size(360, 800),
      tabletSize: Size(800, 1280),
      isDebugPrint: true,
      child: EtanaorokoApp(),
    ),
  );
  logger.info('App widget mounted');
}

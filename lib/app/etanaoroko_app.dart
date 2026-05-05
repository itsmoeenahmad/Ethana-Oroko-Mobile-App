import 'injection_container.dart';
import '../core/theme/app_theme.dart';
import 'package:flutter/material.dart';
import '../core/router/app_router.dart';
import 'package:provider/provider.dart';
import '../core/providers/theme_provider.dart';

class EtanaorokoApp extends StatelessWidget {
  const EtanaorokoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => di<ThemeProvider>()),
      ], // contain only global providers.
      child: Consumer<ThemeProvider>(
        builder: (_, themeProvider, _) {
          return MaterialApp.router(
            title: 'Etana Oroko',
            debugShowCheckedModeBanner: false,

            // Themes - Light theme only for now
            theme: AppTheme.light,
            // Dark theme will be implemented in future
            // darkTheme: AppTheme.dark,
            themeMode: ThemeMode.light, // Force light theme for now
            // Router
            routerConfig: AppRouter.appRouter,
          );
        },
      ),
    );
  }
}

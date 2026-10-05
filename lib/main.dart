import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'core/di/dependency_injection.dart';
import 'core/routes/app_routes.dart';
import 'app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize dependency injection (includes CacheService + StorageService init)
  await DependencyInjection.init();

  // Allow runtime fetching so fonts download in the background after first launch.
  // Do NOT await — font download must never block the startup path.
  GoogleFonts.config.allowRuntimeFetching = true;
  GoogleFonts.pendingFonts([GoogleFonts.roboto()]).catchError((e) {
    debugPrint('Font pre-caching failed: $e');
    return <void>[];

  });


  // Set preferred orientations
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);



  runApp(MyApp(initialRoute: AppRoutes.splash));
  //Hello we are
}
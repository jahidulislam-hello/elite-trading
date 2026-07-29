import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'core/services/cache_service.dart';
import 'core/di/dependency_injection.dart';
import 'core/routes/app_routes.dart';
import 'app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize cache service
  await CacheService().init();

  // Initialize dependency injection
  await DependencyInjection.init();

  // Pre-cache Roboto font - downloads once and caches for offline use
  GoogleFonts.config.allowRuntimeFetching = true;

  // Pre-load Roboto font to cache it on first run
  try {
    await Future.wait([
      GoogleFonts.pendingFonts([GoogleFonts.roboto()]),
    ]);
  } catch (e) {
    // If offline or font loading fails, app will use fallback fonts
    debugPrint('Font pre-caching failed: $e');
  }

  // Set preferred orientations
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  runApp(MyApp(initialRoute: AppRoutes.splash));
}
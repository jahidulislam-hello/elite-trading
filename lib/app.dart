import 'package:elite_trading/core/routes/app_pages.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class MyApp extends StatelessWidget {
  final String initialRoute;
  const MyApp({super.key, required this.initialRoute});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(375, 812),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return GetMaterialApp(
          title: 'HealthCare App',
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            fontFamily: 'Helvetica',
            textTheme: GoogleFonts.poppinsTextTheme(
              Theme.of(context).textTheme,
            ),
            appBarTheme: AppBarTheme(
              backgroundColor: Colors.white,
              elevation: 0,
              iconTheme: const IconThemeData(color: Colors.black87),
              systemOverlayStyle: const SystemUiOverlayStyle(
                statusBarColor: Colors.transparent,
                statusBarIconBrightness: Brightness.light,
                statusBarBrightness: Brightness.dark,
              ),
              titleTextStyle: TextStyle(
                fontFamily: 'Helvetica',
                color: Colors.black87,
                fontSize: 18,
              ),
            ),
          ),
          defaultTransition: Transition.rightToLeft,
          transitionDuration: const Duration(milliseconds: 250),
          initialRoute: initialRoute,
          getPages: AppPages.routes,
          builder: (context, widget) {
            // এই AnnotatedRegion পুরো app-এর সবচেয়ে বাইরের layer-এ বসে,
            // তাই route-level override-কেও ছাপিয়ে সবসময় সাদা status bar icon দেখাবে —
            // AppBar থাকুক বা না থাকুক, যেকোনো স্ক্রিনেই।
            return AnnotatedRegion<SystemUiOverlayStyle>(
              value: const SystemUiOverlayStyle(
                statusBarColor: Colors.transparent,
                statusBarIconBrightness: Brightness.light, // Android — সাদা icon
                statusBarBrightness: Brightness.dark,       // iOS — সাদা icon
                systemNavigationBarColor: Colors.transparent,
                systemNavigationBarIconBrightness: Brightness.light,
              ),
              child: widget ?? const SizedBox.shrink(),
            );
          },
        );
      },
    );
  }
}
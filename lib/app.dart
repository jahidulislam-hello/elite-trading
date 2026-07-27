import 'package:elite_trading/core/routes/app_pages.dart';
import 'package:elite_trading/core/routes/app_routes.dart';
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
            // primaryColor: AppColors.primary,
            // scaffoldBackgroundColor: AppColors.background,

            textTheme: GoogleFonts.poppinsTextTheme(
            Theme.of(context).textTheme,
          ),
            appBarTheme: AppBarTheme(
              backgroundColor: Colors.white,
              elevation: 0,
              iconTheme: const IconThemeData(color: Colors.black87),
              titleTextStyle: TextStyle(
                fontFamily: 'Helvetica',
                color: Colors.black87,
                fontSize: 18,
              ),
            ),
          ),
          defaultTransition: Transition.rightToLeft,
          transitionDuration: const Duration(milliseconds: 250),
          initialRoute:AppRoutes.profilePage,//initialRoute,
          getPages: AppPages.routes,
        );
      },
    );
  }
}
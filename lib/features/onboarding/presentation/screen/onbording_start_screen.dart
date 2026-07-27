import 'package:elite_trading/core/routes/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/utils/app_colors.dart';
import 'package:get/get.dart';

class OnbordingStartScreen extends StatelessWidget {
  const OnbordingStartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            height: double.infinity,
            width: double.infinity,
            padding: EdgeInsets.only(bottom: 100.h),
            color: AppColors.backBackground,
            child: Image.asset("asset/image/onboarding/onebordartingStart.png",fit: BoxFit.cover,),
          ),
          Container(
            padding: EdgeInsets.all(30.h),
            child:Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: 20.h,),
                Image.asset("asset/image/onboarding/logo.png"),
                SizedBox(height: 248.h,),
                Image.asset("asset/image/onboarding/staring_icons.png"),
                Text("Smart Signals",
                    style:GoogleFonts.poppins(
                        color:Colors.white,fontSize: 25.h,fontWeight: FontWeight.w600
                    )),
                Text("Elite Results.",
                    style:GoogleFonts.poppins(
                        color:AppColors.purple,fontSize:25.h,fontWeight: FontWeight.w600
                    )),
                SizedBox(height: 7.h,),

                Container(
                  height: 2,
                  width: 70.w,
                  color:AppColors.purple,
                ),
                SizedBox(height: 7.h,),

                Text("Get Premium trading signals, market analysis and",
                    textAlign: TextAlign.center,
                    style:GoogleFonts.poppins(
                        color:AppColors.darkWhite,fontSize: 12,fontWeight: FontWeight.w400
                    )),
                Text("real-time alerts to stay ahead in the market",
                    textAlign: TextAlign.center,
                    style:GoogleFonts.poppins(
                        color:AppColors.darkWhite,fontSize: 12,fontWeight: FontWeight.w400
                    )),
                SizedBox(height: 15.h,),
                SizedBox(
                  width: double.infinity,
                  height: 45.h,
                  child: ElevatedButton(
                    onPressed: (){
                      Get.offAllNamed(AppRoutes.signInScreen);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.purple,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.r),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("Get Started",
                            textAlign: TextAlign.center,
                            style: GoogleFonts.poppins(
                                color: Colors.white, fontSize: 18, fontWeight: FontWeight.w400
                            )),
                        SizedBox(width: 8.w),
                        Icon(Icons.arrow_forward, color: Colors.white, size: 19,)
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 12.h,),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset("asset/image/onboarding/bracket_left.png"),
                    Text("Join thousands of successful traders today",
                        textAlign: TextAlign.center,
                        style:GoogleFonts.poppins(
                            color: AppColors.darkWhite,fontSize: 12,fontWeight: FontWeight.w400
                        )),
                    Image.asset("asset/image/onboarding/bracket_right.png"),
                  ],
                ),

              ],
            ),
          )
        ],
      ),
    );
  }
}

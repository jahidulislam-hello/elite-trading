import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/routes/app_routes.dart';
import '../../../../core/utils/app_colors.dart';
import 'package:get/get.dart';

class OnebordingTwo extends StatelessWidget {
  const OnebordingTwo({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            height: double.infinity,
            width: double.infinity,
            padding: EdgeInsets.symmetric(vertical: 50.h),
            color: AppColors.backBackground,
            child: Image.asset("asset/image/onboarding/onbordingSecond.png",fit: BoxFit.cover,),
          ),
          Container(
            padding: EdgeInsets.all(24),
            child:Column(
              children: [
                SizedBox(height: 10.h,),
                Align(
                  alignment: Alignment.topRight,
                  child:TextButton(onPressed:(){
                    Get.offNamed(AppRoutes.onbordingStartScreen);
                  },
                      child:Text("Skip",style:GoogleFonts.poppins(
                          color: Colors.white,fontSize: 15,fontWeight: FontWeight.w600
                      ),)
                  ),
                ),
                SizedBox(height: 220.h,),
                Text("Real-time",
                    style:GoogleFonts.poppins(
                        color: Colors.white,fontSize: 32,fontWeight: FontWeight.w600
                    )),

                Text("Trading Alerts",
                    style:GoogleFonts.poppins(
                        color:AppColors.purple,fontSize: 32,fontWeight: FontWeight.w600
                    )),
                SizedBox(height: 7.h,),

                Container(
                  height: 1,
                  width: 50.w,
                  color:AppColors.purple,
                ),
                SizedBox(height: 7.h,),

                Text("Instant notifications for high",
                    textAlign: TextAlign.center,
                    style:GoogleFonts.poppins(
                        color: Colors.white,fontSize: 16,fontWeight: FontWeight.w400
                    )),
                Text("probability trading opportunities so",
                    textAlign: TextAlign.center,
                    style:GoogleFonts.poppins(
                        color: Colors.white,fontSize: 16,fontWeight: FontWeight.w400
                    )),
                Text("you never miss a move.",
                    textAlign: TextAlign.center,
                    style:GoogleFonts.poppins(
                        color: Colors.white,fontSize: 16,fontWeight: FontWeight.w400
                    )),
                SizedBox(height: 290.h,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Container(
                          height: 8.h,
                          width: 12.w,
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.3),
                            borderRadius: BorderRadius.circular(4.r),
                          ),
                        ),
                        SizedBox(width: 6.w),
                        Container(
                          height: 8.h,
                          width: 20.w,
                          decoration: BoxDecoration(
                            color: AppColors.purple,
                            borderRadius: BorderRadius.circular(4.r),
                          ),
                        ),
                        SizedBox(width: 6.w),
                        Container(
                          height: 8.h,
                          width: 12.w,
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.3),
                            borderRadius: BorderRadius.circular(4.r),
                          ),
                        ),
                      ],
                    ),
                    InkWell(
                      onTap: (){
                        Get.toNamed(AppRoutes.onebordingThree);
                      },
                      child: Container(
                        height: 36.h,
                        width: 36.w,
                        decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: AppColors.purple,
                            border: Border.all(
                                width:1,color: Colors.green
                            )
                        ),
                        child: const Icon(
                          Icons.arrow_forward,
                          size: 19,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}

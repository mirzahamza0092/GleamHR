import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gleam_hr/Components/CommonButton.dart';
import 'package:gleam_hr/Components/CommonText.dart';
import 'package:gleam_hr/Providers/DashBoardProviders/DashBoard_Provider.dart';
import 'package:gleam_hr/Providers/DashBoardProviders/HomeProviders/TimeTrackingProvider.dart';
import 'package:gleam_hr/Utils/AppConstants.dart';
import 'package:gleam_hr/Utils/AppPaths.dart';
import 'package:gleam_hr/Utils/Colors.dart';
import 'package:gleam_hr/Utils/Methods.dart';
import 'package:gleam_hr/Utils/SizedBox.dart';
import 'package:provider/provider.dart';

class CommonDashBoardCard extends StatelessWidget {
  bool isTimeTracking, userExistInCheckinLocation;
  // for hiding button according to attendance permission
  bool showButton, menurequired;List<String>items;
  String title, subTitle, leadingPath, buttonTitle;
  var menuOnPressed, buttonOnPressed, eyeOnPressed, faceOnPressed, cardOnPressed;
  Color? color;
  Color textColor;
  Widget contain, bottomerror;
  CommonDashBoardCard({
    required this.title,
    required this.subTitle,
    required this.leadingPath,
    required this.menuOnPressed,
    required this.buttonOnPressed,
    this.color,
    this.textColor=Colors.white,
    this.showButton = true,
    this.items=const [],
    this.contain = const SizedBox(height: 14),
    this.bottomerror = const SizedBox(),
    this.userExistInCheckinLocation = true,
    required this.buttonTitle,
    this.isTimeTracking = false,
    this.eyeOnPressed,
    this.faceOnPressed,
    this.cardOnPressed,
    this.menurequired = true,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: cardOnPressed,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12), color: AppColors.whiteColor),
        padding: const EdgeInsets.all(12),
        child: Padding(
          padding: const EdgeInsets.all(6.0),
          child: Column(
            // mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              ListTile(
                contentPadding: EdgeInsets.zero,
                tileColor: Colors.transparent,
                title: AppConstants.loginmodell!
                            .userAttendanceData["employeeLatestAttendance"]
                            .toString() !=
                        "null"
                    ? Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          CommonTextPoppins(
                                  text: title,
                                  talign: TextAlign.left,
                                  fontweight: FontWeight.w500,
                                  textOverflow: TextOverflow.ellipsis,
                                  fontsize: 16,
                                  color: AppColors.textColor)
                              .animate()
                              .fade(duration: 500.ms)
                              .scale(delay: 500.ms),
                          4.sw,
                          isTimeTracking
                              ? AppConstants
                                          .loginmodell!
                                          .userAttendanceData[
                                              "employeeLatestAttendance"]
                                              ["time_in_status"]
                                          .toString() ==
                                      "Late"
                                  ? Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 3, vertical: 3),
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(100),
                                          color: const Color(0XFFE34A4A)),
                                      child: CommonTextPoppins(
                                          text: "Late",
                                          fontweight: FontWeight.w600,
                                          fontsize: 9.5,
                                          color: AppColors.whiteColor),
                                    )
                                  : const SizedBox()
                              : const SizedBox(),
                        ],
                      )
                    : CommonTextPoppins(
                        text: title,
                        talign: TextAlign.left,
                        fontweight: FontWeight.w500,
                        fontsize: 16,
                        color: AppColors.textColor),
                leading: Stack(
                  children: [
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        isTimeTracking ? 5.sh : 0.sh,
                        Container(
                            width: 50,
                            height: 50,
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                color: const Color(0XFFF6F6F6)),
                            child: SvgPicture.asset(
                              leadingPath,
                              width: 24,
                              height: 24,
                            )),
                      ],
                    ),
                    isTimeTracking
                        ? Container(
                            margin: const EdgeInsets.symmetric(horizontal: 5),
                            decoration: const BoxDecoration(
                              color: Colors.blue,
                              borderRadius: BorderRadius.only(
                                  bottomLeft: Radius.circular(5),
                                  bottomRight: Radius.circular(5)),
                            ),
                            width: 40, height: 12,
                            //"00:00:00"
                            child: FittedBox(child: Consumer<DashBoardProvider>(
                                builder: (context, provider, child) {
                              if (!provider.timerr!.isActive) {
                                if (AppConstants.clocktype == "OUT") {
                                  provider.timerr =
                                      Timer(const Duration(seconds: 1), () {
                                    debugPrint("heyyheyy");
                                    provider.changetimer();
                                  });
                                }
                              }
                              return CommonTextPoppins(
                                  text: AppConstants.loginmodell!.userData!
                                              .todayWorkingHours
                                              .toString() ==
                                          'null'
                                      ? '00:00:00'
                                      : Functions.getWorkingTime(int.parse(
                                              AppConstants.loginmodell!.userData!
                                                  .todayWorkingHours
                                                  .toString()) +
                                          provider.addtimer),
                                  fontweight: FontWeight.w300,
                                  fontsize: 12,
                                  color: AppColors.whiteColor);
                            })),
                          )
                        : const SizedBox(),
                  ],
                ),
                subtitle: FittedBox(
                  fit: BoxFit.scaleDown,
                  alignment: Alignment.bottomLeft,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CommonTextPoppins(
                          text: subTitle,
                          talign: TextAlign.left,
                          fontweight: FontWeight.w500,
                          fontsize: 14,
                          color: AppColors.hintTextColor),
                    ],
                  ),
                ),
                trailing: menurequired
                    ? Column(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                           Expanded(
                                child: PopupMenuButton<String>(
                                        onSelected: (value) {
                                          // Update the selected value when an option is chosen
                                          menuOnPressed(value);
                                        },
                                        itemBuilder: (BuildContext context) {
                                          // Create a list of dropdown menu items
                                          return items.map((String option) {
                                            return PopupMenuItem<String>(
                                              value: option,
                                              child: CommonTextPoppins(text: option,fontweight: FontWeight.w500,fontsize: 15,color: AppColors.blackColor ,),
                                            );
                                          }).toList();
                                        },
                                      ),
                              ),
                          20.sh
                        ],
                      )
                    : const SizedBox(),
              ),
              contain,
              10.sh,
              Row(
                children: [
                  showButton == false
                      ? const SizedBox()
                      : Expanded(
                          flex: 3,
                          child:Consumer<DashBoardProvider>(
                            builder: (context, dashBoardProvider, child) {
                              return isTimeTracking && dashBoardProvider.checkinLoading? const LinearProgressIndicator():CommonButton(
                           color: color,
                            onPressed:
                                //userExistIninLocation
                                //?
                                buttonOnPressed
                            //           : () async{
                            //             debugPrint("objectobjectobjectobjectobjectobject");
                            //              ScaffoldMessenger.of(context).showSnackBar(
                            // SnackBar(content: CommonTextPoppins(
                            //                       text:
                            //                           "Sorry! You Are Not In The Radius Of GlowLogix",
                            //                       fontweight: FontWeight.w500,
                            //                       fontsize: 18,
                            //                       color: AppColors.whiteColor)));
                            //             },
                            ,
                            textColor: textColor,
                            width: width(context),
                            text: buttonTitle,
                            shadowneeded: false,
                            gradientneeded: false,
                          );})),
                  isTimeTracking &&
                          showButton &&
                          AppConstants.loginmodell!
                                  .userAttendanceData["facial_recognition"]
                                  .toString() ==
                              "true"
                      ? const SizedBox(
                          width: 8,
                        )
                      : const SizedBox(),
                  // face attandance
                  isTimeTracking &&
                          showButton &&
                          AppConstants.loginmodell!
                                  .userAttendanceData["facial_recognition"]
                                  .toString() ==
                              "true"
                      ? Expanded(
                          flex: 1,
                          child: InkWell(
                              onTap: faceOnPressed,
                              child: Consumer<TimeTrackingProvider>(
                                  builder: (context, timetracking, child) {
                                return !timetracking.allowAttandanceloading
                                    ? Container(
                                        height: 56,
                                        decoration: BoxDecoration(
                                            border: Border.all(
                                                color: const Color(0XFFc9dbe5)),
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            color:AppColors.primaryColor.withOpacity(.11),),
                                        alignment: Alignment.centerRight,
                                        child: Center(
                                          child: SvgPicture.asset(
                                            ImagePath.faceIcon,
                                            color: AppColors.primaryColor,
                                          ),
                                        ),
                                      )
                                    : const SizedBox(
                                        width: 50,
                                        height: 50,
                                        child: CircularProgressIndicator());
                              })))
                      : Container(),
                  isTimeTracking == true
                      ? const SizedBox(
                          width: 8,
                        )
                      : const SizedBox(),
                  isTimeTracking
                      ? Expanded(
                          flex: 1,
                          child: InkWell(
                            onTap: eyeOnPressed,
                            child: Container(
                              height: 56,
                              decoration: BoxDecoration(
                                  border:
                                      Border.all(color: const Color(0XFFc9dbe5)),
                                  borderRadius: BorderRadius.circular(10),
                                  color: const Color(0XFFf3f6f8)),
                              alignment: Alignment.centerRight,
                              child: const Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Center(
                                  child:
                                      Image(image: AssetImage('assets/eye.png'),color: Colors.black,),
                                ),
                              ),
                            )))
                        : Container(),
              ],
                ),
                10.sh,
                bottomerror,
              ],
            ),
          ),
        ),
    )
    ;
  }
}

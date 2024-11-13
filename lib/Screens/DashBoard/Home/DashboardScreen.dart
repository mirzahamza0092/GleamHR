// ignore_for_file: use_build_context_synchronously

import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_scroll_to_top/flutter_scroll_to_top.dart';
import 'package:geolocator/geolocator.dart';
import 'package:gleam_hr/Components/CommonAppBar.dart';
import 'package:gleam_hr/Providers/BottomNavigationProvider/BottomBarIcon_Provider.dart';
import 'package:gleam_hr/Providers/DashBoardProviders/DashBoard_Provider.dart';
import 'package:gleam_hr/Providers/DashBoardProviders/MoreProviders/LiveLocation_Provider.dart';
import 'package:gleam_hr/Screens/DashBoard/Home/HomeCards/AssetRequest.dart';
import 'package:gleam_hr/Screens/DashBoard/Home/HomeCards/ExpenseRequest.dart';
import 'package:gleam_hr/Screens/DashBoard/Home/HomeCards/Payroll.dart';
import 'package:gleam_hr/Screens/DashBoard/Home/HomeCards/TimeOff.dart';
import 'package:gleam_hr/Screens/DashBoard/Home/HomeCards/TimeTracking.dart';
import 'package:gleam_hr/Components/CommonText.dart';
import 'package:gleam_hr/Screens/DashBoard/Home/HomeCards/WorkFromHome.dart';
import 'package:gleam_hr/Services/BackgroundServices/BackGround_Services.dart';
import 'package:gleam_hr/Utils/AppConstants.dart';
import 'package:gleam_hr/Utils/AppPaths.dart';
import 'package:gleam_hr/Utils/Colors.dart';
import 'package:gleam_hr/Utils/SizedBox.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});
  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final dashBoardProvider =
          Provider.of<DashBoardProvider>(context, listen: false);
      //
      
      //
      if (AppConstants.loginmodell!
                  .userAttendanceData["mobile_attendance_permission"] ==
              true &&
          AppConstants.loginmodell!.userAttendanceData["geo_fencing"] == true) {
        //change destination lat,lng
        dashBoardProvider.changeBasiclatlongandradius(
            AppConstants.loginmodell!.userData!.location == null
                ? "0.0"
                : AppConstants.loginmodell!.userData!.location["latitude"]
                    .toString(),
            AppConstants.loginmodell!.userData!.location == null
                ? "0.0"
                : AppConstants.loginmodell!.userData!.location["longitude"]
                    .toString(),
            AppConstants.loginmodell!.userAttendanceData["geo_radius"]
                .toString());
        // Listen for changes in the user's position and check the geofence status.
        // location listner
        if (dashBoardProvider.stream==null) {
        dashBoardProvider.stream = Geolocator.getPositionStream().listen((position) {
          dashBoardProvider.checkGeofenceStatus(position);
        });
        // Listen for geofence transitions and update the geofence status.
          if (dashBoardProvider.streamrunning==false) {
        dashBoardProvider.streamController.stream.listen((transition) {
          dashBoardProvider.changelocation(transition);
          // dashBoardProvider.geofenceStatus = transition;
        });
          }
        }
      } else {
        dashBoardProvider.changeGeoFensingStatus("Entered");
      }

      //for initial checkin from login
      if (AppConstants.button == "check_out" &&
          AppConstants.clocktype == "OUT") {
        dashBoardProvider.checkin(true);
      } else {
        dashBoardProvider.checkin(false);
      }
      //for initial schedule start time and end time
      dashBoardProvider.schedulestarttime = AppConstants
          .loginmodell!.userWorkSchedule!.workSchedule["schedule_start_time"];
      dashBoardProvider.scheduleendtime = AppConstants
          .loginmodell!.userWorkSchedule!.workSchedule["schedule_end_time"];

      //check latlong for apis
      debugPrint(
          "current longitude${AppConstants.loginmodell!.userData!.currentLongitude}");
      debugPrint(
          "current latitude${AppConstants.loginmodell!.userData!.currentLatitude}");
    });

    //Live location
    if(AppConstants.loginmodell!.userData!.trackLocation == 1){
      final liveLocationProvider =
          Provider.of<LiveLocationProvider>(context, listen: false);
          // get datetime only when user work schedule is not completed
      if (AppConstants.liveLocationTimer.tick==0 || !AppConstants.liveLocationTimer.isActive) {
      DateTime startTime = DateFormat('HH:mm').parse(AppConstants.loginmodell!.userWorkSchedule!.scheduleStartTime.toString());
      DateTime endTime = DateFormat('HH:mm').parse(AppConstants.loginmodell!.userWorkSchedule!.scheduleEndTime.toString());
      DateTime currentTime = DateFormat('HH:mm').parse(DateFormat('HH:mm').format(DateTime.now()));
      debugPrint("live location timer not running noe starting");
      if (currentTime.isAfter(startTime) && currentTime.isBefore(endTime)) {
      debugPrint("live location timer started");
      //background and foreground service
      if (AppConstants.loginmodell!.userData!.trackLocation == 1) {
        // initializeService();
      if (Platform.isAndroid || Platform.isIOS) {
      initPlatformState();
      }
            }
      //
      //foreground service
      // AppConstants.liveLocationTimer=Timer.periodic(Duration(minutes: int.parse(AppConstants.loginmodell!.userData!.frequency.toString())), (Timer timer) async{
      // await liveLocationProvider.liveLocation();
      // });
      //
      }else{
        debugPrint("live location timer stopped");
        //stop timer
      }
      }else{
        debugPrint("live location timer already running");
      }
    }
    super.initState();
  }

  Future createFolderInAppDocDir(String folderName) async {
    //Get this App Document Directory
    Directory? appDocDir = await getExternalStorageDirectory();
    debugPrint(appDocDir!.path);
  }

  @override
  Widget build(BuildContext context) {
    final dashBoardProvider =
        Provider.of<DashBoardProvider>(context, listen: false);
    return Scaffold(
      backgroundColor: AppColors.pageBackgroundColor,
      appBar: PreferredSize(
          preferredSize: Size(width(context), 120),
          child: Consumer<DashBoardProvider>(
            builder: (context, dashBoardProvider, child) {
              return CommonAppBar(
                  subtitle:
                      "${AppConstants.loginmodell!.userData!.firstname} ${(AppConstants.loginmodell!.userData!.lastname).toString() == "null" ? "" : AppConstants.loginmodell!.userData!.lastname} ",
                  trailingimagepath:
                      "https://${Keys.domain}.gleamhrm.com/${AppConstants.loginmodell!.userData!.picture}");
            },
          )),
      body: Consumer<DashBoardProvider>(builder: (context, provider, child) {
        return RefreshIndicator(
            key: context.read<DashBoardProvider>().refreshIndicatorKey,
            color: AppColors.primaryColor,
            onRefresh: () => context.read<DashBoardProvider>().hitRefresh(
                context: context,
                employeeId: AppConstants.loginmodell!.userData!.id.toString()),
            child: SafeArea(
              child: ScrollWrapper(
                promptAlignment: Alignment.topCenter,
                promptAnimationCurve: Curves.elasticInOut,
                promptDuration: const Duration(milliseconds: 400),
                enabledAtOffset: 20,
                scrollOffsetUntilVisible: 20,
                alwaysVisibleAtOffset: true,
                promptReplacementBuilder: (context, function) => InkWell(
                  onTap: () => function(),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SafeArea(child: Container()),
                      Container(
                        height: 30,
                        width: 150,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color: AppColors.textColor),
                        child: Center(
                            child: CommonTextPoppins(
                                text: "Go Upward ∧",
                                fontweight: FontWeight.w500,
                                fontsize: 14,
                                color: AppColors.whiteColor)),
                      ),
                    ],
                  ),
                ),
                builder: (context, properties) => SingleChildScrollView(
                  controller: properties.scrollController,
                  scrollDirection: properties.scrollDirection,
                  reverse: properties.reverse,
                  primary: properties.primary,
                  physics: const AlwaysScrollableScrollPhysics(),
                  child: Consumer<BottomBarIconProvider>(
                    builder: (context, bottomBarIconProvider, child) {
                      return Column(
                    children: [
                      // just check the meter away from destination
                      // Consumer<DashBoardProvider>(
                      //   builder: (context, myType, child) {
                      //     return Text(myType.checkdistance.toString());
                      //   },
                      // ),
                      AppConstants.modulesmodell!.data![6].status.toString() ==
                              "1" && bottomBarIconProvider.bottomBarAddContent[0].isCheck
                          ? const TimeTracking()
                          : const SizedBox(),
                      AppConstants.modulesmodell!.data![0].status.toString() ==
                              "1" && bottomBarIconProvider.bottomBarAddContent[1].isCheck
                          ? Payroll(dashBoardProvider: dashBoardProvider)
                          : const SizedBox(),
                      AppConstants.modulesmodell!.data![8].status.toString() ==
                              "1" && bottomBarIconProvider.bottomBarAddContent[2].isCheck
                          ?const WorkFromHome()
                          : const SizedBox(),
                      AppConstants.modulesmodell!.data![1].status.toString() ==
                              "1" && bottomBarIconProvider.bottomBarAddContent[3].isCheck
                          ? const ExpenseRequest()
                          : const SizedBox(),
                      AppConstants.modulesmodell!.data![2].status.toString() ==
                              "1" && bottomBarIconProvider.bottomBarAddContent[5].isCheck
                          ? const AssetRequest():const SizedBox(),
                      AppConstants.modulesmodell!.data![4].status.toString() ==
                              "1" && bottomBarIconProvider.bottomBarAddContent[4].isCheck
                          ? const TimeOff():const SizedBox(),
                      90.sh,
                    ],
                  );
                    },
                  )),
              ),
            ));
      }),
    );
  }
}

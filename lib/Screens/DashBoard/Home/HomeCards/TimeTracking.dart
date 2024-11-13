import 'package:flip_card/flip_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:gleam_hr/Components/CommonBottomSheet.dart';
import 'package:gleam_hr/Components/CommonButton.dart';
import 'package:gleam_hr/Components/CommonDropDown.dart';
import 'package:gleam_hr/Components/CommonTextField.dart';
import 'package:gleam_hr/Components/commonSnakbar.dart';
import 'package:gleam_hr/Providers/DashBoardProviders/DashBoard_Provider.dart';
import 'package:gleam_hr/Providers/DashBoardProviders/HomeProviders/AdminCorrectionRequests_Provider.dart';
import 'package:gleam_hr/Providers/DashBoardProviders/HomeProviders/CorrectionRequest_Provider.dart';
import 'package:gleam_hr/Providers/DashBoardProviders/HomeProviders/TimeTrackingProvider.dart';
import 'package:gleam_hr/Screens/DashBoard/Home/HomeWidgets/AdminAllCorrectionRequestRow.dart';
import 'package:gleam_hr/Screens/DashBoard/Home/HomeWidgets/AttendanceRequestDecisionCard.dart';
import 'package:gleam_hr/Screens/DashBoard/Home/HomeWidgets/CommonDashBoardCard.dart';
import 'package:gleam_hr/Screens/DashBoard/Home/HomeWidgets/CommonRequestsTableRow.dart';
import 'package:gleam_hr/Screens/DashBoard/Home/HomeWidgets/CommonTableRow.dart';
import 'package:gleam_hr/Components/CommonText.dart';
import 'package:gleam_hr/Screens/DashBoard/People/PeopleWidget/PeopleSearchBar.dart';
import 'package:gleam_hr/Utils/AppConstants.dart';
import 'package:gleam_hr/Utils/Methods.dart';
import 'package:gleam_hr/Utils/checkInternetPermission.dart';
import 'package:gleam_hr/Utils/AppPaths.dart';
import 'package:gleam_hr/Utils/Colors.dart';
import 'package:gleam_hr/Utils/SizedBox.dart';
import 'package:intl/intl.dart';
import 'package:location/location.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

class TimeTracking extends StatefulWidget {
  const TimeTracking({super.key});

  @override
  State<TimeTracking> createState() => _TimeTrackingState();
}

class _TimeTrackingState extends State<TimeTracking> {
  DateRangePickerController  dateRangePickerController = DateRangePickerController();
 
  @override
  Widget build(BuildContext context) {
    final timeTrackingProvider =
        Provider.of<TimeTrackingProvider>(context, listen: false);
    return Consumer<DashBoardProvider>(
      builder: (context, dashBoardProvider, child) {
        return FlipCard(
            key: dashBoardProvider.cardKey,
            flipOnTouch: true,
            front: CommonDashBoardCard(
            key: dashBoardProvider.keycheckin,
            menurequired: true,
            items:AppConstants.loginmodell!.userRole![0].type.toString() ==
                "admin"? ["My Requests","All Requests"]:["My Requests"],
              faceOnPressed: ()async{
              bool faceApiRes =await timeTrackingProvider.faceAttandance(context);
              if (faceApiRes) {
                  Location location = Location();
                bool enabledPermission =
                    await Permission.location.request().isGranted;
                if (AppConstants.loginmodell!.userAttendanceData[
                            "mobile_attendance_permission"] ==
                        true &&
                    AppConstants
                            .loginmodell!.userAttendanceData["geo_fencing"] ==
                        true &&
                    enabledPermission) {
                  await checkInternetPermission(context);
                }
                bool ison = await location.serviceEnabled();
                if (AppConstants.loginmodell!.userAttendanceData[
                            "mobile_attendance_permission"] ==
                        true &&
                    AppConstants
                            .loginmodell!.userAttendanceData["geo_fencing"] ==
                        true &&
                    ison &&
                    enabledPermission) {
                  // await checkInternetPermission(context);

                  //here we write code of 2nd time get location
                  //change destination lat,lng
                  // dashBoardProvider.changeBasiclatlongandradius(
                  //     AppConstants.loginmodell!.userData!.location == null
                  //         ? "0.0"
                  //         : AppConstants
                  //             .loginmodell!.userData!.location["latitude"]
                  //             .toString(),
                  //     AppConstants.loginmodell!.userData!.location == null
                  //         ? "0.0"
                  //         : AppConstants
                  //             .loginmodell!.userData!.location["longitude"]
                  //             .toString(),
                  //     AppConstants.loginmodell!.userAttendanceData["geo_radius"]
                  //         .toString());
                  // // Listen for changes in the user's position and check the geofence status.
                  // // location listner
                  // Geolocator.getPositionStream().listen((position) {
                  //   dashBoardProvider.checkGeofenceStatus(position);
                  // });

                  // Listen for geofence transitions and update the geofence status.
                  // dashBoardProvider.streamController.stream
                  //     .listen((transition) {
                  //   dashBoardProvider.changelocation(transition);
                  //   // dashBoardProvider.geofenceStatus = transition;
                  // });

                  //   //change destination lat,lng
                  //   dashBoardProvider.changeBasiclatlongandradius(AppConstants.loginmodell!.userData!.location["latitude"].toString(), AppConstants.loginmodell!.userData!.location["longitude"].toString(), AppConstants.loginmodell!.userAttendanceData["geo_radius"].toString());
                  //   // Listen for changes in the user's position and check the geofence status.
                  //   // location listner
                  //   Geolocator.getPositionStream().listen((position) {
                  //   dashBoardProvider.checkGeofenceStatus(position);
                  //   });
                  //  // Listen for geofence transitions and update the geofence status.
                  //   dashBoardProvider.streamController.stream.listen((transition) {
                  //   dashBoardProvider.changelocation(transition);
                  //   // dashBoardProvider.geofenceStatus = transition;
                  //   });
                }
                if ((dashBoardProvider.geofenceStatus == "Entered" &&
                        ison == true &&
                        AppConstants.loginmodell!
                                .userAttendanceData["geo_fencing"] ==
                            true &&
                        enabledPermission == true) ||
                    (dashBoardProvider.geofenceStatus == "Entered" &&
                        ((AppConstants.loginmodell!
                                    .userAttendanceData["geo_fencing"] ==
                                false ||
                            AppConstants.loginmodell!
                                    .userAttendanceData["geo_fencing"]
                                    .toString() ==
                                "null")))) {
                  if (dashBoardProvider.ischeckin) {
                    //  dashBoardProvider.checkin(true);
                    CommonBottomSheet(
                        context: context,
                        widget: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 24),
                            child: SingleChildScrollView(
                              child: Form(
                                key: dashBoardProvider.reasonFormKey,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Center(
                                      child: CommonTextPoppins(
                                          text: "Add Clock Out",
                                          talign: TextAlign.left,
                                          fontweight: FontWeight.w600,
                                          fontsize: 20,
                                          color: AppColors.textColor),
                                    ),
                                    30.sh,
                                    CommonTextPoppins(
                                      text: "Event Type *",
                                      fontweight: FontWeight.w500,
                                      fontsize: 12,
                                      color: AppColors.hintTextColor,
                                      talign: TextAlign.left,
                                    ),
                                    4.sh,
                                    Consumer<DashBoardProvider>(
                                      builder:
                                          (context, dashBoardProvider, child) {
                                        return CommonDropDown(
                                            width: width(context),
                                            selectedText:
                                                dashBoardProvider.selectedText,
                                            listItem:
                                                dashBoardProvider.eventTypes,
                                            onchanged: (val) {
                                              dashBoardProvider
                                                  .changeDropDownValue(val);
                                            });
                                      },
                                    ),
                                    16.sh,
                                    Consumer<DashBoardProvider>(
                                      builder:
                                          (context, dashboardprovider, child) {
                                        if (dashboardprovider.hidereason) {
                                          return Container();
                                        } else {
                                          return Column(
                                            mainAxisSize: MainAxisSize.min,
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              CommonTextPoppins(
                                                text: "Reason For Leaving",
                                                fontweight: FontWeight.w500,
                                                fontsize: 12,
                                                color: AppColors.hintTextColor,
                                                talign: TextAlign.left,
                                              ),
                                              4.sh,
                                              CommonTextField(
                                                controller: dashBoardProvider
                                                    .reasoncontroller,
                                                hinttext: "Enter Reason",
                                                validator: (value) {
                                                  // if (value!.isEmpty) {
                                                  //   return "Please Enter Reason";
                                                  // } else {
                                                  //   return null;
                                                  // }
                                                },
                                              ),
                                            ],
                                          );
                                        }
                                      },
                                    ),

                                    //     CommonDropDown(Width: width(context), selectedText: dashBoardProvider.selectedText, listItem: dashBoardProvider.eventTypes, onchanged: (val) {
                                    //    dashBoardProvider.selectedText= val;
                                    //    dashBoardProvider.changeDropDownValue(val);
                                    // }),
                                    30.sh,
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 24.0),
                                      child: CommonButton(
                                          onPressed: () {
                                            if (dashBoardProvider
                                                .reasonFormKey.currentState!
                                                .validate()) {
                                              // dashBoardProvider.checkin(false);
                                              dashBoardProvider.hitCheckOutApi(
                                                 isFace: true,
                                                  context: context,
                                                  reason: dashBoardProvider
                                                              .selectedText ==
                                                          "Scheduled Time Completed"
                                                      ? "Scheduled Time Completed"
                                                      : dashBoardProvider
                                                                  .reasoncontroller
                                                                  .text ==
                                                              ""
                                                          ? "Brb"
                                                          : "Brb-${dashBoardProvider.reasoncontroller.text}",
                                                  takenbreak: dashBoardProvider
                                                      .selectedText);
                                              Navigator.maybePop(context);
                                            }
                                          },
                                          width: width(context),
                                          text: "Add Clock Out"),
                                    ),
                                    16.sh,
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 24.0),
                                      child: CommonButton2(text: "Cancel"),
                                    ),
                                    16.sh,
                                  ],
                                ),
                              ),
                            )));
                    debugPrint("BottomSheet");
                  } else {
                    if (isRedundentClick(DateTime.now())) {
                      Fluttertoast.showToast(
                          msg: "hold on, processing",
                          toastLength: Toast.LENGTH_SHORT,
                          gravity: ToastGravity.BOTTOM,
                          timeInSecForIosWeb: 1,
                          backgroundColor: AppColors.primaryColor,
                          textColor: Colors.white,
                          fontSize: 16.0);
                      debugPrint('hold on, processing');
                      return;
                    }
                    dashBoardProvider.hitCheckInApi(context: context, isFace: true);
                    //dashBoardProvider.checkin(true);
                    debugPrint("close");
                  }
                } else {
                  if (!enabledPermission) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        appSnackBar("Please Allow Location"));
                    
                  } else if (!ison) {
                     ScaffoldMessenger.of(context).showSnackBar(
                        appSnackBar("Please Turn On Location"));
                    
                  } else {
                   ScaffoldMessenger.of(context).showSnackBar(
                        appSnackBar("You cannot mark your attendance because you are ${((double.parse(dashBoardProvider.checkdistance.toString())/1000).toStringAsFixed(3)).toString()} K.M away from your assigned location"));
                    
                  }
                }
              }else{
                // ScaffoldMessenger.of(context).showSnackBar(
                //         appSnackBar("Face Not Recognized"));
   }
              },
              isTimeTracking: true,
              bottomerror:AppConstants.loginmodell!.userRole![0].type.toString() =="admin"?const SizedBox(): (AppConstants.loginmodell!.permissions["attendance"].toString() == "[]" ||
                          AppConstants.loginmodell!.permissions["attendance"]
                                      [AppConstants.loginmodell!.userData!.id.toString()]
                                  ["employee_attendance"] !=
                              "edit") &&
                      (AppConstants.loginmodell!.userRole![0].type.toString() !=
                          "admin")
                  ? FittedBox(
                      child: CommonTextPoppins(
                          text:
                              "Employee Attendance Permission is not assigned",
                          fontweight: FontWeight.w500,
                          fontsize: 12,
                          color: AppColors.redColor))
                  : AppConstants.loginmodell!.userData!.workScheduleId == null
                      ? FittedBox(
                          child: CommonTextPoppins(
                              text: "Work Schedule is not assigned",
                              fontweight: FontWeight.w500,
                              fontsize: 12,
                              color: AppColors.redColor))
                      : AppConstants.loginmodell!.userAttendanceData["mobile_attendance_permission"] == null || AppConstants.loginmodell!.userAttendanceData["mobile_attendance_permission"] == false
                          ? FittedBox(child: CommonTextPoppins(text: "Mobile Attendance Permission is not assigned", fontweight: FontWeight.w500, fontsize: 12, color: AppColors.redColor))
                          : const SizedBox(),
              // contain: Column(
              //   mainAxisSize: MainAxisSize.min,
              //   children: [
              //       Row(
              //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //         children: [CommonTextPoppins(text: "CHECK IN", fontweight: FontWeight.w400, fontsize: 16, color: AppColors.primaryColor),CommonTextPoppins(text: "CHECK OUT", fontweight: FontWeight.w400, fontsize: 16, color: AppColors.primaryColor),],),
              //     5.sh,
              //     ListView.builder(
              //       shrinkWrap: true,
              //       reverse: true,
              //       physics:const NeverScrollableScrollPhysics(),
              //       itemCount: AppConstants.loginmodell!.userAttendanceData["employeeAllAttendanceToday"].length,
              //       itemBuilder: (context,index){
              //     dynamic attendanceIndex =  AppConstants.loginmodell!.userAttendanceData["employeeCurrentMonthAttendance"].indexWhere((item)
              //     => AppConstants.loginmodell!.userAttendanceData["employeeAllAttendanceToday"][index].toString()== item["id"].toString()
              //     );
              //       return Row(
              //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //         children: [Text(AppConstants.loginmodell!.userAttendanceData["employeeCurrentMonthAttendance"][attendanceIndex]["time_in"].toString()=="null"?"-":AppConstants.loginmodell!.userAttendanceData["employeeCurrentMonthAttendance"][attendanceIndex]["time_in"].toString()),Text(AppConstants.loginmodell!.userAttendanceData["employeeCurrentMonthAttendance"][attendanceIndex]["time_out"].toString()=="null"?"-":AppConstants.loginmodell!.userAttendanceData["employeeCurrentMonthAttendance"][attendanceIndex]["time_out"].toString()),],);
              //     }),
              //   ],
              // ),

              userExistInCheckinLocation:
                  dashBoardProvider.geofenceStatus == "Entered" ? true : false,
              title: "Time Tracking",
              subTitle: AppConstants.loginmodell!.userWorkSchedule!.workSchedule
                          .toString() ==
                      "null"
                  ? "No Schedule Available"
                  : "Shift - ${dashBoardProvider.schedulestarttime} to - ${dashBoardProvider.scheduleendtime}",
              leadingPath: ImagePath.clockIcon,
              showButton:AppConstants.loginmodell!.userRole![0].type.toString() =="admin"?true : ((AppConstants.loginmodell!.userAttendanceData[
                                  "mobile_attendance_permission"] ==
                              null ||
                          AppConstants.loginmodell!.userAttendanceData[
                                  "mobile_attendance_permission"] ==
                              false) ||
                      AppConstants.loginmodell!.userData!.workScheduleId ==
                          null ||
                      ((AppConstants.loginmodell!.permissions["attendance"].toString() == "[]" ||
                              AppConstants.loginmodell!.permissions["attendance"]
                                          [AppConstants.loginmodell!.userData!.id.toString()]
                                      ["employee_attendance"] !=
                                  "edit") &&
                          (AppConstants.loginmodell!.userRole![0].type.toString() != "admin")))
                  ? false
                  : true,
              // showButton: AppConstants.loginmodell!.userAttendanceData[
              //                     "mobile_attendance_permission"] ==
              //                 null ||
              //             AppConstants.loginmodell!.userAttendanceData[
              //                     "mobile_attendance_permission"] ==
              //                 false?false:true,
              menuOnPressed: (value) {
                //for fliping card
                // dashBoardProvider.cardKey.currentState!.toggleCard();
                if(value=="My Requests"){
                            context.read<CorrectionRequestProvider>().getAllCorrectionRequests(context: context);
                CommonBottomSheet(context: context, widget:
                 SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(
                        child: CommonTextPoppins(
                            text: "Correction Requests",
                            talign: TextAlign.left,
                            fontweight: FontWeight.w600,
                            fontsize: 20,
                            color: AppColors.textColor),
                      ),
                      30.sh,
                      Padding(
                        padding: EdgeInsets.zero,
                        child: Consumer<CorrectionRequestProvider>(
                          builder: (context, correctionRequestProvider, child) {
                            return Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            //dropdown
                                            CommonDropDown(
                                              width: 70, 
                                              selectedText: correctionRequestProvider.dropdownSelectedText,
                                               listItem: correctionRequestProvider.dropdownlist, 
                                               onchanged: (value){
                                                correctionRequestProvider.changedropdown(value,context);
                                                }),
                                            //search
                                            SizedBox(
                                              width: width(context)*.40,
                                              child: PeopleSearchBar(controller: correctionRequestProvider.searchController, onvaluechange: (value){
                                                                                    correctionRequestProvider.searchlist =  
                                                                                    AppConstants.allCorrectionRequestsmodel!.data!.
                                                                                    where((element) =>
                                              DateFormat('MMM d, y').format(DateTime.parse(element.date.toString())).toLowerCase().contains(value.toString().toLowerCase()) ||
                                              element.status.toString().toLowerCase().contains(value.toString().toLowerCase()))
                                                                                    .toList();
                                                                                    correctionRequestProvider.hitupdate();
                                              }),
                                            ),
                                            PopupMenuButton<String>(
                                              icon: SvgPicture.asset(ImagePath.filterIcon,height: 30),
                                              onSelected: (String value) {
                                                correctionRequestProvider.changeFilterValue(value,context);
                                              },
                                              itemBuilder:
                                                  (BuildContext context) {
                                                return correctionRequestProvider.items
                                                    .map((String item) {
                                                  return PopupMenuItem<String>(
                                                    value: item,
                                                    child: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        CommonTextPoppins(
                                                          text: item,
                                                          fontweight:
                                                              FontWeight.w400,
                                                          fontsize: 12,
                                                          color: AppColors
                                                              .blackColor,
                                                          talign: TextAlign.left,
                                                        ),
                                                        const Divider(
                                                          height: 2,
                                                        )
                                                      ],
                                                    ),
                                                  );
                                                }).toList();
                                              },
                                            ),
                                          ],);
                          },
                        )
                      ),
                      20.sh,
                      CommonRequestsTableRow(
                        rowColor: AppColors.tablefillColor,
                         date: "DATE", 
                         srNo: "S.R.#",
                          status: 0,
                          textColor: AppColors.primaryColor,
                           statusText: "STATUS",
                           actionTap: (){},
                           actionText: "ACTION"),
                      Consumer<CorrectionRequestProvider>(
                  builder: (context, correctionRequestProvider, child) {
                    if (correctionRequestProvider.correctionRequestLoading) {
                      return const Center(child: CircularProgressIndicator.adaptive());
                    } else {
                      if(correctionRequestProvider.searchController.text.isEmpty)
                      {
                     return ListView.builder(
                        itemCount:AppConstants
                                  .allCorrectionRequestsmodel!.data!.length,
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemBuilder:(context, index) {
                       DateTime? timeInDateTime = correctionRequestProvider.parseApiDate(AppConstants.allCorrectionRequestsmodel!.data![index].timeInDate.toString());
                      DateTime? timeOutDateTime = correctionRequestProvider.parseApiDate(AppConstants.allCorrectionRequestsmodel!.data![index].timeOutDate.toString());
                        return CommonRequestsTableRow(
                          rowColor: index%2==1?AppColors.tablefillColor:AppColors.tableUnfillColor,
                           date:timeInDateTime==null?"":DateFormat('MMM d, y').format(DateTime.parse(timeInDateTime.toString(),)),
                           srNo: (index+1).toString(),
                            status: AppConstants.allCorrectionRequestsmodel!.data![index].status.toString()=="approved"?1:AppConstants.allCorrectionRequestsmodel!.data![index].status.toString()=="rejected"?2:AppConstants.allCorrectionRequestsmodel!.data![index].status.toString()=="pending"?3:0,statusText: "",actionTap: (){
                          CommonBottomSheet(context: context, widget: SingleChildScrollView(
                            padding:const EdgeInsets.symmetric(horizontal: 12),
                  child: SizedBox(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Center(
                          child: CommonTextPoppins(
                              text: "Status",
                              talign: TextAlign.left,
                              fontweight: FontWeight.w600,
                              fontsize: 20,
                              color: AppColors.textColor),
                        ),
                        30.sh,
                        Row(children: [Expanded(
                          flex: 3,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                            CommonTextPoppins(text: "Check In Date",talign: TextAlign.left, fontweight: FontWeight.w500, fontsize: 12, color: AppColors.hintTextColor),
                            Row(children: [
                            Expanded(flex: 2, child: Container(height: 50, decoration: BoxDecoration(border: Border.all(color: AppColors.textColor.withOpacity(.25)), color: AppColors.fillColor, borderRadius: BorderRadius.circular(8)), child:Center(child: CommonTextPoppins(talign: TextAlign.center, text:AppConstants.allCorrectionRequestsmodel!.data![index].timeInDate.toString()=="null"? "":timeInDateTime==null?"":DateFormat('MMMM yyyy').format(DateTime.parse(timeInDateTime.toString())), fontweight: FontWeight.w400, fontsize: 14, color: AppColors.textColor)))),
                            CommonTextPoppins(text: " - ", fontweight: FontWeight.w400, fontsize: 14, color: AppColors.textColor),
                            Expanded(flex:1, child: Container(height: 50, decoration: BoxDecoration(border: Border.all(color: AppColors.textColor.withOpacity(.25)), color: AppColors.fillColor, borderRadius: BorderRadius.circular(8)), child:Center(child: CommonTextPoppins(talign: TextAlign.center, text:AppConstants.allCorrectionRequestsmodel!.data![index].timeInDate.toString()=="null"? "":timeInDateTime==null?"":DateFormat('dd').format(DateTime.parse(timeInDateTime.toString())), fontweight: FontWeight.w400, fontsize: 14, color: AppColors.textColor)))),],)
                          ],),
                        ),
                        24.sw,
                        Expanded(
                          flex: 2,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                            CommonTextPoppins(text: "Check In Time",talign: TextAlign.left, fontweight: FontWeight.w500, fontsize: 12, color: AppColors.hintTextColor),
                            Row(children: [
                            Expanded(flex:1, child: Container(height: 50, decoration: BoxDecoration(border: Border.all(color: AppColors.textColor.withOpacity(.25)), color: AppColors.fillColor, borderRadius: BorderRadius.circular(8)), child:Center(child: CommonTextPoppins(talign: TextAlign.center, text:AppConstants.allCorrectionRequestsmodel!.data![index].timeIn.toString()=="null"?"": AppConstants.allCorrectionRequestsmodel!.data![index].timeIn.toString().split(RegExp('[: ]'))[0], fontweight: FontWeight.w400, fontsize: 14, color: AppColors.textColor)))),                            
                            CommonTextPoppins(text: " : ", fontweight: FontWeight.w400, fontsize: 14, color: AppColors.textColor),
                            Expanded(flex:1,child: Container(height: 50,width: 50, decoration: BoxDecoration(border: Border.all(color: AppColors.textColor.withOpacity(.25)), color: AppColors.fillColor, borderRadius: BorderRadius.circular(8)), child:Center(child: CommonTextPoppins(talign: TextAlign.center, text:AppConstants.allCorrectionRequestsmodel!.data![index].timeIn.toString()=="null"?"": "${AppConstants.allCorrectionRequestsmodel!.data![index].timeIn.toString().split(RegExp('[: ]'))[1]} ${AppConstants.allCorrectionRequestsmodel!.data![index].timeIn.toString().split(RegExp('[: ]'))[2]}", fontweight: FontWeight.w400, fontsize: 14, color: AppColors.textColor)))),],)
                          
                          ],),
                        )],),
                        16.sh,
                        Row(children: [Expanded(
                          flex: 3,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                            CommonTextPoppins(text: "Check Out Date",talign: TextAlign.left, fontweight: FontWeight.w500, fontsize: 12, color: AppColors.hintTextColor),
                            Row(children: [
                            Expanded(flex:2, child: Container(height: 50, decoration: BoxDecoration(border: Border.all(color: AppColors.textColor.withOpacity(.25)), color: AppColors.fillColor, borderRadius: BorderRadius.circular(8)), child:Center(child: CommonTextPoppins(talign: TextAlign.center, text:AppConstants.allCorrectionRequestsmodel!.data![index].timeOutDate.toString()=="null"?"":timeOutDateTime==null?"":DateFormat('MMMM yyyy').format(DateTime.parse(timeOutDateTime.toString())), fontweight: FontWeight.w400, fontsize: 14, color: AppColors.textColor)))),
                            CommonTextPoppins(text: " - ", fontweight: FontWeight.w400, fontsize: 14, color: AppColors.textColor),
                            Expanded(flex:1,child: Container(height: 50, decoration: BoxDecoration(border: Border.all(color: AppColors.textColor.withOpacity(.25)), color: AppColors.fillColor, borderRadius: BorderRadius.circular(8)), child:Center(child: CommonTextPoppins(talign: TextAlign.center, text:AppConstants.allCorrectionRequestsmodel!.data![index].timeOutDate.toString()=="null"?"":timeOutDateTime==null?"":DateFormat('dd').format(DateTime.parse(timeOutDateTime.toString())), fontweight: FontWeight.w400, fontsize: 14, color: AppColors.textColor)))),],)
                          ],),
                        ),
                        12.sw,
                        Expanded(
                          flex: 2,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                            CommonTextPoppins(text: "Check Out Time",talign: TextAlign.left, fontweight: FontWeight.w500, fontsize: 12, color: AppColors.hintTextColor),
                            Row(children: [
                            Expanded(flex:1,child: Container(height: 50, decoration: BoxDecoration(border: Border.all(color: AppColors.textColor.withOpacity(.25)), color: AppColors.fillColor, borderRadius: BorderRadius.circular(8)), child:Center(child: CommonTextPoppins(talign: TextAlign.center, text:AppConstants.allCorrectionRequestsmodel!.data![index].timeOut.toString()=="null"?"": AppConstants.allCorrectionRequestsmodel!.data![index].timeOut.toString().split(RegExp('[: ]'))[0], fontweight: FontWeight.w400, fontsize: 14, color: AppColors.textColor)))),
                            CommonTextPoppins(text: " : ", fontweight: FontWeight.w400, fontsize: 14, color: AppColors.textColor),
                            Expanded(flex:1,child: Container(height: 50, decoration: BoxDecoration(border: Border.all(color: AppColors.textColor.withOpacity(.25)), color: AppColors.fillColor, borderRadius: BorderRadius.circular(8)), child:Center(child: CommonTextPoppins(talign: TextAlign.center, text:AppConstants.allCorrectionRequestsmodel!.data![index].timeOut.toString()=="null"?"": "${AppConstants.allCorrectionRequestsmodel!.data![index].timeOut.toString().split(RegExp('[: ]'))[1]} ${AppConstants.allCorrectionRequestsmodel!.data![index].timeIn.toString().split(RegExp('[: ]'))[2]}", fontweight: FontWeight.w400, fontsize: 14, color: AppColors.textColor)))),],)
                          ],),
                        )],),
                        16.sh,
                                      CommonTextPoppins(
                                          text: "Event Type",
                                          talign: TextAlign.start,
                                          fontweight: FontWeight.w500,
                                          fontsize: 12,
                                          color: AppColors.hintTextColor),
                                      4.sh,
                                      AbsorbPointer(
                              absorbing: true,
                              child: CommonDropDown(
                                              width: width(context),
                                              selectedText:
                                                  AppConstants.allCorrectionRequestsmodel!.data![index].reasonForLeaving.toString()=="null"?"Not Available":AppConstants.allCorrectionRequestsmodel!.data![index].reasonForLeaving.toString(),
                                              listItem:
                                                  [AppConstants.allCorrectionRequestsmodel!.data![index].reasonForLeaving.toString(),"Not Available"],
                                              onchanged: (val) {}),
                            ),
                                      16.sh,
                                      CommonTextPoppins(
                                          text: "Status",
                                          talign: TextAlign.start,
                                          fontweight: FontWeight.w500,
                                          fontsize: 12,
                                          color: AppColors.hintTextColor),
                                      4.sh,
                                      SizedBox(
                        height: 50,width: 90,child: Center(child: 
                        Container(height: 30,width: 90, decoration: BoxDecoration(borderRadius: BorderRadius.circular(8),
                        //color:status==1? AppColors.success:status==2?const Color(0XFFE34A4A):status==3?AppColors.primaryColor:AppColors.whiteColor,),
                        color:AppConstants.allCorrectionRequestsmodel!.data![index].status.toString()=="approved"? AppColors.success:AppConstants.allCorrectionRequestsmodel!.data![index].status.toString()=="rejected"? AppColors.redColor:AppConstants.allCorrectionRequestsmodel!.data![index].status.toString()=="pending"?AppColors.primaryColor:AppColors.whiteColor),
                        child: Center(child: Text(AppConstants.allCorrectionRequestsmodel!.data![index].status.toString(),style: TextStyle(color: AppColors.whiteColor),))))),
                        //child: Center(child: CommonTextPoppins(text:status==1? "Approved":status==2?"REJECTED":status==3?"Pending":"", fontweight: FontWeight.w500, fontsize: 12, color: AppColors.whiteColor)))),),
                        SizedBox(
                            height: 50,
                            child: CommonButton2(text: "BACK")),
                            60.sh,
                    ]),
                  ))
                          );
                        },actionText: "");
                      },);
                     }
                      else if(correctionRequestProvider.searchlist.isNotEmpty)
                     {
                      return ListView.builder(
                        itemCount:correctionRequestProvider.searchlist.length,
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemBuilder:(context, index) {
                           DateTime? timeInDateTime = correctionRequestProvider.parseApiDate( correctionRequestProvider.searchlist[index].timeInDate.toString(),);
                        return CommonRequestsTableRow(
                          rowColor: index%2==1?AppColors.tablefillColor:AppColors.tableUnfillColor, 
                          date:timeInDateTime==null?"":DateFormat('MMM d, y').format(DateTime.parse(timeInDateTime.toString())),
                          srNo: (index+1).toString(),
                          status: correctionRequestProvider.searchlist[index].status.toString()=="approved"?1:correctionRequestProvider.searchlist[index].status.toString()=="rejected"?2:correctionRequestProvider.searchlist[index].status.toString()=="pending"?3:0,statusText: "",actionTap: (){
                          CommonBottomSheet(context: context, widget: SingleChildScrollView(
                            padding:const EdgeInsets.symmetric(horizontal: 12),
                  child: SizedBox(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Center(
                          child: CommonTextPoppins(
                              text: "Status",
                              talign: TextAlign.left,
                              fontweight: FontWeight.w600,
                              fontsize: 20,
                              color: AppColors.textColor),
                        ),
                        30.sh,
                        Row(children: [Expanded(
                          flex: 2,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                            CommonTextPoppins(text: "Check In Date",talign: TextAlign.left, fontweight: FontWeight.w500, fontsize: 12, color: AppColors.hintTextColor),
                            Row(children: [
                            Expanded(flex: 2, child: Container(height: 50, decoration: BoxDecoration(border: Border.all(color: AppColors.textColor.withOpacity(.25)), color: AppColors.fillColor, borderRadius: BorderRadius.circular(8)), child:Center(child: CommonTextPoppins(talign: TextAlign.center, text:correctionRequestProvider.searchlist[index].timeInDate.toString()=="null"? "":DateFormat('MMMM yyyy').format(DateFormat('MM-dd-yyyy').parse(correctionRequestProvider.searchlist[index].timeInDate.toString())), fontweight: FontWeight.w400, fontsize: 14, color: AppColors.textColor)))),
                            CommonTextPoppins(text: " - ", fontweight: FontWeight.w400, fontsize: 14, color: AppColors.textColor),
                            Expanded(flex:1, child: Container(height: 50, decoration: BoxDecoration(border: Border.all(color: AppColors.textColor.withOpacity(.25)), color: AppColors.fillColor, borderRadius: BorderRadius.circular(8)), child:Center(child: CommonTextPoppins(talign: TextAlign.center, text:correctionRequestProvider.searchlist[index].timeInDate.toString()=="null"? "":DateFormat('dd').format(DateFormat('MM-dd-yyyy').parse(correctionRequestProvider.searchlist[index].timeInDate.toString())), fontweight: FontWeight.w400, fontsize: 14, color: AppColors.textColor)))),],)
                          ],),
                        ),
                        24.sw,
                        Expanded(
                          flex: 1,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                            CommonTextPoppins(text: "Check In Time",talign: TextAlign.left, fontweight: FontWeight.w500, fontsize: 12, color: AppColors.hintTextColor),
                            Row(children: [
                            Expanded(flex:1, child: Container(height: 50, decoration: BoxDecoration(border: Border.all(color: AppColors.textColor.withOpacity(.25)), color: AppColors.fillColor, borderRadius: BorderRadius.circular(8)), child:Center(child: CommonTextPoppins(talign: TextAlign.center, text:correctionRequestProvider.searchlist[index].timeIn.toString()=="null"?"": correctionRequestProvider.searchlist[index].timeIn.toString().split(RegExp('[: ]'))[0], fontweight: FontWeight.w400, fontsize: 14, color: AppColors.textColor)))),
                            CommonTextPoppins(text: " : ", fontweight: FontWeight.w400, fontsize: 14, color: AppColors.textColor),
                            Expanded(flex:1,child: Container(height: 50,width: 50, decoration: BoxDecoration(border: Border.all(color: AppColors.textColor.withOpacity(.25)), color: AppColors.fillColor, borderRadius: BorderRadius.circular(8)), child:Center(child: CommonTextPoppins(talign: TextAlign.center, text:correctionRequestProvider.searchlist[index].timeIn.toString()=="null"?"": "${correctionRequestProvider.searchlist[index].timeIn.toString().split(RegExp('[: ]'))[1]} ${correctionRequestProvider.searchlist[index].timeIn.toString().split(RegExp('[: ]'))[2]}", fontweight: FontWeight.w400, fontsize: 14, color: AppColors.textColor)))),],)
                          
                          ],),
                        )],),
                        16.sh,
                        Row(children: [Expanded(
                          flex: 2,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                            CommonTextPoppins(text: "Check Out Date",talign: TextAlign.left, fontweight: FontWeight.w500, fontsize: 12, color: AppColors.hintTextColor),
                            Row(children: [
                            Expanded(flex:2, child: Container(height: 50, decoration: BoxDecoration(border: Border.all(color: AppColors.textColor.withOpacity(.25)), color: AppColors.fillColor, borderRadius: BorderRadius.circular(8)), child:Center(child: CommonTextPoppins(talign: TextAlign.center, text:correctionRequestProvider.searchlist[index].timeOutDate.toString()=="null"?"":DateFormat('MMMM yyyy').format(DateFormat('MM-dd-yyyy').parse(correctionRequestProvider.searchlist[index].timeOutDate.toString())), fontweight: FontWeight.w400, fontsize: 14, color: AppColors.textColor)))),
                            CommonTextPoppins(text: " - ", fontweight: FontWeight.w400, fontsize: 14, color: AppColors.textColor),
                            Expanded(flex:1,child: Container(height: 50, decoration: BoxDecoration(border: Border.all(color: AppColors.textColor.withOpacity(.25)), color: AppColors.fillColor, borderRadius: BorderRadius.circular(8)), child:Center(child: CommonTextPoppins(talign: TextAlign.center, text:correctionRequestProvider.searchlist[index].timeOutDate.toString()=="null"?"":DateFormat('dd').format(DateFormat('MM-dd-yyyy').parse(correctionRequestProvider.searchlist[index].timeOutDate.toString())), fontweight: FontWeight.w400, fontsize: 14, color: AppColors.textColor)))),],)
                          ],),
                        ),
                        24.sw,
                        Expanded(
                          flex: 1,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                            CommonTextPoppins(text: "Check Out Time",talign: TextAlign.left, fontweight: FontWeight.w500, fontsize: 12, color: AppColors.hintTextColor),
                            Row(children: [
                            Expanded(flex:1,child: Container(height: 50, decoration: BoxDecoration(border: Border.all(color: AppColors.textColor.withOpacity(.25)), color: AppColors.fillColor, borderRadius: BorderRadius.circular(8)), child:Center(child: CommonTextPoppins(talign: TextAlign.center, text:correctionRequestProvider.searchlist[index].timeOut.toString()=="null"?"": correctionRequestProvider.searchlist[index].timeOut.toString().split(RegExp('[: ]'))[0], fontweight: FontWeight.w400, fontsize: 14, color: AppColors.textColor)))),
                            CommonTextPoppins(text: " : ", fontweight: FontWeight.w400, fontsize: 14, color: AppColors.textColor),
                            Expanded(flex:1,child: Container(height: 50, decoration: BoxDecoration(border: Border.all(color: AppColors.textColor.withOpacity(.25)), color: AppColors.fillColor, borderRadius: BorderRadius.circular(8)), child:Center(child: CommonTextPoppins(talign: TextAlign.center, text:correctionRequestProvider.searchlist[index].timeOut.toString()=="null"?"": "${correctionRequestProvider.searchlist[index].timeOut.toString().split(RegExp('[: ]'))[1]} ${correctionRequestProvider.searchlist[index].timeIn.toString().split(RegExp('[: ]'))[2]}", fontweight: FontWeight.w400, fontsize: 14, color: AppColors.textColor)))),],)
                          ],),
                        )],),
                        16.sh,
                                      CommonTextPoppins(
                                          text: "Event Type",
                                          talign: TextAlign.start,
                                          fontweight: FontWeight.w500,
                                          fontsize: 12,
                                          color: AppColors.hintTextColor),
                                      4.sh,
                                      AbsorbPointer(
                              absorbing: true,
                              child: CommonDropDown(
                                              width: width(context),
                                              selectedText:
                                                  correctionRequestProvider.searchlist[index].reasonForLeaving.toString()=="null"?"Not Available":correctionRequestProvider.searchlist[index].reasonForLeaving.toString(),
                                              listItem:
                                                  [correctionRequestProvider.searchlist[index].reasonForLeaving.toString(),"Not Available"],
                                              onchanged: (val) {}),
                            ),
                                      16.sh,
                                      CommonTextPoppins(
                                          text: "Status",
                                          talign: TextAlign.start,
                                          fontweight: FontWeight.w500,
                                          fontsize: 12,
                                          color: AppColors.hintTextColor),
                                      4.sh,
                                      SizedBox(
                        height: 50,width: 90,child: Center(child: 
                        Container(height: 30,width: 90, decoration: BoxDecoration(borderRadius: BorderRadius.circular(8),
                        //color:status==1? AppColors.success:status==2?const Color(0XFFE34A4A):status==3?AppColors.primaryColor:AppColors.whiteColor,),
                        color:correctionRequestProvider.searchlist[index].status.toString()=="approved"? AppColors.success:correctionRequestProvider.searchlist[index].status.toString()=="rejected"? AppColors.redColor:correctionRequestProvider.searchlist[index].status.toString()=="pending"?AppColors.primaryColor:AppColors.whiteColor),
                        child: Center(child: Text(correctionRequestProvider.searchlist[index].status.toString(),style: TextStyle(color: AppColors.whiteColor),))))),
                        //child: Center(child: CommonTextPoppins(text:status==1? "Approved":status==2?"REJECTED":status==3?"Pending":"", fontweight: FontWeight.w500, fontsize: 12, color: AppColors.whiteColor)))),),
                        SizedBox(
                            height: 50,
                            child: CommonButton2(text: "BACK")),
                            60.sh,
                    ]),
                  ))
                          );
                        },actionText: "");
                      },);
                      }else{
                      return Column(
                        children: [
                          20.sh,
                          Center(
                            child: CommonTextPoppins(
                                        text: "No Search Found",
                                        fontweight: FontWeight.w600,
                                        talign: TextAlign.center,
                                        fontsize: 15,
                                        color: AppColors.primaryColor),
                          ),
                          20.sh,
                        ],
                      );}
                    }
                    
                  },
                ),
                      
                  ])));
              }else if(value=="All Requests"){
                context.read<AdminCorrectionRequestsProvider>().getAdminCorrectionRequests(context: context);
                CommonBottomSheet(context: context, widget:
                 SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(
                        child: CommonTextPoppins(
                            text: "All Correction Requests",
                            talign: TextAlign.left,
                            fontweight: FontWeight.w600,
                            fontsize: 20,
                            color: AppColors.textColor),
                      ),
                      30.sh,
                      Padding(
                        padding: EdgeInsets.zero,
                        child: Consumer<AdminCorrectionRequestsProvider>(
                          builder: (context, adminCorrectionRequestProvider, child) {
                            return Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            //dropdown
                                            CommonDropDown(width: 70, selectedText: adminCorrectionRequestProvider.dropdownSelectedText, listItem: adminCorrectionRequestProvider.dropdownlist, onchanged: (value){adminCorrectionRequestProvider.changedropdown(value,context);}),
                                            //search
                                            SizedBox(
                                              width: width(context)*.40,
                                              child: PeopleSearchBar(controller: adminCorrectionRequestProvider.searchController, onvaluechange: (value){
                                                                                    adminCorrectionRequestProvider.searchlist = AppConstants.adminCorrectionRequestsmodel!.data!
                                                                                    .where((element) =>
                                              DateFormat('MMM d, y').format(DateTime.parse(adminCorrectionRequestProvider.parseApiDate(element.date.toString()).toString())).toLowerCase().contains(value.toString().toLowerCase())||
                                              DateFormat('MMM d, y').format(DateTime.parse(adminCorrectionRequestProvider.parseApiDate(element.timeInDate.toString()).toString())).toLowerCase().contains(value.toString().toLowerCase())||
                                              element.employee!.fullName.toString().toLowerCase().contains(value.toString().toLowerCase()) ||
                                              element.status.toString().toLowerCase().contains(value.toString().toLowerCase()))
                                                                                    .toList();
                                                                                    adminCorrectionRequestProvider.hitupdate();
                                              }),
                                            ),
                                            PopupMenuButton<String>(
                                              icon: SvgPicture.asset(ImagePath.filterIcon,height: 30),
                                              onSelected: (String value) {
                                                adminCorrectionRequestProvider.changeFilterValue(value,context);
                                              },
                                              itemBuilder:
                                                  (BuildContext context) {
                                                return adminCorrectionRequestProvider.items
                                                    .map((String item) {
                                                  return PopupMenuItem<String>(
                                                    value: item,
                                                    child: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        CommonTextPoppins(
                                                          text: item,
                                                          fontweight:
                                                              FontWeight.w400,
                                                          fontsize: 12,
                                                          color: AppColors
                                                              .blackColor,
                                                          talign: TextAlign.left,
                                                        ),
                                                        const Divider(
                                                          height: 2,
                                                        )
                                                      ],
                                                    ),
                                                  );
                                                }).toList();
                                              },
                                            ),
                                          ],);
                          },
                        )
                      ),
                      20.sh,
                      CommonRequestsTableRow(rowColor: AppColors.tablefillColor, date: "REQUESTED ON", srNo: "EMPLOYEE", status: 0,textColor: AppColors.primaryColor, statusText: "REQUESTED FOR",actionTap: (){},actionText: "STATUS"),
                      Consumer<AdminCorrectionRequestsProvider>(
                  builder: (context, correctionRequestProvider, child) {
                    if (correctionRequestProvider.allCorrectionRequestLoading) {
                      return const Center(child: CircularProgressIndicator.adaptive());
                    } else {
                      if(correctionRequestProvider.searchController.text.isEmpty)
                      {
                     return ListView.builder(
                        itemCount:AppConstants.adminCorrectionRequestsmodel!.data!.length,
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemBuilder:(context, index) {
                       DateTime? requestForDateTime = correctionRequestProvider.parseApiDate(AppConstants.adminCorrectionRequestsmodel!.data![index].timeInDate.toString());
                       DateTime? dateV= correctionRequestProvider.parseApiDate(AppConstants.adminCorrectionRequestsmodel!.data![index].date.toString()); 
                        return AdminAllCorrectionRequestRow(
                          requestFor: requestForDateTime==null?"":DateFormat('MMM d, y').format(DateTime.parse(requestForDateTime.toString())),
                           employeeName: AppConstants.adminCorrectionRequestsmodel!.data![index].employee!.firstname.toString(), 
                           rowColor: index%2==1?AppColors.tablefillColor:AppColors.tableUnfillColor, 
                           date: dateV==null?"":DateFormat('MMM d, y').format(DateTime.parse(dateV.toString())), 
                           status: AppConstants.adminCorrectionRequestsmodel!.data![index].status.toString()=="approved"?1:AppConstants.adminCorrectionRequestsmodel!.data![index].status.toString()=="rejected"?2:AppConstants.adminCorrectionRequestsmodel!.data![index].status.toString()=="pending"?3:0,statusText: "",
                        actionTap: (){
                          CommonBottomSheet(context: context, widget: SingleChildScrollView(
                            padding:const EdgeInsets.symmetric(horizontal: 12),
                  child: SizedBox(
                    child: SingleChildScrollView(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Center(
                            child: CommonTextPoppins(
                                text: "Correction Requests Decision",
                                talign: TextAlign.left,
                                fontweight: FontWeight.w600,
                                fontsize: 20,
                                color: AppColors.textColor),
                          ),
                          AttendanceRequestDecisionCard(isOld: true, data: AppConstants.adminCorrectionRequestsmodel!.data![index], context: context),
                          AttendanceRequestDecisionCard(isOld: false, data: AppConstants.adminCorrectionRequestsmodel!.data![index], context: context),
                          Consumer<AdminCorrectionRequestsProvider>(
                            builder: (context, admincorrectionrequestProvider, child) {
                              return admincorrectionrequestProvider.decisionLoading
                                      ? const Center(
                                          child: CircularProgressIndicator.adaptive(),
                                        )
                                      :
                                  Padding(padding: const EdgeInsets.symmetric(horizontal:25.0),
                                    child: Column(mainAxisSize: MainAxisSize.min, children: [
                                    CommonButtonImage(
                                      onPressed: () {
                                        admincorrectionrequestProvider.approveDenyAdminCorrectionRequests(context: context, decision: "approved", correctionId: AppConstants.adminCorrectionRequestsmodel!.data![index].id.toString(), employeeId: AppConstants.adminCorrectionRequestsmodel!.data![index].employee!.id.toString(), date: AppConstants.adminCorrectionRequestsmodel!.data![index].date.toString());
                                      },
                                      width: MediaQuery.of(context).size.width,
                                      text: "Approve",
                                      color: AppColors.primaryColor,
                                      image: ImagePath.approveIcon),
                                  20.sh,
                                  DenyButton(
                                      text: "Deny",
                                      ontap: () {
                                        admincorrectionrequestProvider.approveDenyAdminCorrectionRequests(context: context, decision: "rejected", correctionId: AppConstants.adminCorrectionRequestsmodel!.data![index].id.toString(), employeeId: AppConstants.adminCorrectionRequestsmodel!.data![index].employee!.id.toString(), date: AppConstants.adminCorrectionRequestsmodel!.data![index].date.toString());
                                      },
                                      imagePath: ImagePath.denyIcon)
                      ]),
                                    );
                            },
                          )
                    ]),
                  ))
                          ));                     
                        
                        },);
                      },);
                     }
                      else if(correctionRequestProvider.searchlist.isNotEmpty)
                     {
                      return ListView.builder(
                        itemCount:correctionRequestProvider.searchlist.length,//correctionRequestProvider.dropdownSelectedText=="All"? correctionRequestProvider.searchlist.length:int.parse(correctionRequestProvider.dropdownSelectedText)<= correctionRequestProvider.searchlist.length?int.parse(correctionRequestProvider.dropdownSelectedText):correctionRequestProvider.searchlist.length,
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemBuilder:(context, index) {
                       DateTime? requestForDateTime = correctionRequestProvider.parseApiDate(correctionRequestProvider.searchlist[index].timeInDate.toString());
                       DateTime? dateV= correctionRequestProvider.parseApiDate(correctionRequestProvider.searchlist[index].date.toString()); 
                        
                        return AdminAllCorrectionRequestRow(
                          employeeName: correctionRequestProvider.searchlist[index].employee!.fullName.toString(),
                          requestFor: requestForDateTime==null?"":DateFormat('MMM d, y').format(DateTime.parse(requestForDateTime.toString())), 
                          rowColor: index%2==1?AppColors.tablefillColor:AppColors.tableUnfillColor, 
                          date: dateV==null?"":DateFormat('MMM d, y').format(DateTime.parse(dateV.toString())),
                           status: correctionRequestProvider.searchlist[index].status.toString()=="approved"?1:correctionRequestProvider.searchlist[index].status.toString()=="rejected"?2:correctionRequestProvider.searchlist[index].status.toString()=="pending"?3:0,statusText: "",
                        actionTap: (){
                         CommonBottomSheet(context: context, widget: SingleChildScrollView(
                            padding:const EdgeInsets.symmetric(horizontal: 12),
                  child: SizedBox(
                    child: SingleChildScrollView(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Center(
                            child: CommonTextPoppins(
                                text: "Correction Requests Decision",
                                talign: TextAlign.left,
                                fontweight: FontWeight.w600,
                                fontsize: 20,
                                color: AppColors.textColor),
                          ),
                          AttendanceRequestDecisionCard(isOld: true, data: correctionRequestProvider.searchlist[index], context: context),
                          AttendanceRequestDecisionCard(isOld: false, data: correctionRequestProvider.searchlist[index], context: context),
                      Consumer<AdminCorrectionRequestsProvider>(
                            builder: (context, admincorrectionrequestProvider, child) {
                              return admincorrectionrequestProvider.decisionLoading
                                      ? const Center(
                                          child: CircularProgressIndicator.adaptive(),
                                        )
                                      :
                                  Padding(padding: const EdgeInsets.symmetric(horizontal:25.0),
                                    child: Column(mainAxisSize: MainAxisSize.min, children: [
                                    CommonButtonImage(
                                      onPressed: () {
                                        admincorrectionrequestProvider.approveDenyAdminCorrectionRequests(context: context, decision: "approved", correctionId: correctionRequestProvider.searchlist[index].id.toString(), employeeId: correctionRequestProvider.searchlist[index].employee!.id.toString(), date: correctionRequestProvider.searchlist[index].date.toString());
                                      },
                                      width: MediaQuery.of(context).size.width,
                                      text: "Approve",
                                      color: AppColors.primaryColor,
                                      image: ImagePath.approveIcon),
                                  20.sh,
                                  DenyButton(
                                      text: "Deny",
                                      ontap: () {
                                        admincorrectionrequestProvider.approveDenyAdminCorrectionRequests(context: context, decision: "rejected", correctionId: correctionRequestProvider.searchlist[index].id.toString(), employeeId: correctionRequestProvider.searchlist[index].employee!.id.toString(), date: correctionRequestProvider.searchlist[index].date.toString());
                                      },
                                      imagePath: ImagePath.denyIcon)
                      ]),
                                    );
                            },
                          )
                    ]),
                    ),
                  ))
                          );
                  });
                      },);
                      }else{
                      return Column(
                        children: [
                          20.sh,
                          Center(
                            child: CommonTextPoppins(
                                        text: "No Search Found",
                                        fontweight: FontWeight.w600,
                                        talign: TextAlign.center,
                                        fontsize: 15,
                                        color: AppColors.primaryColor),
                          ),
                          20.sh,
                        ],
                      );}                    
                    }  
                  },
                ),
                  ])));
              
                }},
              buttonOnPressed: () async {
                Location location = Location();
                bool enabledPermission =
                    await Permission.location.request().isGranted;
                if (AppConstants.loginmodell!.userAttendanceData[
                            "mobile_attendance_permission"] ==
                        true &&
                    AppConstants
                            .loginmodell!.userAttendanceData["geo_fencing"] ==
                        true &&
                    enabledPermission) {
                  await checkInternetPermission(context);
                }
                bool ison = await location.serviceEnabled();
                if (AppConstants.loginmodell!.userAttendanceData[
                            "mobile_attendance_permission"] ==
                        true &&
                    AppConstants
                            .loginmodell!.userAttendanceData["geo_fencing"] ==
                        true &&
                    ison &&
                    enabledPermission) {
                  // await checkInternetPermission(context);

                  //here we write code of 2nd time get location
                  //change destination lat,lng
                  // dashBoardProvider.changeBasiclatlongandradius(
                  //     AppConstants.loginmodell!.userData!.location == null
                  //         ? "0.0"
                  //         : AppConstants
                  //             .loginmodell!.userData!.location["latitude"]
                  //             .toString(),
                  //     AppConstants.loginmodell!.userData!.location == null
                  //         ? "0.0"
                  //         : AppConstants
                  //             .loginmodell!.userData!.location["longitude"]
                  //             .toString(),
                  //     AppConstants.loginmodell!.userAttendanceData["geo_radius"]
                  //         .toString());
                  // // Listen for changes in the user's position and check the geofence status.
                  // // location listner
                  // Geolocator.getPositionStream().listen((position) {
                  //   dashBoardProvider.checkGeofenceStatus(position);
                  // });

                  // // Listen for geofence transitions and update the geofence status.
                  // dashBoardProvider.streamController.stream
                  //     .listen((transition) {
                  //   dashBoardProvider.changelocation(transition);
                  //   // dashBoardProvider.geofenceStatus = transition;
                  // });

                  //   //change destination lat,lng
                  //   dashBoardProvider.changeBasiclatlongandradius(AppConstants.loginmodell!.userData!.location["latitude"].toString(), AppConstants.loginmodell!.userData!.location["longitude"].toString(), AppConstants.loginmodell!.userAttendanceData["geo_radius"].toString());
                  //   // Listen for changes in the user's position and check the geofence status.
                  //   // location listner
                  //   Geolocator.getPositionStream().listen((position) {
                  //   dashBoardProvider.checkGeofenceStatus(position);
                  //   });
                  //  // Listen for geofence transitions and update the geofence status.
                  //   dashBoardProvider.streamController.stream.listen((transition) {
                  //   dashBoardProvider.changelocation(transition);
                  //   // dashBoardProvider.geofenceStatus = transition;
                  //   });
                }
                if ((dashBoardProvider.geofenceStatus == "Entered" &&
                        ison == true &&
                        AppConstants.loginmodell!
                                .userAttendanceData["geo_fencing"] ==
                            true &&
                        enabledPermission == true) ||
                    (dashBoardProvider.geofenceStatus == "Entered" &&
                        ((AppConstants.loginmodell!
                                    .userAttendanceData["geo_fencing"] ==
                                false ||
                            AppConstants.loginmodell!
                                    .userAttendanceData["geo_fencing"]
                                    .toString() ==
                                "null")))) {
                  if (dashBoardProvider.ischeckin) {
                    //  dashBoardProvider.checkin(true);
                    CommonBottomSheet(
                        context: context,
                        widget: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 24),
                            child: SingleChildScrollView(
                              child: Form(
                                key: dashBoardProvider.reasonFormKey,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Center(
                                      child: CommonTextPoppins(
                                          text: "Add Clock Out",
                                          talign: TextAlign.left,
                                          fontweight: FontWeight.w600,
                                          fontsize: 20,
                                          color: AppColors.textColor),
                                    ),
                                    30.sh,
                                    CommonTextPoppins(
                                      text: "Event Type *",
                                      fontweight: FontWeight.w500,
                                      fontsize: 12,
                                      color: AppColors.hintTextColor,
                                      talign: TextAlign.left,
                                    ),
                                    4.sh,
                                    Consumer<DashBoardProvider>(
                                      builder:
                                          (context, dashBoardProvider, child) {
                                        return CommonDropDown(
                                            width: width(context),
                                            selectedText:
                                                dashBoardProvider.selectedText,
                                            listItem:
                                                dashBoardProvider.eventTypes,
                                            onchanged: (val) {
                                              dashBoardProvider
                                                  .changeDropDownValue(val);
                                            });
                                      },
                                    ),
                                    16.sh,
                                    Consumer<DashBoardProvider>(
                                      builder:
                                          (context, dashboardprovider, child) {
                                        if (dashboardprovider.hidereason) {
                                          return Container();
                                        } else {
                                          return Column(
                                            mainAxisSize: MainAxisSize.min,
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              CommonTextPoppins(
                                                text: "Reason For Leaving",
                                                fontweight: FontWeight.w500,
                                                fontsize: 12,
                                                color: AppColors.hintTextColor,
                                                talign: TextAlign.left,
                                              ),
                                              4.sh,
                                              CommonTextField(
                                                controller: dashBoardProvider
                                                    .reasoncontroller,
                                                hinttext: "Enter Reason",
                                                validator: (value) {
                                                  // if (value!.isEmpty) {
                                                  //   return "Please Enter Reason";
                                                  // } else {
                                                  //   return null;
                                                  // }
                                                },
                                              ),
                                            ],
                                          );
                                        }
                                      },
                                    ),

                                    //     CommonDropDown(Width: width(context), selectedText: dashBoardProvider.selectedText, listItem: dashBoardProvider.eventTypes, onchanged: (val) {
                                    //    dashBoardProvider.selectedText= val;
                                    //    dashBoardProvider.changeDropDownValue(val);
                                    // }),
                                    30.sh,
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 24.0),
                                      child: CommonButton(
                                          onPressed: () {
                                            if (dashBoardProvider
                                                .reasonFormKey.currentState!
                                                .validate()) {
                                              // dashBoardProvider.checkin(false);
                                              dashBoardProvider.hitCheckOutApi(
                                                isFace: false,
                                                  context: context,
                                                  reason: dashBoardProvider
                                                              .selectedText ==
                                                          "Scheduled Time Completed"
                                                      ? "Scheduled Time Completed"
                                                      : dashBoardProvider
                                                                  .reasoncontroller
                                                                  .text ==
                                                              ""
                                                          ? "Brb"
                                                          : "Brb-${dashBoardProvider.reasoncontroller.text}",
                                                  takenbreak: dashBoardProvider
                                                      .selectedText);
                                              Navigator.maybePop(context);
                                            }
                                          },
                                          width: width(context),
                                          text: "Add Clock Out"),
                                    ),
                                    16.sh,
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 24.0),
                                      child: CommonButton2(text: "Cancel"),
                                    ),
                                    16.sh,
                                  ],
                                ),
                              ),
                            )));
                    debugPrint("BottomSheet");
                  } else {
                    if (isRedundentClick(DateTime.now())) {
                      Fluttertoast.showToast(
                          msg: "hold on, processing",
                          toastLength: Toast.LENGTH_SHORT,
                          gravity: ToastGravity.BOTTOM,
                          timeInSecForIosWeb: 1,
                          backgroundColor: AppColors.primaryColor,
                          textColor: Colors.white,
                          fontSize: 16.0);
                      debugPrint('hold on, processing');
                      return;
                    }
                    dashBoardProvider.hitCheckInApi(context: context, isFace: false);
                    //dashBoardProvider.checkin(true);
                    debugPrint("close");
                  }
                } else {
                  if (!enabledPermission) {
                    ScaffoldMessenger.of(context).showSnackBar(
                        appSnackBar("Please Allow Location"));
                     
                  } else if (!ison) {
                     ScaffoldMessenger.of(context).showSnackBar(
                        appSnackBar("Please Turn On Location"));
                    
                  } else {
                     ScaffoldMessenger.of(context).showSnackBar(
                        appSnackBar("You cannot mark your attendance because you are ${((double.parse(dashBoardProvider.checkdistance.toString())/1000).toStringAsFixed(3)).toString()} K.M away from your assigned location"));
                  }
                }
              },
              buttonTitle: dashBoardProvider.ischeckin == false
                  ? "Check in"
                  : "Check Out",
              color: dashBoardProvider.ischeckin == false?Colors.blue:const Color(0XFFE34A4A),
              eyeOnPressed: () {
                dashBoardProvider.getAttendance(
                    employeeid:
                        AppConstants.loginmodell!.userData!.id.toString(),
                    context: context);
                CommonBottomSheet(
                    context: context,
                    widget: SingleChildScrollView(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Center(
                            child: CommonTextPoppins(
                                text: "Attendance",
                                talign: TextAlign.left,
                                fontweight: FontWeight.w600,
                                fontsize: 20,
                                color: AppColors.textColor),
                          ),
                          24.sh,
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 24),
                            child: CommonTextPoppins(
                              text: "Select Option",
                              fontweight: FontWeight.w500,
                              fontsize: 12,
                              color: AppColors.hintTextColor,
                              talign: TextAlign.left,
                            ),
                          ),
                          4.sh,
                          Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 24),
                              child: Column(
                                children: [
                                  Consumer<DashBoardProvider>(
                                    builder: (context, dashBoardProvider, child) {
                                      return CommonDropDown(
                                          width: width(context),
                                          selectedText: dashBoardProvider
                                              .selectedAttendanceType,
                                          listItem:
                                              dashBoardProvider.attendanceTypes,
                                          onchanged: (val) {
                                            dashBoardProvider
                                                .changeAttendanceTypeValue(val);
                                          });
                                    },
                                  ),20.sh,
                                  Consumer<DashBoardProvider>(
                            builder: (context, dashboardprovider, child) {
                             return    dashBoardProvider.selectedAttendanceType=="Week" ?  Row(
                            children: [
                              // InkWell(
                              //   onTap:(){
                                   
                              //   },
                              //   child: SvgPicture.asset(ImagePath.attendenceBackIcon)),
                              //   10.sw,
                              //     SvgPicture.asset(ImagePath.attendenceNextIcon),
                                    
                                    //10.sw,

                                      // CommonTextPoppins(
                                      // text: "Week ${dashboardprovider.totalWeek}:",
                                      // talign: TextAlign.left,
                                      // fontweight: FontWeight.w600,
                                      // fontsize: 14,
                                      // color: AppColors.blackColor),
                              3.sw,
                              CommonTextPoppins(
                              text: '${dashboardprovider.firstDateOfWeek} - ${dashboardprovider.lastDateOfWeek}',
                              talign: TextAlign.left,
                              fontweight: FontWeight.w400,
                              fontsize: 14,
                              color: AppColors.blackColor),
                            ],
                          ):Row(
                            children: [
                              InkWell(
                                onTap: (){
                                  debugPrint("back");
                                  dateRangePickerController.backward!();
                                },
                                child: SvgPicture.asset(ImagePath.attendenceBackIcon)),
                                10.sw,
                                  InkWell(
                                     onTap: (){
              dateRangePickerController.forward!();
                                },
                                    child: SvgPicture.asset(ImagePath.attendenceNextIcon)),
                                    10.sw,

                                      CommonTextPoppins(
                                      text: dashBoardProvider.month.toString(),
                                      talign: TextAlign.left,
                                      fontweight: FontWeight.w600,
                                      fontsize: 14,
                                      color: AppColors.blackColor),
                              5.sw,
                              CommonTextPoppins(
                              text: dashBoardProvider.year.toString(),
                              talign: TextAlign.left,
                              fontweight: FontWeight.w400,
                              fontsize: 14,
                              color: AppColors.blackColor),
                            ],
                          );}),
                                ],
                              )),
                          20.sh,
                         
                          Consumer<DashBoardProvider>(
                            builder: (context, dashboardprovider, child) {
                              if (dashboardprovider.attendanceloading ==
                                  true) {
                                return const Center(
                                    child:
                                        CircularProgressIndicator.adaptive());
                              } else if (dashboardprovider
                                      .selectedAttendanceType ==
                                  "Week") {
                                List<String> listatt = [];
                                DateTime initialdate = DateTime.now();
                                for (var i = 0; i < 7; i++) {
                                  DateTime now = initialdate
                                      .subtract(const Duration(days: 1));
                                  String formattedDate =
                                      DateFormat('yyyy-MM-dd').format(now);
                                  debugPrint(formattedDate);
                                  listatt.add(formattedDate);
                                  initialdate = now;
                                }
                                dashboardprovider.calculateDate(listatt[6],listatt[0]);
                                dashboardprovider.calculateWeek();
                                return Table(
                                    border: const TableBorder(
                                      horizontalInside: BorderSide(
                                        color: Colors.white, // Divider color
                                        width: 1.5, // Adjust the width to increase the height
                                        style: BorderStyle.solid,
                                      ),
                                    ),// Allows to add a border decoration around your table
                                    children: [
                                      CommonTableRow(
                                        context:context,
                                          textColor: AppColors.primaryColor,
                                          color: AppColors.tablefillColor,
                                          date: "Date",
                                          checkin: "Check In",
                                          checkout: "Check Out",
                                          hours: "Hours",
                                          ),
                                      AppConstants.attendance!.isNotEmpty
                                          ? CommonTableRow(
                                            context:context,
                                              id: listatt[0].toString(),
                                              color: (AppConstants.attendance![
                                                                  listatt[0]][
                                                              "attendance_status"])
                                                          .toString() ==
                                                      'Absent'
                                                  ? AppColors.redLightColor.withOpacity(.55)
                                                  : (AppConstants.attendance![listatt[0]]["attendance_status"]).toString()=="Weekend"?AppColors.primaryColor
                                              .withOpacity(.2):AppColors.success.withOpacity(0.25),
                                              date: listatt[0].toString() ==
                                                      'null'
                                                  ? '-'
                                                  : listatt[0],
                                              checkin: AppConstants
                                                          .attendance![
                                                              listatt[0]]
                                                              ["time_in"]
                                                          .toString() ==
                                                      'null'
                                                  ? '-'
                                                  : AppConstants.attendance![
                                                      listatt[0]]["time_in"],
                                              checkout: AppConstants
                                                          .attendance![
                                                              listatt[0]]
                                                              ["time_out"]
                                                          .toString() ==
                                                      'null'
                                                  ? '-'
                                                  : AppConstants.attendance![
                                                      listatt[0]]["time_out"],
                                              hours: AppConstants.attendance![
                                                              listatt[0]]
                                                              ["hours"]
                                                          .toString() ==
                                                      'null'
                                                  ? '-'
                                                  : (AppConstants.attendance![
                                                              listatt[0]]
                                                          ["hours"])
                                                      .toString(),
                                            )
                                          : CommonTableRow(
                                            context:context,
                                              color:
                                                  AppColors.tableUnfillColor,
                                              date: "-",
                                              checkin: "-",
                                              checkout: "-",
                                              hours: "-",
                                            ),
                                      AppConstants.attendance!.length > 1
                                          ? CommonTableRow(
                                            context:context,
                                              id: listatt[1].toString(),
                                              color: (AppConstants.attendance![
                                                                  listatt[1]][
                                                              "attendance_status"])
                                                          .toString() ==
                                                      'Absent'
                                                  ? AppColors.redLightColor.withOpacity(.55)

                                                  : (AppConstants.attendance![listatt[1]]["attendance_status"]).toString()=="Weekend"?AppColors.primaryColor
                                              .withOpacity(.2):AppColors.success.withOpacity(0.25),
                                              date: listatt[1].toString() ==
                                                      'null'
                                                  ? '-'
                                                  : listatt[1],
                                              checkin: AppConstants
                                                          .attendance![
                                                              listatt[1]]
                                                              ["time_in"]
                                                          .toString() ==
                                                      'null'
                                                  ? '-'
                                                  : AppConstants.attendance![
                                                      listatt[1]]["time_in"],
                                              checkout: AppConstants
                                                          .attendance![
                                                              listatt[1]]
                                                              ["time_out"]
                                                          .toString() ==
                                                      'null'
                                                  ? '-'
                                                  : AppConstants.attendance![
                                                      listatt[1]]["time_out"],
                                              hours: AppConstants.attendance![
                                                              listatt[1]]
                                                              ["hours"]
                                                          .toString() ==
                                                      'null'
                                                  ? '-'
                                                  : (AppConstants.attendance![
                                                              listatt[1]]
                                                          ["hours"])
                                                      .toString(),
                                            )
                                          : CommonTableRow(
                                            context:context,
                                              color: AppColors.tablefillColor,
                                              date: "-",
                                              checkin: "-",
                                              checkout: "-",
                                              hours: "-",
                                            ),
                                      AppConstants.attendance!.length > 2
                                          ? CommonTableRow(
                                            context:context,
                                              id: listatt[2].toString(),
                                              color: (AppConstants.attendance![
                                                                  listatt[2]][
                                                              "attendance_status"])
                                                          .toString() ==
                                                      'Absent'
                                                   ? AppColors.redLightColor.withOpacity(.55)

                                                  : (AppConstants.attendance![listatt[2]]["attendance_status"]).toString()=="Weekend"?AppColors.primaryColor
                                              .withOpacity(.2):AppColors.success.withOpacity(0.25),
                                              date: listatt[2].toString() ==
                                                      'null'
                                                  ? '-'
                                                  : listatt[2],
                                              checkin: AppConstants
                                                          .attendance![
                                                              listatt[2]]
                                                              ["time_in"]
                                                          .toString() ==
                                                      'null'
                                                  ? '-'
                                                  : AppConstants.attendance![
                                                      listatt[2]]["time_in"],
                                              checkout: AppConstants
                                                          .attendance![
                                                              listatt[2]]
                                                              ["time_out"]
                                                          .toString() ==
                                                      'null'
                                                  ? '-'
                                                  : AppConstants.attendance![
                                                      listatt[2]]["time_out"],
                                              hours: AppConstants.attendance![
                                                              listatt[2]]
                                                              ["hours"]
                                                          .toString() ==
                                                      'null'
                                                  ? '-'
                                                  : (AppConstants.attendance![
                                                              listatt[2]]
                                                          ["hours"])
                                                      .toString(),
                                            )
                                          : CommonTableRow(
                                            context:context,
                                              color:
                                                  AppColors.tableUnfillColor,
                                              date: "-",
                                              checkin: "-",
                                              checkout: "-",
                                              hours: "-",
                                            ),
                                      AppConstants.attendance!.length > 3
                                          ? CommonTableRow(
                                            context:context,
                                              id: listatt[3].toString(),
                                              color: (AppConstants.attendance![
                                                                  listatt[3]][
                                                              "attendance_status"])
                                                          .toString() ==
                                                      'Absent'
                                                    ? AppColors.redLightColor.withOpacity(.55)

                                                  : (AppConstants.attendance![listatt[3]]["attendance_status"]).toString()=="Weekend"?AppColors.primaryColor
                                              .withOpacity(.2):AppColors.success.withOpacity(0.25),
                                              date: listatt[3].toString() ==
                                                      'null'
                                                  ? '-'
                                                  : listatt[3],
                                              checkin: AppConstants
                                                          .attendance![
                                                              listatt[3]]
                                                              ["time_in"]
                                                          .toString() ==
                                                      'null'
                                                  ? '-'
                                                  : AppConstants.attendance![
                                                      listatt[3]]["time_in"],
                                              checkout: AppConstants
                                                          .attendance![
                                                              listatt[3]]
                                                              ["time_out"]
                                                          .toString() ==
                                                      'null'
                                                  ? '-'
                                                  : AppConstants.attendance![
                                                      listatt[3]]["time_out"],
                                              hours: AppConstants.attendance![
                                                              listatt[3]]
                                                              ["hours"]
                                                          .toString() ==
                                                      'null'
                                                  ? '-'
                                                  : (AppConstants.attendance![
                                                              listatt[3]]
                                                          ["hours"])
                                                      .toString(),
                                            )
                                          : CommonTableRow(
                                            context:context,
                                              color: AppColors.tablefillColor,
                                              date: "-",
                                              checkin: "-",
                                              checkout: "-",
                                              hours: "-",
                                            ),
                                      AppConstants.attendance!.length > 4
                                          ? CommonTableRow(
                                            context:context,
                                              id: listatt[4].toString(),
                                              color: (AppConstants.attendance![
                                                                  listatt[4]][
                                                              "attendance_status"])
                                                          .toString() ==
                                                      'Absent'
                                                   ? AppColors.redLightColor.withOpacity(.55)

                                                  : (AppConstants.attendance![listatt[4]]["attendance_status"]).toString()=="Weekend"?AppColors.primaryColor
                                              .withOpacity(.2):AppColors.success.withOpacity(0.25),
                                              date: listatt[4].toString() ==
                                                      'null'
                                                  ? '-'
                                                  : listatt[4],
                                              checkin: AppConstants
                                                          .attendance![
                                                              listatt[4]]
                                                              ["time_in"]
                                                          .toString() ==
                                                      'null'
                                                  ? '-'
                                                  : AppConstants.attendance![
                                                      listatt[4]]["time_in"],
                                              checkout: AppConstants
                                                          .attendance![
                                                              listatt[4]]
                                                              ["time_out"]
                                                          .toString() ==
                                                      'null'
                                                  ? '-'
                                                  : AppConstants.attendance![
                                                      listatt[4]]["time_out"],
                                              hours: AppConstants.attendance![
                                                              listatt[4]]
                                                              ["hours"]
                                                          .toString() ==
                                                      'null'
                                                  ? '-'
                                                  : (AppConstants.attendance![
                                                              listatt[4]]
                                                          ["hours"])
                                                      .toString(),
                                            )
                                          : CommonTableRow(
                                            context:context,
                                              color:
                                                  AppColors.tableUnfillColor,
                                              date: "-",
                                              checkin: "-",
                                              checkout: "-",
                                              hours: "-",
                                            ),
                                      AppConstants.attendance!.length > 5
                                          ? CommonTableRow(
                                            context:context,
                                              id: listatt[5].toString(),
                                              color: (AppConstants.attendance![
                                                                  listatt[5]][
                                                              "attendance_status"])
                                                          .toString() ==
                                                      'Absent'
                                                      ? AppColors.redLightColor.withOpacity(.55)

                                                  : (AppConstants.attendance![listatt[5]]["attendance_status"]).toString()=="Weekend"?AppColors.primaryColor
                                              .withOpacity(.2):AppColors.success.withOpacity(0.25),
                                              date: listatt[5].toString() ==
                                                      'null'
                                                  ? '-'
                                                  : listatt[5],
                                              checkin: AppConstants
                                                          .attendance![
                                                              listatt[5]]
                                                              ["time_in"]
                                                          .toString() ==
                                                      'null'
                                                  ? '-'
                                                  : AppConstants.attendance![
                                                      listatt[5]]["time_in"],
                                              checkout: AppConstants
                                                          .attendance![
                                                              listatt[5]]
                                                              ["time_out"]
                                                          .toString() ==
                                                      'null'
                                                  ? '-'
                                                  : AppConstants.attendance![
                                                      listatt[5]]["time_out"],
                                              hours: AppConstants.attendance![
                                                              listatt[5]]
                                                              ["hours"]
                                                          .toString() ==
                                                      'null'
                                                  ? '-'
                                                  : (AppConstants.attendance![
                                                              listatt[5]]
                                                          ["hours"])
                                                      .toString(),
                                            )
                                          : CommonTableRow(
                                            context:context,
                                              color: AppColors.tablefillColor,
                                              date: "-",
                                              checkin: "-",
                                              checkout: "-",
                                              hours: "-",
                                            ),
                                      AppConstants.attendance!.length > 6
                                          ? CommonTableRow(
                                            context:context,
                                              id: listatt[6].toString(),
                                              color: (AppConstants.attendance![
                                                                  listatt[6]][
                                                              "attendance_status"])
                                                          .toString() ==
                                                      'Absent'
                                                  ? AppColors.redLightColor.withOpacity(.55) 

                                                  : (AppConstants.attendance![listatt[6]]["attendance_status"]).toString()=="Weekend"?AppColors.primaryColor
                                              .withOpacity(.2):AppColors.success.withOpacity(0.25),
                                              date: listatt[6].toString() ==
                                                      'null'
                                                  ? '-'
                                                  : listatt[6],
                                              checkin: AppConstants
                                                          .attendance![
                                                              listatt[6]]
                                                              ["time_in"]
                                                          .toString() ==
                                                      'null'
                                                  ? '-'
                                                  : AppConstants.attendance![
                                                      listatt[6]]["time_in"],
                                              checkout: AppConstants
                                                          .attendance![
                                                              listatt[6]]
                                                              ["time_out"]
                                                          .toString() ==
                                                      'null'
                                                  ? '-'
                                                  : AppConstants.attendance![
                                                      listatt[6]]["time_out"],
                                              hours: AppConstants.attendance![
                                                              listatt[6]]
                                                              ["hours"]
                                                          .toString() ==
                                                      'null'
                                                  ? '-'
                                                  : (AppConstants.attendance![
                                                              listatt[6]]
                                                          ["hours"])
                                                      .toString(),
                                            )
                                          : CommonTableRow(
                                            context:context,
                                              color:
                                                  AppColors.success.withOpacity(.25),
                                              date: "-",
                                              checkin: "-",
                                              checkout: "-",
                                              hours: "-",
                                            ),
                                    ]);
                              } else {
                                List<DateTime> presentSpecialDates = [];
                                List<DateTime> specialdates = [];
                                String formattedDate;
                                DateTime tempDate, now, initialdate;
                                initialdate = DateTime.now();
                                for (var i = 0;
                                    i < DateTime.now().day - 1;
                                    i++) {
                                  now = initialdate
                                      .subtract(const Duration(days: 1));
                                  formattedDate =
                                      DateFormat('yyyy-MM-dd').format(now);
                                  if (AppConstants.attendance![formattedDate]
                                          .toString() !=
                                      "null") if (AppConstants
                                          .attendance![formattedDate]
                                              ["attendance_status"]
                                          .toString() ==
                                      'Absent') {
                                    tempDate = DateFormat("yyyy-MM-dd")
                                        .parse(formattedDate.toString());
                                    specialdates.add(tempDate);
                                  } else {
                                    tempDate = DateFormat("yyyy-MM-dd")
                                        .parse(formattedDate.toString());
                                    presentSpecialDates.add(tempDate);
                                  }
                                  initialdate = now;
                                }
                                return Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 28,
                                  ),
                                  child: SfDateRangePicker(
                                     navigationMode:DateRangePickerNavigationMode.none,
                                  controller: dateRangePickerController,         
                                  allowViewNavigation: false, 
                                  headerHeight: 0,
                                 onViewChanged:(DateRangePickerViewChangedArgs args) {
                                 int month=args.visibleDateRange.startDate!.month;
                                  int year=args.visibleDateRange.startDate!.year;
                                  dashBoardProvider.getMonthYear(month, year);
                                   },
                                    enableMultiView: false,
                                    enablePastDates: false,
                                    monthViewSettings:
                                        DateRangePickerMonthViewSettings(
                                         enableSwipeSelection :false,
                                          specialDates: presentSpecialDates,
                                          blackoutDates: specialdates,
                                    ),
                                    selectableDayPredicate: (DateTime date) {
                                      if (date.weekday == DateTime.saturday ||
                                          date.weekday == DateTime.sunday) {
                                        return false;
                                      }
                                      return true;
                                    },
                                    rangeTextStyle: TextStyle(
                                        color: AppColors.hintTextColor),
                                    monthCellStyle:
                                        DateRangePickerMonthCellStyle(
                                      textStyle: TextStyle(
                                          color: AppColors.hintTextColor),
                                      weekendDatesDecoration: BoxDecoration(
                                          color: AppColors.primaryColor
                                              .withOpacity(.2),
                                          border: Border.all(width: 1),
                                          shape: BoxShape.circle),
                                      specialDatesDecoration: BoxDecoration(
                                          color: AppColors.greenColor
                                              .withOpacity(.25),
                                          border: Border.all(
                                              color: AppColors.greenColor,
                                              width: 1),
                                          shape: BoxShape.circle),
                                      blackoutDatesDecoration: BoxDecoration(
                                          color: const Color(0XFFE34A4A)
                                              .withOpacity(.25),
                                          border: Border.all(
                                              color: const Color(0XFFE34A4A),
                                              width: 1),
                                          shape: BoxShape.circle),
                                    ),
                                  ),
                                );
                              }
                            },
                          )
                        ],
                      ),
                    ));
              },
            ),
            back: Container(
              height: height(context) * .25,
              margin: const EdgeInsets.symmetric(
                horizontal: 24,
              ),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: AppColors.whiteColor),
              padding: const EdgeInsets.all(24),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        CommonTextPoppins(
                            text: "Time Tracking",
                            fontweight: FontWeight.w500,
                            fontsize: 16,
                            color: AppColors.textColor),
                            4.sw,
                        AppConstants
                                    .loginmodell!
                                    .userAttendanceData[
                                        "employeeLatestAttendance"]
                                    .toString() ==
                                "null"
                            ? const SizedBox()
                            : AppConstants
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
                                        fontsize: 10,
                                        color: AppColors.whiteColor),
                                  )
                                : const SizedBox(),
                                const Spacer(),
                        InkWell(
                            onTap: () => dashBoardProvider.cardKey.currentState!
                                .toggleCard(),
                            child: SvgPicture.asset(ImagePath.infoCircle)),
                      ],
                    ),
                    CommonTextPoppins(
                        text: AppConstants
                                    .loginmodell!.userWorkSchedule!.workSchedule
                                    .toString() ==
                                "null"
                            ? "No Schedule Available"
                            : "Start - ${AppConstants.loginmodell!.userAttendanceData["employeeAllAttendanceToday"].toString() == "null" || AppConstants.loginmodell!.userAttendanceData["employeeAllAttendanceToday"].toString() == "[]" ? "-" : dashBoardProvider.schedulestart} | End - ${dashBoardProvider.schedulestart == "-" ? "-" : AppConstants.loginmodell!.userAttendanceData["employeeLatestAttendance"].toString() == "null" ? "-" : AppConstants.loginmodell!.userAttendanceData["employeeLatestAttendance"]["taken_a_break"] == "false" ? AppConstants.loginmodell!.userAttendanceData["employeeLatestAttendance"]["time_out"].toString() : "-"}",
                        //text: AppConstants.loginmodell!.userWorkSchedule!.workSchedule.toString()=="null"?"No Schedule Available": "Start - ${AppConstants.loginmodell!.userAttendanceData["employeeCurrentMonthAttendance"][AppConstants.startTime]["id"]} | End - ${dashBoardProvider.scheduleendtime}",
                        talign: TextAlign.left,
                        fontweight: FontWeight.w500,
                        fontsize: 14,
                        color: AppColors.hintTextColor),
                    5.sh,
                    const Divider(), //here
                    Container(
                      alignment: Alignment.topLeft,
                      height: height(context) * .10,
                      child: ListView.builder(
                          padding: EdgeInsets.zero,
                          shrinkWrap: true,
                          //physics: const NeverScrollableScrollPhysics(),
                          reverse: true,
                          itemCount: AppConstants
                              .loginmodell!
                              .userAttendanceData["employeeAllAttendanceToday"]
                              .length,
                          itemBuilder: (context, index) {
                            dynamic attendanceIndex = AppConstants
                                .loginmodell!
                                .userAttendanceData[
                                    "employeeCurrentMonthAttendance"]
                                .indexWhere((item) =>
                                    AppConstants
                                        .loginmodell!
                                        .userAttendanceData[
                                            "employeeAllAttendanceToday"][index]
                                        .toString() ==
                                    item["id"].toString());
                            // dynamic attendanceIndex =  AppConstants.loginmodell!.userAttendanceData["employeeCurrentMonthAttendance"].indexWhere((item)
                            // => AppConstants.loginmodell!.userAttendanceData["employeeAllAttendanceToday"][index].toString()== item["id"].toString()
                            // );
                            return Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: AppConstants
                                          .loginmodell!
                                          .userAttendanceData[
                                              "employeeCurrentMonthAttendance"]
                                              [attendanceIndex]["taken_a_break"]
                                          .toString() ==
                                      "false"
                                  ? []
                                  : [
                                      CommonTextPoppins(
                                          text: AppConstants
                                                      .loginmodell!
                                                      .userAttendanceData[
                                                          "employeeCurrentMonthAttendance"]
                                                          [attendanceIndex]
                                                          ["time_out"]
                                                      .toString() ==
                                                  "null"
                                              ? "-"
                                              : "Break Start - ${AppConstants.loginmodell!.userAttendanceData["employeeCurrentMonthAttendance"][attendanceIndex]["time_out"].toString() == "null" ? "-" : AppConstants.loginmodell!.userAttendanceData["employeeCurrentMonthAttendance"][attendanceIndex]["time_out"].toString()}",
                                          color: AppColors.hintTextColor,
                                          fontsize: 13,
                                          fontweight: FontWeight.w500,
                                          talign: TextAlign.left),
                                      CommonTextPoppins(
                                          text: AppConstants
                                                      .loginmodell!
                                                      .userAttendanceData[
                                                          "employeeCurrentMonthAttendance"]
                                                          [attendanceIndex]
                                                          ["time_out"]
                                                      .toString() ==
                                                  "null"
                                              ? "-"
                                              : "| End - ${AppConstants.loginmodell!.userAttendanceData["employeeCurrentMonthAttendance"].length > attendanceIndex + 1 ? AppConstants.loginmodell!.userAttendanceData["employeeCurrentMonthAttendance"][attendanceIndex + 1]["time_in"] : ""}",
                                          color: AppColors.hintTextColor,
                                          fontsize: 13,
                                          fontweight: FontWeight.w500,
                                          talign: TextAlign.left),
                                    ],
                            );
                          }),
                    ),
                  ],
                ),
              ),
            ));
      },
    );
  }
}
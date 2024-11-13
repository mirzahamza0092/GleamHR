import 'dart:async';
import 'package:flutter/material.dart';
import 'package:gleam_hr/Models/AuthModels/CheckModulesModel.dart';
import 'package:gleam_hr/Models/AuthModels/StagingLoginModel.dart';
import 'package:gleam_hr/Models/DashBoardModels/AllExpenseRequestModel.dart';
import 'package:gleam_hr/Models/DashBoardModels/HomeModels/AllCorrectionRequestModel.dart';
import 'package:gleam_hr/Models/DashBoardModels/PeopleModels/AllEmployeeDetailsModel.dart';
import 'package:gleam_hr/Models/DashBoardModels/AppbarModels/AllEmployeeEnrollStatusModel.dart';
import 'package:gleam_hr/Models/DashBoardModels/MoreModels/AllEmployeeRolesModel.dart';
import 'package:gleam_hr/Models/DashBoardModels/AppbarModels/AllNotificationsModel.dart';
import 'package:gleam_hr/Models/DashBoardModels/MoreModels/AllOfficeModel.dart';
import 'package:gleam_hr/Models/DashBoardModels/HomeModels/AllTimeOffRequestModel.dart';
import 'package:gleam_hr/Models/DashBoardModels/HomeModels/AssetRequestModel.dart';
import 'package:gleam_hr/Models/DashBoardModels/HomeModels/AssetTypeModel.dart';
import 'package:gleam_hr/Models/DashBoardModels/HomeModels/CheckinCheckoutModel.dart';
import 'package:gleam_hr/Models/DashBoardModels/HomeModels/ExpenseRequestTypesModel.dart';
import 'package:gleam_hr/Models/DashBoardModels/MoreModels/GetLocationTrackingEnabledEmployeesModel.dart';
import 'package:gleam_hr/Models/DashBoardModels/HomeModels/GetTimeOffModel.dart';
import 'package:gleam_hr/Models/DashBoardModels/HomeModels/GetWorkFromHomeModel.dart';
import 'package:gleam_hr/Models/DashBoardModels/HomeModels/PaySlipsModel.dart';
import 'package:gleam_hr/Models/DashBoardModels/HomeModels/WorkFromHomeRequestModel.dart';
import 'package:local_auth/local_auth.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';
import '../Models/DashBoardModels/AppbarModels/AllAnnouncementsModel.dart';
import '../Models/DashBoardModels/PeopleModels/SpecificEmployeeModel.dart';
import '../Models/DashBoardModels/MoreModels/EmployeeShift_Model.dart';

class AppConstants {
  //bio metric Auth
  static final LocalAuthentication auth = LocalAuthentication();
  static bool supportstate = false;
  //models object
  static StagingLoginModel? loginmodell;
  static AllCorrectionRequestsModel? allCorrectionRequestsmodel;
  static AllCorrectionRequestsModel? adminCorrectionRequestsmodel;
  static AllTimeOffRequestsModel? allTimeOffRequestsmodel;
  static WorkFromHomeRequestModel? wfhRequestsmodel;
  static AssetRequestModel? assetRequestsmodel;
  static AllExpenseRequestsModel? allExpenseRequestsmodel;
  static CheckModulesModel? modulesmodell;
  static GetTimeOffModel? timeoffmodel;
  static AssetTypesModel? assetTypes;
  static GetWorkFromHomeModel? wfhmodel;
  static AllEmployeeEnrollStatusModel? allEmployeeEnrollStatusModel;
  static AllEmployeesDetailsModel? allEmployeesDetailsModel;
  static EmployeeShiftModel? employeeShiftModel;
  static AllEmployeeRolesModel? allEmployeeRoleModel;
  static AllOfficeLocationModel? allOfficeLocationModel;
  static GetLocationTrackingEnabledEmployeesModel? allTrackedEmployee;
 // static AllEmployeesSpecificModel? allEmployeesSpecificModel;
  static AnnouncementModel? announcementModel;
  static AllNotificationsModel? allnotificationDetailsModel;
  static CheckinCheckoutModel? checkincheckoutmodel;
  static PaySlipsModel? paySlipsModel;
  static ExpenseRequestModel? expenseRequestModel;
  static SpecificEmployeeModel? specifiEmployeescModel;
  //
  static String? token;
  static String? button;
  static String? clocktype;
  static Map? attendance;
  static int? startTime, endTime;
  static String? fcmtoken = '';
  static String? playerId = '';
  static String? appPackage = '';
  static bool fromLogin = false;
  static List<String> barOptions=[];
  static bool livemode = false;//true for live and false for staging
  static Timer liveLocationTimer = Timer(const Duration(), () { });//livelocation timer
  static List<String> item = [];

  //main keys
  static final GlobalKey<NavigatorState> navigatorKey =
      GlobalKey<NavigatorState>();
  static final GlobalKey<ScaffoldMessengerState> snackbarKey =
      GlobalKey<ScaffoldMessengerState>();
}

PickerDateRange excludeWeekends(DateTime startDate, DateTime endDate) {
  DateTime newStartDate = startDate;
  DateTime newEndDate = endDate;

  while (newStartDate.weekday == DateTime.saturday ||
      newStartDate.weekday == DateTime.sunday) {
    newStartDate = newStartDate.add(const Duration(days: 1));
  }

  while (newEndDate.weekday == DateTime.saturday ||
      newEndDate.weekday == DateTime.sunday) {
    newEndDate = newEndDate.subtract(const Duration(days: 1));
  }

  return PickerDateRange(newStartDate, newEndDate);
}

double getDifferenceWithoutWeekends(DateTime startDate, DateTime endDate) {
  double nbDays = 0;
  DateTime currentDay = startDate.subtract(const Duration(days: 1));
  while (currentDay.isBefore(endDate)) {
    currentDay = currentDay.add(const Duration(days: 1));
    if (AppConstants.timeoffmodel!.daysData!.nonWorkingDays!.length
            .toString() ==
        "2") {
      if (currentDay.weekday != DateTime.saturday &&
          currentDay.weekday != DateTime.sunday) {
        nbDays += double.parse(
            AppConstants.timeoffmodel!.daysData!.scheduleHours.toString());
      }
    } else {
      if (currentDay.weekday != DateTime.sunday) {
        nbDays += double.parse(
            AppConstants.timeoffmodel!.daysData!.scheduleHours.toString());
      }
    }
  }
  return nbDays;
}

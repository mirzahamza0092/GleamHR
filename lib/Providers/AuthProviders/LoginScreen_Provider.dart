import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gleam_hr/Components/commonSnakbar.dart';
import 'package:gleam_hr/Models/AuthModels/CheckModulesModel.dart';
import 'package:gleam_hr/Models/AuthModels/StagingLoginModel.dart';
import 'package:gleam_hr/Providers/DashBoardProviders/DashBoard_Provider.dart';
import 'package:gleam_hr/Providers/DashBoardProviders/MeProviders/MeScreen_Provider.dart';
import 'package:gleam_hr/Routes/routes.dart' as route;
import 'package:gleam_hr/Screens/DashBoard/Home/HomeWidgets/CustomDialogBox.dart';
import 'package:gleam_hr/Services/BackgroundServices/BackGround_Services.dart';
import 'package:gleam_hr/Services/AuthServices/CheckModulesModel_Service.dart';
import 'package:gleam_hr/Services/AuthServices/LoginScreen_Service.dart';
import 'package:gleam_hr/Utils/AppConstants.dart';
import 'package:gleam_hr/Utils/AppPaths.dart';
import 'package:gleam_hr/Utils/Methods.dart';
import 'package:gleam_hr/Utils/checkInternetPermission.dart';
import 'package:intl/intl.dart';
import 'package:local_auth/local_auth.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginScreenProvider extends ChangeNotifier {
  TextEditingController nameoremail = TextEditingController();
  TextEditingController password = TextEditingController();
  bool isLoading = false, visibility = true, rememberme = false;
  String? bioenabled, bioenabled2;

  changeVisibility() {
    //change visibility of login page password
    visibility = !visibility;
    notifyListeners();
  }

  isbioenabled() async {
    // getting the value of bio metric enabled
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bioenabled = prefs.getBool("enabledBioMetric").toString();
    bioenabled2 = prefs.getBool("enabledBioMetric2").toString();
    notifyListeners();
  }

  getrememberMe()async{
    await SharedPreferences.getInstance().then((prefs) {
      if (prefs.getBool("rememberme").toString() == "null") {
        rememberme=false;
        if (prefs.getString("rememberme_username").toString() != "null") {
        nameoremail.text=prefs.getString("rememberme_username").toString();
        }
      } else {
        rememberme = prefs.getBool("rememberme")!;
        if (prefs.getString("rememberme_username").toString() != "null") {
        nameoremail.text=prefs.getString("rememberme_username").toString();
        }
      }
      });
      notifyListeners();
    }
  setRememberMe(bool value)async{
    rememberme = value;
      SharedPreferences.getInstance().then((prefs) {
        prefs.setBool("rememberme", value);
      });
    notifyListeners();
  }
Future<bool> userAuthorization({required String reason}) async {
  return await AppConstants.auth.authenticate(
      localizedReason: reason,
      options: (const AuthenticationOptions(
          stickyAuth: true,
          biometricOnly: true,
          useErrorDialogs: true,
          sensitiveTransaction: false)));
}
  biometric(BuildContext context, bool isShowDialog) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      if (prefs.getBool("enabledBioMetric2") == null ||
          prefs.getBool("enabledBioMetric2") == false) {
        bool isauthenticate = await userAuthorization(reason: "Please Authenticate");
        if (isauthenticate) {
        context.read<MeScreenProvider>().changeEnabledBioMetric(true); 
        isbioenabled();
        await showDialog(
            context: context,
            builder: (BuildContext context) {
              return CustomDialogBox(
                title: "You have to enter credentials first time when login",
                text: "OK",
                img: Image.asset(ImagePath.dialogBoxImage),
              );
            });
      }}
      if (prefs.getBool("enabledBioMetric2") == true) {
        bool authenticated = await AppConstants.auth.authenticate(
            localizedReason: "For Login",
            options: (const AuthenticationOptions(
                stickyAuth: false,
                biometricOnly: false,
                useErrorDialogs: false,
                sensitiveTransaction: false)));
        debugPrint("Status: $authenticated");
        if (authenticated) {
          hitLogin(context, prefs.getString("username").toString(),
              prefs.getString("password").toString());
        }
      } else {
        debugPrint(prefs.getBool("enabledBioMetric").toString());
      }
    } on PlatformException catch (exception) {
      debugPrint(exception.toString());
    }
  }

  hitLogin(BuildContext context, String nameoremail, String password) async {
    try {
      if (await checkinternetconnection()) {
        //login api call
        isLoading = true;
        notifyListeners();
        var moduleRes =
            await CheckModulesModelService.activeModulesList(context: context);
        if (moduleRes is CheckModulesModel) {
          SharedPreferences prefs = await SharedPreferences.getInstance();
          await prefs.setString(
              "moduleRes", checkModulesModelToJson(moduleRes));
          AppConstants.modulesmodell = await checkModulesModelFromJson(
              prefs.getString("moduleRes").toString());
        }
        var res = await LoginScreenService.login(
            emailOrUsername: nameoremail, password: password, context: context);
        if (res is StagingLoginModel) {
          StagingLoginModel? demologinmodel;
          demologinmodel = res;
          AppConstants.loginmodell = demologinmodel;
          SharedPreferences prefs = await SharedPreferences.getInstance();
          if (prefs.getBool("enabledBioMetric") == true) {
            context.read<MeScreenProvider>().changeEnabledBioMetric(true);
          }
          //start time and end working time
          // debugPrint(AppConstants.loginmodell!.userAttendanceData["employeeAllAttendanceToday"][1]["id"].toString());
          //     dynamic startTime= AppConstants.loginmodell!.userAttendanceData["employeeCurrentMonthAttendance"].indexWhere((item)
          //               => int.parse(AppConstants.loginmodell!.userAttendanceData["employeeAllAttendanceToday"][1]["id"].toString())== int.parse(item["id"].toString())
          //               );
          //               // DebugCreator(startTime);
          //               debugPrint("yoon"+startTime.toString());
          //
          if (bioenabled == "true") {
            await prefs.setString("username", nameoremail.toString());
            await prefs.setString("password", password.toString());
            await prefs.setBool("enabledBioMetric2", true);
          }
          await prefs.setString(
              "loginmodel", stagingLoginModelToJson(demologinmodel));
          debugPrint("//\\");
          AppConstants.loginmodell = stagingLoginModelFromJson(
              prefs.getString("loginmodel").toString());

          await prefs.setString(
              "button",
              AppConstants.loginmodell!
                              .userAttendanceData["attendance_marking_data"] ==
                          null ||
                      AppConstants.loginmodell!
                              .userAttendanceData["attendance_marking_data"] ==
                          false ||
                      AppConstants.loginmodell!
                              .userAttendanceData["attendance_marking_data"]
                              .toString() ==
                          "[]"
                  ? "null"
                  : (AppConstants.loginmodell!
                              .userAttendanceData["attendance_marking_data"]
                          ["button"])
                      .toString());
          await prefs.setString(
              "clock_type",
              AppConstants.loginmodell!
                              .userAttendanceData["attendance_marking_data"] ==
                          null ||
                      AppConstants.loginmodell!
                              .userAttendanceData["attendance_marking_data"] ==
                          false ||
                      AppConstants.loginmodell!
                              .userAttendanceData["attendance_marking_data"]
                              .toString() ==
                          "[]"
                  ? "null"
                  : (AppConstants.loginmodell!
                              .userAttendanceData["attendance_marking_data"]
                          ["clock_type"])
                      .toString());
          AppConstants.button = prefs.getString("button");
          AppConstants.clocktype = prefs.getString("clock_type");

          if (AppConstants.clocktype == "null" &&
              AppConstants.button == "null") {
           if (AppConstants.loginmodell!.userRole![0].type.toString() !="admin") {
            ScaffoldMessenger.of(context).showSnackBar(
           appSnackBar("You Don't Have Mobile Attendance Permission")); 
           }
            notifyListeners();
          }
          if (AppConstants.loginmodell!.userData!.workScheduleId.toString() ==
              "null") {
            if (AppConstants.loginmodell!.userRole![0].type.toString() !="admin") {
            ScaffoldMessenger.of(context).showSnackBar(
           appSnackBar("You Don't Have Mobile Attendance Permission"));
           }
            notifyListeners();
          }
          //
          //start time
          if (AppConstants.loginmodell!
                      .userAttendanceData["employeeAllAttendanceToday"]
                      .toString() ==
                  "null" ||
              AppConstants.loginmodell!
                      .userAttendanceData["employeeAllAttendanceToday"]
                      .toString() ==
                  "[]") {
            context.read<DashBoardProvider>().schedulestarttime = "-";
          } else {
            List list = AppConstants.loginmodell!
                .userAttendanceData["employeeCurrentMonthAttendance"]
                .toList();
            for (var element in list) {
              if (element["id"].toString() ==
                  AppConstants
                      .loginmodell!
                      .userAttendanceData["employeeAllAttendanceToday"][
                          AppConstants
                                  .loginmodell!
                                  .userAttendanceData[
                                      "employeeAllAttendanceToday"]
                                  .length -
                              1]
                      .toString()) {
                context.read<DashBoardProvider>().schedulestart =
                    element["time_in"].toString();
              }
            }
          }
          //
          debugPrint(demologinmodel.accessToken.toString());
          if (demologinmodel.accessToken.toString() != "null" &&
              demologinmodel.accessToken.toString() != "") {
            final prefs = await SharedPreferences.getInstance();
            prefs.setString(Keys.token, demologinmodel.accessToken.toString());
            // demologinmodel.userData?.lastLogin=null;
            // demologinmodel.userData?.lastLoginMobile = null;
            if (demologinmodel.userData?.lastLogin == null &&
                demologinmodel.userData?.lastLoginMobile == null) {
              debugPrint("this is idd${AppConstants.loginmodell!.userData!.id}");
              debugPrint("token---->>>>>${prefs.get(Keys.token)}");
              AppConstants.fromLogin = true;
              isLoading = false;
              notifyListeners();

              Navigator.of(context).pushNamed(route.setpassword);
              ScaffoldMessenger.of(context).showSnackBar(
                  appSnackBar("Please set password"));
            } else {
                //calling get timeoff
                  // if (AppConstants.modulesmodell!.data![4].status.toString() ==
                  //     "1") {
                  //   var timeOffResp = await GetTimeOffService.getTimeOff(
                  //       context: context,
                  //       userid:
                  //           AppConstants.loginmodell!.userData!.id.toString());
                  //   await prefs.setString(
                  //       "gettimeoffpolicies", getTimeOffModelToJson(timeOffResp));
                  //   AppConstants.timeoffmodel = getTimeOffModelFromJson(
                  //       prefs.getString("gettimeoffpolicies").toString());
                  //   debugPrint(AppConstants.timeoffmodel!.policies!.length.toString());
                  // }
                //
                //calling get work from home
                  // if (AppConstants.modulesmodell!.data![8].status.toString() ==
                  //     "1") {
                  //   var wfhResp = await GetWorkFromHomeService.getWorkFromHome(
                  //       context: context,
                  //       userid:
                  //           AppConstants.loginmodell!.userData!.id.toString());
                  //   await prefs.setString(
                  //       "getwfhpolicies", getWorkFromHomeModelToJson(wfhResp));
                  //   AppConstants.wfhmodel = getWorkFromHomeModelFromJson(
                  //       prefs.getString("getwfhpolicies").toString());
                  //   debugPrint(AppConstants.wfhmodel!.data!.length.toString());
                  // }
                //

                isLoading = false;
                notifyListeners();
                if (prefs.getBool("rememberme") == true) {
                  await prefs.setString("rememberme_username",nameoremail);
                  // prefs.setString("rememberme_password",password);
                }else{
                  await prefs.setString("rememberme_username","");
                  // prefs.setString("rememberme_password","");
                }
                if (AppConstants.loginmodell!.userData!.trackLocation.toString()=="1") {
                  String permissionErrorMessage =await getlocationPermissions();
                  if (permissionErrorMessage == "") {
                  DateTime startTime = DateFormat('HH:mm').parse(AppConstants.loginmodell!.userWorkSchedule!.scheduleStartTime.toString());
                  DateTime endTime = DateFormat('HH:mm').parse(AppConstants.loginmodell!.userWorkSchedule!.scheduleEndTime.toString());
                  DateTime currentTime = DateFormat('HH:mm').parse(DateFormat('HH:mm').format(DateTime.now()));
                  debugPrint("live location timer not running noe starting");
                  if (currentTime.isAfter(startTime) && currentTime.isBefore(endTime)) {
                  await backgroundForegroundFetch();
                  }
                ScaffoldMessenger.of(context)
                    .showSnackBar(appSnackBar("Login Successful"));
                  Functions.startDisplayingTime(context);
                  Navigator.of(context).pushNamedAndRemoveUntil(
                    route.bottomNav, (Route route) => false);
                this.nameoremail.clear();
                this.password.clear();
                debugPrint("token---->>>>>${prefs.get(Keys.token)}");
                await checkVersion();
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                        appSnackBar(permissionErrorMessage));
                  }
                } else {
                ScaffoldMessenger.of(context)
                    .showSnackBar(appSnackBar("Login Successful"));
                Functions.startDisplayingTime(context);
                Navigator.of(context).pushNamedAndRemoveUntil(
                    route.bottomNav, (Route route) => false);
                this.nameoremail.clear();
                this.password.clear();
                debugPrint("token---->>>>>${prefs.get(Keys.token)}");
                await checkVersion();
                }
            }
          } else {
            isLoading = false;
            notifyListeners();
          }
        } else {
          isLoading = false;
          notifyListeners();
        }
      } else {
         ScaffoldMessenger.of(context).showSnackBar(
           appSnackBar("No Internet Connection")); 
        notifyListeners();
      }
    } catch (exception) {
      debugPrint(exception.toString());
      isLoading = false;
      notifyListeners();
    }
    //Navigator.of(context).pushNamedAndRemoveUntil(route.bottomNav,(Route route) => false);
  }
}

import 'dart:async';
import 'package:expansion_tile_card/expansion_tile_card.dart';
import 'package:flip_card/flip_card.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:gleam_hr/Components/commonSnakbar.dart';
import 'package:gleam_hr/Models/AuthModels/StagingLoginModel.dart';
import 'package:gleam_hr/Models/DashBoardModels/HomeModels/CheckinCheckoutModel.dart';
import 'package:gleam_hr/Models/DashBoardModels/HomeModels/GetTimeOffModel.dart';
import 'package:gleam_hr/Models/DashBoardModels/HomeModels/PaySlipsModel.dart';
import 'package:gleam_hr/Screens/DashBoard/Home/HomeWidgets/CustomDialogBox.dart';
import 'package:gleam_hr/Services/DashBoardServices/HomeServices/TimeTrackingServices/CheckinApi_Service.dart';
import 'package:gleam_hr/Services/DashBoardServices/HomeServices/TimeTrackingServices/CheckoutApi_Service.dart';
import 'package:gleam_hr/Services/DashBoardServices/HomeServices/TimeTrackingServices/EmployeeAttandance_Service.dart';
import 'package:gleam_hr/Services/DashBoardServices/HomeServices/TimeOffServices/GetTimeOff_Service.dart';
import 'package:gleam_hr/Services/DashBoardServices/HitRefreshApi_Service.dart';
import 'package:gleam_hr/Services/DashBoardServices/HomeServices/PayrollServices/PaySlips_Service.dart';
import 'package:gleam_hr/Services/DashBoardServices/HomeServices/TimeOffServices/StoreTimeOffRequest_Service.dart';
import 'package:gleam_hr/Utils/AppConstants.dart';
import 'package:gleam_hr/Utils/AppPaths.dart';
import 'package:gleam_hr/Utils/Methods.dart';
import 'package:intl/intl.dart';
import 'package:sentry_flutter/sentry_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

class DashBoardProvider extends ChangeNotifier {
  PickerDateRange picker = const PickerDateRange(null, null);
  String startdateformat = "", enddateformat = "";
  int screenNumber = 0;
 String month=DateFormat('MMMM').format(DateTime(2023, DateTime.now().month));
  int year=DateTime.now().year;
   late DateRangePickerController dateRangeController=DateRangePickerController();
  bool loading=false;
  GlobalKey keycheckin = GlobalKey();
  GlobalKey keyview = GlobalKey();
  GlobalKey keytimeoff = GlobalKey();
  GlobalKey keypayroll = GlobalKey();
  GlobalKey keywfh = GlobalKey();
  GlobalKey keyexpenserequest = GlobalKey();

  List<DateTime> days = [];
  List<double> dayshours = [];
  bool ischeckin = false,
      checkinLoading = false,
      isLoading = false,
      attendanceloading = false,
      payslipsloading = false,
      hidereason = false,
      attendenceCheck = false;
  String timeof = "TIME OFF CATEGORY";
  final GlobalKey<ExpansionTileCardState> cardexpandabletile = GlobalKey();
  final GlobalKey<ExpansionTileCardState> eventTypesTile = GlobalKey();
  String selectedText = "break";
  //time off variable
  bool holidayfound = false;
  bool repeatationFound = false;
  String policyId = "", strtdate = "", endate = "", totalNumberofAmount = "";
  TextEditingController note = TextEditingController();
  Map<String, dynamic> dailyAmount = {};
  String firstDateOfWeek="",lastDateOfWeek="",totalWeek="";
  //
  List<String> eventTypes = ["break", "Scheduled Time Completed"];
  String selectedAttendanceType = "Week";
  String? PayslipYear="2024";
  List<String> years=["2024", "2023", "2022", "2021"];
  String? schedulestarttime, scheduleendtime, schedulestart = "-";
  List<String> attendanceTypes = ["Week", "Month"];
  GlobalKey<FormState> noteFormKey = GlobalKey();
  GlobalKey<FormState> reasonFormKey = GlobalKey();
  TextEditingController reasoncontroller = TextEditingController();
  final GlobalKey<RefreshIndicatorState> refreshIndicatorKey =
      GlobalKey<RefreshIndicatorState>();
  GlobalKey<FlipCardState> cardKey = GlobalKey<FlipCardState>();
  int addtimer = 0;
  Timer? timerr = Timer(Duration.zero, () {});

//////////for location (geo fencing)
  // Define the geofence coordinates and radius.
  double _latitude = 33.646273;
  double _longitude = 72.996566; //latitude: 33.6462° N, longitude: 72.9964° E
  double _radius = 60;
  double? checkdistance;
  // Define a stream controller to handle geofence transitions.
  bool streamrunning=false;
  final StreamController<String> streamController =
      StreamController<String>.broadcast();
  //for controlling current location stream
  StreamSubscription<Position>? stream;
  // Define a variable to hold the geofence status.
  String geofenceStatus = '';
  checkGeofenceStatus(Position position) async{
    double distanceInMeters = Geolocator.distanceBetween(
        position.latitude, position.longitude, _latitude, _longitude);
    checkdistance = distanceInMeters;
    if (distanceInMeters <= _radius) {
      streamController.add('Entered');
    } else {
      streamController.add('Exited');
    }
    notifyListeners();
  }

int totalWeeksInYear(DateTime from, DateTime to) {
  from = DateTime.utc(from.year, from.month, from.day);
  to = DateTime.utc(to.year, to.month, to.day);
  return (to.difference(from).inDays / 7).ceil();
}
String formatDate(DateTime date) {
  return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
}
 String getMonthName(int month) {
    return DateFormat('MMMM').format(DateTime(2023, month));
  }
  changelocation(String transition) {
    geofenceStatus = transition;
    debugPrint("Check your distance$checkdistance");
    streamrunning=true;
// notifyListeners();
  }

  changeBasiclatlongandradius(String lat, String lng, String radius) {
    _latitude = double.parse(lat);
    _longitude = double.parse(lng);
    _radius = double.parse(radius);
    notifyListeners();
  }

  changeGeoFensingStatus(String newstatus) {
    geofenceStatus = newstatus;
    notifyListeners();
  }
//////////

  getMonthYear(int m,int y){
    month=  getMonthName(m);
    year=y;
  }

  calculateDate(var firstDate,var secondDate){
    List<String>fDate=firstDate.split('-');
    List<String>sDate=secondDate.split('-');
    String month1=getMonthName(int.parse(fDate[1]));
    String date1=fDate[2];
     String month2=getMonthName(int.parse(sDate[1]));
    String date2=sDate[2];
    firstDateOfWeek='${month1.substring(0, 3)} $date1';
    lastDateOfWeek='${month2.substring(0, 3)} $date2';
  }
  
  calculateWeek(){
  final now = DateTime.now();
  final firstJan = DateTime(now.year, 1, 1);
  final weekNumber = totalWeeksInYear(firstJan, now); 
  totalWeek='$weekNumber';
  }
changeScreenToCalender(BuildContext context,int screenNo){
screenNumber=screenNo;
notifyListeners();
}
  changeScreenNumber(BuildContext context) {
    if (screenNumber < 2) {
      screenNumber++;
      notifyListeners();
    } else {
      debugPrint("dispose");
      picker = const PickerDateRange(null, null);
      startdateformat = "";
      enddateformat = "";
      screenNumber = 0;
      days = [];
      dayshours = [];
      timeof = "TIME OFF CATEGORY";
      Navigator.pop(context);
    }
    notifyListeners();
  }

  changeTimeOfCategory(String val, String id) {
    timeof = val;
    policyId = id;
    cardexpandabletile.currentState!.collapse();
    //show details
    notifyListeners();
  }

  changeDateFormat(
      DateRangePickerSelectionChangedArgs dateRangePickerSelectionChangedArgs) {
    picker = dateRangePickerSelectionChangedArgs.value;
    if (picker.startDate != null) {
      DateTime sd = picker.startDate!;
      startdateformat = DateFormat('MMMM d, EEEE,').format(sd);
      strtdate = DateFormat('yyyy-MM-dd,').format(sd);
      debugPrint(DateFormat('yyyy-MM-dd,').format(sd));
    }
    if (picker.endDate != null) {
      DateTime ed = picker.endDate!;
      enddateformat = DateFormat('MMMM d, EEEE,').format(ed);
      endate = DateFormat('yyyy-MM-dd,').format(ed);
      debugPrint(DateFormat('yyyy-MM-dd,').format(ed));
    }
    if (picker.startDate != null && picker.endDate != null) {
      days = [];
      dayshours = [];
      holidayfound = false;
      repeatationFound = false;
      for (var element in AppConstants.timeoffmodel!.holidays!) {
        for (var i = 0;
            i < picker.endDate!.difference(picker.startDate!).inDays;
            i++) {
          if (picker.startDate!
                  .add(Duration(days: i))
                  .toString()
                  .substring(0, 10) ==
              element.toString().substring(0, 10)) {
            holidayfound = true;
            debugPrint("holidayfound");
          }
        }
      }
      if (!holidayfound) {
        for (int i = 0;
            i <= picker.endDate!.difference(picker.startDate!).inDays;
            i++) {
          days.add(picker.startDate!.add(Duration(days: i)));
          //debugPrint(days[i].toString().substring(0, 10));
          //user total hour of user
          if (AppConstants.timeoffmodel!.daysData!.nonWorkingDays!.length
                  .toString() ==
              "2") {
            if (days[i].weekday != DateTime.saturday &&
                days[i].weekday != DateTime.sunday) {
              debugPrint(double.parse(AppConstants
                  .timeoffmodel!.daysData!.scheduleHours
                  .toString()).toString());
              dayshours.add(double.parse(AppConstants
                  .timeoffmodel!.daysData!.scheduleHours
                  .toString()));
            } else {
              dayshours.add(0);
            }
          } else {
            if (days[i].weekday != DateTime.sunday) {
              dayshours.add(double.parse(AppConstants
                  .timeoffmodel!.daysData!.scheduleHours
                  .toString()));
            } else {
              dayshours.add(0);
            }
          }
        }
      }
      //for checking call already exist
      for (var element in AppConstants.timeoffmodel!.requestedDays!) {
        DateTime currentDay =
            element.requestTimeOff!.to!.subtract(const Duration(days: 1));
        while (currentDay.isBefore(element.requestTimeOff!.from!)) {
          currentDay = currentDay.add(const Duration(days: 1));
          for (var i = 0; i < days.length; i++) {
            if (days[i].toString().substring(0, 10) ==
                currentDay.toString().substring(0, 10)) {
              repeatationFound = true;
            }
          }
        }
      }
      // for (var element in AppConstants.timeoffmodel!.requestedDays!) {
      //   DateTime currentDay = element.requestTimeOff!.to!.subtract(Duration(days: 1));
      //   while (currentDay.isBefore(element.requestTimeOff!.from!)) {
      //   currentDay = currentDay.add(Duration(days: 1));
      //   }
      // }

      totalNumberofAmount =
          getDifferenceWithoutWeekends(picker.startDate!, picker.endDate!)
              .toString();
    }
    notifyListeners();
  }

  checkin(bool val) {
    ischeckin = val;
    notifyListeners();
  }

  changeDropDownValue(value) {
    selectedText = value;
    if (selectedText == "Scheduled Time Completed") {
      hidereason = true;
    } else {
      hidereason = false;
    }
    notifyListeners();
  }

  changeAttendanceTypeValue(value) {
    selectedAttendanceType = value;
    notifyListeners();
  }

  hitCheckInApi({
    required BuildContext context,
    required bool isFace,
  }) async {
    try {
      if (await checkinternetconnection()) {
        addtimer = 0;
        timerr!.cancel();
        checkinLoading = true;
        notifyListeners();
        DateTime now = DateTime.now();
        String formattedDate = DateFormat('yyyy-MM-dd').format(now);
        debugPrint(formattedDate);
        // final ImagePicker picker = ImagePicker();
        // XFile? file;
        // file = await picker.pickImage(source: ImageSource.camera);
        // if (file != null && file != "") {
        // var resp = await ImageRecognationService.hitImageRecognation(
        //     path: file.path, context: context);
        //if (resp.toString() == "true") {
        var response = await CheckinApiService.checkin(
          isFace: isFace,
            clockType: AppConstants.clocktype.toString(),
            relatedToDate: AppConstants.clocktype.toString() == "IN"
                ? formattedDate
                : AppConstants.loginmodell!
                        .userAttendanceData["attendance_marking_data"]
                    ["related_to_date"],
            employeeId: AppConstants.loginmodell!.userData!.id.toString(),
            context: context);
        if (response != null) {
          if (response is CheckinCheckoutModel) {
            if (response.success.toString() == "1") {
              checkin(true);
              timerr!.cancel();
               ScaffoldMessenger.of(context).showSnackBar(
           appSnackBar("Attendance Marked Successfully")); 
              
              notifyListeners();
            } else {
                ScaffoldMessenger.of(context).showSnackBar(
           appSnackBar("Attendance Didn't Marked")); 
              
            }
            CheckinCheckoutModel? model;
            model = response;
            AppConstants.checkincheckoutmodel = model;
            SharedPreferences prefs = await SharedPreferences.getInstance();
            await prefs.setString(
                "checkincheckoutmodel", checkinCheckoutModelToJson(model));
            AppConstants.checkincheckoutmodel = checkinCheckoutModelFromJson(
                prefs.getString("checkincheckoutmodel").toString());
            await prefs.setString(
                "button",
                AppConstants.checkincheckoutmodel!
                    .attendanceDetails!.attendanceMarkingData!.button.toString());
            await prefs.setString(
                "clock_type",
                AppConstants.checkincheckoutmodel!
                    .attendanceDetails!.attendanceMarkingData!.clockType.toString());
            AppConstants.button = prefs.getString("button");
            AppConstants.clocktype = prefs.getString("clock_type");
            checkinLoading = false;
            refreshIndicatorKey.currentState?.show();
            attendenceCheck = false;
            notifyListeners();
            // dosort=false;
            // notifyListeners();
          } else {
            checkinLoading = false;
            attendenceCheck = false;
            notifyListeners();
          }
        } else {
          checkinLoading = false;
          notifyListeners();
        }
        // } else {
        //   ScaffoldMessenger.of(context).showSnackBar(
        //       const SnackBar(content: Text("Image is not recognized")));
        // }
        // } else {
        //   debugPrint("no image");
        // }
      } else {
        //Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
           appSnackBar("No Internet Connection")); 
        
        notifyListeners();
      }
    } catch (exception) {
    if (AppConstants.livemode) {
          await Sentry.captureException(exception);
        }
      debugPrint(exception.toString());
      checkinLoading = false;
      notifyListeners();
    }
  }

  hitCheckOutApi({
    required BuildContext context,
    required String reason,
    required String takenbreak,
    required bool isFace,
  }) async {
    try {
      if (await checkinternetconnection()) {
        addtimer = 0;
        timerr!.cancel();
        checkinLoading = true;
        notifyListeners();
        DateTime now = DateTime.now();
        String formattedDate = DateFormat('yyyy-MM-dd').format(now);
        debugPrint(formattedDate);
        // final ImagePicker picker = ImagePicker();
        // XFile? file;
        // file = await picker.pickImage(source: ImageSource.camera);
        // if (file != null && file != "") {
        //   var resp = await ImageRecognationService.hitImageRecognation(
        //       path: file.path, context: context);
        //if (resp.toString() == "true") {
        var response = await CheckoutApiService.checkout(
          isFace: isFace,
            clockType: AppConstants.clocktype.toString(),
            reason: reason,
            takenabreak: takenbreak,
            employeeId: AppConstants.loginmodell!.userData!.id.toString(),
            context: context);
        if (response != null) {
          debugPrint("ashbabja");

          if (response is CheckinCheckoutModel) {
            if (response.success.toString() == "1") {
              checkin(false);
              timerr!.cancel();
            }
            CheckinCheckoutModel? model;
            model = response;
            AppConstants.checkincheckoutmodel = model;
            SharedPreferences prefs = await SharedPreferences.getInstance();
            await prefs.setString(
                "checkincheckoutmodel", checkinCheckoutModelToJson(model));
            AppConstants.checkincheckoutmodel = checkinCheckoutModelFromJson(
                prefs.getString("checkincheckoutmodel").toString());
            await prefs.setString(
                "button",
                AppConstants.checkincheckoutmodel!
                    .attendanceDetails!.attendanceMarkingData!.button.toString());
            await prefs.setString(
                "clock_type",
                AppConstants.checkincheckoutmodel!
                    .attendanceDetails!.attendanceMarkingData!.clockType.toString());
            AppConstants.button = prefs.getString("button");
            AppConstants.clocktype = prefs.getString("clock_type");
            ScaffoldMessenger.of(context).showSnackBar(
           appSnackBar("Attendance Marked Successfully")); 
             
            checkinLoading = false;

            refreshIndicatorKey.currentState?.show();

            attendenceCheck = false;
            notifyListeners();
            // dosort=false;
            // notifyListeners();
          } else {
            attendenceCheck = false;
            checkinLoading = false;
            notifyListeners();
          }
        } else {
          checkinLoading = false;
          notifyListeners();
        }
        // } else {
        //   ScaffoldMessenger.of(context).showSnackBar(
        //       const SnackBar(content: Text("Image is not recognized")));
        // }
        // } else {
        //   debugPrint("no image");
        // }
      } else {
        //Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
           appSnackBar("No Internet Connection"));
        notifyListeners();
      }
    } catch (exception) {
    if (AppConstants.livemode) {
          await Sentry.captureException(exception);
        }
      checkinLoading = true;
      notifyListeners();
    }
  }

  Future<void> hitRefresh(
      {required BuildContext context, required String employeeId}) async {
    try {
      if (await checkinternetconnection()) {
        addtimer = 0;
        timerr!.cancel();
        isLoading = true;
        notifyListeners();
        if (stream!=null) {
          stream!.cancel();
          stream=null;
        }
        var res = await HitRefreshApiService.refresh(
            employeeId: employeeId, context: context);
        addtimer = 0;
        timerr!.cancel();
        if (res != null) {
          if (res is StagingLoginModel) {
            StagingLoginModel? demologinmodel;
            demologinmodel = res;
            AppConstants.loginmodell = demologinmodel;
            SharedPreferences prefs = await SharedPreferences.getInstance();
            await prefs.setString(
                "loginmodel", stagingLoginModelToJson(demologinmodel));
            debugPrint("//\\");
            AppConstants.loginmodell = stagingLoginModelFromJson(
                prefs.getString("loginmodel").toString());
            await prefs.setString(
                "button",
                AppConstants.loginmodell!
                    .userAttendanceData["attendance_marking_data"]["button"]
                    .toString());
            await prefs.setString(
                "clock_type",
                AppConstants.loginmodell!
                    .userAttendanceData["attendance_marking_data"]["clock_type"]
                    .toString());
            AppConstants.button = prefs.getString("button");
            AppConstants.clocktype = prefs.getString("clock_type");
            //
            if (AppConstants.loginmodell!
                  .userAttendanceData["mobile_attendance_permission"] ==
              true &&
          AppConstants.loginmodell!.userAttendanceData["geo_fencing"] == true) {
          //change destination lat,lng
          changeBasiclatlongandradius(
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
        if(stream==null){
          stream=Geolocator.getPositionStream().listen((position) {
          checkGeofenceStatus(position);
        });
        if (!streamrunning) {
         streamController.stream.listen((transition) {
          changelocation(transition);
        });
        }
        }
      } else {
        changeGeoFensingStatus("Entered");
      }
            //
            debugPrint("tokentoken${demologinmodel.accessToken}");
            debugPrint("tokentoken refresh");
            if (AppConstants.button == "check_out" &&
                AppConstants.clocktype == "OUT") {
              checkin(true);
            } else {
              checkin(false);
              timerr!.cancel();
            }
            schedulestarttime = AppConstants.loginmodell!.userWorkSchedule!
                .workSchedule["schedule_start_time"];
            scheduleendtime = AppConstants.loginmodell!.userWorkSchedule!
                .workSchedule["schedule_end_time"];

            //start time
            if (AppConstants.loginmodell!
                        .userAttendanceData["employeeAllAttendanceToday"]
                        .toString() ==
                    "null" ||
                AppConstants.loginmodell!
                        .userAttendanceData["employeeAllAttendanceToday"]
                        .toString() ==
                    "[]") {
              schedulestart = "-";
            } else {
              List list = AppConstants.loginmodell!
                  .userAttendanceData["employeeCurrentMonthAttendance"]
                  .toList();
              debugPrint("length${AppConstants
                      .loginmodell!
                      .userAttendanceData["employeeAllAttendanceToday"][
                          AppConstants
                                  .loginmodell!
                                  .userAttendanceData[
                                      "employeeAllAttendanceToday"]
                                  .length -
                              1]}");
              list.forEach((element) {
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
                  schedulestart = element["time_in"].toString();
                }
              });
            }
            //start time and end working time
            // AppConstants.startTime= AppConstants.loginmodell!.userAttendanceData["employeeCurrentMonthAttendance"].indexWhere((item)
            //           => AppConstants.loginmodell!.userAttendanceData["employeeAllAttendanceToday"][AppConstants.loginmodell!.userAttendanceData["employeeAllAttendanceToday"].length-1]["id"]== item["id"].toString()
            //           );
            //           debugPrint(AppConstants.startTime.toString());
            //
            if (demologinmodel.accessToken.toString() != "null" &&
                demologinmodel.accessToken.toString() != "") {
              isLoading = false;
              addtimer = 0;
              timerr!.cancel();
              notifyListeners();
              final prefs = await SharedPreferences.getInstance();
              prefs.setString(
                  Keys.token, demologinmodel.accessToken.toString());
              debugPrint("token---->>>>>${prefs.get(Keys.token)}");
            } else {
              isLoading = false;
              addtimer = 0;
              timerr!.cancel();
              notifyListeners();
            }
          } else {
            isLoading = false;
            addtimer = 0;
            timerr!.cancel();
            notifyListeners();
          }
        }
      } else {
        Navigator.pop(context);

       ScaffoldMessenger.of(context).showSnackBar(
           appSnackBar("No Internet Connection"));
        notifyListeners();
      }
    } catch (exception) {
    if (AppConstants.livemode) {
          await Sentry.captureException(exception);
        }
      debugPrint(exception.toString());
    }
  }

  getAttendance(
      {required String employeeid, required BuildContext context}) async {
    try {
      if (await checkinternetconnection()) {
        attendanceloading = true;
        notifyListeners();
        var response = await EmployeeAttandanceService.getAttendance(
            employeeId: employeeid, context: context);
        if (response != null) {
          // debugPrint("ssc" + response["2023-05-09"]["employee_name"]);
          AppConstants.attendance = response;
          attendanceloading = false;
          notifyListeners();
        } else {
          Navigator.maybePop(context);
          //attendanceloading = false;
          notifyListeners();
        }
      } else {
        Navigator.pop(context);
       ScaffoldMessenger.of(context).showSnackBar(
           appSnackBar("No Internet Connection"));
        notifyListeners();
      }
    } catch (exception) {
    if (AppConstants.livemode) {
          await Sentry.captureException(exception);
        }
      debugPrint(exception.toString());

      attendanceloading = false;
      notifyListeners();
    }
  }

  changetimer() {
    addtimer++;
    notifyListeners();
  }

  getPaySlips(
      {required String employeeid,
      required String PayslipYear,
       required BuildContext context}) async {
    try {
      if (await checkinternetconnection()) {
        payslipsloading = true;
        notifyListeners();
        var response = await PaySlipsService.getPaySlips(
            year: PayslipYear.toString(),
            employeeId: employeeid, context: context);
        if (response != null && response is PaySlipsModel) {
          // debugPrint("ssc" + response["2023-05-09"]["employee_name"]);
          AppConstants.paySlipsModel = response;
          payslipsloading = false;
          notifyListeners();
        } else {
          AppConstants.paySlipsModel = null;
          //Navigator.maybePop(context);
          payslipsloading = false;
          notifyListeners();
        }
      } else {
        //Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
           appSnackBar("No Internet Connection"));
        notifyListeners();
      }
    } catch (exception) {
    if (AppConstants.livemode) {
          await Sentry.captureException(exception);
        }
      debugPrint(exception.toString());
      payslipsloading = false;
      notifyListeners();
    }
  }

  hitStoreTimeOff(BuildContext context) async {
loading=true;
notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    for (var i = 0; i < days.length; i++) {
      dailyAmount[days[i].toString()] = dayshours[i].toString();
    }
    dynamic c = (picker.endDate!.difference(picker.startDate!).inHours / 3) + 8;
    debugPrint("CCCC$c");
    debugPrint("objectaa");
    debugPrint(dailyAmount.toString());
    var responce = await StoreTimeOffRequestService.storeTimeOff(
        context: context,
        userid: AppConstants.loginmodell!.userData!.id.toString(),
        permissionCheck: "false",
        to: strtdate,
        from: endate,
        timeOffPolicyId: policyId,
        totalAmount: totalNumberofAmount,
        // (picker.endDate!.difference(picker.startDate!).inHours / 3 + 8)
        //     .toString(),
        note: note.text,
        dailyAmount: dailyAmount);

    if (responce != null) {
      changeScreenNumber(context);
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return CustomDialogBox(
              title: responce.toString(),
              //descriptions: "Hii all this is a custom dialog in flutter and  you will be use in your flutter applications",
              text: "OK",
              img: Image.asset(ImagePath.dialogBoxImage),
            );
          });
      var timeOffResp = await GetTimeOffService.getTimeOff(
          context: context,
          userid: AppConstants.loginmodell!.userData!.id.toString());
      await prefs.setString(
          "gettimeoffpolicies", getTimeOffModelToJson(timeOffResp));
      AppConstants.timeoffmodel = getTimeOffModelFromJson(
          prefs.getString("gettimeoffpolicies").toString());
          loading=false;
    }
  }

  attendCheck() {
    debugPrint("axbajxbjaba");
    attendenceCheck = true;
    notifyListeners();
  }
}

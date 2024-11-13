import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:gleam_hr/Components/commonSnakbar.dart';
import 'package:gleam_hr/Models/DashBoardModels/HomeModels/GetWorkFromHomeModel.dart';
import 'package:gleam_hr/Models/DashBoardModels/HomeModels/WorkFromHomeRequestModel.dart' as wfhmodel;
import 'package:gleam_hr/Screens/DashBoard/Home/HomeWidgets/CustomDialogBox.dart';
import 'package:gleam_hr/Services/DashBoardServices/HomeServices/WfhServices/GetWorkFromHome_Service.dart';
import 'package:gleam_hr/Services/DashBoardServices/HomeServices/WfhServices/StoreWorkFromHome_Service.dart';
import 'package:gleam_hr/Utils/AppConstants.dart';
import 'package:gleam_hr/Utils/AppPaths.dart';
import 'package:gleam_hr/Utils/Colors.dart';
import 'package:gleam_hr/Utils/Methods.dart';
import 'package:intl/intl.dart';
import 'package:sentry_flutter/sentry_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

class WorkFromHomeProvider extends ChangeNotifier {
  bool decisionLoading = false, wFHRequestLoading=true;bool loading=false;
  List<wfhmodel.Datum> searchlist = [];
  String dropdownSelectedText = "1",filteredValue="All";
  String dropdownAllSelectedText = "1",filteredAllValue="All";
  List<String> dropdownlist = [];
  List<String> items = ["All", "Approved", "Rejected", "Pending"];
  List<String> allitems = ["All", "Approved", "Rejected", "Pending"];
  TextEditingController searchController = TextEditingController();
  TextEditingController searchAllController = TextEditingController();

  PickerDateRange picker = const PickerDateRange(null, null);
  String startdateformat = "", enddateformat = "";
  bool alreadyExist = false;

  GlobalKey<FormState> noteFormKey = GlobalKey();
  TextEditingController note = TextEditingController();
  List<DateTime> pending = [], approved = [], rejected = [];
callinggetWFH(BuildContext context)async {
//calling get WFH
  if (await checkinternetconnection()) {
     final prefs = await SharedPreferences.getInstance();
               if (AppConstants.modulesmodell!.data![8].status.toString() ==
                    "1") {
                  var wfhResp = await WorkFromHomeService.getMyWorkFromHomeRequestspolicy(
                      context: context,
                      userid:
                          AppConstants.loginmodell!.userData!.id.toString());
                  await prefs.setString(
                      "getwfhpolicies", getWorkFromHomeModelToJson(wfhResp));
                  AppConstants.wfhmodel = getWorkFromHomeModelFromJson(
                      prefs.getString("getwfhpolicies").toString());
                  debugPrint(AppConstants.wfhmodel!.data!.length.toString());
                }}else{
          Navigator.of(context).pop();
          ScaffoldMessenger.of(context).showSnackBar(
           appSnackBar("No Internet Connection"));
          
                }
}
  changeDateFormat(
      DateRangePickerSelectionChangedArgs dateRangePickerSelectionChangedArgs) {
    picker = dateRangePickerSelectionChangedArgs.value;
    if (picker.startDate != null) {
      DateTime sd = picker.startDate!;
      startdateformat = DateFormat('MMMM d, EEEE,').format(sd);
      debugPrint(startdateformat);
    }
    if (picker.endDate != null) {
      DateTime ed = picker.endDate!;
      enddateformat = DateFormat('MMMM d, EEEE,').format(ed);
      debugPrint(enddateformat);
    }
    if (picker.startDate != null && picker.endDate != null) {
      DateTime sd = picker.startDate!;
      DateTime ed = picker.endDate!;
      enddateformat = DateFormat('MMMM d, EEEE,').format(ed);
      startdateformat = DateFormat('MMMM d, EEEE,').format(sd);
      debugPrint(enddateformat);
      debugPrint(startdateformat);
    }
    notifyListeners();
  }

  clear() {
    picker = const PickerDateRange(null, null);
    startdateformat = "";
    enddateformat = "";
    note.clear();
    notifyListeners();
  }

  checkExistance() {
    alreadyExist = false;
    if (picker.endDate != null) {
      for (var element in AppConstants.wfhmodel!.daysData!) {
        for (var i = 0;
            i < picker.endDate!.difference(picker.startDate!).inDays;
            i++) {
          if (picker.startDate!
                  .add(Duration(days: i))
                  .toString()
                  .substring(0, 10) ==
              element.toString().substring(0, 10)) {
            alreadyExist = true;
          }
        }
      }
    } else if(picker.startDate != null){
      for (var element in AppConstants.wfhmodel!.daysData!) {
        for (var i = 0;
            i < picker.startDate!.day;
            i++) {
          if (picker.startDate!
                  .add(Duration(days: i))
                  .toString()
                  .substring(0, 10) ==
              element.toString().substring(0, 10)) {
            alreadyExist = true;
          }
        }
      }
    }
     {}
  }

  changeStatusOfdates() {
    if (AppConstants.wfhmodel!=null) {
    AppConstants.wfhmodel!.data!.forEach((element) {
      if (element.status.toString() == "approved") {
        approved.add(element.from!);
        approved.add(element.to!);
      } else if (element.status.toString() == "pending") {
        pending.add(element.from!);
        pending.add(element.to!);
      } else if (element.status.toString() == "rejected") {
        rejected.add(element.from!);
        rejected.add(element.to!);
      }
    });}
    notifyListeners();
  }

  callWorkFromHome(BuildContext context) async {
    try {
      if (await checkinternetconnection()) { 
         loading=true;
         notifyListeners();
        final prefs = await SharedPreferences.getInstance();
        var res;
        if (picker.startDate != null && picker.endDate != null) {
          
          res = await StoreWorkFromHomeService.storeWfh(
              context: context,
              userid: AppConstants.loginmodell!.userData!.id.toString(),
              to: picker.endDate.toString().substring(0, 10),
              from: picker.startDate.toString().substring(0, 10),
              reason: note.text.toString());
          clear();
        } else if (picker.startDate != null) {
          res = await StoreWorkFromHomeService.storeWfh(
              context: context,
              userid: AppConstants.loginmodell!.userData!.id.toString(),
              to: picker.startDate.toString().substring(0, 10),
              from: picker.startDate.toString().substring(0, 10),
              reason: note.text.toString());
          clear();
        }
        Navigator.of(context).pop();
        if (res != null) { 
          showDialog(
              context: context,
              builder: (BuildContext context) {
                return CustomDialogBox(
                  title: res.toString(),
                  //descriptions: "Hii all this is a custom dialog in flutter and  you will be use in your flutter applications",
                  text: "OK",
                  img: Image.asset(ImagePath.dialogBoxImage),
                );
              });
          var wfhResp = await WorkFromHomeService.getMyWorkFromHomeRequestspolicy(
              context: context,
              userid: AppConstants.loginmodell!.userData!.id.toString());
          await prefs.setString(
              "getwfhpolicies", getWorkFromHomeModelToJson(wfhResp));
          AppConstants.wfhmodel = getWorkFromHomeModelFromJson(
              prefs.getString("getwfhpolicies").toString());
          changeStatusOfdates();
          loading=false;
          notifyListeners();
        }
      } else {
        Navigator.of(context).pop();
        ScaffoldMessenger.of(context).showSnackBar(
           appSnackBar("No Internet Connection"));
        
        Future.delayed(const Duration(seconds: 7), () {
          // After 3 seconds, navigate to the main screen
          
          notifyListeners();
        });
        notifyListeners();
      }
    } catch (exception) {
    if (AppConstants.livemode) {
          await Sentry.captureException(exception);
        }
      debugPrint(exception.toString());
    }
  }
  
  // view my requests
  changedropdown(String val,BuildContext context) {
    dropdownSelectedText = val;
    getWFHRequests(context: context);
    notifyListeners();
  }

  changeFilterValue(String val,BuildContext context) {
    filteredValue=val;
    dropdownSelectedText="1";
    getWFHRequests(context: context);
    notifyListeners();
  }

  getWFHRequests({required BuildContext context}) async {
    try {
      wFHRequestLoading = true;
      notifyListeners();
      if (await checkinternetconnection()) {
        var response =
            await WorkFromHomeService.getWorkFromHome(
                userId: AppConstants.loginmodell!.userData!.id.toString(),
                status: filteredValue,
                page: dropdownSelectedText,
                context: context);
        if (response is wfhmodel.WorkFromHomeRequestModel) {
          AppConstants.wfhRequestsmodel = response;
          dropdownlist=[];
          if (AppConstants.wfhRequestsmodel!.totalPages! >= 1) {
          dropdownlist = List.generate(AppConstants.wfhRequestsmodel!.totalPages!, (index) => (index + 1).toString());
          }
          wFHRequestLoading = false;
          notifyListeners();
        } else {
          Navigator.maybePop(context);
          wFHRequestLoading = false;
          notifyListeners();
        }
      } else {
        wFHRequestLoading = false;
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
            appSnackBar("No Internet Connection"));
        notifyListeners();
      }
    } catch (exception) {
    if (AppConstants.livemode) {
          await Sentry.captureException(exception);
        }
      wFHRequestLoading = false;
      debugPrint(exception.toString());
      notifyListeners();
    }
  }

  // view all requests
  changealldropdown(String val,BuildContext context) {
    dropdownAllSelectedText = val;
    getAllWFHRequests(context: context);
    notifyListeners();
  }

  changeallFilterValue(String val,BuildContext context) {
    filteredAllValue=val;
    dropdownAllSelectedText="1";
    notifyListeners();
    getAllWFHRequests(context: context);
    notifyListeners();
  }

  getAllWFHRequests({required BuildContext context}) async {
    try {
      wFHRequestLoading = true;
      notifyListeners();
      if (await checkinternetconnection()) {
        var response = await WorkFromHomeService.getAllWorkFromHome(status: filteredAllValue, page: dropdownAllSelectedText, context: context);
        if (response is wfhmodel.WorkFromHomeRequestModel) {
          AppConstants.wfhRequestsmodel = response;
          dropdownlist=[];
          if (AppConstants.wfhRequestsmodel!.totalPages! > 1) {
          dropdownlist = List.generate(AppConstants.wfhRequestsmodel!.totalPages!, (index) => (index + 1).toString());
          }
          wFHRequestLoading = false;
          notifyListeners();
        } else {
          Navigator.maybePop(context);
          wFHRequestLoading = false;
          notifyListeners();
        }
      } else {
        wFHRequestLoading = false;
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
            appSnackBar("No Internet Connection"));
        notifyListeners();
      }
    } catch (exception) {
    if (AppConstants.livemode) {
          await Sentry.captureException(exception);
        }
      wFHRequestLoading = false;
      debugPrint(exception.toString());
      notifyListeners();
    }
  }

approveDenyWfhRequest({required BuildContext context,required String decision,required String requestId,required String employeeId,required String approverId}) async {
    try {
      if (await checkinternetconnection()) {
        decisionLoading=true;
        notifyListeners();
        var response =
            await WorkFromHomeService.approveDenyWfhRequests(context: context, id: requestId, employeeId: employeeId, approverId: approverId, decision: decision);
        if (response == true) {
          decisionLoading=false;
          Navigator.of(context).pop();
          Fluttertoast.showToast(
            msg: "Work from home request decision is updated successfully",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: AppColors.primaryColor,
            textColor: Colors.white,
            fontSize: 16.0);
          getAllWFHRequests(context: context);
        } else {
          decisionLoading=false;
          Navigator.of(context).pop();
          Fluttertoast.showToast(
            msg: "Work from home request decision failed to update",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: AppColors.primaryColor,
            textColor: Colors.white,
            fontSize: 16.0);
          notifyListeners();
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
            appSnackBar("No Internet Connection"));
        notifyListeners();
      }
    } catch (exception) {
    if (AppConstants.livemode) {
          await Sentry.captureException(exception);
        }
      decisionLoading=false;
      notifyListeners();
    }
  }

hitupdate() {
    notifyListeners();
  }
}

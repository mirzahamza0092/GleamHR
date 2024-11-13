import 'package:flutter/material.dart';
import 'package:gleam_hr/Components/commonSnakbar.dart';
import 'package:gleam_hr/Models/DashBoardModels/HomeModels/AllTimeOffRequestModel.dart';
import 'package:gleam_hr/Models/DashBoardModels/HomeModels/GetTimeOffModel.dart';
import 'package:gleam_hr/Services/DashBoardServices/HomeServices/TimeOffServices/GetAllTimeOffRequest_Service.dart';
import 'package:gleam_hr/Services/DashBoardServices/HomeServices/TimeOffServices/GetTimeOff_Service.dart';
import 'package:gleam_hr/Utils/AppConstants.dart';
import 'package:gleam_hr/Utils/Methods.dart';
import 'package:sentry_flutter/sentry_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TimeOffProvider extends ChangeNotifier {
  List<Datum> searchlist = [];
  String dropdownSelectedText = "1",filteredValue="All";
  List<String> dropdownlist = [];
  List<String> items = ["All", "Approved", "Rejected", "Pending"];
  TextEditingController searchController = TextEditingController();
  bool timeOffRequestLoading=true;

  changedropdown(String val,BuildContext context) {
    dropdownSelectedText = val;
    getAllTimeOffRequests(context: context);
    notifyListeners();
  }

  changeFilterValue(String val,BuildContext context) {
    filteredValue=val;
    dropdownSelectedText="1";
    getAllTimeOffRequests(context: context);
    notifyListeners();
  }

  hitupdate() {
    notifyListeners();
  }
  callinggettimeoff(BuildContext context)async{
  //calling get timeoff
   if (await checkinternetconnection()) {
       final prefs = await SharedPreferences.getInstance();
                if (AppConstants.modulesmodell!.data![4].status.toString() ==
                    "1") {
                  var timeOffResp = await GetTimeOffService.getTimeOff(
                      context: context,
                      userid:
                          AppConstants.loginmodell!.userData!.id.toString());
                  await prefs.setString(
                      "gettimeoffpolicies", getTimeOffModelToJson(timeOffResp));
                  AppConstants.timeoffmodel = getTimeOffModelFromJson(
                      prefs.getString("gettimeoffpolicies").toString());
                  debugPrint(AppConstants.timeoffmodel!.policies!.length.toString());
                }}else{
                            Navigator.of(context).pop();
                   ScaffoldMessenger.of(context).showSnackBar(
                  appSnackBar("No Internet Connection"));
                 
                }
}
    getAllTimeOffRequests({required BuildContext context}) async {
    try {
      timeOffRequestLoading = true;
      notifyListeners();
      if (await checkinternetconnection()) {
        var response =
            await GetAllTimeOffRequestService.getAllTimeOffRequests(
                userId: AppConstants.loginmodell!.userData!.id.toString(),
                status: filteredValue,
                page: dropdownSelectedText,
                context: context);
        if (response is AllTimeOffRequestsModel) {
          AppConstants.allTimeOffRequestsmodel = response;
          dropdownlist=[];
          if (AppConstants.allTimeOffRequestsmodel!.totalPages! >= 1) {
          dropdownlist = List.generate(AppConstants.allTimeOffRequestsmodel!.totalPages!, (index) => (index + 1).toString());
          }
          timeOffRequestLoading = false;
          notifyListeners();
        } else {
          Navigator.maybePop(context);
          timeOffRequestLoading = false;
          notifyListeners();
        }
      } else {
        timeOffRequestLoading = false;
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
            appSnackBar("No Internet Connection"));
        notifyListeners();
      }
    } catch (exception) {
    if (AppConstants.livemode) {
          await Sentry.captureException(exception);
        }
      timeOffRequestLoading = false;
      debugPrint(exception.toString());
      notifyListeners();
    }
  }
}
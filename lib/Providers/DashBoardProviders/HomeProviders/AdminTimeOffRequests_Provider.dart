import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:gleam_hr/Components/commonSnakbar.dart';
import 'package:gleam_hr/Models/DashBoardModels/HomeModels/AllTimeOffRequestModel.dart';
import 'package:gleam_hr/Services/DashBoardServices/HomeServices/TimeOffServices/AdminTimeOffRequestService.dart';
import 'package:gleam_hr/Utils/AppConstants.dart';
import 'package:gleam_hr/Utils/Colors.dart';
import 'package:gleam_hr/Utils/Methods.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

class AdminTimeOffRequestsProvider extends ChangeNotifier {
  bool allTimeOffRequestLoading = true,decisionLoading=false;
  TextEditingController searchController = TextEditingController();
  String dropdownSelectedText = "1",filteredValue="All";
  List<String> dropdownlist = ["All", "1",];
  List<String> items = ["All", "Approved", "Rejected", "Pending"];
  List<Datum> searchlist = [];
  
  changedropdown(String val,BuildContext context) {
    dropdownSelectedText = val;
    getAdminTimeOffRequests(context: context);
    notifyListeners();
  }
  changeFilterValue(String val,BuildContext context) {
    filteredValue=val;
    dropdownSelectedText="1";
    getAdminTimeOffRequests(context: context);
    notifyListeners();
  }

  hitupdate() {
    notifyListeners();
  }

  getAdminTimeOffRequests({required BuildContext context,}) async {
    try {
      allTimeOffRequestLoading = true;
      notifyListeners();
      if (await checkinternetconnection()) {
        var response =
            await AdminTimeOffRequestService.getAllTimeOffRequests(context: context, status: filteredValue,page: dropdownSelectedText);
        if (response is AllTimeOffRequestsModel) {
          AppConstants.allTimeOffRequestsmodel = response;
          if (AppConstants.allTimeOffRequestsmodel!.totalPages! >= 1) {
          dropdownlist=[];
          dropdownlist = List.generate(AppConstants.allTimeOffRequestsmodel!.totalPages!, (index) => (index + 1).toString());
          dropdownSelectedText=AppConstants.allTimeOffRequestsmodel!.currentPage.toString();
          }
          allTimeOffRequestLoading = false;
          notifyListeners();
        } else {
          allTimeOffRequestLoading = false;
          notifyListeners();
        }
      } else {
        allTimeOffRequestLoading = false;
        ScaffoldMessenger.of(context).showSnackBar(
            appSnackBar("No Internet Connection"));
        notifyListeners();
      }
    } catch (exception) {
    if (AppConstants.livemode) {
          await Sentry.captureException(exception);
        }
      allTimeOffRequestLoading = false;
      debugPrint(exception.toString());
      notifyListeners();
    }
  }

  approveDenyAdminTimeOffRequests({required BuildContext context,required String status,required String TimeOffId,required String employeeId}) async {
    try {
      if (await checkinternetconnection()) {
        decisionLoading=true;
        notifyListeners();
        var response =
            await AdminTimeOffRequestService.approveDenyAdminTimeOffRequests(context: context, TimeOffId: TimeOffId, employeeId: employeeId, status: status);
        if (response == true) {
          decisionLoading=false;
          Navigator.of(context).pop();
          Fluttertoast.showToast(
            msg: "Time Off request status is updated successfully",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: AppColors.primaryColor,
            textColor: Colors.white,
            fontSize: 16.0);
          getAdminTimeOffRequests(context: context);
          searchController.clear();
        } else {
          decisionLoading=false;
          Navigator.of(context).pop();
          Fluttertoast.showToast(
            msg: "TimeOff request decision failed to update",
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
}
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:gleam_hr/Components/commonSnakbar.dart';
import 'package:gleam_hr/Services/DashBoardServices/HomeServices/TimeTrackingServices/AdminCorrectionRequestService.dart';
import 'package:gleam_hr/Utils/AppConstants.dart';
import 'package:gleam_hr/Utils/Colors.dart';
import 'package:gleam_hr/Utils/Methods.dart';
import 'package:intl/intl.dart';
import 'package:sentry_flutter/sentry_flutter.dart';
import 'package:gleam_hr/Models/DashBoardModels/HomeModels/AllCorrectionRequestModel.dart';

class AdminCorrectionRequestsProvider extends ChangeNotifier {
  bool allCorrectionRequestLoading = true,decisionLoading=false;
  TextEditingController searchController = TextEditingController();
  String dropdownSelectedText = "1",filteredValue="All";
  List<String> dropdownlist = ["All", "1",];
  List<String> items = ["All", "Approved", "Rejected", "Pending"];
  List<Datum> searchlist = [];
  
  changedropdown(String val,BuildContext context) {
    dropdownSelectedText = val;
    getAdminCorrectionRequests(context: context);
    notifyListeners();
  }
  changeFilterValue(String val,BuildContext context) {
    filteredValue=val;
    dropdownSelectedText="1";
    getAdminCorrectionRequests(context: context);
    notifyListeners();
  }

  hitupdate() {
    notifyListeners();
  }
DateTime? parseApiDate(String dateString) { 
  try {
    return DateTime.parse(dateString);
  } catch (e) { 
  } 
  List<String> formats = ['dd-MM-yyyy', 'yyyy-MM-dd'];
  for (var formatString in formats) {
    try {
      final format = DateFormat(formatString);
      return format.parse(dateString);
    } catch (e) {
    }
  }  print('Failed to parse date string: $dateString');
  return null;
}
  getAdminCorrectionRequests({required BuildContext context,}) async {
    try {
      allCorrectionRequestLoading = true;
      notifyListeners();
      if (await checkinternetconnection()) {
        var response =
            await AdminCorrectionRequestService.getAllCorrectionRequests(context: context, status: filteredValue,page: dropdownSelectedText);
        if (response is AllCorrectionRequestsModel) {
          AppConstants.adminCorrectionRequestsmodel = response;
          if (AppConstants.adminCorrectionRequestsmodel!.totalPages! >= 1) {
          dropdownlist=[];
          dropdownlist = List.generate(AppConstants.adminCorrectionRequestsmodel!.totalPages!, (index) => (index + 1).toString());
          dropdownSelectedText=AppConstants.adminCorrectionRequestsmodel!.currentPage.toString();
          }
          allCorrectionRequestLoading = false;
          notifyListeners();
        } else {
          allCorrectionRequestLoading = false;
          notifyListeners();
        }
      } else {
        allCorrectionRequestLoading = false;
        ScaffoldMessenger.of(context).showSnackBar(
            appSnackBar("No Internet Connection"));
        notifyListeners();
      }
    } catch (exception) {
    if (AppConstants.livemode) {
          await Sentry.captureException(exception);
        }
      allCorrectionRequestLoading = false;
      debugPrint(exception.toString());
      notifyListeners();
    }
  }

  approveDenyAdminCorrectionRequests({required BuildContext context,required String decision,required String correctionId,required String employeeId,required String date}) async {
    try {
      if (await checkinternetconnection()) {
        decisionLoading=true;
        notifyListeners();
        var response =
            await AdminCorrectionRequestService.approveDenyAdminCorrectionRequests(context: context, correctionId: correctionId, employeeId: employeeId, date: date, decision: decision);
        if (response == true) {
          decisionLoading=false;
          Navigator.of(context).pop();
          Fluttertoast.showToast(
            msg: "Attendance correction request decision is updated successfully",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: AppColors.primaryColor,
            textColor: Colors.white,
            fontSize: 16.0);
          getAdminCorrectionRequests(context: context);
        } else {
          decisionLoading=false;
          Navigator.of(context).pop();
          Fluttertoast.showToast(
            msg: "Attendance correction request decision failed to update",
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
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:gleam_hr/Components/commonSnakbar.dart';
import 'package:gleam_hr/Models/DashBoardModels/AllExpenseRequestModel.dart';
import 'package:gleam_hr/Services/DashBoardServices/HomeServices/ExpenseServices/AdminExpenseRequestService.dart';
import 'package:gleam_hr/Utils/AppConstants.dart';
import 'package:gleam_hr/Utils/Colors.dart';
import 'package:gleam_hr/Utils/Methods.dart';
import 'package:intl/intl.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

class AdminExpenseRequestsProvider extends ChangeNotifier {
  bool allExpenseRequestLoading = true,decisionLoading=false;
  TextEditingController searchController = TextEditingController();
  String dropdownSelectedText = "1",filteredValue="All";
  List<String> dropdownlist = ["All", "1",];
  List<String> items = ["All", "Approved", "Rejected", "Pending"];
  List<Datum> searchlist = [];
  
  changedropdown(String val,BuildContext context) {
    dropdownSelectedText = val;
    getAdminExpenseRequests(context: context);
    notifyListeners();
  }
  changeFilterValue(String val,BuildContext context) {
    filteredValue=val;
    dropdownSelectedText="1";
    getAdminExpenseRequests(context: context);
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
  getAdminExpenseRequests({required BuildContext context,}) async {
    try {
      allExpenseRequestLoading = true;
      notifyListeners();
      if (await checkinternetconnection()) {
        var response =
            await AdminExpenseRequestService.getAllExpenseRequests(context: context, status: filteredValue,page: dropdownSelectedText);
        if (response is AllExpenseRequestsModel) {
          AppConstants.allExpenseRequestsmodel = response;
          if (AppConstants.allExpenseRequestsmodel!.totalPages! >= 1) {
          dropdownlist=[];
          dropdownlist = List.generate(AppConstants.allExpenseRequestsmodel!.totalPages!, (index) => (index + 1).toString());
          dropdownSelectedText=AppConstants.allExpenseRequestsmodel!.currentPage.toString();
          }
          allExpenseRequestLoading = false;
          notifyListeners();
        } else {
          allExpenseRequestLoading = false;
          notifyListeners();
        }
      } else {
        allExpenseRequestLoading = false;
        ScaffoldMessenger.of(context).showSnackBar(
            appSnackBar("No Internet Connection"));
        notifyListeners();
      }
    } catch (exception) {
    if (AppConstants.livemode) {
          await Sentry.captureException(exception);
        }
      allExpenseRequestLoading = false;
      debugPrint(exception.toString());
      notifyListeners();
    }
  }

  approveDenyAdminExpenseRequests({required BuildContext context,required String status,required String expenseId,required String employeeId,required String expense_type_id,required String decision_by}) async {
    try {
      if (await checkinternetconnection()) {
        decisionLoading=true;
        notifyListeners();
        var response =
            await AdminExpenseRequestService.approveDenyAdminExpenseRequests(context: context, expenseId: expenseId, employeeId: employeeId, status: status,expense_type_id: expense_type_id,decision_by: decision_by);
        if (response == true) {
          decisionLoading=false;
          Navigator.of(context).pop();
          Fluttertoast.showToast(
            msg: "Expense request status is updated successfully",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: AppColors.primaryColor,
            textColor: Colors.white,
            fontSize: 16.0);
          getAdminExpenseRequests(context: context);
          searchController.clear();
        } else {
          decisionLoading=false;
          Navigator.of(context).pop();
          Fluttertoast.showToast(
            msg: "Expense request decision failed to update",
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
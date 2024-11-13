import 'package:flutter/material.dart';
import 'package:gleam_hr/Components/commonSnakbar.dart';
import 'package:gleam_hr/Models/DashBoardModels/PeopleModels/AllEmployeeDetailsModel.dart';
import 'package:gleam_hr/Models/DashBoardModels/AppbarModels/AllEmployeeEnrollStatusModel.dart';
import 'package:gleam_hr/Services/DashBoardServices/HomeServices/TimeTrackingServices/FaceRecognition_Service.dart';
import 'package:gleam_hr/Services/DashBoardServices/PeopleServices/GetAllEmployees_Service.dart';
import 'package:gleam_hr/Utils/AppConstants.dart';
import 'package:gleam_hr/Utils/Methods.dart';
import 'package:sentry_flutter/sentry_flutter.dart';
import '../../../Models/DashBoardModels/MoreModels/EmployeeShift_Model.dart';
import '../../../Services/DashBoardServices/MoreServices/GetEmployeeShift_Service.dart';

class EmployeeShiftProvider extends ChangeNotifier{
  TextEditingController search = TextEditingController();
  bool isLoading = false;
  dynamic searchlist = [];
  hitupdate() {
    notifyListeners();
  }

  getAllEmployees(BuildContext context) async {
    try {
      if (await checkinternetconnection()) {
        isLoading = true;
        notifyListeners();
        var response =
            await GetAllEmployeesService.getAllEmployees(context: context);
        if (response != null) {
          if (response is AllEmployeesDetailsModel) {
            AppConstants.allEmployeesDetailsModel = response;
            var res=await FaceRecognitionService.allEmployeeStatus(context: context);
            if (res is AllEmployeeEnrollStatusModel) {
              AppConstants.allEmployeeEnrollStatusModel = res;
            }
            isLoading = false;
            notifyListeners();
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
    if (AppConstants.livemode) {
          await Sentry.captureException(exception);
        }
      isLoading = false;
      notifyListeners();
    }
  }

 getEmployeeShift(BuildContext context,String userId) async{
    try {
      if (await checkinternetconnection()) {
        isLoading = true;
        notifyListeners();
        var response =
            await GetEmployeeShiftService.getEmployeeShift(
              context: context,
              userId:  userId);
        if (response != null) {
          if (response is EmployeeShiftModel) {
            // SharedPreferences prefs = await SharedPreferences.getInstance();
            // await prefs.setString(
            //     "allempshiftmodel", EmployeeShiftModelToJson(allEmpModel));
            // AppConstants.employeeShiftModel =
            //     EmployeeShiftModelFromJson(
            //         prefs.getString("allempshiftmodel").toString());
            AppConstants.employeeShiftModel = response;
            isLoading = false;
            notifyListeners();
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
    if (AppConstants.livemode) {
          await Sentry.captureException(exception);
        }
      isLoading = false;
      notifyListeners();
    }
  }
}
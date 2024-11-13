import 'package:flutter/material.dart';
import 'package:gleam_hr/Components/commonSnakbar.dart';
import 'package:gleam_hr/Models/DashBoardModels/PeopleModels/AllEmployeeDetailsModel.dart';
import 'package:gleam_hr/Models/DashBoardModels/MoreModels/AllEmployeeRolesModel.dart';
import 'package:gleam_hr/Services/DashBoardServices/PeopleServices/GetAllEmployees_Service.dart';
import 'package:gleam_hr/Services/DashBoardServices/MoreServices/GetAllRoles_Service.dart';
import 'package:gleam_hr/Utils/AppConstants.dart';
import 'package:gleam_hr/Utils/Methods.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

class ChangeEmployeeRoleProvider extends ChangeNotifier{
  TextEditingController search = TextEditingController();
  bool isLoading = false;
  List<String> roles = [];
  List<Employee> searchlist = [];
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

  getEmployeerole(BuildContext context) async{
    try {
      if (await checkinternetconnection()) {
        isLoading = true;
        notifyListeners();
        var response =
            await GetEmployeeRoleService.getEmployeerole(
              context: context);
        if (response != null) {
          if (response is AllEmployeeRolesModel) {
            AppConstants.allEmployeeRoleModel = response;
            roles = [];
            AppConstants.allEmployeeRoleModel!.roles!.forEach((element) { 
              roles.add(element.name!);});
            roles.add("Not Available");
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

  changeRole({required BuildContext context,required String employeeId,required String roleId})async{
    try {
      if (await checkinternetconnection()) {
        AppConstants.allEmployeeRoleModel!.roles!.forEach((element) { 
          if(element.name==roleId){
            roleId=element.id.toString();
          }
        });
        isLoading = true;
        notifyListeners();
        var response =
            await GetEmployeeRoleService.changeEmployeerole(context: context, roleId: roleId, employeeId: employeeId);
        if (response != null) {
          if (response == true) {
            ScaffoldMessenger.of(context).showSnackBar(
            appSnackBar("Role Changed Successfully"));
            await getAllEmployees(context);
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
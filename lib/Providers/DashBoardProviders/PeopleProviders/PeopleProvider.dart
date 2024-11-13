import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:gleam_hr/Components/commonSnakbar.dart';
import 'package:gleam_hr/Models/DashBoardModels/PeopleModels/AllEmployeeDetailsModel.dart';
import 'package:gleam_hr/Models/DashBoardModels/PeopleModels/SpecificEmployeeModel.dart';
import 'package:gleam_hr/Services/DashBoardServices/PeopleServices/GetAllEmployees_Service.dart';
import 'package:gleam_hr/Utils/AppConstants.dart';
import 'package:gleam_hr/Utils/Colors.dart';
import 'package:gleam_hr/Utils/Methods.dart';
import 'package:sentry_flutter/sentry_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../Services/DashBoardServices/PeopleServices/GetSpecificEmployee_Service.dart';

class PeopleProvider extends ChangeNotifier {
  bool go = false;
  String alp = "0";
  bool isMailCopied=true,isPhoneCopied=true;
  int screenNumber = 1;
  String? filteredValue;
  List<String> items = [
    'All',
    'Software Engineer',
    'Machine Learning Engineer',
    'Business Developer',
    'Graphics Designer',
    'UI/UX Designer',
    'Lead Designer',
    'HR Manager'
  ];

  TextEditingController search = TextEditingController();
  bool isLoading = false;

  List<Employee> searchlist = [];
  bool dosort = false;

  //show//
  String name = "", email = "", phoneNo = "", officeLocation ="" ,currentTime ="";

  hitupdate() {
    notifyListeners();
  }
  
  copyText(BuildContext context,String text,String msg,bool mail,bool mobile){
     if(mail){
        isMailCopied=false;
                notifyListeners();
            Future.delayed(const Duration(seconds: 1), () { 
              isMailCopied = true; 
              notifyListeners(); 
            });
     }else if(mobile){
        isPhoneCopied=false;
        notifyListeners();
            Future.delayed(const Duration(seconds: 1), () { 
              isPhoneCopied = true;
              notifyListeners();
            });
     }
               Fluttertoast.showToast(
                msg: msg,
                toastLength: Toast.LENGTH_SHORT,
                gravity: ToastGravity.BOTTOM,
                timeInSecForIosWeb: 1,
                backgroundColor: AppColors.primaryColor,
                textColor: Colors.white,
                fontSize: 16.0
        );    
        Clipboard.setData(ClipboardData(text:text));
        notifyListeners();
  }
  changedosort(bool dosortnewvalue) {
    dosort = dosortnewvalue;
    notifyListeners();
  }

  getAllEmployees(BuildContext context) async {
    try {
      if (await checkinternetconnection()) {
        isLoading = true;
        notifyListeners();
        var response =
            await GetAllEmployeesService.getAllEmployees(context: context,
              );
        if (response != null) {
          if (response is AllEmployeesDetailsModel) {
            AllEmployeesDetailsModel? allEmpModel;
            allEmpModel = response;
            AppConstants.allEmployeesDetailsModel = allEmpModel;
            SharedPreferences prefs = await SharedPreferences.getInstance();
            await prefs.setString(
                "allempnmodel", allEmployeesDetailsModelToJson(allEmpModel));
            AppConstants.allEmployeesDetailsModel =
                allEmployeesDetailsModelFromJson(
                    prefs.getString("allempnmodel").toString());
            dosort = true;
            isLoading = false;
            notifyListeners();
            // dosort=false;
            // notifyListeners();
          } else {
            isLoading = false;
            notifyListeners();
          }
        } else {
          isLoading = true;
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
      isLoading = true;
      notifyListeners();
    }
  }

  void Filter(String val) {
    debugPrint("valuuuuuu-$val");
    filteredValue = val;
    notifyListeners();
  }

  List<bool> _isChecked = List.generate(8, (index) => false);
  List<bool> get isChecked => _isChecked;

  void setChecked(bool newValue, int index) {
    if (index == 0) {
      _isChecked = List.generate(_isChecked.length, (index) => newValue);
    } else {
      _isChecked[index] = newValue;
    }

    notifyListeners();
  }

  changeScreenNumber(int v, String n, String e, String phno) {
    screenNumber = v;
    name = n;
    email = e;
    phoneNo = phno;
    notifyListeners();
  }

  
  getSpecificEmployee(BuildContext context,String id) async {
    try {
      if (await checkinternetconnection()) {
        isLoading = true;
        notifyListeners();
        var response = await GetSpecificEmployeeService.getSpecificEmployees(context: context, userId: int.parse(id));
        if (response != null) {
          if (response is SpecificEmployeeModel) {
            AppConstants.specifiEmployeescModel = response;
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
      isLoading = true;
      notifyListeners();
    }
  }

  getEmployeeManager(BuildContext context,String id) async {
    try {
      if (await checkinternetconnection()) {
        var response = await GetSpecificEmployeeService.getSpecificEmployees(context: context, userId: int.parse(id));
        if (response != null) {
          if (response is SpecificEmployeeModel) {
            AppConstants.specifiEmployeescModel = response;
          } else {
          }
        } else {
        }
      } else {
         ScaffoldMessenger.of(context).showSnackBar(
           appSnackBar("No Internet Connection"));
      }
    } catch (exception) {
    if (AppConstants.livemode) {
          await Sentry.captureException(exception);
        }
    }
  }
}

import 'package:flutter/material.dart';
import 'package:gleam_hr/Components/commonSnakbar.dart';
import 'package:gleam_hr/Services/DashBoardServices/MoreServices/ChangePasswordSettingService.dart';
import 'package:gleam_hr/Utils/AppConstants.dart';
import 'package:gleam_hr/Utils/Methods.dart';
import 'package:sentry_flutter/sentry_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ChangePasswordProvider extends ChangeNotifier {
  GlobalKey<FormState> changePasswordkey = GlobalKey();
  TextEditingController currentPassword = TextEditingController();
  TextEditingController newPassword = TextEditingController();
  TextEditingController confirmPassword = TextEditingController();

  bool isloading = false;
List<bool> viewPassword=[true,true,true];
changeViewPassword(int index,){
viewPassword[index]=!viewPassword[index];
notifyListeners();
}
  clear() {
    newPassword.clear();
    currentPassword.clear();
    confirmPassword.clear();
  }

  hitChangePassword(BuildContext context) async {
    try {
      if (await checkinternetconnection()) {
        isloading = true;
        notifyListeners();
        SharedPreferences prefs = await SharedPreferences.getInstance();
        var res = await ChangePasswordSettingService.hitChangePassword(
            context: context,
            empid: AppConstants.loginmodell!.userData!.id.toString(),
            currentPassword: currentPassword.text.toString(),
            password: newPassword.text.toString(),
            confirmPassword: confirmPassword.text.toString());
        if (res != null) {
          if (res["success"].toString() == "1") {
            newPassword.clear();
            currentPassword.clear();
            confirmPassword.clear();
             ScaffoldMessenger.of(context).showSnackBar(
           appSnackBar(res["message"].toString()));
           
           

            isloading = false;
            prefs.setBool("enabledBioMetric2", false);
            prefs.setBool("enabledBioMetric", false);
            notifyListeners();
          } else {
             ScaffoldMessenger.of(context).showSnackBar(
           appSnackBar(res["message"].toString()));
            
            isloading = false;
            notifyListeners();
          }
        } else {
          isloading = false;
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
      isloading = false;
      notifyListeners();
      debugPrint(exception.toString());
    }
  }
}

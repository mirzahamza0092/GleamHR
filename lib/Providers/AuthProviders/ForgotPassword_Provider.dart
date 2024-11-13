import 'package:flutter/material.dart';
import 'package:gleam_hr/Components/commonSnakbar.dart';
import 'package:gleam_hr/Routes/routes.dart' as route;
import 'package:gleam_hr/Services/AuthServices/RecoverPassword_Service.dart';
import 'package:gleam_hr/Utils/AppConstants.dart';
import 'package:gleam_hr/Utils/Methods.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

class ForgotPasswordProvider extends ChangeNotifier {
  TextEditingController nameoremail = TextEditingController();
  GlobalKey<FormState> forgetPasswordkey = GlobalKey();
  bool isloading = false;

  hitRecoverPassword(BuildContext context) async {
    if (forgetPasswordkey.currentState!.validate()) {
      try {
        if (await checkinternetconnection()) {
          isloading = true;
          notifyListeners();
          var res = await RecoverPasswordService.recoverPassword(
              context: context, emailorusername: nameoremail.text);
          if (res != null) {
            if (res["success"].toString() == "1") {
              AppConstants.fromLogin = false;
              Navigator.of(context).pushNamed(route.verifypassword);
               ScaffoldMessenger.of(context).showSnackBar(
           appSnackBar(res["message"].toString())); 
              isloading = false;

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
      //nameoremail.clear();
    }
  }
}

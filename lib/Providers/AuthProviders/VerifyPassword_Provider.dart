import 'package:flutter/material.dart';
import 'package:gleam_hr/Components/commonSnakbar.dart';
import 'package:gleam_hr/Providers/AuthProviders/ForgotPassword_Provider.dart';
import 'package:gleam_hr/Routes/routes.dart' as route;
import 'package:gleam_hr/Services/AuthServices/VerifyOtp_Service.dart';
import 'package:gleam_hr/Utils/AppConstants.dart';
import 'package:gleam_hr/Utils/AppPaths.dart';
import 'package:gleam_hr/Utils/Methods.dart';
import 'package:provider/provider.dart';
import 'package:sentry_flutter/sentry_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

class VerifyPasswordProvider extends ChangeNotifier {
  TextEditingController password = TextEditingController();
  GlobalKey<FormState> verifyPasswordkey = GlobalKey();
  bool isloading = false;

  hitVerifyPassword(BuildContext context) async {
    if (verifyPasswordkey.currentState!.validate()) {
      try {
        if (await checkinternetconnection()) {
          isloading = true;
          notifyListeners();
          var res = await VerifyOtpService.verifyOtp(
              context: context,
              emailorusername:
                  context.read<ForgotPasswordProvider>().nameoremail.text,
              otp: password.text);
          if (res != null) {
            if (res["success"].toString() == "1") {
              password.clear();
              final prefs = await SharedPreferences.getInstance();
              await prefs.setString(Keys.token, res["token"].toString());
              Navigator.of(context).pushNamed(route.setpassword);
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
    }
  }
}

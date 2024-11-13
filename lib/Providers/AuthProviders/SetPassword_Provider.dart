import 'package:flutter/material.dart';
import 'package:gleam_hr/Components/commonSnakbar.dart';
import 'package:gleam_hr/Providers/AuthProviders/ForgotPassword_Provider.dart';
import 'package:gleam_hr/Providers/AuthProviders/LoginScreen_Provider.dart';
import 'package:gleam_hr/Routes/routes.dart' as route;
import 'package:gleam_hr/Screens/Auth/LoginOnboarding.dart';
import 'package:gleam_hr/Services/AuthServices/ChangePassword_Service.dart';
import 'package:gleam_hr/Utils/AppConstants.dart';
import 'package:gleam_hr/Utils/AppPaths.dart';
import 'package:gleam_hr/Utils/Methods.dart';
import 'package:provider/provider.dart';
import 'package:sentry_flutter/sentry_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SetPasswordProvider extends ChangeNotifier {
  TextEditingController confirmPassword = TextEditingController();
  TextEditingController password = TextEditingController();
  GlobalKey<FormState> setPasswordKey = GlobalKey();

  bool isloading = false;
  hitResetPassword(BuildContext context) async {

    if (setPasswordKey.currentState!.validate()) {
      try {
        if (await checkinternetconnection()) {
          isloading = true;
          notifyListeners();
          SharedPreferences prefs = await SharedPreferences.getInstance();
          if (AppConstants.fromLogin == true) {
            final loginScreenProvider =
                Provider.of<LoginScreenProvider>(context, listen: false);
            // ignore: use_build_context_synchronously
            var res2 = await ChangePasswordService.resetPasswordByLogin(
                context: context,
                id: (AppConstants.loginmodell?.userData?.id).toString(),
                password: password.text,
                confirmPassword: confirmPassword.text);
            if (res2 != null) {
              if (res2 == true) {
                isloading = false;
                password.clear();
                confirmPassword.clear();
                loginScreenProvider.nameoremail.clear();
                loginScreenProvider.password.clear();
                Navigator.of(context)
                .pushAndRemoveUntil(MaterialPageRoute(builder:(context) => const LoginOnboarding(),),(Route route) => false);                        
                // Navigator.of(context).pushNamedAndRemoveUntil(
                //     route.login, (Route route) => false);
              } else {
                isloading = false;
                password.clear();
                confirmPassword.clear();
                loginScreenProvider.nameoremail.clear();
                loginScreenProvider.password.clear();
                Navigator.of(context).pushNamedAndRemoveUntil(
                    route.login, (Route route) => false);
              }
            }
          } else {
            var res = await ChangePasswordService.resetPassword(
                context: context,
                emailorusername:
                    context.read<ForgotPasswordProvider>().nameoremail.text,
                token: prefs.getString(Keys.token)!,
                password: password.text,
                confirmPassword: confirmPassword.text);
            if (res != null) {
              if (res["success"].toString() == "1") {
                password.clear();
                confirmPassword.clear();
                Navigator.of(context).pushNamedAndRemoveUntil(
                    route.login, (Route route) => false);

                ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(res["message"].toString())));

                isloading = false;
                prefs.setBool("enabledBioMetric2", false);
                prefs.setBool("enabledBioMetric", false);
                //a.enabledBioMetric = false;
                notifyListeners();
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(res["message"].toString())));

                isloading = false;
                notifyListeners();
              }
            } else {
              isloading = false;
              notifyListeners();
            }
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

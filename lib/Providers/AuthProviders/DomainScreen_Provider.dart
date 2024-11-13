import 'package:flutter/material.dart';
import 'package:gleam_hr/Components/commonSnakbar.dart';
import 'package:gleam_hr/Routes/routes.dart' as route;
import 'package:gleam_hr/Services/AuthServices/DomainVerification_Service.dart';
import 'package:gleam_hr/Utils/AppConstants.dart';
import 'package:gleam_hr/Utils/AppPaths.dart';
import 'package:gleam_hr/Utils/Methods.dart';
import 'package:sentry_flutter/sentry_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DomainScreenProvider extends ChangeNotifier {
  TextEditingController domain = TextEditingController();
  GlobalKey<FormState> domainScreenFormKey = GlobalKey();
  bool isLoading = false;

  bool domainEntered = false;
  isDomainEntered(bool val) {
    domainEntered = val;
    notifyListeners();
  }

  enterDomain(BuildContext context) async {
    if (domainScreenFormKey.currentState!.validate() &&
        domainEntered == false) {
      debugPrint("domain:${domain.text}");
      try {
        if (await checkinternetconnection()) {
          isLoading = true;
          notifyListeners();
          var response = await DomainVerificationService.VerifyDomain(
              domainName: domain.text.trim(), context: context);
          if (response["success"].toString() == "1") {
            final prefs = await SharedPreferences.getInstance();
            await prefs.setString("tanent-id", response["tenant_id"].toString());
            await prefs.setString(Keys.domainurl,
                "https://${domain.text.trim()}.gleamhrm.com/api/v1/");
            await prefs.setString(Keys.onlydomain, domain.text.trim());
            Keys.domain = prefs.getString(Keys.onlydomain);
            ScaffoldMessenger.of(context).showSnackBar(
            appSnackBar("Domain Entered Successfully")
            );
            isLoading = false;
            notifyListeners();
            Navigator.of(context)
                .pushNamedAndRemoveUntil(route.login, (route) => false);
            //Navigator.of(context).pushNamed(route.login);
            domain.clear();
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
}

// import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'package:gleam_hr/Models/AuthModels/LoginDemoModel.dart';
// import 'package:gleam_hr/Models/AuthModels/LoginModel.dart';
// import 'package:gleam_hr/Utils/AppPaths.dart';
// import 'package:http/http.dart' as http;
// import 'package:shared_preferences/shared_preferences.dart';

// class LoginScreenService {
//   static Future login({
//     required String emailOrUsername,
//     required String password,
//     required BuildContext context,
//   }) async {
//     try {
//       final prefs=await SharedPreferences.getInstance();
//      String domain= prefs.getString(Keys.domainurl).toString();
//       var request = http.MultipartRequest('POST',
//           Uri.parse("$domain${Keys.login}"));
//       request.fields
//           .addAll({'official_email': emailOrUsername, 'password': password});
//       http.StreamedResponse response = await request.send();
//       String responseBody = await response.stream.bytesToString();
//       Map mapBody = jsonDecode(responseBody);
//       if (response.statusCode == 200) {
//         if (domain=="https://demo.gleamhrm.com/api/gleam_mobile/") {
//           return demoLoginModelFromJson(responseBody);
//         }
//         else{
//         return loginModelFromJson(responseBody);
//         }
//       } else {
//         ScaffoldMessenger.of(context)
//             .showSnackBar(SnackBar(content: Text(mapBody["message"].toString())));
//       }
//     } catch (exception) {
//       debugPrint(e);
//     }
//   }
// }

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:gleam_hr/Components/commonSnakbar.dart';
import 'package:gleam_hr/Models/AuthModels/StagingLoginModel.dart';
import 'package:gleam_hr/Utils/AppConstants.dart';
import 'package:gleam_hr/Utils/AppPaths.dart';
import 'package:gleam_hr/Utils/Methods.dart';
import 'package:http/http.dart' as http;
import 'package:sentry_flutter/sentry_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginScreenService {
  static Future login({
    required String emailOrUsername,
    required String password,
    required BuildContext context,
  }) async {
    try {
      await Functions.firebasegetfcmtoken();
      final prefs = await SharedPreferences.getInstance();
//      String domainurl = prefs.getString(Keys.domainurl).toString();
      String onlydomain = prefs.getString(Keys.onlydomain).toString();
      var request =
         http.MultipartRequest('POST', Uri.parse("https://$onlydomain.gleamhrm.com/api/v2/${Keys.login}"));
      request.fields.addAll({
        'official_email': emailOrUsername,
        'password': password,
        'player_id': AppConstants.playerId.toString()
      });
      http.StreamedResponse response = await request.send();
      String responseBody = await response.stream.bytesToString();
      Map mapBody = jsonDecode(responseBody);
      if (response.statusCode == 200) {
        return stagingLoginModelFromJson(responseBody);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
                        appSnackBar(mapBody["message"].toString())); 
      }
    } catch (exception) {
    if (AppConstants.livemode) {
          await Sentry.captureException(exception);
        }
      // Fluttertoast.showToast(
      //     msg: e.toString(),
      //     toastLength: Toast.LENGTH_SHORT,
      //     gravity: ToastGravity.CENTER,
      //     timeInSecForIosWeb: 1,
      //     backgroundColor: Colors.red,
      //     textColor: Colors.white,
      //     fontSize: 16.0);
      debugPrint(exception.toString());
    }
  }
}

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

class HitRefreshApiService {
  static Future refresh({
    required String employeeId,
    required BuildContext context,
  }) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      String token = prefs.getString(Keys.token).toString();
      // String domainurl = prefs.getString(Keys.domainurl).toString();
      var headers = {'Authorization': 'Bearer $token'};
      String onlydomain = prefs.getString(Keys.onlydomain).toString();
      var request =
         http.MultipartRequest('POST', Uri.parse("https://$onlydomain.gleamhrm.com/api/v2/get-dashboard-data"));
      // var request = http.MultipartRequest(
      //     'POST', Uri.parse("${domainurl}get-dashboard-data"));
      request.fields.addAll({'employee_id': employeeId});

      request.headers.addAll(headers);
      http.StreamedResponse response = await request.send();
      String responseBody = await response.stream.bytesToString();
      if (response.statusCode == 200) {
        if (responseBody == '"Unauthenticated."') {
          Functions.logoutAccount(context: context, message: "Session Expired");
        } else {
          Functions.reset();
          return stagingLoginModelFromJson(responseBody);
        }
      } else {

        Map mapBody = jsonDecode(responseBody);
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
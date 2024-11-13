import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:gleam_hr/Components/commonSnakbar.dart';
import 'package:gleam_hr/Models/DashBoardModels/HomeModels/CheckinCheckoutModel.dart';
import 'package:gleam_hr/Utils/AppConstants.dart';
import 'package:gleam_hr/Utils/AppPaths.dart';
import 'package:gleam_hr/Utils/Methods.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:sentry_flutter/sentry_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CheckoutApiService {
  static Future checkout({
    required String clockType,
    required String reason,
    required String takenabreak,
    required String employeeId,
    required bool isFace,
    required BuildContext context,
  }) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      String token = prefs.getString(Keys.token).toString();
      String domainurl = prefs.getString(Keys.domainurl).toString();
      DateTime dt = DateTime.now();
      String format = DateFormat("yyyy-MM-dd HH:mm:ss").format(dt);
      var headers = {'Authorization': 'Bearer $token'};
      var request = http.MultipartRequest(
          'POST', Uri.parse("${domainurl}attendance/check-out"));
      request.fields.addAll({
        'clock_type': clockType,
        'employee_id': employeeId,
        'reason_for_leaving': reason,
        'taken_a_break': takenabreak,
        'time': format,
        'source':isFace? "mobile-app-face attendance":"mobile-app attendance"
      });

      request.headers.addAll(headers);

      http.StreamedResponse response = await request.send();

      String responseBody = await response.stream.bytesToString();
      if (response.statusCode == 200) {
        if (responseBody == '"Unauthenticated."') {
          Functions.logoutAccount(context: context, message: "Session Expired");
        } else {
          Functions.reset();
          return checkinCheckoutModelFromJson(responseBody);
        }
      } else {
        Map mapBody = jsonDecode(responseBody);
         ScaffoldMessenger.of(context).showSnackBar(
                        appSnackBar( mapBody["message"].toString()));
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

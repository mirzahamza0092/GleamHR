import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:gleam_hr/Components/commonSnakbar.dart';
import 'package:gleam_hr/Utils/AppConstants.dart';
import 'package:gleam_hr/Utils/AppPaths.dart';
import 'package:gleam_hr/Utils/Methods.dart';
import 'package:http/http.dart' as http;
import 'package:sentry_flutter/sentry_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CorrectionRequestService {
  static Future storeCorrectionRequest({
    required BuildContext context,
    required String userid,
    required String firstCheckinDate,
    required String totalEnteries,
    required Map<String, dynamic> timeInDate,
    required Map<String, dynamic> timeIn,
    required Map<String, dynamic> timeOutDate,
    required Map<String, dynamic> timeOut,
    required Map<String, dynamic> timeInStatus,
    required Map<String, dynamic> attandanceStatus,
    required Map<String, dynamic> reasonForLeaving,
    required Map<String, dynamic> takenaBreak,
  }) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      String token = prefs.getString(Keys.token).toString();
      String domainurl = prefs.getString(Keys.domainurl).toString();
      var headers = {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token'
      };
      var request = http.Request(
          'POST', Uri.parse("${domainurl}attendance-correction-request"));
      request.body = json.encode({
        "employee_id": userid,
        "date": firstCheckinDate,
        "total_entries": totalEnteries,
        "time_in_date": timeInDate,
        "time_in": timeIn,
        "time_out_date": timeOutDate,
        "time_out": timeOut,
        "time_in_status": timeInStatus,
        "attendance_status": attandanceStatus,
        "reason_for_leaving": reasonForLeaving,
        "taken_a_break": takenaBreak
      });
      request.headers.addAll(headers);

      http.StreamedResponse response = await request.send();

      String responseBody = await response.stream.bytesToString();
      if (response.statusCode == 200) {
        if (responseBody == '"Unauthenticated."') {
          Functions.logoutAccount(context: context, message: "Session Expired");
        } else {
          Functions.reset();
          Map mapBody = jsonDecode(responseBody);
          // ScaffoldMessenger.of(context).showSnackBar(
          //   SnackBar(content: Text(mapBody["message"].toString())));
          if (mapBody["id"].toString() == "1") {
            return mapBody["message"].toString();
          } else {
            return mapBody["message"].toString();
          }
        }
      } else {
        Map mapBody = jsonDecode(responseBody);
         ScaffoldMessenger.of(context).showSnackBar(
                        appSnackBar(mapBody["id"].toString()));
      
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

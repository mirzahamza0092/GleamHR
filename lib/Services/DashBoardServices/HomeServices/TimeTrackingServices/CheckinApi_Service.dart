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

class CheckinApiService {
  static Future checkin({
    required String clockType,
    required String relatedToDate,
    required String employeeId,
    required bool isFace,
    required BuildContext context,
  }) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      String token = prefs.getString(Keys.token).toString();
      var headers = {'Authorization': 'Bearer $token'};
      DateTime dt = DateTime.now();
      String format = DateFormat("yyyy-MM-dd HH:mm:ss").format(dt);
      var request = http.MultipartRequest(
          'POST', Uri.parse("https://${Keys.domain}.gleamhrm.com/api/v3/attendance/check-in"));
      request.fields.addAll({
        'clock_type': clockType,
        'time': format, //DateTime.now().toString(),
        'related_to_date': relatedToDate,
        'employee_id': employeeId,
        'source':isFace? "mobile-app-face attendance":"mobile-app attendance"
      });

      debugPrint("timestamp${DateTime.now()}");
      request.headers.addAll(headers);

      http.StreamedResponse response = await request.send();

      String responseBody = await response.stream.bytesToString();

      if (response.statusCode == 200) {
        if (responseBody == '"Unauthenticated."') {
          Functions.logoutAccount(context: context, message: "Session Expired");
          //logout code
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

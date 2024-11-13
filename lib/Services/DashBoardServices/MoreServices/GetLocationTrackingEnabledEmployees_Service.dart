import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:gleam_hr/Models/DashBoardModels/MoreModels/GetLocationTrackingEnabledEmployeesModel.dart';
import 'package:gleam_hr/Utils/AppConstants.dart';
import 'package:gleam_hr/Utils/AppPaths.dart';
import 'package:gleam_hr/Utils/Methods.dart';
import 'package:http/http.dart' as http;
import 'package:sentry_flutter/sentry_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

class GetLocationTrackingEnabledEmployeesService {
  static Future getEmployees({
    required BuildContext context,
    required String page,
  }) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      String token = prefs.getString(Keys.token).toString();
      String domainurl = prefs.getString(Keys.domainurl).toString();
      var headers = {'Authorization': 'Bearer $token'};
      var request = http.MultipartRequest(
          'GET',
          Uri.parse(
              "${domainurl}get-location-tracking-enabled-employees?page=$page"));
      request.headers.addAll(headers);
      http.StreamedResponse response = await request.send();
      String responseBody = await response.stream.bytesToString();
      if (response.statusCode == 200) {
        if (responseBody == '"Unauthenticated."') {
          Functions.logoutAccount(context: context, message: "Session Expired");
        } else {
          Functions.reset();
          Map mapBody = jsonDecode(responseBody);
          if (mapBody["success"].toString() == "1") {
            return getLocationTrackingEnabledEmployeesModelFromJson(
                responseBody);
          } else {
            return false;
          }
        }
      } else {
        return false;
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

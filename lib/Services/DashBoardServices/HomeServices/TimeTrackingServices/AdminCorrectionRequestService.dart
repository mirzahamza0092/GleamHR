import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:gleam_hr/Models/DashBoardModels/HomeModels/AllCorrectionRequestModel.dart';
import 'package:gleam_hr/Utils/AppConstants.dart';
import 'package:gleam_hr/Utils/AppPaths.dart';
import 'package:gleam_hr/Utils/Methods.dart';
import 'package:http/http.dart' as http;
import 'package:sentry_flutter/sentry_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AdminCorrectionRequestService {
  static Future getAllCorrectionRequests({
    required BuildContext context,
    required String page,
    required String status,
  }) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      String token = prefs.getString(Keys.token).toString();
      var headers = {'Authorization': 'Bearer $token'};
      var request;
      if(status=="All"){
      request = http.Request('GET', Uri.parse("https://${Keys.domain}.gleamhrm.com/api/v3/requests/attendance-correction?page=$page"));
      }else{
      request = http.Request('GET', Uri.parse("https://${Keys.domain}.gleamhrm.com/api/v3/requests/attendance-correction?page=$page&status=$status"));
      }
      request.headers.addAll(headers);
      http.StreamedResponse response = await request.send();
      String responseBody = await response.stream.bytesToString();
      if (response.statusCode == 200) {
        if (responseBody == '"Unauthenticated."') {
          Functions.logoutAccount(context: context, message: "Session Expired");
        } else {
          Functions.reset();
          return allCorrectionRequestsModelFromJson(responseBody);
        }
      } else {
        Map mapBody = jsonDecode(responseBody);
        ScaffoldMessenger.of(context).showSnackBar(
               SnackBar(content: Text(mapBody["message"].toString())));
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

  static Future approveDenyAdminCorrectionRequests({
    required BuildContext context,
    required String correctionId,
    required String employeeId,
    required String date,
    required String decision,
  }) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      String token = prefs.getString(Keys.token).toString();
      var headers = {'Authorization': 'Bearer $token',
      'Content-Type': 'application/json'};
      var request = http.Request('POST', Uri.parse('https://${Keys.domain}.gleamhrm.com/api/v3/request/attendance-correction/approval'));
      request.body = json.encode({
        'correction_id': correctionId,
        'employee_id': employeeId,
        'date': date,
        'decision': decision
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
          if (mapBody["success"].toString()=="1") {
            return true;
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

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:gleam_hr/Models/DashBoardModels/HomeModels/AllTimeOffRequestModel.dart';
 import 'package:gleam_hr/Utils/AppConstants.dart';
import 'package:gleam_hr/Utils/AppPaths.dart';
import 'package:gleam_hr/Utils/Methods.dart';
import 'package:http/http.dart' as http;
import 'package:sentry_flutter/sentry_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AdminTimeOffRequestService {
  static Future getAllTimeOffRequests({
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
      request = http.Request('GET', Uri.parse("https://${Keys.domain}.gleamhrm.com/api/v3/requests/time-off/?page=$page"));
      }else{
      request = http.Request('GET', Uri.parse("https://${Keys.domain}.gleamhrm.com/api/v3/requests/time-off/?page=$page&status=$status"));
      }
      request.headers.addAll(headers);
      http.StreamedResponse response = await request.send();
      String responseBody = await response.stream.bytesToString();
      if (response.statusCode == 200) {
        if (responseBody == '"Unauthenticated."') {
          Functions.logoutAccount(context: context, message: "Session Expired");
        } else {
          Functions.reset();
          return allTimeOffRequestsModelFromJson(responseBody);
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
      
      debugPrint(exception.toString());
    }
  }

  static Future approveDenyAdminTimeOffRequests({
    required BuildContext context,
    required String TimeOffId,
    required String employeeId,
    required String status,
  }) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      String token = prefs.getString(Keys.token).toString();
      var headers = {'Authorization': 'Bearer $token'};
      var request = http.MultipartRequest('POST', Uri.parse('https://${Keys.domain}.gleamhrm.com/api/v3/request/time-off/approval'));
      request.fields.addAll({
        'id': TimeOffId,
        'employee_id': employeeId,
        'status': status
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
      
      debugPrint(exception.toString());
    }
  }
}

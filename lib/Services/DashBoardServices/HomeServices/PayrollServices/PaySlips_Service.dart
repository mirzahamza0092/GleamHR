import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:gleam_hr/Components/commonSnakbar.dart';
import 'package:gleam_hr/Models/DashBoardModels/HomeModels/PaySlipsModel.dart';
import 'package:gleam_hr/Utils/AppConstants.dart';
import 'package:gleam_hr/Utils/AppPaths.dart';
import 'package:gleam_hr/Utils/Methods.dart';
import 'package:http/http.dart' as http;
import 'package:sentry_flutter/sentry_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PaySlipsService {
  static Future getPaySlips({
    required String employeeId,
    required BuildContext context,
    required String year,
  }) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      String token = prefs.getString(Keys.token).toString();
      String domainurl = prefs.getString(Keys.domainurl).toString();
      var headers = {'Authorization': 'Bearer $token'};
      var request;
      if (year == "") {
       request = http.MultipartRequest(
          'POST', Uri.parse("${domainurl}get-salary-slip"));
      } else {
       request = http.MultipartRequest(
          'POST', Uri.parse("${domainurl}get-salary-slip?year=$year"));
      }
      request.fields.addAll({'id': employeeId});

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
            return paySlipsModelFromJson(responseBody);
          } else {
             ScaffoldMessenger.of(context).showSnackBar(
                        appSnackBar(mapBody["data"].toString()));
             }
        }
      } else {
        return null;
      }
    } catch (exception) {
    if (AppConstants.livemode) {
          await Sentry.captureException(exception);
        }
      debugPrint(exception.toString());
    }
  }
}

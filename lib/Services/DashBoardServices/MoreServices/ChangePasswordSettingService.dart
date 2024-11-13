// ignore_for_file: use_build_context_synchronously

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:gleam_hr/Utils/AppConstants.dart';
import 'package:gleam_hr/Utils/AppPaths.dart';
import 'package:gleam_hr/Utils/Methods.dart';
import 'package:http/http.dart' as http;
import 'package:sentry_flutter/sentry_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ChangePasswordSettingService {
  static Future hitChangePassword(
      {required BuildContext context,
      required String empid,
      required String currentPassword,
      required String password,
      required String confirmPassword}) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      String token = prefs.getString(Keys.token).toString();
      var headers = {'Authorization': 'Bearer $token'};
      var request = http.MultipartRequest(
          'POST', Uri.parse("https://${Keys.domain}.gleamhrm.com/api/v3/employees/$empid/update-password"));
      request.fields.addAll({
        'employee_id': empid,
        'current_password': currentPassword,
        'password': password,
        'password_confirmation': confirmPassword
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
          //     SnackBar(content: Text(mapBody["message"].toString())));
          return mapBody;
        }
      } else {
        Map mapBody = jsonDecode(responseBody);
        return mapBody;
        //ScaffoldMessenger.of(context).showSnackBar(
        //     SnackBar(content: Text(mapBody["message"].toString())));
      }
    } catch (exception) {
    if (AppConstants.livemode) {
          await Sentry.captureException(exception);
        }
      debugPrint(exception.toString());
    }
  }
}

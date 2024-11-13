// ignore_for_file: use_build_context_synchronously

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:gleam_hr/Components/commonSnakbar.dart';
import 'package:gleam_hr/Screens/Auth/LoginScreen.dart';
import 'package:gleam_hr/Utils/AppConstants.dart';
import 'package:gleam_hr/Utils/AppPaths.dart';
import 'package:http/http.dart' as http;
import 'package:sentry_flutter/sentry_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ChangePasswordService {
  static Future resetPassword(
      {required BuildContext context,
      required String emailorusername,
      required String token,
      required String password,
      required String confirmPassword}) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      String domainurl = prefs.getString(Keys.domainurl).toString();
      var request = http.MultipartRequest(
          'POST', Uri.parse("${domainurl}reset-password/update"));
      request.fields.addAll({
        'official_email': emailorusername,
        'token': token,
        'password': password,
        'password_confirmation': confirmPassword
      });

      http.StreamedResponse response = await request.send();
      String responseBody = await response.stream.bytesToString();
      Map mapBody = jsonDecode(responseBody);
      if (response.statusCode == 401) {
        return mapBody;
      } else if (mapBody["message"].toString() == "Request Time Out") {
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => const LoginScreen()),
            (route) => false);
      } else {
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => const LoginScreen()),
            (route) => false);
        ScaffoldMessenger.of(context).showSnackBar(
                        appSnackBar( mapBody["message"].toString()));
       
      }
    } catch (exception) {
    if (AppConstants.livemode) {
          await Sentry.captureException(exception);
        }
      debugPrint(exception.toString());
    }
  }

  static Future resetPasswordByLogin(
      {required BuildContext context,
      required String id,
      required String password,
      required String confirmPassword}) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      String domainurl = prefs.getString(Keys.domainurl).toString();
      String token = prefs.getString(Keys.token).toString();
      var headers = {'Authorization': 'Bearer $token'};

      var request = http.MultipartRequest(
          'POST', Uri.parse("${domainurl}reset-password-first-login"));
      request.fields.addAll({
        'id': AppConstants.loginmodell!.userData!.id.toString(),
        'password': password,
        'password_confirmation': confirmPassword
      });
      request.headers.addAll(headers);

      http.StreamedResponse response = await request.send();
      String responseBody = await response.stream.bytesToString();
      Map mapBody = jsonDecode(responseBody);

      if (response.statusCode == 200) {
        if (mapBody["success"] == 1) {
          ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(mapBody["message"].toString())));
          return true;
        }
      } else {
        if (mapBody["success"] == 0) {
          ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(mapBody["message"].toString())));
          return false;
        }
      }
    } catch (exception) {
    if (AppConstants.livemode) {
          await Sentry.captureException(exception);
        }
      debugPrint(exception.toString());
    }
  }
}

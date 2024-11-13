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

class VerifyOtpService {
  static Future verifyOtp({
    required BuildContext context,
    required String emailorusername,
    required String otp,
  }) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      String domainurl = prefs.getString(Keys.domainurl).toString();
      var request = http.MultipartRequest(
          'POST', Uri.parse("${domainurl}reset-password/otp/verify"));
      request.fields.addAll({'official_email': emailorusername, 'otp': otp});

      http.StreamedResponse response = await request.send();
      String responseBody = await response.stream.bytesToString();
      Map mapBody = jsonDecode(responseBody);
      if (response.statusCode == 401) {
        return mapBody;
      } else if (mapBody["message"].toString() == "OTP Expired.") {
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => const LoginScreen()),
            (route) => false);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
                        appSnackBar("OTP Invalid"));
             
         
       
      }
    } catch (exception) {
    if (AppConstants.livemode) {
          await Sentry.captureException(exception);
        }
      debugPrint(exception.toString());
    }
  }
}

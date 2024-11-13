// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:gleam_hr/Models/DashBoardModels/AppbarModels/AllEmployeeEnrollStatusModel.dart';
import 'package:gleam_hr/Utils/AppConstants.dart';
import 'dart:convert';
import 'package:gleam_hr/Utils/Methods.dart';
import 'package:http/http.dart' as http;
import 'package:sentry_flutter/sentry_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FaceRecognitionService {
  //Ml local
  // static String serverUrl = "https://ca0d-2407-d000-1a-b54d-3915-1a72-45fc-ee96.ngrok-free.app/";
  //real
  static String serverUrl = "http://16.171.154.188:5003/";
  static Future check(BuildContext context,String empId) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      var request = http.MultipartRequest(
          'POST', Uri.parse('${serverUrl}check'));
      request.fields.addAll({
        'tenant_id': prefs.getString("tanent-id").toString(),
        'emp_id': empId,
      });

      http.StreamedResponse response = await request.send();
      String responseBody = await response.stream.bytesToString();
      Map mapBody = jsonDecode(responseBody);
      if (response.statusCode == 200) {
        if (mapBody["status"].toString() == "true") {
          Functions.reset();
          return true;
        } else {
          return false;
        }
      }
    } catch (exception) {
    if (AppConstants.livemode) {
          await Sentry.captureException(exception);
        }
    }
  }

  static Future register(
      {required String image,required String accountId, required BuildContext context}) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      var request = http.MultipartRequest(
          'POST', Uri.parse('${serverUrl}register'));
      request.fields.addAll({
        'tenant_id': prefs.getString("tanent-id").toString(),
        'emp_id': accountId.toString()
      });
      request.files.add(await http.MultipartFile.fromPath('image', image));

      http.StreamedResponse response = await request.send();
      String responseBody = await response.stream.bytesToString();
      Map mapBody = jsonDecode(responseBody);
      if (response.statusCode == 200) {
        if (mapBody["status"].toString() == "true") {
          Functions.reset();
          return true;
        } else {
          return false;
        }
      }
    } catch (exception) {
    if (AppConstants.livemode) {
          await Sentry.captureException(exception);
        }
    }
  }

  static Future recognizeface({
    required String image,
    required BuildContext context,
  }) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      var request = http.MultipartRequest(
          'POST', Uri.parse('${serverUrl}recognize_face'));
      request.files.add(await http.MultipartFile.fromPath('image', image));
      request.fields.addAll({
        'tenant_id': prefs.getString("tanent-id").toString(),
        'emp_id': AppConstants.loginmodell!.userData!.id.toString()
      });
      http.StreamedResponse response = await request.send();
      String responseBody = await response.stream.bytesToString();
      Map mapBody = jsonDecode(responseBody);
      if (response.statusCode == 200) {
        if (mapBody["status"].toString() == "true") {
          Functions.reset();
          return true;
        } else {
          return false;
        }
      }
    } catch (exception) {
    if (AppConstants.livemode) {
          await Sentry.captureException(exception);
        }
    }
  }

  static Future allEmployeeStatus({
    required BuildContext context,
  }) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      var headers = {
      'Content-Type': 'application/json'
      };
      var request = http.Request('POST', Uri.parse('${serverUrl}employees'));
      request.body = json.encode({
        "tenant_id": prefs.getString("tanent-id").toString(),
      });
      request.headers.addAll(headers);
      http.StreamedResponse response = await request.send();
      
      String responseBody = await response.stream.bytesToString();
      Map mapBody = jsonDecode(responseBody);
      if (response.statusCode == 200) {
        if (mapBody["status"].toString() == "true") {
          Functions.reset();
          return allEmployeeEnrollStatusModelFromJson(responseBody);
        } else {
          return false;
        }
      }
    } catch (exception) {
    if (AppConstants.livemode) {
          await Sentry.captureException(exception);
        }
    }
  }
}
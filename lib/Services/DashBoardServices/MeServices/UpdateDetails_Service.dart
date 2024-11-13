import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:gleam_hr/Components/commonSnakbar.dart';
import 'package:gleam_hr/Utils/AppConstants.dart';
import 'package:gleam_hr/Utils/AppPaths.dart';
import 'package:gleam_hr/Utils/Methods.dart';
import 'package:sentry_flutter/sentry_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class UpdateDetailsService {
  static Future updateDetails({
    required BuildContext context,
    required String firstname,
    required String lastname,
    required String phone,
    required String picture,
    required String fatherName,
    required String motherName,
    required String martialStatus,
    required String dob,
    required String gender,
  }) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      String token = prefs.getString(Keys.token).toString();
      String domainurl = prefs.getString(Keys.domainurl).toString();
      var headers = {'Authorization': 'Bearer $token'};
      var request = http.MultipartRequest(
          'POST', Uri.parse("${domainurl}update-personal-details"));
      request.fields.addAll({
        'id': AppConstants.loginmodell!.userData!.id.toString(),
        'firstname': firstname,
        'lastname': lastname,
        'contact_no': phone,
        'father_name': fatherName,
        'mother_name': motherName,
        // 'marital_status': martialStatus,
        // 'date_of_birth': dob,
        // 'gender': gender,
      });
      if (picture != "null") {
        request.files
            .add(await http.MultipartFile.fromPath('picture', picture));
      }

      request.headers.addAll(headers);
      http.StreamedResponse response = await request.send();
      String responseBody = await response.stream.bytesToString();
      if (response.statusCode == 200) {
        if (responseBody == '"Unauthenticated."') {
          Functions.logoutAccount(context: context, message: "Session Expired");
          //logout code
        } else {
          Map mapBody = jsonDecode(responseBody);
          Functions.reset();
          return mapBody;
        }
      } else {
        Map mapBody = jsonDecode(responseBody);
        mapBody.forEach((field, messages) {
          debugPrint('$field:');
          messages.forEach((message) {
            ScaffoldMessenger.of(context).showSnackBar(
                        appSnackBar(message));
             
            
          });
        });
      }
    } catch (exception) {
    if (AppConstants.livemode) {
          await Sentry.captureException(exception);
        }
      debugPrint(exception.toString());

      
      
    }
  }
}

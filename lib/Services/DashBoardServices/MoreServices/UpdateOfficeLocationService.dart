import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:gleam_hr/Utils/AppConstants.dart';
import 'package:gleam_hr/Utils/AppPaths.dart';
import 'package:gleam_hr/Utils/Methods.dart';
import 'package:sentry_flutter/sentry_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class UpdateLocationDetailsService {
  static Future updateLocDetails({
    required BuildContext context,
    required String name,
    required String city,
    required String state,
    required String street,
    required String id,
    required String postalcode,
    required String country,
    required String lat,
    required String lng,
    required String phoneNumber,
    required String radius,
  }) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      String token = prefs.getString(Keys.token).toString();
      String domainurl = prefs.getString(Keys.domainurl).toString();
      var headers = {'Authorization': 'Bearer $token'};
      var request = http.MultipartRequest(
          'POST', Uri.parse("${domainurl}update-location-details"));
      request.fields.addAll({
        'location_id': id,
        'name': name,
        'street_1': street,
        'city': city,
        'state': state,
        'zip_code': postalcode==""?"0":postalcode,
        'country': country,
        'latitude': lat,
        'longitude': lng,
        'phone_number': phoneNumber,
        'geo_radius': radius
      });
      request.headers.addAll(headers);
      http.StreamedResponse response = await request.send();
      String responseBody = await response.stream.bytesToString();
      if (response.statusCode == 200) {
        if (responseBody == '"Unauthenticated."') {
          Functions.logoutAccount(context: context, message: "Session Expired");
          //logout code
        } else {
        Map mapBody = jsonDecode(responseBody);
        if (mapBody["success"].toString() == "1") {
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

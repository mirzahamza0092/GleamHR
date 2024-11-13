import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:gleam_hr/Components/commonSnakbar.dart';
import 'package:gleam_hr/Utils/AppConstants.dart';
import 'package:gleam_hr/Utils/AppPaths.dart';
import 'package:http/http.dart' as http;
import 'package:sentry_flutter/sentry_flutter.dart';

class DomainVerificationService {
  static Future VerifyDomain({
    required String domainName,
    required BuildContext context,
  }) async {
    try {
      var request;
      if (domainName == 'staging') {
        request = http.MultipartRequest(
            'POST', Uri.parse('https://staging${Urlls.domainurl}'));
        request.fields.addAll({'domain': 'staging.gleamhrm.com'});
      } else {
        request = http.MultipartRequest(
            'POST', Uri.parse('https://backend${Urlls.domainurl}'));
        request.fields.addAll({'domain': '$domainName.gleamhrm.com'});
      }
      http.StreamedResponse response = await request.send();
      String responseBody = await response.stream.bytesToString();
      Map mapBody = jsonDecode(responseBody);
      if (response.statusCode == 200) {
        return mapBody;
      } else {
        ScaffoldMessenger.of(context)
            .showSnackBar(appSnackBar(mapBody["message"].toString()));
        return mapBody;
      }
    } catch (exception) {
      if (AppConstants.livemode) {
          await Sentry.captureException(exception);
        }
      ScaffoldMessenger.of(context)
          .showSnackBar(appSnackBar(exception.toString()));
      debugPrint(exception.toString());
    }
  }
}
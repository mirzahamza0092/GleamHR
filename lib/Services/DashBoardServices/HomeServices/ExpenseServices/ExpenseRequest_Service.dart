import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:gleam_hr/Models/DashBoardModels/HomeModels/ExpenseRequestTypesModel.dart';
import 'package:gleam_hr/Utils/AppConstants.dart';
import 'package:gleam_hr/Utils/AppPaths.dart';
import 'package:gleam_hr/Utils/Methods.dart';
import 'package:http/http.dart' as http;
import 'package:sentry_flutter/sentry_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ExpenseRequestServices {
  static Future ExpenseRequestService() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      String token = prefs.getString(Keys.token).toString();

      String domainurl = prefs.getString(Keys.domainurl).toString();
      var headers = {'Authorization': 'Bearer $token'};
      var request = http.MultipartRequest(
          'GET', Uri.parse("${domainurl}get-expense-type"));
      request.headers.addAll(headers);

      http.StreamedResponse response = await request.send();
      Future<String> resString = response.stream.bytesToString();
      if (response.statusCode == 200) {
        //debugPrint(await response.stream.bytesToString());

        return expenseRequestModelFromJson(await resString);
      } else {
        debugPrint(response.reasonPhrase);
      }
    } catch (exception) {
    if (AppConstants.livemode) {
          await Sentry.captureException(exception);
        }
      debugPrint(exception.toString());
    }
  }

  static Future ExpenseRequestSend(
      String DateRangeValue,
      String selecteCategoryType,
      String expense,
      String comment,
      String expenseTypeId,
      List<String> ImageList) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      String token = prefs.getString(Keys.token).toString();
      var id = AppConstants.loginmodell!.userData!.id.toString();

      String domainurl = prefs.getString(Keys.domainurl).toString();
      var headers = {'Authorization': 'Bearer $token'};
      var request =
          http.MultipartRequest('POST', Uri.parse("${domainurl}store-expense"));
      request.fields.addAll({
        'id': id,
        'expense_type_id': expenseTypeId.toString(),
        'date': DateRangeValue,
        'expense': expense,
        'expense_category': selecteCategoryType,
        'comment': comment
      });
      for (int i = 0; i < ImageList.length; i++) {
        request.files.add(await http.MultipartFile.fromPath(
            'expense_proof[]', ImageList[i]));
      }
      request.headers.addAll(headers);

      http.StreamedResponse response = await request.send();
      String resString = await response.stream.bytesToString();
      Map mapBody = jsonDecode(resString);
      if (response.statusCode == 200) {
        Functions.reset();
        debugPrint("sncascnoancoasncoasnco$resString");
        return mapBody;
      } else {
        return mapBody;
      }
    } catch (exception) {
    if (AppConstants.livemode) {
          await Sentry.captureException(exception);
        }
      debugPrint(exception.toString());
    }
  }
}

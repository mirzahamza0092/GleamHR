import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:gleam_hr/Components/commonSnakbar.dart';
import 'package:gleam_hr/Models/DashBoardModels/HomeModels/AssetRequestModel.dart';
import 'package:gleam_hr/Models/DashBoardModels/HomeModels/AssetTypeModel.dart';
import 'package:gleam_hr/Utils/AppConstants.dart';
import 'package:gleam_hr/Utils/AppPaths.dart';
import 'package:gleam_hr/Utils/Error_handling.dart';
import 'package:gleam_hr/Utils/Methods.dart';
import 'package:http/http.dart' as http;
import 'package:sentry_flutter/sentry_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AssetRequestService {
  static Future getAssetTypesService({
    required BuildContext context,
  }) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      String token = prefs.getString(Keys.token).toString();
      String domainurl = prefs.getString(Keys.domainurl).toString();
      var headers = {'Authorization': 'Bearer $token'};
      var request =
          http.Request('GET', Uri.parse("${domainurl}get-asset-type"));
      request.headers.addAll(headers);
      http.StreamedResponse response = await request.send();
      String responseBody = await response.stream.bytesToString();
      if (response.statusCode == 200) {
        if (responseBody == '"Unauthenticated."') {
          Functions.logoutAccount(context: context, message: "Session Expired");
        } else {
          Functions.reset();
          return assetTypesModelFromJson(responseBody);
        }
      } else {
        ScaffoldMessenger.of(context)
            .showSnackBar(appSnackBar(getErrorMessage(response.statusCode)));
        return false;
      }
    } catch (exception) {
      if (AppConstants.livemode) {
        await Sentry.captureException(exception);
      }
      // Fluttertoast.showToast(
      //     msg: e.toString(),
      //     toastLength: Toast.LENGTH_SHORT,
      //     gravity: ToastGravity.CENTER,
      //     timeInSecForIosWeb: 1,
      //     backgroundColor: Colors.red,
      //     textColor: Colors.white,
      //     fontSize: 16.0);
      debugPrint(exception.toString());
    }
  }

  static Future storeAssetRequest({
    required String assetId,
    required String message,
    required String empId,
    required BuildContext context,
  }) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      String token = prefs.getString(Keys.token).toString();
      String domainurl = prefs.getString(Keys.domainurl).toString();
      var headers = {'Authorization': 'Bearer $token'};
      var request = http.MultipartRequest(
          'POST', Uri.parse("${domainurl}store-asset-request"));
      request.fields.addAll(
          {'employee_id': empId, 'asset_type_id': assetId, 'message': message});
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
            return true;
          } else {
            return false;
          }
        }
      } else {
        ScaffoldMessenger.of(context)
            .showSnackBar(appSnackBar(getErrorMessage(response.statusCode)));
        return false;
      }
    } catch (exception) {
      if (AppConstants.livemode) {
        await Sentry.captureException(exception);
      }
      // Fluttertoast.showToast(
      //     msg: e.toString(),
      //     toastLength: Toast.LENGTH_SHORT,
      //     gravity: ToastGravity.CENTER,
      //     timeInSecForIosWeb: 1,
      //     backgroundColor: Colors.red,
      //     textColor: Colors.white,
      //     fontSize: 16.0);
      debugPrint(exception.toString());
    }
  }

  static Future getAssetRequest({
    required String userId,
    required String status,
    required String page,
    required BuildContext context,
  }) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      String token = prefs.getString(Keys.token).toString();
      var headers = {'Authorization': 'Bearer $token'};
      var request;
      if (status == "All") {
        request = http.Request(
            'GET',
            Uri.parse(
                "https://${Keys.domain}.gleamhrm.com/api/v3/requests/asset/$userId?page=$page"));
      } else {
        request = http.Request(
            'GET',
            Uri.parse(
                "https://${Keys.domain}.gleamhrm.com/api/v3/requests/asset/$userId?page=$page&status=$status"));
      }
      request.headers.addAll(headers);
      http.StreamedResponse response = await request.send();
      String responseBody = await response.stream.bytesToString();
      if (response.statusCode == 200) {
        if (responseBody == '"Unauthenticated."') {
          Functions.logoutAccount(context: context, message: "Session Expired");
        } else {
          Functions.reset();
          return assetRequestModelFromJson(responseBody);
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
      // Fluttertoast.showToast(
      //     msg: e.toString(),
      //     toastLength: Toast.LENGTH_SHORT,
      //     gravity: ToastGravity.CENTER,
      //     timeInSecForIosWeb: 1,
      //     backgroundColor: Colors.red,
      //     textColor: Colors.white,
      //     fontSize: 16.0);
      debugPrint(exception.toString());
    }
  }

  static getAllAssetRequest({
    required String status,
    required String page,
    required BuildContext context,
  }) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      String token = prefs.getString(Keys.token).toString();
      var headers = {'Authorization': 'Bearer $token'};
      var request;
      if (status == "All") {
        request = http.Request(
            'GET',
            Uri.parse(
                "https://${Keys.domain}.gleamhrm.com/api/v3/requests/asset?page=$page"));
      } else {
        request = http.Request(
            'GET',
            Uri.parse(
                "https://${Keys.domain}.gleamhrm.com/api/v3/requests/asset?page=$page&status=$status"));
      }
      request.headers.addAll(headers);
      http.StreamedResponse response = await request.send();
      String responseBody = await response.stream.bytesToString();
      if (response.statusCode == 200) {
        if (responseBody == '"Unauthenticated."') {
          Functions.logoutAccount(context: context, message: "Session Expired");
        } else {
          Functions.reset();
          return assetRequestModelFromJson(responseBody);
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
      // Fluttertoast.showToast(
      //     msg: e.toString(),
      //     toastLength: Toast.LENGTH_SHORT,
      //     gravity: ToastGravity.CENTER,
      //     timeInSecForIosWeb: 1,
      //     backgroundColor: Colors.red,
      //     textColor: Colors.white,
      //     fontSize: 16.0);
      debugPrint(exception.toString());
    }
  }
  
  static Future approveDenyAssetRequests({
    required BuildContext context,
    required String id,
    required String employeeId,
    required String assetTypeId,
    required String decision,
  }) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      String token = prefs.getString(Keys.token).toString();
      var headers = {'Authorization': 'Bearer $token',
      'Content-Type': 'application/json'};
      var request = http.Request('POST', Uri.parse('https://${Keys.domain}.gleamhrm.com/api/v3/request/asset/approval'));
      request.body = json.encode({
        'id': id,
        'employee_id': employeeId,
        "asset_type_id": assetTypeId,
        'status': decision
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
      // Fluttertoast.showToast(
      //     msg: e.toString(),
      //     toastLength: Toast.LENGTH_SHORT,
      //     gravity: ToastGravity.CENTER,
      //     timeInSecForIosWeb: 1,
      //     backgroundColor: Colors.red,
      //     textColor: Colors.white,
      //     fontSize: 16.0);
      debugPrint(exception.toString());
    }
  }
}

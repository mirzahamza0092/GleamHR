import 'package:flutter/material.dart';
import 'package:gleam_hr/Providers/DashBoardProviders/DashBoard_Provider.dart';
import 'package:location/location.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';

checkInternetPermission(BuildContext context) async {
  if (await Permission.location.request().isGranted) {
    Location location =  Location();
    bool ison = await location.serviceEnabled();
    if (!ison) {
      //if defvice is off
      bool isturnedon = await location.requestService();
      if (isturnedon) {
        debugPrint("GPS device is turned ON");
      } else {
        // again ask for internet permission
        context.read<DashBoardProvider>().changeGeoFensingStatus("failed");
        debugPrint("GPS Device is still OFF");
      }
    }
    debugPrint("permission1111");
    debugPrint("permission2222");
  }
}

Future<String> getlocationPermissions() async {
  Location location = Location();
  if (!await Permission.location.request().isGranted) {
    return "Please allow location permission to access the app.";
  } else {
    bool ison = await location.serviceEnabled();
    if (!ison) {
      return "Please turn on location services to access the app.";
    }
  }
  return "";
}

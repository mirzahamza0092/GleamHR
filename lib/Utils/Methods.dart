import 'dart:async';
import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_version_checker/flutter_app_version_checker.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:gleam_hr/Components/commonSnakbar.dart';
import 'package:gleam_hr/Providers/BottomNavigationProvider/BottomNavigation_Provider.dart';
import 'package:gleam_hr/Providers/DashBoardProviders/MeProviders/MeScreen_Provider.dart';
import 'package:gleam_hr/Screens/Auth/LoginScreen.dart';
import 'package:gleam_hr/Utils/AppConstants.dart';
import 'package:gleam_hr/Utils/AppPaths.dart';
import 'package:gleam_hr/Utils/Colors.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:sentry_flutter/sentry_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

class Functions {
  static String getWorkingTime(int secondsElapsed) {
    int hours = secondsElapsed ~/ 3600;
    int minutes = (secondsElapsed % 3600) ~/ 60;
    int seconds = secondsElapsed % 60;
    return '$hours:$minutes:$seconds';
  }

  static logoutAccount(
      {required BuildContext context, required String message}) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString(Keys.token, "");
    prefs.setString("loginmodel", "null");
    prefs.setString("allempnmodel", "null");
    await prefs.setString("button", "null");
    await prefs.setString("clock_type", "null");
    context.read<MeScreenProvider>().selectdFile = null;
    context.read<BottomNavigationProvider>().bottomnavindex = 0;
    stop();
    reset();
    //prefs.setString(Keys.domainurl, "");
    Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const LoginScreen()),
        (route) => false);
        ScaffoldMessenger.of(context).showSnackBar(
                        appSnackBar(message));    
  }

  static String timeAgo(DateTime d) {
    Duration diff = DateTime.now().difference(d);
    if (diff.inDays > 365) {
      return "${(diff.inDays / 365).floor()} ${(diff.inDays / 365).floor() == 1 ? "year" : "years"} ago";
    }
    if (diff.inDays > 30) {
      return "${(diff.inDays / 30).floor()} ${(diff.inDays / 30).floor() == 1 ? "month" : "months"} ago";
    }
    if (diff.inDays > 7) {
      return "${(diff.inDays / 7).floor()} ${(diff.inDays / 7).floor() == 1 ? "week" : "weeks"} ago";
    }
    if (diff.inDays > 0) {
      return "${diff.inDays} ${diff.inDays == 1 ? "day" : "days"} ago";
    }
    if (diff.inHours > 0) {
      return "${diff.inHours} ${diff.inHours == 1 ? "hour" : "hours"} ago";
    }
    if (diff.inMinutes > 0) {
      return "${diff.inMinutes} ${diff.inMinutes == 1 ? "minute" : "minutes"} ago";
    }
    return "just now";
  }

  static firebasegetfcmtoken() async {
    String oneSignalId;
    if (AppConstants.livemode) {
    //gleam
    oneSignalId = 'd281c866-75f8-4e14-84d2-725968066f2e';
    } else {
    //talha test
    oneSignalId = 'dcb223dc-9cf7-47a2-acc9-47598d2e68c8';
    }
    OneSignal.shared.setAppId(
      oneSignalId,
    );
    OneSignal.shared.setLogLevel(OSLogLevel.verbose, OSLogLevel.none);
    OneSignal.shared
        .promptUserForPushNotificationPermission()
        .then((value) => debugPrint("ACCEPTED"));
    final status = await OneSignal.shared.getDeviceState();
    final String? osUserID = status?.userId;
    AppConstants.playerId = osUserID;
    debugPrint("player id $osUserID");

    // Set notification received and opened handlers
    // OneSignal.shared.completeNotification("notificationId", true);
    
    // OneSignal.shared.setNotificationWillShowInForegroundHandler((event) {
    //   // our own call
    //   NotificationHelper.sendNotification(event.notification.title!.toString(),
    //       event.notification.body.toString());
    //   event.complete(event.notification);
    // });
    OneSignal.shared.setNotificationOpenedHandler(
      (OSNotificationOpenedResult result) {
        // Handle the notification
        debugPrint('Notification Opened: ${result.notification.body}');
      },
    );
  }

  static int secondsElapsed = 0;
  static Timer? timer;
//start time
  static void startDisplayingTime(BuildContext context) {
    timer = Timer.periodic(const Duration(seconds: 1), (Timer timer) async {
      secondsElapsed++;

      debugPrint(formatTime(secondsElapsed, context));
      // int hours = secondsElapsed ~/ 3600;
      int minutes = (secondsElapsed % 3600) ~/ 60;
      int remainingSeconds = secondsElapsed % 60;

      if (minutes.toString() == "9" && remainingSeconds.toString() == "30") {
        stop();
        reset();

        debugPrint("=======logout=========session expired=========");
        //
        final prefs = await SharedPreferences.getInstance();
        prefs.setString(Keys.token, "");
        prefs.setString("loginmodel", "null");
        prefs.setString("allempnmodel", "null");
        await prefs.setString("button", "null");
        await prefs.setString("clock_type", "null");
        //context.read<MeScreenProvider>().selectdFile=null;
        //context.read<BottomNavigationProvider>().bottomnavindex = 0;
        AppConstants.navigatorKey.currentState!.pushAndRemoveUntil(
            MaterialPageRoute(builder: (context) => const LoginScreen()),
            (route) => false);
        AppConstants.snackbarKey.currentState
            ?.showSnackBar(appSnackBar("Session Expired"));
      }
    });
  }

  //stop timer
  static void stop() {
    timer?.cancel();
  }

//reset timer
  static void reset() {
    secondsElapsed = 0;
  }

  static String formatTime(int seconds, BuildContext context) {
    int hours = seconds ~/ 3600;
    int minutes = (seconds % 3600) ~/ 60;
    int remainingSeconds = seconds % 60;
    return '${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}:${remainingSeconds.toString().padLeft(2, '0')}';
  }
}

DateTime? loginClickTime;

bool isRedundentClick(DateTime currentTime) {
  if (loginClickTime == null) {
    loginClickTime = currentTime;
    debugPrint("first click");
    return false;
  }
  debugPrint('diff is ${currentTime.difference(loginClickTime!).inSeconds}');
  if (currentTime.difference(loginClickTime!).inSeconds < 5) {
    // set this difference time in seconds
    return true;
  }
  loginClickTime = currentTime;
  return false;
}

Future checkVersion() async {
  final checker = AppVersionChecker();
  checker.checkUpdate().then((value) async {
    debugPrint(value.canUpdate.toString()); //return true if update is available
    if (value.canUpdate) {
      return await showDialog(
        context: AppConstants.navigatorKey.currentContext!,
        builder: (context) => AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          elevation: 0,
          title: const Text('Update App'),
          content: const Text('New version of GleamHR is available'),
          actions: [
            ElevatedButton(
              onPressed: () async {
                await launch(value.appURL.toString(), forceWebView: false);
              },
              child: const Text('Update'),
            ),
            ElevatedButton(
              onPressed: () => Navigator.of(context).pop(false),
              //return true when click on "Yes"
              child: const Text('Later'),
            ),
          ],
        ),
      );
    }
    debugPrint(value.currentVersion); //return current app version
    debugPrint(value.newVersion); //return the new app version
    debugPrint(value.appURL); //return the app url
    debugPrint(value
        .errorMessage); //return error message if found else it will return null
  });
}

Future<bool> checkinternetconnection() async {
  var connectivity = Connectivity();
  try {
    final hasInternet = await connectivity.checkConnectivity();

    if (hasInternet == ConnectivityResult.mobile ||
        hasInternet == ConnectivityResult.wifi) {
      return true;
    } else {
      return false;
    }
    // final result = await InternetAddress.lookup('example.com');
    // if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
    //   if (result.length>1) {
    //     return true;
    //   } else {
    //     return false;
    //   }
    // }else{
    //   return false;
    // }
  } on SocketException catch (_) {
    return false;
  }
}

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}

Future<String> downloadFile(String url, String fileName, String dir) async {
  HttpClient httpClient = HttpClient();
  File file;
  String filePath = '';

  try {
  PermissionStatus? status;
  if (Platform.isAndroid) {
  final androidInfo = await DeviceInfoPlugin().androidInfo;
  if (androidInfo.version.sdkInt <= 32) {
    status=await Permission.storage.request();
  }  else {
    status=await Permission.photos.request();
  }
  }else if (Platform.isIOS) {
  status=await Permission.storage.request();
  }
  if(status!.isGranted){
    var request = await httpClient.getUrl(Uri.parse(url));
    var response = await request.close();
    if (response.statusCode == 200) {
      var bytes = await consolidateHttpClientResponseBytes(response);
      filePath = '$dir/$fileName';
      file = File(filePath);
      if(file.existsSync()){
        await file.delete();
      }
      await file.writeAsBytes(bytes);
      Fluttertoast.showToast(
                                                      msg: "File Downloaded",
                                                      toastLength: Toast.LENGTH_SHORT,
                                                      gravity: ToastGravity.BOTTOM,
                                                      timeInSecForIosWeb: 1,
                                                      backgroundColor: AppColors.primaryColor,
                                                      textColor: Colors.white,
                                                      fontSize: 16.0);
    } else {
      filePath = 'Error code: ${response.statusCode}';
    }
      }else{
        Fluttertoast.showToast(
                                                      msg: "Please Allow Storage Permissions",
                                                      toastLength: Toast.LENGTH_SHORT,
                                                      gravity: ToastGravity.BOTTOM,
                                                      timeInSecForIosWeb: 1,
                                                      backgroundColor: AppColors.primaryColor,
                                                      textColor: Colors.white,
                                                      fontSize: 16.0);
      }
  } catch (exception) {
    if (AppConstants.livemode) {
          await Sentry.captureException(exception);
        }
    filePath = 'Can not fetch url';
  }

  return filePath;
}

// Future<void> saveImageToGallery(Uint8List imageBytes) async {
//   final result = await ImageGallerySaver.saveImage(imageBytes);
//   try {
//   if (result['isSuccess']) {
//     debugPrint('Image saved successfully');
//   } else {
//     debugPrint('Failed to save image: ${result['error']}');
//   }  
//   } catch (e) {
//     debugPrint(e);
//   }
  
// }


convertStringToJson(String inputString) async{
  // Remove left and right brackets from the input string
  inputString = inputString.replaceAll('{', '').replaceAll('}', '');
  // Split the input string by commas and trim each part
  List<String> parts = inputString.split(',').map((e) => e.trim()).toList();

  // Define a map to store key-value pairs
  Map<String, dynamic> jsonMap = {};

  // Iterate over the parts
  for (String part in parts) {
    // Split each part by colon to separate key and value
    List<String> keyValue = part.split(':').map((e) => e.trim()).toList();

    // Extract the key and value
    String key = keyValue[0];
    String value = keyValue[1];

    // Add the key-value pair to the map
    // If the value is not already enclosed in double quotes, enclose it
    if (!value.startsWith('"') && !value.endsWith('"')) {
      value = value;
    }
    jsonMap[key] = value;
  }

  return jsonMap;
}

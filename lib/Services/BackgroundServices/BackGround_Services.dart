import 'package:background_fetch/background_fetch.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:gleam_hr/Utils/AppConstants.dart';
import 'package:gleam_hr/Utils/Methods.dart';
import 'package:gleam_hr/Utils/checkInternetPermission.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';

@pragma('vm:entry-point')
void backgroundFetchHeadlessTask(HeadlessTask task) async {
  String taskId = task.taskId;
  bool isTimeout = task.timeout;
  if (isTimeout) {
    // This task has exceeded its allowed running-time.  You must stop what you're doing and immediately .finish(taskId)
    debugPrint("[BackgroundFetch] Headless task timed-out: $taskId");
    BackgroundFetch.finish(taskId);
    return;
  }
  debugPrint("[BackgroundFetch] Headless event received: $taskId");
  if (await checkinternetconnection()) {
    await backgroundForegroundFetch();
  } else {
    storelocalData();
    //here i store local data  
  }
  BackgroundFetch.finish(taskId);
}

storelocalData()async{
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  Map<String,dynamic> offlineData = {"latitude": 0.0, "longitude": 0.0, "user_id": AppConstants.loginmodell!.userData!.id.toString(), "time": DateTime.now(), "show_message": "No Internet Connection"};
  AppConstants.item = prefs.getStringList('localData')==null?[]:prefs.getStringList('localData')!;
  AppConstants.item.add(offlineData.toString());
  prefs.setStringList('localData', AppConstants.item);
}
pushlocalData()async{
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  AppConstants.item = prefs.getStringList('localData')==null?[]:prefs.getStringList('localData')!;
  if(AppConstants.item.isNotEmpty){
    AppConstants.item.forEach((element) async {
      Map<String, dynamic> offlineData =await convertStringToJson(element);
      await FirebaseFirestore.instance.collection("Users").add(offlineData).then((value) {
        debugPrint("User addedd");
      }).catchError((onError) {
        debugPrint("error in location adding");
      });
    });
    prefs.remove('localData');
    AppConstants.item.clear();
  }
}

backgroundForegroundFetch() async {
  await pushlocalData();
  String permissionErrorMessage =await getlocationPermissions();
  if (await checkinternetconnection()) {
    final permissionStatus = await Permission.location.request();
    if (permissionStatus.isGranted && permissionErrorMessage=="") {
      debugPrint("Location permission granted true");
      await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      ).then(
        (Position position) async {
          await FirebaseFirestore.instance.collection("Users").add({
            "latitude": position.latitude,
            "longitude": position.longitude,
            "user_id": AppConstants.loginmodell!.userData!.id.toString(),
            "time": DateTime.now(),
            "show_message": permissionErrorMessage,
          }).then((value) {
            debugPrint("User added${DateTime.now()}");
          }).catchError((onError) {
            debugPrint("error in location adding");
          });
        },
      );
    } else {
      await FirebaseFirestore.instance.collection("Users").add({
            "latitude": 0.0,
            "longitude": 0.0,
            "user_id": AppConstants.loginmodell!.userData!.id.toString(),
            "time": DateTime.now(),
            "show_message": permissionErrorMessage,
          }).then((value) {
            debugPrint("User added${DateTime.now()}");
          }).catchError((onError) {
            debugPrint("error in location adding");
          });
    }
  }
}

void initPlatformState() async{
  //await backgroundForegroundFetch();
  BackgroundFetch.configure(
    BackgroundFetchConfig(
      minimumFetchInterval: int.parse(AppConstants
          .loginmodell!.userData!.frequency
          .toString()), // minimum interval in minutes
      stopOnTerminate: false,
      enableHeadless: true,
      requiresBatteryNotLow: false,
      requiresCharging: false,
      requiresStorageNotLow: false,
    startOnBoot: false
    ),
    (String taskId) async {
// This callback is fired when the app is in the foreground
      print("[BackgroundFetch] Event received: $taskId");
// Perform tasks here, such as updating UI or fetching data
      await backgroundForegroundFetch();
      BackgroundFetch.finish(taskId);
    },
  );
  BackgroundFetch.registerHeadlessTask(backgroundFetchHeadlessTask);
}


// import 'dart:async';
// import 'dart:io';
// import 'dart:ui';

// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_background_service/flutter_background_service.dart';
// import 'package:flutter_background_service_android/flutter_background_service_android.dart';
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';
// import 'package:geolocator/geolocator.dart';
// import 'package:gleam_hr/Providers/DashBoardProviders/MoreProviders/LiveLocation_Provider.dart';
// import 'package:gleam_hr/Utils/AppConstants.dart';
// import 'package:gleam_hr/Utils/Methods.dart';
// import 'package:intl/intl.dart';
// import 'package:permission_handler/permission_handler.dart';
// import 'package:provider/provider.dart';

// const AndroidNotificationChannel channel = AndroidNotificationChannel(
//   'my_foreground', // id
//   'High Importance Notifications', // title
//   description:
//       'This channel is used for important notifications.', // description
//   importance: Importance.high,
//   playSound: true,
// );

// /// Foreground and Background
// Future<void> initializeService() async {
//   final service = FlutterBackgroundService();
//   // if (await service.isRunning()) {
//   //   debugPrint('Service already running, no need to start again.');
//   //   return;
//   // }
//   final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
//       FlutterLocalNotificationsPlugin();
//   if (Platform.isIOS || Platform.isAndroid) {
//     await flutterLocalNotificationsPlugin.initialize(
//       const InitializationSettings(
//         iOS: DarwinInitializationSettings(),
//         android: AndroidInitializationSettings('ic_bg_service_small'),
//       ),
//     );
//   }

//   await flutterLocalNotificationsPlugin
//       .resolvePlatformSpecificImplementation<
//           AndroidFlutterLocalNotificationsPlugin>()
//       ?.createNotificationChannel(channel);

//   await service.configure(
//     androidConfiguration: AndroidConfiguration(
//       onStart: onStart,
//       autoStart: true,
//       isForegroundMode: true,
//       notificationChannelId: 'my_foreground',
//       initialNotificationContent: 'running',
//       foregroundServiceNotificationId: 888,
//     ),
//     iosConfiguration: IosConfiguration(
//       autoStart: true,
//       onForeground: onStart,
//       onBackground: onIosBackground,
//     ),
//   );
// }

// @pragma('vm:entry-point')
// Future<bool> onIosBackground(ServiceInstance service) async {
//   WidgetsFlutterBinding.ensureInitialized();
//   await runBackgroundandForeGroundTask();
//   return true;
// }

// @pragma('vm:entry-point')
// void onStart(ServiceInstance service) async {
//   await runBackgroundandForeGroundTask();
//   if (service is AndroidServiceInstance) {
//     service.on('setAsBackground').listen((event) {
//       service.setAsBackgroundService();
//     });
//   }
//   service.on('stopService').listen((event) {
//     service.stopSelf();
//   });
// }

// /// Foreground and Background ///
// Future<void> runBackgroundandForeGroundTask() async {
//   WidgetsBinding.instance?.addPostFrameCallback((_) async {
//     final locationPermissionStatus = await Permission.location.request();
//     if (locationPermissionStatus.isGranted) {
//       debugPrint("Location permission granted true");
//       startLocationTracking();
//     } else {
//       debugPrint("Location permission denied");
//     }
//   });
// }

// void startLocationTracking() {
//   AppConstants.liveLocationTimer = Timer.periodic(
//     const Duration(seconds: 30),
//     (Timer timer) async {
//       if (await checkinternetconnection()) {
//         final permissionStatus = await Permission.location.request();
//         if (permissionStatus.isGranted) {
//           debugPrint("Location permission granted true");
//           await Geolocator.getCurrentPosition(
//             desiredAccuracy: LocationAccuracy.high,
//           ).then(
//             (Position position) async {
//               await FirebaseFirestore.instance.collection("Users").add({
//                 "latitude": position.latitude,
//                 "longitude": position.longitude,
//                 "user_id": AppConstants.loginmodell!.userData!.id.toString(),
//                 "time": DateTime.now(),
//               }).then((value) {
//                 debugPrint("User added");
//               }).catchError((onError) {
//                 debugPrint("error in location adding");
//               });
//             },
//           );
//         } else {
//           debugPrint("Location permission denied");
//         }
//       }
//     },
//   );
// }

// Future<void> stopService() async {
//   final service = FlutterBackgroundService();
//   service.invoke("stopService");
// }

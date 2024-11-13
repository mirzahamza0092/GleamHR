// import 'package:flutter_local_notifications/flutter_local_notifications.dart';

// class NotificationHelper {
//  static final FlutterLocalNotificationsPlugin _flutterLocalNotificationPlugin =
//       FlutterLocalNotificationsPlugin();
  
// static const AndroidInitializationSettings _androidInitializationSettings=AndroidInitializationSettings("ic_stat_onesignal_default");

// static void initializeNotification()async{
//   InitializationSettings initializationSettings=const InitializationSettings(
//     android: _androidInitializationSettings,
//   );
//   await _flutterLocalNotificationPlugin.initialize(initializationSettings);
//   const AndroidNotificationDetails("channelId", "channelName",importance: Importance.max,priority: Priority.high);
// }

// static void sendNotification(String title,String body)async{
//   AndroidNotificationDetails androidNotificationDetails=const AndroidNotificationDetails("channelId", "channelName",importance: Importance.max,priority: Priority.high);
//   NotificationDetails notificationDetails = NotificationDetails(android: androidNotificationDetails);
//   await _flutterLocalNotificationPlugin.show(0, title, body, notificationDetails);
// }
// }
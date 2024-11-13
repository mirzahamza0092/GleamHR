import 'dart:io';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:gleam_hr/Bindings/bindings.dart';
import 'package:gleam_hr/Routes/Routes.dart' as route;
import 'package:gleam_hr/Utils/AppConstants.dart';
import 'package:gleam_hr/Utils/Methods.dart';
import 'package:gleam_hr/Utils/sharedPreferenceHelper.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:provider/provider.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await SharedPreferencesHelper().init();
  PackageInfo packageInfo = await PackageInfo.fromPlatform();
  AppConstants.appPackage = packageInfo.version;
  AppConstants.barOptions= SharedPreferencesHelper().getBottomBarFeature();
  if (Platform.isAndroid) {
    // NotificationHelper.initializeNotification();
  }else{
    debugPrint("objectobj3");
    FlutterContacts.config.includeNotesOnIos13AndAbove;
  }
  HttpOverrides.global = MyHttpOverrides();

  HttpOverrides.global = MyHttpOverrides();
  await SentryFlutter.init(
    (options) {
      options.dsn = 'https://cfba4053d83f4b8bbc200463d6201454@sentry.glowlogix.com/2';
    },
    // Init your App.
    appRunner: () => runApp(const MyApp()),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: bindings,
      child: MaterialApp(
        scaffoldMessengerKey: AppConstants.snackbarKey,
        navigatorKey: AppConstants.navigatorKey,
        theme: ThemeData(
          fontFamily: GoogleFonts.poppins().fontFamily,
          primarySwatch: Colors.blue,
        ),
        debugShowCheckedModeBanner: false,
        //forgot password
        // home: test(),

        // recoveryour password 2
        //home: SplashScreen(),
        initialRoute: '/',
        onGenerateRoute: route.generateRoutes,
        // routes: {
        //   '/home': (context) => Home(),
        //   '/': (context) => SplashScreen(),
        // },
      ),
    );
  }
}

class GoToDashBoard extends StatelessWidget {
  const GoToDashBoard({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: bindings,
      child: MaterialApp(
        scaffoldMessengerKey: AppConstants.snackbarKey,
        navigatorKey: AppConstants.navigatorKey,
        // home: const SplashScreen(),
        title: "GleamHR",
        theme: ThemeData(
          fontFamily: GoogleFonts.poppins().fontFamily,
          primarySwatch: Colors.blue,
        ),
        debugShowCheckedModeBanner: false,
        initialRoute: '/',
        onGenerateRoute: route.generateRoutes,
      ),
    );
  }
}

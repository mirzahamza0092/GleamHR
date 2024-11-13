import 'package:flutter/material.dart';
import 'package:gleam_hr/Screens/Auth/DomainScreen.dart';
import 'package:gleam_hr/Screens/Auth/LoginOnboarding.dart';
import 'package:gleam_hr/Screens/Auth/LoginScreen.dart';
import 'package:gleam_hr/Screens/Auth/SetPassword.dart';
import 'package:gleam_hr/Screens/Auth/SplashScreen.dart';
import 'package:gleam_hr/Screens/Auth/VerifyPassword.dart';
import 'package:gleam_hr/Screens/DashBoard/BottomNavigation.dart';
import 'package:gleam_hr/Screens/DashBoard/Home/DashboardScreen.dart';
import 'package:gleam_hr/Screens/DashBoard/Inbox/InboxScreen.dart';
import 'package:gleam_hr/Screens/DashBoard/More/MoreScreens/ChangeEmployeeRole.dart';
import 'package:gleam_hr/Screens/DashBoard/More/MoreScreens/ChangePasswordScreen.dart';
import 'package:gleam_hr/Screens/DashBoard/More/MoreScreens/EmployeeRegisterScreen.dart';
import 'package:gleam_hr/Screens/DashBoard/More/MoreScreens/EmployeeShift.dart';
import 'package:gleam_hr/Screens/DashBoard/More/MoreScreens/OfficesList.dart';
import 'package:gleam_hr/Screens/DashBoard/More/MoreScreens/SettingScreen.dart';
import 'package:gleam_hr/Screens/DashBoard/More/MoreScreens/TrackedEmployee.dart';
import 'package:gleam_hr/screens/Auth/ForgotPasswordScreen.dart';
import 'package:page_transition/page_transition.dart';

//routes
const String home = '/home';
const String splashscreen = '/';
const String login = 'login';
const String loginOnboarding = 'loginOnboarding';
const String domainscreen = 'domainscreen';
const String forgotpasswordscreen = 'forgotpasswordscreen';
const String verifypassword = 'verifypassword';
const String setpassword = 'setpassword';
const String dashboard = 'dashboard';
const String bottomNav = 'bottomNav';
const String inboxScreen = 'inboxScreen';
const String settingScreen = 'settingScreen';
const String changePasswordScreen = 'changePasswordScreen';
const String employeeRegisterScreen = 'employeeRegisterScreen';
const String setOfficeLocation = 'setOfficeLocation';
const String trackedEmployee = 'trackedEmployee';
const String setLocation = 'setLocation';
const String employeeShift = 'EmployeeShift';
const String changeEmployeeRole = 'changeEmployeeRole';

//cases for the routes
Route<dynamic>? generateRoutes(RouteSettings settings) {
  //  Map<String, dynamic> arguments =
  //         settings.arguments as Map<String, dynamic>;

  switch (settings.name) {
    case splashscreen:
      return PageTransition(
          type: PageTransitionType.bottomToTop,
          child: const SplashScreen(),
          duration: const Duration(milliseconds: 600));
    case login:
      return PageTransition(
          type: PageTransitionType.bottomToTop,
          child: const LoginScreen(),
          duration: const Duration(milliseconds: 600));
    case loginOnboarding:
      return PageTransition(
          type: PageTransitionType.bottomToTop,
          child: const LoginOnboarding(),
          duration: const Duration(milliseconds: 600));
    case domainscreen:
      return PageTransition(
          type: PageTransitionType.topToBottom,
          child: const DomainScreen(),
          duration: const Duration(milliseconds: 600));
    case forgotpasswordscreen:
      return PageTransition(
          type: PageTransitionType.topToBottom,
          child: const ForgotPasswordScreen(),
          duration: const Duration(milliseconds: 600));
    case verifypassword:
      return PageTransition(
          type: PageTransitionType.topToBottom,
          child: const VerifyPassword(),
          duration: const Duration(milliseconds: 600));
    case setpassword:
      return PageTransition(
          type: PageTransitionType.topToBottom,
          child: const SetPassword(),
          duration: const Duration(milliseconds: 600));
    case dashboard:
      return PageTransition(
          type: PageTransitionType.bottomToTop,
          child: const DashboardScreen(),
          duration: const Duration(milliseconds: 600));
    case bottomNav:
      return PageTransition(
          type: PageTransitionType.bottomToTop,
          child: const BottomNavigation(),
          duration: const Duration(milliseconds: 600));
    case inboxScreen:
      return PageTransition(
          type: PageTransitionType.bottomToTop,
          child: const InboxScreen(),
          duration: const Duration(milliseconds: 600));
    case settingScreen:
      return PageTransition(
          type: PageTransitionType.bottomToTop,
          child: const SettingScreen(),
          duration: const Duration(milliseconds: 600));
    case changePasswordScreen:
      return PageTransition(
          type: PageTransitionType.bottomToTop,
          child: const ChangePasswordScreen(),
          duration: const Duration(milliseconds: 600));
    case employeeRegisterScreen:
      return PageTransition(
          type: PageTransitionType.bottomToTop,
          child: const EmployeeRegisterScreen(),
          duration: const Duration(milliseconds: 600));
    case setOfficeLocation:
      return PageTransition(
          type: PageTransitionType.bottomToTop,
          child: const OfficesList(),
          duration: const Duration(milliseconds: 600));
    case trackedEmployee:
      return PageTransition(
          type: PageTransitionType.bottomToTop,
          child: const TrackedEmployees(),
          duration: const Duration(milliseconds: 600));
    case employeeShift:
      return PageTransition(
          type: PageTransitionType.bottomToTop,
          child:  const EmployeeShift(),
          duration: const Duration(milliseconds: 600));      
    case changeEmployeeRole:
      return PageTransition(
          type: PageTransitionType.bottomToTop,
          child:  const ChangeEmployeeRole(),
          duration: const Duration(milliseconds: 600));      
    // case splashscreen:
    //   return MaterialPageRoute(builder: (context) => SplashScreen());
    // case login:
    //   return MaterialPageRoute(builder: (context) => const LoginScreen());
    // case domainscreen:
    //   return MaterialPageRoute(builder: (context) => DomainScreen());

    // case forgotpasswordscreen:
    //   return MaterialPageRoute(builder: (context) => ForgotPasswordScreen());
    // case verifypassword:
    //   return MaterialPageRoute(builder: (context) => VerifyPassword());
    // case setpassword:
    //   return MaterialPageRoute(builder: (context) => const SetPassword());
    // case dashboard:
    //   return MaterialPageRoute(builder: (context) => DashboardScreen());
    // case bottomNav:
    //   return MaterialPageRoute(builder: (context) => BottomNavigation());

    default:
      throw ('This route does not exist');
  }
}

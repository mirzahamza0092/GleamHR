import 'package:flutter/material.dart';

class AppColors {
  static Color primaryColor = const Color(0XFF218AC4);
  static Color secondryColor = const Color(0XFF41A7DE);
  static Color pageBackgroundColor = const Color(0XFFE5E5E5);
  static Color whiteColor = const Color(0XFFFFFFFF);
  static Color blackColor = const Color(0XFF000000);
  static Color greenColor = const Color(0XFF1ECD89);
  static Color success = const Color(0XFF21C46C);
  static Color greenLightColor = const Color.fromARGB(255, 202, 255, 235);
  static Color absentColor = const Color(0XFFC42121).withOpacity(.25);

  static Color redColor = const Color(0XFFF44336);
  static Color redLightColor = const Color.fromARGB(255, 243, 182, 179);
  static Color greyColor = const Color(0XFF082F41);
  static Color hintTextColor = const Color(0XFF808080);
  static Color fillColor = const Color(0XFFF2F2F2);
  static Color textColor = const Color(0XFF0B2F42);
  static Color gradient3 = const Color(0XFF002D3F);
  static Color deepPurple = const Color.fromARGB(255, 2, 72, 100);
  static Color tableUnfillColor = const Color(0XFFF9F9F9);
  static Color tablefillColor = const Color(0XFFEEEEEE);
  static Color tableTextColor = const Color(0XFF929292);
  static Color gradient1 = const Color.fromARGB(0, 45, 63, 1);
  static Color gradient2 = const Color.fromARGB(5, 134, 191, 1);

  static List<Color> gradientcolor = [
    primaryColor,
    secondryColor,
  ];
  static List<Color> tableFillgradientcolor = [
    primaryColor.withOpacity(.10),
    secondryColor.withOpacity(.10),
  ];
}

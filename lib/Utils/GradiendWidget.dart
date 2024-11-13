import 'package:flutter/material.dart';
import 'package:gleam_hr/Utils/Colors.dart';

dynamic gradientwidget = LinearGradient(
  begin: Alignment.topCenter,
  end: Alignment.bottomCenter,
  colors: AppColors.gradientcolor,
);

dynamic horizontalgradientwidget = LinearGradient(
  begin: Alignment.topLeft,
  end: Alignment.topRight,
  colors: AppColors.gradientcolor,
);

dynamic tablegradientwidget = LinearGradient(
  begin: Alignment.topLeft,
  end: Alignment.topRight,
  colors: AppColors.tableFillgradientcolor,
);

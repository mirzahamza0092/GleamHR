import 'package:flutter/material.dart';

class LoginOnboardingProvider extends ChangeNotifier {
  final PageController controller = PageController(initialPage: 0);

  var index = 0;

 setIndex()
 {
  index;
  notifyListeners();
 }
}

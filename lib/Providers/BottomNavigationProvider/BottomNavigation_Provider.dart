import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gleam_hr/Screens/DashBoard/Home/DashboardScreen.dart';
import 'package:gleam_hr/Screens/DashBoard/Me/MeScreen.dart';
import 'package:gleam_hr/Screens/DashBoard/More/MoreScreens/MoreScreen.dart';
import 'package:gleam_hr/Screens/DashBoard/People/PeopleScreen.dart';
import 'package:gleam_hr/Utils/AppPaths.dart';

class BottomNavigationProvider extends ChangeNotifier {
  PageController pageController = PageController();
  int bottomnavindex = 0;

  List<Widget> screenlist = [
    const DashboardScreen(),
    const MeScreen(),
    const PeopleScreen(),
    const MoreScreen(),
    //const PeopleNewScreen(),
  ];
  List<String> iconslist = [
    ImagePath.homeIcon,
    ImagePath.meIcon,
    ImagePath.peopleIcon,
    ImagePath.moreIcon
  ];
  final textlist = [
    "Home",
    "Me",
    "People",
    "More",
  ];

  onPagechanged(int index) {
    bottomnavindex = index;

    notifyListeners();
    debugPrint("index is : $index");
  }

  GlobalKey bottomNavigationKey = GlobalKey();
}

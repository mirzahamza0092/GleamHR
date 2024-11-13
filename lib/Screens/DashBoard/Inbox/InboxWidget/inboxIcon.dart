import "package:flutter/material.dart";
import "package:gleam_hr/Utils/AppPaths.dart";
import "package:gleam_hr/Utils/Colors.dart";
import 'package:flutter_svg/flutter_svg.dart';

class InboxIcon extends StatelessWidget {
  const InboxIcon({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      width: 50,
      decoration: BoxDecoration(
          color: AppColors.primaryColor.withOpacity(.09),
          borderRadius: BorderRadius.circular(8.0)),
      child: Center(
        child: SvgPicture.asset(
          ImagePath.announcIcon,
          height: 20,
          width: 20,
        ),
      ),
    );
  }
}

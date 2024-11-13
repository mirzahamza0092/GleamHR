import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gleam_hr/Components/CommonText.dart';
import 'package:gleam_hr/Utils/Colors.dart';
import 'package:gleam_hr/Utils/SizedBox.dart';

Widget moreMenu({
  required String icon,
  required String text,
  required var onclick,
}) {
  return InkWell(
    onTap: onclick,
    child: Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 15.0, bottom: 15.0,left: 25),
          child: Row(
            children: [
              SvgPicture.asset(
                icon,
                width: 24,
                height: 26,
                color: AppColors.textColor,
              ),
              20.sw,
              CommonTextPoppins(
                  text: text,
                  fontweight: FontWeight.w400,
                  fontsize: 14,
                  color: AppColors.textColor),
                 
            ],
          ),
        ),
          Divider(
              height: 0.5,
              color: AppColors.pageBackgroundColor,
            ),
      ],
    ),
  );
}

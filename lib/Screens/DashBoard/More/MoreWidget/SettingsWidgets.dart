import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gleam_hr/Components/CommonText.dart';
import 'package:gleam_hr/Utils/Colors.dart';

Widget commonSettingListile({
  String icon = "",
  required String text,
  required var onclick,
  var switcherTap,
  bool iconneeded = false,
  IconData iconData = Icons.arrow_forward_ios,
  bool switcherEnabled = false,
  bool changer = false,
}) {
  return Column(
    mainAxisSize: MainAxisSize.min,
    children: [
      Divider(
        height: 0.5,
        color: AppColors.pageBackgroundColor,
      ),
      ListTile(
        horizontalTitleGap: 0,
        contentPadding: const EdgeInsets.symmetric(horizontal: 30),
        onTap: () {
          onclick();
        },
        leading: iconneeded
            ? Icon(
                iconData,
                size: 20,
                color: AppColors.hintTextColor,
              )
            : SvgPicture.asset(
                icon,
                width: 20,
                height: 20,
                color: AppColors.hintTextColor,
              ),
        title: CommonTextPoppins(
            text: text,
            talign: TextAlign.left,
            fontweight: FontWeight.w400,
            fontsize: 14,
            color: AppColors.hintTextColor),
        trailing: switcherEnabled
            ? Transform.scale(
                scale: 0.9,
                child: Switch(
                  onChanged: (val) async {
                    switcherTap(val);
                  },
                  value: changer,
                  activeColor: AppColors.primaryColor,
                  activeTrackColor: AppColors.primaryColor,
                  inactiveThumbColor: AppColors.hintTextColor,
                  inactiveTrackColor: AppColors.pageBackgroundColor,
                ),
              )
            : const SizedBox(),
      ),
    ],
  );
}

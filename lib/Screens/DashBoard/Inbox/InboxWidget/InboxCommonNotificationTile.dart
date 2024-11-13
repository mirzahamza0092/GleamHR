import "package:flutter/material.dart";
import "package:gleam_hr/Components/CommonText.dart";
import "package:gleam_hr/Utils/Colors.dart";
import "package:gleam_hr/Utils/SizedBox.dart";
import "inboxIcon.dart";

class InboxCommonNotificationTile extends StatelessWidget {
  String title, time, readat;
  InboxCommonNotificationTile(
      {required this.title,
      //required this.subtitle,
      required this.readat,
      required this.time,
      super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      // mainAxisSize: MainAxisSize.min,
      children: [
        ListTile(
          leading: const InboxIcon(),
          contentPadding: const EdgeInsets.symmetric(horizontal: 24),
          title: CommonTextPoppins(
              text: title,
              fontweight: FontWeight.w400,
              fontsize: 14,
              textOverflow: TextOverflow.ellipsis,
              talign: TextAlign.left,
              color: AppColors.textColor),
          trailing: Padding(
            padding: const EdgeInsets.only(
              bottom: 34.0,
            ),
            child: CommonTextPoppins(
                text: time,
                textOverflow: TextOverflow.ellipsis,
                talign: TextAlign.left,
                fontweight: FontWeight.w400,
                fontsize: 12,
                color: const Color(0XFFB0B0B0)),
          ),
        ),
        Center(
          child: SizedBox(
              height: 0, width: width(context) * .8, child: const Divider()),
        ),
      ],
    );
  }
}

import 'package:flutter/material.dart';
import 'package:gleam_hr/Components/CommonText.dart';
import 'package:gleam_hr/Utils/Colors.dart';

class SwitchButton extends StatelessWidget {
  var onPressed;
  double width,height;
  String text;
  bool shadowneeded,isactivated;
  SwitchButton({
    required this.onPressed,
    required this.width,
    required this.height,
    required this.text,
    this.shadowneeded = false,
    required this.isactivated,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color:isactivated? AppColors.primaryColor:const Color(0XFFFAFAFA),
          boxShadow: shadowneeded
              ? [
                  BoxShadow(
                      color: AppColors.primaryColor,
                      offset: const Offset(1, 3),
                      blurRadius: 10,
                      spreadRadius: 0),
                ]
              : [],
          borderRadius: BorderRadius.circular(8)),
      child: ElevatedButton(
          onPressed: onPressed,
          style: ButtonStyle(
              elevation: MaterialStateProperty.all(0),
              overlayColor: MaterialStateProperty.all(Colors.transparent),
              backgroundColor: MaterialStateProperty.all(Colors.transparent),
              ),
          child: CommonTextPoppins(
              text: text,
              fontweight: FontWeight.w500,
              fontsize: 14.0,
              color:isactivated? AppColors.whiteColor:AppColors.hintTextColor)),
    );
  }
}
import 'package:flutter/material.dart';
import 'package:gleam_hr/Components/CommonText.dart';
import 'package:gleam_hr/Utils/Colors.dart';
class CorrectionRequestGetDate extends StatelessWidget {
  String text;
  CorrectionRequestGetDate({required this.text,super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8), color: AppColors.fillColor),
      //padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Center(child: CommonTextPoppins(text: text,textOverflow: TextOverflow.ellipsis, fontweight: FontWeight.w400, fontsize: 12, color: AppColors.blackColor),),
    );
  }
}

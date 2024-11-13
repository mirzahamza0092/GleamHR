import 'package:flutter/material.dart';
import 'package:gleam_hr/Components/CommonText.dart';
import 'package:gleam_hr/Utils/Colors.dart';
import 'package:gleam_hr/Utils/SizedBox.dart';

SnackBar appSnackBar(String message) {
  return SnackBar(
          duration: const Duration(seconds: 5),
          content: Row(
            children: [
              Container(height: 20,width: 2,
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.all(Radius.circular(10)),
                color: AppColors.whiteColor,
              ),
              ),20.sw,
              Expanded(child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CommonTextPoppins(text: message,fontweight: FontWeight.w500,fontsize: 12,color: AppColors.whiteColor,),
                ],
              )),
            ],
          ),
          backgroundColor: AppColors.textColor,
          elevation: 10,
          behavior: SnackBarBehavior.floating,
          margin: const EdgeInsets.all(15),
        );
}


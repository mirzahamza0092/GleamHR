import 'package:flutter/material.dart';
import 'package:gleam_hr/Components/CommonText.dart';
import 'package:gleam_hr/utils/colors.dart';

Widget AdminAllCorrectionRequestRow({
  required Color rowColor,
  required String date,
  required String employeeName,
  required String statusText,
  required String requestFor,
  required var actionTap,
  required int status, //1 is approved, 2 => denied, 3 => pending
  Color? textColor = const Color(0XFF929292),
}) {
  return GestureDetector(
    onLongPress: actionTap,
    child: Container(
      color: rowColor,
      child: Row(children: [Expanded(child: SizedBox(
            height: 50,
            child: Center(
              child: CommonTextPoppins(
                  text: employeeName,
                  talign: TextAlign.left,
                  fontweight: FontWeight.w600,
                  fontsize: 11,
                  color: textColor!),
            )),),Expanded(child: SizedBox(
            height: 50,
            child: Center(
              child: CommonTextPoppins(
                  text: date,
                  talign: TextAlign.left,
                  fontweight: FontWeight.w600,
                  fontsize: 11,
                  color: textColor),
            )),
        ),
        Expanded(child: SizedBox(
            height: 50,
            child: Center(
              child: CommonTextPoppins(
                      text: requestFor,
                      talign: TextAlign.left,
                      fontweight: FontWeight.w600,
                      fontsize: 11,
                      color: textColor),
            )),),
        Expanded(child: statusText==""? SizedBox(
          height: 50,width: 90,child: Center(child: Container(height: 30,width: 90, decoration: BoxDecoration(borderRadius: BorderRadius.circular(8),color:status==1? AppColors.success:status==2?const Color(0XFFE34A4A):status==3?AppColors.primaryColor:Colors.orange.withOpacity(.5),),child: Center(child: CommonTextPoppins(text:status==1? "Approved":status==2?"Rejected":status==3?"Pending":"Canceled", fontweight: FontWeight.w500, fontsize: 12, color: AppColors.whiteColor)))),):SizedBox(
            height: 50,
            child: Center(
              child: CommonTextPoppins(
                  text: statusText,
                  talign: TextAlign.left,
                  fontweight: FontWeight.w600,
                  fontsize: 11,
                  color: textColor),
            )),
        ),],),
    ),
  );
}

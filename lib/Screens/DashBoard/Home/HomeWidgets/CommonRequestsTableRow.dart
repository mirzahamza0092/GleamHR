import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gleam_hr/Components/CommonText.dart';
import 'package:gleam_hr/Utils/AppPaths.dart';
import 'package:gleam_hr/utils/colors.dart';

Widget CommonRequestsTableRow({
  required Color rowColor,
  required String date,
  required String srNo,
  required String statusText,
  required String actionText,
  required var actionTap,
  required int status, //1 is approved, 2 => denied, 3 => pending, 4 => canceled
  Color? textColor = const Color(0XFF929292),
}) {
  return Container(
    color: rowColor,
    child: Row(children: [Expanded(child: SizedBox(
          height: 50,
          child: Center(
            child: CommonTextPoppins(
                text: srNo,
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
      ),Expanded(child: statusText==""? SizedBox(
        height: 50,width: 90,child: Center(child: Container(height: 30,width: 90, decoration: BoxDecoration(borderRadius: BorderRadius.circular(8),color:status==1? AppColors.success:status==2?const Color(0XFFE34A4A):status==3?AppColors.primaryColor:Colors.orange.withOpacity(.5),),child: Center(child: CommonTextPoppins(text:status==1? "Approved":status==2?"Rejected":status==3?"Pending":status==4?"Canceled":"", fontweight: FontWeight.w500, fontsize: 12, color: AppColors.whiteColor)))),):SizedBox(
          height: 50,
          child: Center(
            child: CommonTextPoppins(
                text: statusText,
                talign: TextAlign.left,
                fontweight: FontWeight.w600,
                fontsize: 11,
                color: textColor),
          )),
      ),Expanded(child: GestureDetector(
        onTap: actionTap,
        child: SizedBox(
            height: 50,
            child: Center(
              child: actionText == ""
                  ? Container(
                      height: 30,
                      width: 30,
                      decoration: BoxDecoration(
                          color: AppColors.primaryColor.withOpacity(.05),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                              color: AppColors.primaryColor.withOpacity(.20))),
                      child: Center(
                        child: SvgPicture.asset(
                          ImagePath.eyeIcon,
                          color: AppColors.textColor,
                        ),
                      ),
                    )
                  : CommonTextPoppins(
                      text: actionText,
                      talign: TextAlign.left,
                      fontweight: FontWeight.w600,
                      fontsize: 11,
                      color: textColor),
            )),
      ),),],),
  );
}

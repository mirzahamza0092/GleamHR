import 'package:flutter/material.dart';
import 'package:gleam_hr/Components/CommonText.dart';
import 'package:gleam_hr/Models/DashBoardModels/HomeModels/AllCorrectionRequestModel.dart';
import 'package:gleam_hr/Utils/AppPaths.dart';
import 'package:gleam_hr/Utils/Colors.dart';
import 'package:gleam_hr/Utils/SizedBox.dart';

Widget AttendanceRequestDecisionCard({required Datum data,required BuildContext context,required bool isOld}){
  return Container(
    width: width(context),
    decoration: BoxDecoration(borderRadius: BorderRadius.circular(12),color: Colors.white,boxShadow: [BoxShadow(color: AppColors.blackColor.withOpacity(.10),spreadRadius: 0,blurRadius: 40,offset: const Offset(0, 8))]),
    padding:const EdgeInsets.all(20),
    margin:const EdgeInsets.all(20),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
      isOld?CommonTextPoppins(text: "Old Attendance", fontweight: FontWeight.w500,talign: TextAlign.start, fontsize: 16, color: AppColors.textColor):
      CommonTextPoppins(text: "Requested Attendance Changes", fontweight: FontWeight.w500,talign: TextAlign.start, fontsize: 16, color: AppColors.textColor),
      Padding(
        padding:const EdgeInsets.only(left: 10),
        child: Wrap(
          alignment: WrapAlignment.start,
          children: [
          Image.asset(ImagePath.decisionCalender,color: AppColors.primaryColor,width: 20,height:20),
          5.sw,
          CommonTextPoppins(text: "DATE/CHECK IN", fontweight: FontWeight.w500, fontsize: 16, color: AppColors.textColor),
          10.sw,
          CommonTextPoppins(text:data.timeInDate.toString().contains(',')?isOld?data.timeInDate.toString().split(",").first: data.timeInDate.toString().split(",").last:isOld?"-": data.timeInDate.toString(), fontweight: FontWeight.w500, fontsize: 14, color: AppColors.textColor),
          5.sw,
          CommonTextPoppins(text: data.timeIn.toString().contains(',')?isOld?data.timeIn.toString().split(",").first: data.timeIn.toString().split(",").last:isOld?"-": data.timeIn.toString(), fontweight: FontWeight.w500, fontsize: 14, color: AppColors.textColor),
        ],),
      ),
      Padding(
        padding:const EdgeInsets.only(left: 10),
        child: Wrap(
          alignment: WrapAlignment.start,
          children: [
          Image.asset(ImagePath.decisionCalender,color: AppColors.primaryColor,width: 20,height:20),
          5.sw,
          CommonTextPoppins(text: "DATE/CHECK OUT", fontweight: FontWeight.w500, fontsize: 16, color: AppColors.textColor),
          10.sw,
          CommonTextPoppins(text: data.timeOutDate.toString().contains(',')?isOld?data.timeOutDate.toString().split(",").first: data.timeOutDate.toString().split(",").last:isOld?"-": data.timeOutDate.toString(), fontweight: FontWeight.w500, fontsize: 14, color: AppColors.textColor),
          5.sw,
          CommonTextPoppins(text: data.timeOut.toString().contains(',')?isOld?data.timeOut.toString().split(",").first: data.timeOut.toString().split(",").last:isOld?"-": data.timeOut.toString(), fontweight: FontWeight.w500, fontsize: 14, color: AppColors.textColor),
        ],),
      ),
      CommonTextPoppins(text: "CHECK IN Status", fontweight: FontWeight.w500,talign: TextAlign.start, fontsize: 16, color: AppColors.textColor),
      Padding(
        padding: const EdgeInsets.only(left:10.0),
        child: CommonTextPoppins(text: data.timeInStatus.toString().contains(',')?isOld?data.timeInStatus.toString().split(",").first: data.timeInStatus.toString().split(",").last:isOld?"-": data.timeInStatus.toString(), fontweight: FontWeight.w500, fontsize: 14, color: AppColors.textColor),
      ),
      CommonTextPoppins(text: "Reason", fontweight: FontWeight.w500,talign: TextAlign.start, fontsize: 16, color: AppColors.textColor),
      Padding(
        padding: const EdgeInsets.only(left: 10.0),
        child: CommonTextPoppins(text: data.reasonForLeaving.toString()!="null" || data.reasonForLeaving.toString()!=""?data.reasonForLeaving.toString().contains(',')?isOld?data.reasonForLeaving.toString().split(",").first: data.reasonForLeaving.toString().split(",").last:isOld?"-": data.reasonForLeaving.toString():"-", fontweight: FontWeight.w500, fontsize: 14, color: AppColors.textColor),
      ),
      data.status !=""? SizedBox(
        height: 50,width: 90,child: Center(child: Container(height: 30,width: 90, decoration: BoxDecoration(borderRadius: BorderRadius.circular(8),color:data.status!.toLowerCase()=="approved"? AppColors.success:data.status!.toLowerCase()=="rejected"?const Color(0XFFE34A4A):data.status!.toLowerCase()=="pending"?AppColors.primaryColor:AppColors.whiteColor,),child: Center(child: CommonTextPoppins(text:data.status!.toLowerCase()=="approved"? "Approved":data.status!.toLowerCase()=="rejected"?"Rejected":data.status!.toLowerCase()=="pending"?"Pending":"", fontweight: FontWeight.w500, fontsize: 12, color: AppColors.whiteColor)))),):SizedBox(
          height: 50,
          child: Center(
            child: CommonTextPoppins(
                text: data.status.toString(),
                talign: TextAlign.left,
                fontweight: FontWeight.w600,
                fontsize: 11,
                color: data.status!.toLowerCase()=="approved"? AppColors.success:data.status!.toLowerCase()=="rejected"?const Color(0XFFE34A4A):data.status!.toLowerCase()=="pending"?AppColors.primaryColor:AppColors.whiteColor,),
          )),
    ],),
  );
}
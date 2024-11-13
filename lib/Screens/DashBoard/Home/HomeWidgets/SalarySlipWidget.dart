import 'package:flutter/material.dart';
import 'package:gleam_hr/Components/CommonText.dart';
import 'package:gleam_hr/Utils/Colors.dart';
import 'package:gleam_hr/Utils/SizedBox.dart';

Container SalarySlipWidget({required BuildContext context,required String name,required String salaryType,required String mobilenumber,required String tenure,required String grosssalary,required String absents,required String netpayable,required String basicSal,required String salary }) {
    return Container(width: width(context), padding:const EdgeInsets.only(top: 16,left: 16,bottom: 16), margin:const EdgeInsets.symmetric(horizontal: 24,vertical: 32,),decoration: BoxDecoration(borderRadius: BorderRadius.circular(8),border: Border.all(width: 1,color: AppColors.textColor.withOpacity(.25)),color: const Color(0XFFFAFAFA)),
                      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                        CommonTextPoppins(text: "Name",talign: TextAlign.left, fontweight: FontWeight.w500, fontsize: 12, color: AppColors.hintTextColor),
                        CommonTextPoppins(text: name,talign: TextAlign.left, fontweight: FontWeight.w500, fontsize: 14, color: AppColors.textColor),
                        8.sh,
                        CommonTextPoppins(text: "Mobile Number",talign: TextAlign.left, fontweight: FontWeight.w500, fontsize: 12, color: AppColors.hintTextColor),
                        CommonTextPoppins(text: mobilenumber,talign: TextAlign.left, fontweight: FontWeight.w500, fontsize: 14, color: AppColors.textColor),
                        8.sh,CommonTextPoppins(text: "Month",talign: TextAlign.left, fontweight: FontWeight.w500, fontsize: 12, color: AppColors.hintTextColor),
                        CommonTextPoppins(text: tenure,talign: TextAlign.left, fontweight: FontWeight.w500, fontsize: 14, color: AppColors.textColor),
                        8.sh,
                        salaryType=="Gross Salary"?
                        CommonTextPoppins(text: "Gross Salary",talign: TextAlign.left, fontweight: FontWeight.w500, fontsize: 12, color: AppColors.hintTextColor):
                        salaryType=="Bifurcation Salary"?
                        CommonTextPoppins(text: "Basic Salary",talign: TextAlign.left, fontweight: FontWeight.w500, fontsize: 12, color: AppColors.hintTextColor):
                        CommonTextPoppins(text: "Salary",talign: TextAlign.left, fontweight: FontWeight.w500, fontsize: 12, color: AppColors.hintTextColor),
                        salaryType=="Gross Salary"?
                        CommonTextPoppins(text: grosssalary,talign: TextAlign.left, fontweight: FontWeight.w500, fontsize: 14, color: AppColors.textColor):
                        salaryType=="Bifurcation Salary"?
                        CommonTextPoppins(text: basicSal,talign: TextAlign.left, fontweight: FontWeight.w500, fontsize: 14, color: AppColors.textColor):
                        CommonTextPoppins(text: salary,talign: TextAlign.left, fontweight: FontWeight.w500, fontsize: 14, color: AppColors.textColor),
                        8.sh,CommonTextPoppins(text: "Absents",talign: TextAlign.left, fontweight: FontWeight.w500, fontsize: 12, color: AppColors.hintTextColor),
                        CommonTextPoppins(text: absents,talign: TextAlign.left, fontweight: FontWeight.w500, fontsize: 14, color: AppColors.textColor),
                        8.sh,CommonTextPoppins(text: "Net Payable",talign: TextAlign.left, fontweight: FontWeight.w500, fontsize: 12, color: AppColors.hintTextColor),
                        CommonTextPoppins(text: netpayable,talign: TextAlign.left, fontweight: FontWeight.w500, fontsize: 14, color: AppColors.textColor),                     
                      ],),);
  }

import 'package:flutter/material.dart';
import 'package:gleam_hr/Components/CommonBottomSheet.dart';
import 'package:gleam_hr/Components/CommonButton.dart';
import 'package:gleam_hr/Providers/DashBoardProviders/DashBoard_Provider.dart';
import 'package:gleam_hr/Screens/DashBoard/Home/HomeWidgets/CommonDashBoardCard.dart';
import 'package:gleam_hr/Components/CommonText.dart';
import 'package:gleam_hr/Screens/DashBoard/Home/HomeWidgets/SalarySlipWidget.dart';
import 'package:gleam_hr/Utils/AppConstants.dart';
import 'package:gleam_hr/Utils/GeneratePdf.dart';
import 'package:gleam_hr/Utils/AppPaths.dart';
import 'package:gleam_hr/Utils/Colors.dart';
import 'package:gleam_hr/Utils/SizedBox.dart';
import 'package:provider/provider.dart';
import 'PayrollDetail.dart';

class Payroll extends StatelessWidget {
  DashBoardProvider dashBoardProvider;
  
   Payroll({
    required this.dashBoardProvider,
    super.key});

  @override
  
  Widget build(BuildContext context) {
    return CommonDashBoardCard(
      key: context.read<DashBoardProvider>().keypayroll,
                    title: "Payroll",
                    subTitle: "You’re just few clicks away",
                    leadingPath: ImagePath.payroll,
                    color: AppColors.primaryColor.withOpacity(.11),
                    menurequired: true,
                    items:const ["All Payrolls"],
                    menuOnPressed: (value) {
                      Navigator.push(
                      context,
                     MaterialPageRoute(builder: (context) => PayrollDetail(
                        dashBoardProvider: dashBoardProvider,
                     )),
            ); 
                    },
                    buttonOnPressed: () {
                      dashBoardProvider.getPaySlips(
                        PayslipYear: "",
                          employeeid:
                              AppConstants.loginmodell!.userData!.id.toString(),
                          context: context);
                         // AppConstants.paySlipsModel.toString() == "null"? Text("no data"):
                      CommonBottomSheet(
                          context: context,
                          widget: Consumer<DashBoardProvider>(
                            builder: (context, dashboardProvider, child) {
                                debugPrint(AppConstants.paySlipsModel.toString());
                                if (dashboardProvider.payslipsloading) {
                                  return const CircularProgressIndicator.adaptive();
                                }else{
                                  return Container(
                                  padding: const EdgeInsets.only(top: 0),
                                  child: SingleChildScrollView(
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        CommonTextPoppins(
                                            text: "Salary Slip",
                                            fontweight: FontWeight.w600,
                                            fontsize: 20,
                                            color: AppColors.textColor),
                                            
                                        // CommonButton(onPressed: (){
                                        //   Navigator.of(context).push(MaterialPageRoute(builder: (context) => ShowDownloaded()));
                                        // },
                                        // width: width(context)*.5, text: 'View Downloaded'),

                                        AppConstants.paySlipsModel.toString() == "null"? Text("No PaySlip Available",style: TextStyle(fontWeight: FontWeight.w600
                                        ,color: AppColors.primaryColor),):
                                        SalarySlipWidget(
                                            context: context,
                                            salaryType: AppConstants.paySlipsModel!.data![AppConstants.paySlipsModel!.data!.length - 1].basicSalary.toString() !=
                                                    "N/A"
                                                ? "Bifurcation Salary"
                                                : AppConstants.paySlipsModel!.data![AppConstants.paySlipsModel!.data!.length - 1].grossSalary.toString() !=
                                                        "N/A"
                                                    ? "Gross Salary"
                                                    : AppConstants.paySlipsModel!.data![AppConstants.paySlipsModel!.data!.length - 1].salary.toString() != "N/A" &&
                                                            AppConstants.paySlipsModel!.data![AppConstants.paySlipsModel!.data!.length - 1].noOfItems.toString() !=
                                                                "N/A"
                                                        ? "Per Item Salary"
                                                        : "Hourly Salary",
                                            basicSal: AppConstants.paySlipsModel!.data![AppConstants.paySlipsModel!.data!.length - 1].basicSalary
                                                .toString(),
                                            salary: AppConstants.paySlipsModel!.data![AppConstants.paySlipsModel!.data!.length - 1].salary
                                                .toString(),
                                            name: "${AppConstants.loginmodell!.userData!.firstname}" +
                                                " ${(AppConstants.loginmodell!.userData!.lastname).toString() == "null" ? "" : AppConstants.loginmodell!.userData!.lastname} ",
                                            mobilenumber:
                                                AppConstants.loginmodell!.userData!.contactNo.toString() == "null"
                                                    ? "Not Available"
                                                    : AppConstants.loginmodell!
                                                        .userData!.contactNo
                                                        .toString(),
                                            tenure: AppConstants.paySlipsModel!.data![AppConstants.paySlipsModel!.data!.length - 1].tenure.toString(),
                                            grosssalary: AppConstants.paySlipsModel!.data![AppConstants.paySlipsModel!.data!.length - 1].grossSalary.toString(),
                                            absents: AppConstants.paySlipsModel!.data![AppConstants.paySlipsModel!.data!.length - 1].absentCount.toString(),
                                            netpayable: AppConstants.paySlipsModel!.data![AppConstants.paySlipsModel!.data!.length - 1].netPayable.toString()),
                                            AppConstants.paySlipsModel.toString() == "null"? const SizedBox():
                                        Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 40),
                                            child: CommonButton(
                                              onPressed: () {
                                                GeneratePdf(
                                                    context: context,
                                                    wantDownload: true,
                                                    isDowloaded: true,
                                                    startMonthYear: AppConstants.paySlipsModel!.data![AppConstants.paySlipsModel!.data!.length - 1].tenure.toString(),
                                                    salaryType: AppConstants.paySlipsModel!.data![AppConstants.paySlipsModel!.data!.length - 1].basicSalary
                                                                .toString() !=
                                                            "N/A"
                                                        ? "Bifurcation Salary"
                                                        : AppConstants.paySlipsModel!.data![AppConstants.paySlipsModel!.data!.length - 1].grossSalary.toString() !=
                                                                "N/A"
                                                            ? "Gross Salary"
                                                            : AppConstants.paySlipsModel!.data![AppConstants.paySlipsModel!.data!.length - 1].salary.toString() !=
                                                                        "N/A" &&
                                                                    AppConstants.paySlipsModel!.data![AppConstants.paySlipsModel!.data!.length - 1].salary.toString().contains('items') ==
                                                                        true
                                                                ? "Per Item Salary"
                                                                : "Hourly Salary",
                                                    netpay: AppConstants.paySlipsModel!.data![AppConstants.paySlipsModel!.data!.length - 1].netPayable
                                                        .toString(),
                                                    empname: AppConstants
                                                        .loginmodell!
                                                        .userData!
                                                        .firstname
                                                        .toString(),
                                                    employeetatus:
                                                        AppConstants.loginmodell!.userData!.designation.toString() == "null"? "": AppConstants.loginmodell!.userData!.designation["status"].toString() == "1"
                                                            ? "Active"
                                                            : "Non Active",
                                                    designation:AppConstants.loginmodell!.userData!.designation.toString() == "null"? "":  AppConstants
                                                        .loginmodell!
                                                        .userData!
                                                        .designation["designation_name"]
                                                        .toString(),
                                                    saltenure: AppConstants.paySlipsModel!.data![AppConstants.paySlipsModel!.data!.length - 1].tenure.toString(),
                                                    basicsal: AppConstants.paySlipsModel!.data![AppConstants.paySlipsModel!.data!.length - 1].basicSalary.toString(),
                                                    homeallowance: AppConstants.paySlipsModel!.data![AppConstants.paySlipsModel!.data!.length - 1].homeAllowance.toString(),
                                                    noofItems: AppConstants.paySlipsModel!.data![AppConstants.paySlipsModel!.data!.length - 1].noOfItems.toString(),
                                                    salary: AppConstants.paySlipsModel!.data![AppConstants.paySlipsModel!.data!.length - 1].salary.toString(),
                                                    specialallowance: AppConstants.paySlipsModel!.data![AppConstants.paySlipsModel!.data!.length - 1].specialAllowance.toString(),
                                                    totalhour: AppConstants.paySlipsModel!.data![AppConstants.paySlipsModel!.data!.length - 1].totalHours.toString(),
                                                    travelallowance: AppConstants.paySlipsModel!.data![AppConstants.paySlipsModel!.data!.length - 1].travelAllowance.toString(),
                                                    grosssal: AppConstants.paySlipsModel!.data![AppConstants.paySlipsModel!.data!.length - 1].grossSalary.toString(),
                                                    overtimepay: AppConstants.paySlipsModel!.data![AppConstants.paySlipsModel!.data!.length - 1].overtimePay.toString(),
                                                    bonus: AppConstants.paySlipsModel!.data![AppConstants.paySlipsModel!.data!.length - 1].bonus.toString(),
                                                    incometax: AppConstants.paySlipsModel!.data![AppConstants.paySlipsModel!.data!.length - 1].incomeTax.toString(),
                                                    deduction: AppConstants.paySlipsModel!.data![AppConstants.paySlipsModel!.data!.length - 1].deduction.toString(),
                                                    customdeduction: AppConstants.paySlipsModel!.data![AppConstants.paySlipsModel!.data!.length - 1].customDeduction.toString(),
                                                    assetdeduction: AppConstants.paySlipsModel!.data![AppConstants.paySlipsModel!.data!.length - 1].assetDeduction.toString(),
                                                    imageurl: "https://media.licdn.com/dms/image/C4E33AQHbzrIBV14SgA/productpage-logo-image_100_100/0/1631003095532/glowlogix_gleamhrm_logo?e=2147483647&v=beta&t=FK_p3gaHZym7z7VM19ee5kkCLPetSVAzhkWQT6sy16s");
                                              },
                                              width: width(context),
                                              text: "Download Salary Slip",
                                            )),
                                        20.sh,
                                        AppConstants.paySlipsModel.toString() == "null"? const SizedBox():
                                        Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 40),
                                            child: CommonButton2(text: "CANCEL",)
                                            ),
                                        30.sh,
                                      ],
                                    ),
                                  ),
                                );
                              
                                }
                            },
                          ));
                    },
                    textColor: AppColors.primaryColor,
                    buttonTitle: "View Salary Slip");
  }
}
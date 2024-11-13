import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gleam_hr/Components/CommonAppBar.dart';
import 'package:gleam_hr/Components/CommonText.dart';
import 'package:gleam_hr/Screens/DashBoard/More/MoreWidget/MoreMenuWidget.dart';
import 'package:gleam_hr/Utils/AppConstants.dart';
import 'package:gleam_hr/Utils/AppPaths.dart';
import 'package:gleam_hr/Utils/Colors.dart';
import 'package:gleam_hr/Utils/SizedBox.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../../../Components/CommonBottomSheet.dart';
import '../../../../Components/PaySlipDropDown.dart';
import '../../../../Providers/DashBoardProviders/DashBoard_Provider.dart';
import '../../../../Utils/GeneratePdf.dart';

class PayrollDetail extends StatelessWidget {
  DashBoardProvider dashBoardProvider;
   PayrollDetail({super.key,required this.dashBoardProvider});
 List<String> listItem = [];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: AppColors.whiteColor,
        appBar: PreferredSize(
            preferredSize: Size(width(context), 120),
            // child: CommonAppBar(
            //       subtitle: "${AppConstants.loginmodell!.userData.firstname} ${AppConstants.loginmodell!.userData.lastname}",
            //       trailingimagepath:"https://${Keys.domain}.gleamhrm.com/${peopledetails!.userData.picture}"),
            child: InkWell(
              onTap: () {
                //           Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) =>
                // DomainScreen()), (route) => false);
              },
              child: CommonAppBar(
                  subtitle:
                      "${AppConstants.loginmodell!.userData!.firstname} ${(AppConstants.loginmodell!.userData!.lastname).toString() == "null" ? "" : AppConstants.loginmodell!.userData!.lastname}",
                  trailingimagepath:
                      "https://${Keys.domain}.gleamhrm.com/${AppConstants.loginmodell!.userData!.picture}"),
            )),
        body: SingleChildScrollView(
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Padding(
               padding: const EdgeInsets.only(left: 25,top: 25.0, bottom: 15),
               child: Row(
                 children: [
                  GestureDetector(
                    onTap: (){
                      Navigator.pop(context);
                    },
                    child: Icon(Icons.arrow_back,color: AppColors.primaryColor,)),
                  9.sw,
                   CommonTextPoppins(
                                     text: "Payroll",
                                     fontweight: FontWeight.w700,
                                     fontsize: 20,
                                     color: AppColors.textColor),
                 ],
               ),
                          ),
                          moreMenu(
                  icon: ImagePath.SalarySlipIcon, text: "Salary Slips", onclick: () {
                    dashBoardProvider.getPaySlips(
                       PayslipYear: dashBoardProvider.PayslipYear.toString(),
                        employeeid:
                            AppConstants.loginmodell!.userData!.id.toString(),
                        context: context,
                      );
                      CommonBottomSheet(
                          context: context,
                          widget: Consumer<DashBoardProvider>(
                            builder: (context, dashboardProvider, child) {
                              // if (dashboardProvider.payslipsloading == true) {
                              //   return const Center(
                              //     child: CircularProgressIndicator.adaptive(),
                              //   );
                              // } else {
                              return SingleChildScrollView(
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Row(
                                      //mainAxisAlignment: MainAxisAlignment.start,

                                      children: [
                                        20.sw,
                                        GestureDetector(
                                          onTap: (){
                                            Navigator.pop(context);
                                          },
                                          child: Icon(Icons.arrow_back,color: AppColors.primaryColor,)),
                                        100.sw,
                                        Center(
                                          child: CommonTextPoppins(
                                              text: "Salary Slips",
                                              fontweight: FontWeight.w600,
                                              fontsize: 20,
                                              color: AppColors.textColor),
                                        ),
                                      ],
                                    ),
                                    32.sh,
                                    Padding(
                                      padding: const EdgeInsets.only(right:290),
                                      child: CommonTextPoppins(
                                                              text: "YEAR",
                                                              talign: TextAlign
                                                                  .left,
                                                              fontweight:
                                                                  FontWeight
                                                                      .w500,
                                                              fontsize: 12,
                                                              color: AppColors
                                                                  .hintTextColor),
                                    ),
                                    10.sh,
                                     Container(
                                    height: 50,
                                        width: 350,
                                      padding: const EdgeInsets.symmetric(horizontal: 5),
      
                                   decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(12),
          
                                     color: const Color(0XFFFAFAFA)),
                                          child: Center(
                                    child:
                                   PaySlipDropDown(
                                    width: 380,
                                     selectedText: dashBoardProvider.PayslipYear.toString(),
                                     listItem: dashBoardProvider.years,
                                      onchanged: (value)  {
                                     dashBoardProvider.getPaySlips(employeeid: AppConstants.loginmodell!.userData!.id.toString(), PayslipYear: value, context: context);
                                         dashBoardProvider.PayslipYear = value;
                                    },
                                   ),
                                      ),
                                    //30.sh,
                                     ),
                                     Consumer<DashBoardProvider>(
                                      builder: (context, dashBoardProvider,
                                          child) {
                                        if (dashboardProvider
                                                .payslipsloading ==
                                            true) {
                                          return const Center(
                                            child: CircularProgressIndicator
                                                .adaptive(),
                                          );
                                        } else {
                                          return AppConstants.paySlipsModel.toString() == "null"? CommonTextPoppins(text: "No Data Found",
                                          fontweight: FontWeight.w600,
                                          color: AppColors.primaryColor,
                                          fontsize: 15,
                                          ):
                                           ListView.builder(
                                              physics:const NeverScrollableScrollPhysics(),
                                              padding: EdgeInsets.zero,
                                              itemCount: AppConstants
                                                  .paySlipsModel!
                                                  .data!
                                                  .length,
                                               shrinkWrap: true,
                                              itemBuilder:
                                                  (context, index) {
                                                  return Column(
                                                  children: [
                                                    Container(
                                                      decoration:
                                                          BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(8),
                                                        color: const Color(
                                                            0XFFFAFAFA),
                                                      ),
                                                      margin: const EdgeInsets
                                                              .symmetric(
                                                          horizontal: 24,
                                                          vertical: 12),
                                                          
                                                      child: ListTile(
                                                        //contentPadding:const EdgeInsets.all(16),
                                                        title: CommonTextPoppins(
                                                          text: "MONTH",
                                                          talign: TextAlign
                                                              .left,
                                                          fontweight:
                                                              FontWeight
                                                                  .w500,
                                                          fontsize: 12,
                                                          color: AppColors
                                                              .hintTextColor),
                                                        subtitle: CommonTextPoppins(
                                                          text:DateFormat("MMM yyyy").format(DateFormat("dd-MM-yyyy").parse(AppConstants.paySlipsModel!.data![index].tenure.toString().split(' to ')[1])),
                                                          talign: TextAlign
                                                              .left,
                                                          fontweight:
                                                              FontWeight
                                                                  .w500,
                                                          fontsize: 14,
                                                          color: const Color(
                                                                0XFF343434)),

                                                        trailing: SizedBox(
                                                          width: width(context)*.2,
                                                          child: Row(
                                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                            mainAxisSize: MainAxisSize.min,
                                                            children: [
                                                              InkWell(
                                                                  onTap: () {
                                                                    GeneratePdf(
                                                                        context:
                                                                            context,
                                                                        wantDownload: true,
                                                                        isDowloaded: true,
                                                                        salaryType: AppConstants.paySlipsModel!.data![index].basicSalary.toString() !=
                                                                                "N/A"
                                                                            ? "Bifurcation Salary"
                                                                            : AppConstants.paySlipsModel!.data![index].grossSalary.toString() !=
                                                                                    "N/A"
                                                                                ? "Gross Salary"
                                                                                : AppConstants.paySlipsModel!.data![index].salary.toString() != "N/A" &&
                                                                                        AppConstants.paySlipsModel!.data![index].salary.toString().contains('items') ==
                                                                                            true
                                                                                    ? "Per Item Salary"
                                                                                    : "Hourly Salary",
                                                                        startMonthYear: AppConstants.paySlipsModel!.data![index].tenure.toString(),
                                                                        basicsal: AppConstants
                                                                            .paySlipsModel!
                                                                            .data![
                                                                                index]
                                                                            .basicSalary
                                                                            .toString(),
                                                                        homeallowance:
                                                                            AppConstants.paySlipsModel!.data![index].homeAllowance
                                                                                .toString(),
                                                                        noofItems: AppConstants
                                                                            .paySlipsModel!
                                                                            .data![index]
                                                                            .noOfItems
                                                                            .toString(),
                                                                        netpay: AppConstants.paySlipsModel!.data![index].netPayable.toString(),
                                                                        salary: AppConstants.paySlipsModel!.data![index].salary.toString(),
                                                                        specialallowance: AppConstants.paySlipsModel!.data![index].specialAllowance.toString(),
                                                                        totalhour: AppConstants.paySlipsModel!.data![index].totalHours.toString(),
                                                                        travelallowance: AppConstants.paySlipsModel!.data![index].travelAllowance.toString(),
                                                                        empname: AppConstants.loginmodell!.userData!.firstname.toString(),
                                                                        employeetatus:AppConstants.loginmodell!.userData!.designation.toString()=="null"?"": AppConstants.loginmodell!.userData!.designation["status"].toString() == "1" ? "Active" : "Non Active",
                                                                        designation:AppConstants.loginmodell!.userData!.designation.toString()=="null"?"": AppConstants.loginmodell!.userData!.designation["designation_name"].toString(),
                                                                        saltenure: AppConstants.paySlipsModel!.data![index].tenure.toString(),
                                                                        grosssal: AppConstants.paySlipsModel!.data![index].grossSalary.toString(),
                                                                        overtimepay: AppConstants.paySlipsModel!.data![index].overtimePay.toString(),
                                                                        bonus: AppConstants.paySlipsModel!.data![index].bonus.toString(),
                                                                        incometax: AppConstants.paySlipsModel!.data![index].incomeTax.toString(),
                                                                        deduction: AppConstants.paySlipsModel!.data![index].deduction.toString(),
                                                                        customdeduction: AppConstants.paySlipsModel!.data![index].customDeduction.toString(),
                                                                        assetdeduction: AppConstants.paySlipsModel!.data![index].assetDeduction.toString(),
                                                                        imageurl: "https://media.licdn.com/dms/image/C4E33AQHbzrIBV14SgA/productpage-logo-image_100_100/0/1631003095532/glowlogix_gleamhrm_logo?e=2147483647&v=beta&t=FK_p3gaHZym7z7VM19ee5kkCLPetSVAzhkWQT6sy16s");
                                                                  },
                                                                  child: SvgPicture
                                                                      .asset(
                                                                    ImagePath
                                                                        .downloadIcon,
                                                                    color: AppColors
                                                                        .primaryColor,
                                                                  ),
                                                                  ),
                                                              InkWell(
                                                                  onTap: () {
                                                                    GeneratePdf(
                                                                        context:
                                                                            context,
                                                                        wantDownload: true,
                                                                        isDowloaded: false,
                                                                        startMonthYear: AppConstants.paySlipsModel!.data![index].tenure.toString(),
                                                                        salaryType: AppConstants.paySlipsModel!.data![index].basicSalary.toString() !=
                                                                                "N/A"
                                                                            ? "Bifurcation Salary"
                                                                            : AppConstants.paySlipsModel!.data![index].grossSalary.toString() !=
                                                                                    "N/A"
                                                                                ? "Gross Salary"
                                                                                : AppConstants.paySlipsModel!.data![index].salary.toString() != "N/A" &&
                                                                                        AppConstants.paySlipsModel!.data![index].salary.toString().contains('items') ==
                                                                                            true
                                                                                    ? "Per Item Salary"
                                                                                    : "Hourly Salary",
                                                                        basicsal: AppConstants
                                                                            .paySlipsModel!
                                                                            .data![
                                                                                index]
                                                                            .basicSalary
                                                                            .toString(),
                                                                        homeallowance:
                                                                            AppConstants.paySlipsModel!.data![index].homeAllowance
                                                                                .toString(),
                                                                        noofItems: AppConstants
                                                                            .paySlipsModel!
                                                                            .data![index]
                                                                            .noOfItems
                                                                            .toString(),
                                                                        netpay: AppConstants.paySlipsModel!.data![index].netPayable.toString(),
                                                                        salary: AppConstants.paySlipsModel!.data![index].salary.toString(),
                                                                        specialallowance: AppConstants.paySlipsModel!.data![index].specialAllowance.toString(),
                                                                        totalhour: AppConstants.paySlipsModel!.data![index].totalHours.toString(),
                                                                        travelallowance: AppConstants.paySlipsModel!.data![index].travelAllowance.toString(),
                                                                        empname: AppConstants.loginmodell!.userData!.firstname.toString(),
                                                                        employeetatus: AppConstants.loginmodell!.userData!.designation.toString()=="null"?"": AppConstants.loginmodell!.userData!.designation["status"].toString() == "1" ? "Active" : "Non Active",
                                                                        designation: AppConstants.loginmodell!.userData!.designation.toString()=="null"?"":AppConstants.loginmodell!.userData!.designation["designation_name"].toString(),
                                                                        saltenure: AppConstants.paySlipsModel!.data![index].tenure.toString(),
                                                                        grosssal: AppConstants.paySlipsModel!.data![index].grossSalary.toString(),
                                                                        overtimepay: AppConstants.paySlipsModel!.data![index].overtimePay.toString(),
                                                                        bonus: AppConstants.paySlipsModel!.data![index].bonus.toString(),
                                                                        incometax: AppConstants.paySlipsModel!.data![index].incomeTax.toString(),
                                                                        deduction: AppConstants.paySlipsModel!.data![index].deduction.toString(),
                                                                        customdeduction: AppConstants.paySlipsModel!.data![index].customDeduction.toString(),
                                                                        assetdeduction: AppConstants.paySlipsModel!.data![index].assetDeduction.toString(),
                                                                        imageurl: "https://media.licdn.com/dms/image/C4E33AQHbzrIBV14SgA/productpage-logo-image_100_100/0/1631003095532/glowlogix_gleamhrm_logo?e=2147483647&v=beta&t=FK_p3gaHZym7z7VM19ee5kkCLPetSVAzhkWQT6sy16s");
                                                                  },
                                                                  child:Icon(Icons.visibility_outlined,color: AppColors.primaryColor),
                                                                  ),
                                                            ],
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                    const SizedBox(height: 12,)
                                                    
                                                  ],
                                                  
                                                );
                                                
                                              }
                                              
                                              );
                                          
                                        }
                                      },
                                    ),
                                    
                                  ],
                                ),
                              );
                              
                              //}
                            },
                            
                          ),
                          
                          );

                  }
                  ),
                  moreMenu(
                  icon: ImagePath.LoanIcon, text: "Loans", onclick: () {
                  }),
                     moreMenu(
                  icon: ImagePath.TaxCertificationIcon, text: "Tax Collections", onclick: () {
                  }),
                  moreMenu(
                  icon: ImagePath.TaxSlabIcon, text: "Tax Slabs", onclick: () {
                  }), 
                        ]),
              
        ));
  }
}

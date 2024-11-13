import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gleam_hr/Components/CommonBottomSheet.dart';
import 'package:gleam_hr/Components/CommonButton.dart';
import 'package:gleam_hr/Components/CommonDropDown.dart';
import 'package:gleam_hr/Components/CommonText.dart';
import 'package:gleam_hr/Components/CommonTextField.dart';
import 'package:gleam_hr/Providers/DashBoardProviders/HomeProviders/AdminExpenseRequests_Provider.dart';
import 'package:gleam_hr/Providers/DashBoardProviders/HomeProviders/ExpenseRequestProvider.dart';
import 'package:gleam_hr/Screens/DashBoard/Home/HomeWidgets/AdminAllCorrectionRequestRow.dart';
import 'package:gleam_hr/Screens/DashBoard/Home/HomeWidgets/CommonDashBoardCard.dart';
import 'package:gleam_hr/Screens/DashBoard/Home/HomeWidgets/CommonRequestsTableRow.dart';
import 'package:gleam_hr/Screens/DashBoard/Home/HomeWidgets/ExpenseFileWidget.dart';
import 'package:gleam_hr/Screens/DashBoard/People/PeopleWidget/PeopleSearchBar.dart';
import 'package:gleam_hr/Utils/AppConstants.dart';
import 'package:gleam_hr/Utils/AppPaths.dart';
import 'package:gleam_hr/Utils/Colors.dart';
import 'package:gleam_hr/Utils/SizedBox.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

class ExpenseRequest extends StatefulWidget {
  const ExpenseRequest({super.key});

  @override
  State<ExpenseRequest> createState() => _ExpenseRequestState();
}

class _ExpenseRequestState extends State<ExpenseRequest> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {});
    var a = Provider.of<ExpenseRequestProvider>(context, listen: false);
    a.categoryList = [];
    a.message = "";
    a.FetchCategory(context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    BuildContext contexta = context;
    return CommonDashBoardCard(
        title: "Expense Request",
        subTitle: "Now expenses will not be delay",
        leadingPath: ImagePath.ExpenseCardIcon,
        menurequired: true,
        color: AppColors.primaryColor.withOpacity(.11),
        textColor: AppColors.primaryColor,
         items:AppConstants.loginmodell!.userRole![0].type.toString() ==
                "admin"? ["My Requests","All Requests"]:["My Requests"],
        menuOnPressed: (value) {
        if(value=="My Requests"){
                            context.read<ExpenseRequestProvider>().getAllExpenseRequests(context: context);
                CommonBottomSheet(context: context, widget:
                 SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(
                        child: CommonTextPoppins(
                            text: "Expense Requests",
                            talign: TextAlign.left,
                            fontweight: FontWeight.w600,
                            fontsize: 20,
                            color: AppColors.textColor),
                      ),
                      30.sh,
                      Padding(
                        padding: EdgeInsets.zero,
                        child: Consumer<ExpenseRequestProvider>(
                          builder: (context, expenseRequestProvider, child) {
                            return Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            //dropdown
                                            CommonDropDown(
                                              width: 70, 
                                              selectedText: expenseRequestProvider.dropdownSelectedText,
                                               listItem: expenseRequestProvider.dropdownlist, 
                                               onchanged: (value){
                                                expenseRequestProvider.changedropdown(value,context);
                                                }),
                                            //search
                                            SizedBox(
                                              width: width(context)*.40,
                                              child: PeopleSearchBar(controller: expenseRequestProvider.searchController, onvaluechange: (value){
                                                                                    expenseRequestProvider.searchlist =  
                                                                                    AppConstants.allExpenseRequestsmodel!.data!.
                                                                                    where((element) =>
                                              DateFormat('MMM d, y').format(DateTime.parse(expenseRequestProvider.parseApiDate(element.startDate.toString()).toString())).toLowerCase().contains(value.toString().toLowerCase())||
                                              element.status.toString().toLowerCase().contains(value.toString().toLowerCase()))
                                                                                    .toList();
                                                                                    expenseRequestProvider.hitupdate();
                                              }),
                                            ),
                                            PopupMenuButton<String>(
                                              icon: SvgPicture.asset(ImagePath.filterIcon,height: 30),
                                              onSelected: (String value) {
                                                expenseRequestProvider.changeFilterValue(value,context);
                                              },
                                              itemBuilder:
                                                  (BuildContext context) {
                                                return expenseRequestProvider.items
                                                    .map((String item) {
                                                  return PopupMenuItem<String>(
                                                    value: item,
                                                    child: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        CommonTextPoppins(
                                                          text: item,
                                                          fontweight:
                                                              FontWeight.w400,
                                                          fontsize: 12,
                                                          color: AppColors
                                                              .blackColor,
                                                          talign: TextAlign.left,
                                                        ),
                                                        const Divider(
                                                          height: 2,
                                                        )
                                                      ],
                                                    ),
                                                  );
                                                }).toList();
                                              },
                                            ),
                                          ],);
                          },
                        )
                      ),
                      20.sh,
                      CommonRequestsTableRow(rowColor: AppColors.tablefillColor, date: "DATE", srNo: "S.R.#", status: 0,textColor: AppColors.primaryColor, statusText: "STATUS",actionTap: (){},actionText: "ACTION"),
                      Consumer<ExpenseRequestProvider>(
                  builder: (context, expenseRequestProvider, child) {
                    if (expenseRequestProvider.expenseRequestLoading) {
                      return const Center(child: CircularProgressIndicator.adaptive());
                    } else {
                      if(expenseRequestProvider.searchController.text.isEmpty)
                      {
                     return ListView.builder(
                        itemCount:AppConstants.allExpenseRequestsmodel!.data!.length,
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemBuilder:(context, index) { 
                    DateTime? startDateTime = expenseRequestProvider.parseApiDate( AppConstants.allExpenseRequestsmodel!.data![index].startDate.toString());
                     DateTime? endDateTime = expenseRequestProvider.parseApiDate( AppConstants.allExpenseRequestsmodel!.data![index].endDate.toString());
                        return CommonRequestsTableRow(rowColor: index%2==1?AppColors.tablefillColor:AppColors.tableUnfillColor, 
                        date:startDateTime==null?"":DateFormat('MMM d, y').format(DateTime.parse(startDateTime.toString())), srNo: (index+1).toString(), status: AppConstants.allExpenseRequestsmodel!.data![index].status.toString()=="approved"?1:AppConstants.allExpenseRequestsmodel!.data![index].status.toString()=="Denied"?2:AppConstants.allExpenseRequestsmodel!.data![index].status.toString()=="pending"?3:AppConstants.allExpenseRequestsmodel!.data![index].status.toString()=="Canceled"?4:0,statusText: "",
                        actionTap: (){
                          CommonBottomSheet(context: context, widget: SingleChildScrollView(
                            padding:const EdgeInsets.symmetric(horizontal: 12),
                  child: SizedBox(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Center(
                          child: CommonTextPoppins(
                              text: "Status",
                              talign: TextAlign.left,
                              fontweight: FontWeight.w600,
                              fontsize: 20,
                              color: AppColors.textColor),
                        ),
                        30.sh,
                        Row(children: [Expanded(
                          flex: 2,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                            CommonTextPoppins(text: "DATE",talign: TextAlign.left, fontweight: FontWeight.w500, fontsize: 12, color: AppColors.hintTextColor),
                            Row(children: [
                            Expanded(flex: 2, child: Container(height: 50, decoration: BoxDecoration(border: Border.all(color: AppColors.textColor.withOpacity(.25)), color: AppColors.fillColor, borderRadius: BorderRadius.circular(8)), child:Center(child: CommonTextPoppins(talign: TextAlign.center, text:AppConstants.allExpenseRequestsmodel!.data![index].startDate.toString()=="null"? "":startDateTime==null?"":DateFormat('MMMM y').format(DateTime.parse(startDateTime.toString())), fontweight: FontWeight.w400, fontsize: 14, color: AppColors.textColor)))),
                            CommonTextPoppins(text: " - ", fontweight: FontWeight.w400, fontsize: 14, color: AppColors.textColor),
                            Expanded(flex:1, child: Container(height: 50, decoration: BoxDecoration(border: Border.all(color: AppColors.textColor.withOpacity(.25)), color: AppColors.fillColor, borderRadius: BorderRadius.circular(8)), child:Center(child: CommonTextPoppins(talign: TextAlign.center, text:AppConstants.allExpenseRequestsmodel!.data![index].startDate.toString()=="null"? "":startDateTime==null?"":DateFormat('d').format(DateTime.parse(startDateTime.toString())), fontweight: FontWeight.w400, fontsize: 14, color: AppColors.textColor),))),
                            //to
                            CommonTextPoppins(text: " to ", fontweight: FontWeight.w400, fontsize: 14, color: AppColors.textColor),
                            //to
                            Expanded(flex: 2, child: Container(height: 50, decoration: BoxDecoration(border: Border.all(color: AppColors.textColor.withOpacity(.25)), color: AppColors.fillColor, borderRadius: BorderRadius.circular(8)), child:Center(child: CommonTextPoppins(talign: TextAlign.center, text:AppConstants.allExpenseRequestsmodel!.data![index].endDate.toString()=="null"? "":endDateTime==null?"":DateFormat('MMMM y').format(DateTime.parse(endDateTime.toString())), fontweight: FontWeight.w400, fontsize: 14, color: AppColors.textColor)))),
                            CommonTextPoppins(text: " - ", fontweight: FontWeight.w400, fontsize: 14, color: AppColors.textColor),
                            Expanded(flex:1, child: Container(height: 50, decoration: BoxDecoration(border: Border.all(color: AppColors.textColor.withOpacity(.25)), color: AppColors.fillColor, borderRadius: BorderRadius.circular(8)), child:Center(child: CommonTextPoppins(talign: TextAlign.center, text:AppConstants.allExpenseRequestsmodel!.data![index].endDate.toString()=="null"? "":endDateTime==null?"":DateFormat('d').format(DateTime.parse(endDateTime.toString())).toString(), fontweight: FontWeight.w400, fontsize: 14, color: AppColors.textColor),))),
                            const Expanded(flex:1, child: SizedBox()),
                            ],),
                             16.sh,
                            CommonTextPoppins(text: "Expense Category",talign: TextAlign.left, fontweight: FontWeight.w500, fontsize: 12, color: AppColors.hintTextColor),
                            5.sh,
                            Container(padding:const EdgeInsets.symmetric(horizontal: 20,vertical: 10),alignment: Alignment.centerLeft,height: 50, decoration: BoxDecoration(border: Border.all(color: AppColors.textColor.withOpacity(.25)), color: AppColors.fillColor, borderRadius: BorderRadius.circular(8)), child:CommonTextPoppins(talign: TextAlign.left, text: AppConstants.allExpenseRequestsmodel!.data![index].expenseCategory.toString(), fontweight: FontWeight.w400, fontsize: 14, color: AppColors.textColor)),
                            16.sh,
                            CommonTextPoppins(text: "Reason",talign: TextAlign.left, fontweight: FontWeight.w500, fontsize: 12, color: AppColors.hintTextColor),
                            5.sh,
                            Container(padding:const EdgeInsets.symmetric(horizontal: 20,vertical: 10),alignment: Alignment.centerLeft,height: 50, decoration: BoxDecoration(border: Border.all(color: AppColors.textColor.withOpacity(.25)), color: AppColors.fillColor, borderRadius: BorderRadius.circular(8)), child:CommonTextPoppins(talign: TextAlign.left, text: AppConstants.allExpenseRequestsmodel!.data![index].comment.toString()=='null'?"Not Found":AppConstants.allExpenseRequestsmodel!.data![index].comment.toString(), fontweight: FontWeight.w400, fontsize: 14, color: AppColors.textColor)),
                            ],),
                        ),
                        ],),
                        16.sh,
                        CommonTextPoppins(
                        text: "STATUS",
                        talign: TextAlign.start,
                        fontweight: FontWeight.w500,
                        fontsize: 12,
                        color: AppColors.hintTextColor),
                        4.sh,
                        SizedBox(
                        height: 50,width: 90,child: Center(child: 
                        Container(height: 30,width: 90, decoration: BoxDecoration(borderRadius: BorderRadius.circular(8),
                        //color:status==1? AppColors.success:status==2?const Color(0XFFE34A4A):status==3?AppColors.primaryColor:AppColors.whiteColor,),
                        color:AppConstants.allExpenseRequestsmodel!.data![index].status.toString()=="approved"? AppColors.success:AppConstants.allExpenseRequestsmodel!.data![index].status.toString()=="Denied"? AppColors.redColor:AppConstants.allExpenseRequestsmodel!.data![index].status.toString()=="pending"?AppColors.primaryColor:AppConstants.allExpenseRequestsmodel!.data![index].status.toString()=="Canceled"?AppColors.primaryColor:AppColors.whiteColor),
                        child: Center(child: Text(AppConstants.allExpenseRequestsmodel!.data![index].status.toString(),style: TextStyle(color: AppColors.whiteColor),))))),
                        //child: Center(child: CommonTextPoppins(text:status==1? "Approved":status==2?"REJECTED":status==3?"Pending":"", fontweight: FontWeight.w500, fontsize: 12, color: AppColors.whiteColor)))),),
                        SizedBox(
                            height: 50,
                            child: CommonButton2(text: "BACK")),
                            60.sh,
                    ]),
                  ))
                          );
                        },actionText: "");
                      },);
                      }else if(expenseRequestProvider.searchlist.isNotEmpty)
                     {
                     return ListView.builder(
                        itemCount:expenseRequestProvider.searchlist.length,
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemBuilder:(context, index) { 
                    DateTime? startDateTime = expenseRequestProvider.parseApiDate(expenseRequestProvider.searchlist[index].startDate.toString());
                     DateTime? endDateTime = expenseRequestProvider.parseApiDate( expenseRequestProvider.searchlist[index].endDate.toString());
                        return CommonRequestsTableRow(rowColor: index%2==1?AppColors.tablefillColor:AppColors.tableUnfillColor, 
                        date:startDateTime==null?"":DateFormat('MMM d, y').format(DateTime.parse(startDateTime.toString())), srNo: (index+1).toString(), status: expenseRequestProvider.searchlist[index].status.toString()=="approved"?1:expenseRequestProvider.searchlist[index].status.toString()=="Denied"?2:expenseRequestProvider.searchlist[index].status.toString()=="pending"?3:expenseRequestProvider.searchlist[index].status.toString()=="Canceled"?4:0,statusText: "",
                        actionTap: (){
                          CommonBottomSheet(context: context, widget: SingleChildScrollView(
                            padding:const EdgeInsets.symmetric(horizontal: 12),
                  child: SizedBox(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Center(
                          child: CommonTextPoppins(
                              text: "Status",
                              talign: TextAlign.left,
                              fontweight: FontWeight.w600,
                              fontsize: 20,
                              color: AppColors.textColor),
                        ),
                        30.sh,
                        Row(children: [Expanded(
                          flex: 2,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                            CommonTextPoppins(text: "DATE",talign: TextAlign.left, fontweight: FontWeight.w500, fontsize: 12, color: AppColors.hintTextColor),
                            Row(children: [
                            Expanded(flex: 2, child: Container(height: 50, decoration: BoxDecoration(border: Border.all(color: AppColors.textColor.withOpacity(.25)), color: AppColors.fillColor, borderRadius: BorderRadius.circular(8)), child:Center(child: CommonTextPoppins(talign: TextAlign.center, text:expenseRequestProvider.searchlist[index].startDate.toString()=="null"? "":startDateTime==null?"":DateFormat('MMMM y').format(DateTime.parse(startDateTime.toString())), fontweight: FontWeight.w400, fontsize: 14, color: AppColors.textColor)))),
                            CommonTextPoppins(text: " - ", fontweight: FontWeight.w400, fontsize: 14, color: AppColors.textColor),
                            Expanded(flex:1, child: Container(height: 50, decoration: BoxDecoration(border: Border.all(color: AppColors.textColor.withOpacity(.25)), color: AppColors.fillColor, borderRadius: BorderRadius.circular(8)), child:Center(child: CommonTextPoppins(talign: TextAlign.center, text:expenseRequestProvider.searchlist[index].startDate.toString()=="null"? "":startDateTime==null?"":DateFormat('d').format(DateTime.parse(startDateTime.toString())), fontweight: FontWeight.w400, fontsize: 14, color: AppColors.textColor),))),
                            //to
                            CommonTextPoppins(text: " to ", fontweight: FontWeight.w400, fontsize: 14, color: AppColors.textColor),
                            //to
                            Expanded(flex: 2, child: Container(height: 50, decoration: BoxDecoration(border: Border.all(color: AppColors.textColor.withOpacity(.25)), color: AppColors.fillColor, borderRadius: BorderRadius.circular(8)), child:Center(child: CommonTextPoppins(talign: TextAlign.center, text:expenseRequestProvider.searchlist[index].endDate.toString()=="null"? "":endDateTime==null?"":DateFormat('MMMM y').format(DateTime.parse(endDateTime.toString())), fontweight: FontWeight.w400, fontsize: 14, color: AppColors.textColor)))),
                            CommonTextPoppins(text: " - ", fontweight: FontWeight.w400, fontsize: 14, color: AppColors.textColor),
                            Expanded(flex:1, child: Container(height: 50, decoration: BoxDecoration(border: Border.all(color: AppColors.textColor.withOpacity(.25)), color: AppColors.fillColor, borderRadius: BorderRadius.circular(8)), child:Center(child: CommonTextPoppins(talign: TextAlign.center, text:expenseRequestProvider.searchlist[index].endDate.toString()=="null"? "":endDateTime==null?"":DateFormat('d').format(DateTime.parse(endDateTime.toString())).toString(), fontweight: FontWeight.w400, fontsize: 14, color: AppColors.textColor),))),
                            const Expanded(flex:1, child: SizedBox()),
                            ],),
                             16.sh,
                            CommonTextPoppins(text: "Expense Category",talign: TextAlign.left, fontweight: FontWeight.w500, fontsize: 12, color: AppColors.hintTextColor),
                            5.sh,
                            Container(padding:const EdgeInsets.symmetric(horizontal: 20,vertical: 10),alignment: Alignment.centerLeft,height: 50, decoration: BoxDecoration(border: Border.all(color: AppColors.textColor.withOpacity(.25)), color: AppColors.fillColor, borderRadius: BorderRadius.circular(8)), child:CommonTextPoppins(talign: TextAlign.left, text: expenseRequestProvider.searchlist[index].expenseCategory.toString(), fontweight: FontWeight.w400, fontsize: 14, color: AppColors.textColor)),
                            16.sh,
                            CommonTextPoppins(text: "Reason",talign: TextAlign.left, fontweight: FontWeight.w500, fontsize: 12, color: AppColors.hintTextColor),
                            5.sh,
                            Container(padding:const EdgeInsets.symmetric(horizontal: 20,vertical: 10),alignment: Alignment.centerLeft,height: 50, decoration: BoxDecoration(border: Border.all(color: AppColors.textColor.withOpacity(.25)), color: AppColors.fillColor, borderRadius: BorderRadius.circular(8)), child:CommonTextPoppins(talign: TextAlign.left, text: expenseRequestProvider.searchlist[index].comment.toString()=='null'?"Not Found":expenseRequestProvider.searchlist[index].comment.toString(), fontweight: FontWeight.w400, fontsize: 14, color: AppColors.textColor)),
                            ],),
                        ),
                        ],),
                        16.sh,
                        CommonTextPoppins(
                        text: "STATUS",
                        talign: TextAlign.start,
                        fontweight: FontWeight.w500,
                        fontsize: 12,
                        color: AppColors.hintTextColor),
                        4.sh,
                        SizedBox(
                        height: 50,width: 90,child: Center(child: 
                        Container(height: 30,width: 90, decoration: BoxDecoration(borderRadius: BorderRadius.circular(8),
                        //color:status==1? AppColors.success:status==2?const Color(0XFFE34A4A):status==3?AppColors.primaryColor:AppColors.whiteColor,),
                        color:expenseRequestProvider.searchlist[index].status.toString()=="approved"? AppColors.success:expenseRequestProvider.searchlist[index].status.toString()=="Denied"? AppColors.redColor:expenseRequestProvider.searchlist[index].status.toString()=="pending"?AppColors.primaryColor:expenseRequestProvider.searchlist[index].status.toString()=="Canceled"?AppColors.primaryColor:AppColors.whiteColor),
                        child: Center(child: Text(expenseRequestProvider.searchlist[index].status.toString(),style: TextStyle(color: AppColors.whiteColor),))))),
                        //child: Center(child: CommonTextPoppins(text:status==1? "Approved":status==2?"REJECTED":status==3?"Pending":"", fontweight: FontWeight.w500, fontsize: 12, color: AppColors.whiteColor)))),),
                        SizedBox(
                            height: 50,
                            child: CommonButton2(text: "BACK")),
                            60.sh,
                    ]),
                  ))
                          );
                        },actionText: "");
                      },);
                      }
                      else{
                      return Column(
                        children: [
                          20.sh,
                          Center(
                            child: CommonTextPoppins(
                                        text: "No Search Found",
                                        fontweight: FontWeight.w600,
                                        talign: TextAlign.center,
                                        fontsize: 15,
                                        color: AppColors.primaryColor),
                          ),
                          20.sh,
                        ],
                      );}
                    }
                    
                  },
                ),
                      
                  ])));
              }
              else if(value=="All Requests"){
               context.read<AdminExpenseRequestsProvider>().getAdminExpenseRequests(context: context);
                CommonBottomSheet(context: context, widget:
                 SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(
                        child: CommonTextPoppins(
                            text: "All Expense Requests",
                            talign: TextAlign.left,
                            fontweight: FontWeight.w600,
                            fontsize: 20,
                            color: AppColors.textColor),
                      ),
                      30.sh,
                      Padding(
                        padding: EdgeInsets.zero,
                        child: Consumer<AdminExpenseRequestsProvider>(
                          builder: (context, adminExpenseRequestProvider, child) {
                            return Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            //dropdown
                                            CommonDropDown(width: 70, selectedText: adminExpenseRequestProvider.dropdownSelectedText, listItem: adminExpenseRequestProvider.dropdownlist, onchanged: (value){adminExpenseRequestProvider.changedropdown(value,context);}),
                                            //search
                                            SizedBox(
                                              width: width(context)*.40,
                                              child: PeopleSearchBar(controller: adminExpenseRequestProvider.searchController, onvaluechange: (value){
                                                                                    adminExpenseRequestProvider.searchlist = AppConstants.allExpenseRequestsmodel!.data!
                                                                                    .where((element) =>
                                              DateFormat('MMM d, y').format(DateTime.parse(adminExpenseRequestProvider.parseApiDate(element.startDate.toString()).toString())).toLowerCase().contains(value.toString().toLowerCase())||

                                              DateFormat('MMM d, y').format(DateTime.parse(adminExpenseRequestProvider.parseApiDate(element.startDate.toString()).toString())).toLowerCase().contains(value.toString().toLowerCase())||
                                              DateFormat('MMM d, y').format(DateTime.parse(adminExpenseRequestProvider.parseApiDate(element.endDate.toString()).toString())).toLowerCase().contains(value.toString().toLowerCase()) ||
                                              element.employeeName!.firstname.toString().toLowerCase().contains(value.toString().toLowerCase()) ||
                                              element.status.toString().toLowerCase().contains(value.toString().toLowerCase()))
                                                                                    .toList();
                                                                                    adminExpenseRequestProvider.hitupdate();
                                              }),
                                            ),
                                            PopupMenuButton<String>(
                                              icon: SvgPicture.asset(ImagePath.filterIcon,height: 30),
                                              onSelected: (String value) {
                                                adminExpenseRequestProvider.changeFilterValue(value,context);
                                              },
                                              itemBuilder:
                                                  (BuildContext context) {
                                                return adminExpenseRequestProvider.items
                                                    .map((String item) {
                                                  return PopupMenuItem<String>(
                                                    value: item,
                                                    child: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        CommonTextPoppins(
                                                          text: item,
                                                          fontweight:
                                                              FontWeight.w400,
                                                          fontsize: 12,
                                                          color: AppColors
                                                              .blackColor,
                                                          talign: TextAlign.left,
                                                        ),
                                                        const Divider(
                                                          height: 2,
                                                        )
                                                      ],
                                                    ),
                                                  );
                                                }).toList();
                                              },
                                            ),
                                          ],);
                          },
                        )
                      ),
                      20.sh,
                      CommonRequestsTableRow(rowColor: AppColors.tablefillColor, date: "START DATE", srNo: "EMPLOYEE", status: 0,textColor: AppColors.primaryColor, statusText: "END DATE",actionTap: (){},actionText: "STATUS"),
                      Consumer<AdminExpenseRequestsProvider>(
                  builder: (context, adminExpenseRequestProvider, child) {
                    if (adminExpenseRequestProvider.allExpenseRequestLoading) {
                      return const Center(child: CircularProgressIndicator.adaptive());
                    } else {
                      if(adminExpenseRequestProvider.searchController.text.isEmpty)
                      {
                     return ListView.builder(
                        itemCount:AppConstants.allExpenseRequestsmodel!.data!.length,
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemBuilder:(context, index) {
                           DateTime? startDateTime = adminExpenseRequestProvider.parseApiDate( AppConstants.allExpenseRequestsmodel!.data![index].startDate.toString());
                          DateTime? endDateTime = adminExpenseRequestProvider.parseApiDate( AppConstants.allExpenseRequestsmodel!.data![index].endDate.toString());
                        
                        return AdminAllCorrectionRequestRow(
                          requestFor:endDateTime==null?"":DateFormat('MMM d, y').format(DateTime.parse(endDateTime.toString())),
                           employeeName: AppConstants.allExpenseRequestsmodel!.data![index].employeeName!.firstname.toString(), 
                           rowColor: index%2==1?AppColors.tablefillColor:AppColors.tableUnfillColor, 
                           date: startDateTime==null?"":DateFormat('MMM d, y').format(DateTime.parse(startDateTime.toString())), 
                           status: AppConstants.allExpenseRequestsmodel!.data![index].status.toString()=="approved"?1:AppConstants.allExpenseRequestsmodel!.data![index].status.toString()=="rejected"||AppConstants.allExpenseRequestsmodel!.data![index].status.toString()=="Denied"?2:AppConstants.allExpenseRequestsmodel!.data![index].status.toString()=="pending"?3:AppConstants.allExpenseRequestsmodel!.data![index].status.toString()=="Denied"?4:0,statusText: "",
                        actionTap: (){
                          CommonBottomSheet(context: context, widget: SingleChildScrollView(
                            padding:const EdgeInsets.symmetric(horizontal: 12),
                  child: SizedBox(
                    child: SingleChildScrollView(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Center(
                            child: CommonTextPoppins(
                                text: "Expense Requests Decision",
                                talign: TextAlign.left,
                                fontweight: FontWeight.w600,
                                fontsize: 20,
                                color: AppColors.textColor),
                          ),
                         30.sh,
                        Row(children: [Expanded(
                          flex: 2,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                            CommonTextPoppins(text: "DATE",talign: TextAlign.left, fontweight: FontWeight.w500, fontsize: 12, color: AppColors.hintTextColor),
                            Row(children: [
                            Expanded(flex: 2, child: Container(height: 50, decoration: BoxDecoration(border: Border.all(color: AppColors.textColor.withOpacity(.25)), color: AppColors.fillColor, borderRadius: BorderRadius.circular(8)), child:Center(child: CommonTextPoppins(talign: TextAlign.center, text:AppConstants.allExpenseRequestsmodel!.data![index].startDate.toString()=="null"? "":startDateTime==null?"":DateFormat('MMMM y').format(DateTime.parse(startDateTime.toString())), fontweight: FontWeight.w400, fontsize: 14, color: AppColors.textColor)))),
                            CommonTextPoppins(text: " - ", fontweight: FontWeight.w400, fontsize: 14, color: AppColors.textColor),
                            Expanded(flex:1, child: Container(height: 50, decoration: BoxDecoration(border: Border.all(color: AppColors.textColor.withOpacity(.25)), color: AppColors.fillColor, borderRadius: BorderRadius.circular(8)), child:Center(child: CommonTextPoppins(talign: TextAlign.center, text:AppConstants.allExpenseRequestsmodel!.data![index].startDate.toString()=="null"? "":startDateTime==null?"":DateFormat('d').format(DateTime.parse(startDateTime.toString())), fontweight: FontWeight.w400, fontsize: 14, color: AppColors.textColor),))),
                            //to
                            CommonTextPoppins(text: " to ", fontweight: FontWeight.w400, fontsize: 14, color: AppColors.textColor),
                            //to
                            Expanded(flex: 2, child: Container(height: 50, decoration: BoxDecoration(border: Border.all(color: AppColors.textColor.withOpacity(.25)), color: AppColors.fillColor, borderRadius: BorderRadius.circular(8)), child:Center(child: CommonTextPoppins(talign: TextAlign.center, text:AppConstants.allExpenseRequestsmodel!.data![index].endDate.toString()=="null"? "":endDateTime==null?"":DateFormat('MMMM y').format(DateTime.parse(endDateTime.toString())), fontweight: FontWeight.w400, fontsize: 14, color: AppColors.textColor)))),
                            CommonTextPoppins(text: " - ", fontweight: FontWeight.w400, fontsize: 14, color: AppColors.textColor),
                            Expanded(flex:1, child: Container(height: 50, decoration: BoxDecoration(border: Border.all(color: AppColors.textColor.withOpacity(.25)), color: AppColors.fillColor, borderRadius: BorderRadius.circular(8)), child:Center(child: CommonTextPoppins(talign: TextAlign.center, text:AppConstants.allExpenseRequestsmodel!.data![index].endDate.toString()=="null"? "":endDateTime==null?"":DateFormat('d').format(DateTime.parse(endDateTime.toString())).toString(), fontweight: FontWeight.w400, fontsize: 14, color: AppColors.textColor),))),
                            const Expanded(flex:1, child: SizedBox()),
                            ],),
                            16.sh,
                            CommonTextPoppins(text: "Expense Amount",talign: TextAlign.left, fontweight: FontWeight.w500, fontsize: 12, color: AppColors.hintTextColor),
                            5.sh,
                           Container(padding:const EdgeInsets.symmetric(horizontal: 20,vertical: 10),alignment: Alignment.centerLeft,height: 50, decoration: BoxDecoration(border: Border.all(color: AppColors.textColor.withOpacity(.25)), color: AppColors.fillColor, borderRadius: BorderRadius.circular(8)), child:CommonTextPoppins(talign: TextAlign.left, text: AppConstants.allExpenseRequestsmodel!.data![index].expense.toString(), fontweight: FontWeight.w400, fontsize: 14, color: AppColors.textColor)),
                            16.sh,
                            CommonTextPoppins(text: "Expense Category",talign: TextAlign.left, fontweight: FontWeight.w500, fontsize: 12, color: AppColors.hintTextColor),
                            5.sh,
                           Container(padding:const EdgeInsets.symmetric(horizontal: 20,vertical: 10),alignment: Alignment.centerLeft,height: 50, decoration: BoxDecoration(border: Border.all(color: AppColors.textColor.withOpacity(.25)), color: AppColors.fillColor, borderRadius: BorderRadius.circular(8)), child:CommonTextPoppins(talign: TextAlign.left, text: AppConstants.allExpenseRequestsmodel!.data![index].expenseCategory.toString(), fontweight: FontWeight.w400, fontsize: 14, color: AppColors.textColor)),
                            16.sh,
                            CommonTextPoppins(text: "Reason",talign: TextAlign.left, fontweight: FontWeight.w500, fontsize: 12, color: AppColors.hintTextColor),
                            5.sh,
                            Container(padding:const EdgeInsets.symmetric(horizontal: 20,vertical: 10),alignment: Alignment.centerLeft, decoration: BoxDecoration(border: Border.all(color: AppColors.textColor.withOpacity(.25)), color: AppColors.fillColor, borderRadius: BorderRadius.circular(8)), child:CommonTextPoppins(talign: TextAlign.left, text: AppConstants.allExpenseRequestsmodel!.data![index].comment.toString()=='null'?"Not Found":AppConstants.allExpenseRequestsmodel!.data![index].comment.toString(), fontweight: FontWeight.w400, fontsize: 14, color: AppColors.textColor)),
                            ],),
                        ),
                        ],),
                        16.sh,
                        CommonTextPoppins(
                        text: "STATUS",
                        talign: TextAlign.start,
                        fontweight: FontWeight.w500,
                        fontsize: 12,
                        color: AppColors.hintTextColor),
                         4.sh,
                        SizedBox(
                        height: 50,width: 90,child: Center(child: 
                        Container(height: 30,width: 90, decoration: BoxDecoration(borderRadius: BorderRadius.circular(8),
                        //color:status==1? AppColors.success:status==2?const Color(0XFFE34A4A):status==3?AppColors.primaryColor:AppColors.whiteColor,),
                        color:AppConstants.allExpenseRequestsmodel!.data![index].status.toString()=="approved"? AppColors.success:AppConstants.allExpenseRequestsmodel!.data![index].status.toString()=="Denied"||AppConstants.allExpenseRequestsmodel!.data![index].status.toString()=="rejected"? AppColors.redColor:AppConstants.allExpenseRequestsmodel!.data![index].status.toString()=="pending"?AppColors.primaryColor:AppConstants.allExpenseRequestsmodel!.data![index].status.toString()=="Canceled"?Colors.orange.withOpacity(.5):AppColors.whiteColor),
                        child: Center(child: Text(AppConstants.allExpenseRequestsmodel!.data![index].status.toString(),style: TextStyle(color: AppColors.whiteColor),))))),
                          Consumer<AdminExpenseRequestsProvider>(
                            builder: (context, adminExpenseRequestProvider, child) {
                              return adminExpenseRequestProvider.decisionLoading
                                      ? const Center(
                                          child: CircularProgressIndicator.adaptive(),
                                        )
                                      :
                                  Padding(padding: const EdgeInsets.symmetric(horizontal:25.0),
                                    child: Column(mainAxisSize: MainAxisSize.min, children: [
                                    CommonButtonImage(
                                      onPressed: () {
                                        adminExpenseRequestProvider.approveDenyAdminExpenseRequests(
                                          context: context,
                                           status: "approved", 
                                           expenseId: AppConstants.allExpenseRequestsmodel!.data![index].id.toString(),
                                            employeeId: AppConstants.allExpenseRequestsmodel!.data![index].employeeId.toString(),
                                            expense_type_id: AppConstants.allExpenseRequestsmodel!.data![index].expenseTypeId.toString(),
                                            decision_by: AppConstants.loginmodell!.userData!.id.toString(),
                                            );
                                      },
                                      width: MediaQuery.of(context).size.width,
                                      text: "Approve",
                                      color: AppColors.primaryColor,
                                      image: ImagePath.approveIcon),
                                  20.sh,
                                  DenyButton(
                                      text: "Deny",
                                      ontap: () {
                                        adminExpenseRequestProvider.approveDenyAdminExpenseRequests(
                                          context: context,
                                          status: "rejected",
                                          expenseId: AppConstants.allExpenseRequestsmodel!.data![index].id.toString(),
                                          employeeId: AppConstants.allExpenseRequestsmodel!.data![index].employeeId.toString(),
                                          expense_type_id: AppConstants.allExpenseRequestsmodel!.data![index].expenseTypeId.toString(),
                                          decision_by: AppConstants.loginmodell!.userData!.id.toString(),
                                          );
                                      },
                                      imagePath: ImagePath.denyIcon)
                      ]),
                                    );
                            },
                          )
                    ]),
                  ))
                          ));                     
                        
                        },);
                      },);
                     }
                      else if(adminExpenseRequestProvider.searchlist.isNotEmpty)
                     {
                      return ListView.builder(
                        itemCount:adminExpenseRequestProvider.searchlist.length,//correctionRequestProvider.dropdownSelectedText=="All"? correctionRequestProvider.searchlist.length:int.parse(correctionRequestProvider.dropdownSelectedText)<= correctionRequestProvider.searchlist.length?int.parse(correctionRequestProvider.dropdownSelectedText):correctionRequestProvider.searchlist.length,
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemBuilder:(context, index) {
                          DateTime? startDateTime = adminExpenseRequestProvider.parseApiDate(adminExpenseRequestProvider.searchlist[index].startDate.toString());
                     DateTime? endDateTime = adminExpenseRequestProvider.parseApiDate( adminExpenseRequestProvider.searchlist[index].endDate.toString());
                      
                        return AdminAllCorrectionRequestRow(employeeName: adminExpenseRequestProvider.searchlist[index].employeeName!.firstname.toString(),
                        requestFor:endDateTime==null?"":DateFormat('MMM d, y').format(DateTime.parse(endDateTime.toString())),
                        rowColor: index%2==1?AppColors.tablefillColor:AppColors.tableUnfillColor,
                         date: startDateTime==null?"":DateFormat('MMM d, y').format(DateTime.parse(startDateTime.toString())),
                         status: adminExpenseRequestProvider.searchlist[index].status.toString()=="approved"?1:adminExpenseRequestProvider.searchlist[index].status.toString()=="rejected"||adminExpenseRequestProvider.searchlist[index].status.toString()=="Denied"?2:adminExpenseRequestProvider.searchlist[index].status.toString()=="pending"?3:adminExpenseRequestProvider.searchlist[index].status.toString()=="Denied"?4:0,statusText: "",
                        actionTap: (){
                        CommonBottomSheet(context: context, widget: SingleChildScrollView(
                            padding:const EdgeInsets.symmetric(horizontal: 12),
                  child: SizedBox(
                    child: SingleChildScrollView(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Center(
                            child: CommonTextPoppins(
                                text: "Expense Requests Decision",
                                talign: TextAlign.left,
                                fontweight: FontWeight.w600,
                                fontsize: 20,
                                color: AppColors.textColor),
                          ),
                         30.sh,
                        Row(children: [Expanded(
                          flex: 2,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                            CommonTextPoppins(text: "DATE",talign: TextAlign.left, fontweight: FontWeight.w500, fontsize: 12, color: AppColors.hintTextColor),
                            Row(children: [
                            Expanded(flex: 2, child: Container(height: 50, decoration: BoxDecoration(border: Border.all(color: AppColors.textColor.withOpacity(.25)), color: AppColors.fillColor, borderRadius: BorderRadius.circular(8)), child:Center(child: CommonTextPoppins(talign: TextAlign.center, text:adminExpenseRequestProvider.searchlist[index].startDate.toString()=="null"? "":startDateTime==null?"":DateFormat('MMMM y').format(DateTime.parse(startDateTime.toString())), fontweight: FontWeight.w400, fontsize: 14, color: AppColors.textColor)))),
                            CommonTextPoppins(text: " - ", fontweight: FontWeight.w400, fontsize: 14, color: AppColors.textColor),
                            Expanded(flex:1, child: Container(height: 50, decoration: BoxDecoration(border: Border.all(color: AppColors.textColor.withOpacity(.25)), color: AppColors.fillColor, borderRadius: BorderRadius.circular(8)), child:Center(child: CommonTextPoppins(talign: TextAlign.center, text:adminExpenseRequestProvider.searchlist[index].startDate.toString()=="null"? "":startDateTime==null?"":DateFormat('d').format(DateTime.parse(startDateTime.toString())), fontweight: FontWeight.w400, fontsize: 14, color: AppColors.textColor),))),
                            //to
                            CommonTextPoppins(text: " to ", fontweight: FontWeight.w400, fontsize: 14, color: AppColors.textColor),
                            //to
                            Expanded(flex: 2, child: Container(height: 50, decoration: BoxDecoration(border: Border.all(color: AppColors.textColor.withOpacity(.25)), color: AppColors.fillColor, borderRadius: BorderRadius.circular(8)), child:Center(child: CommonTextPoppins(talign: TextAlign.center, text:adminExpenseRequestProvider.searchlist[index].endDate.toString()=="null"? "":endDateTime==null?"":DateFormat('MMMM y').format(DateTime.parse(endDateTime.toString())), fontweight: FontWeight.w400, fontsize: 14, color: AppColors.textColor)))),
                            CommonTextPoppins(text: " - ", fontweight: FontWeight.w400, fontsize: 14, color: AppColors.textColor),
                            Expanded(flex:1, child: Container(height: 50, decoration: BoxDecoration(border: Border.all(color: AppColors.textColor.withOpacity(.25)), color: AppColors.fillColor, borderRadius: BorderRadius.circular(8)), child:Center(child: CommonTextPoppins(talign: TextAlign.center, text:adminExpenseRequestProvider.searchlist[index].endDate.toString()=="null"? "":endDateTime==null?"":DateFormat('d').format(DateTime.parse(endDateTime.toString())).toString(), fontweight: FontWeight.w400, fontsize: 14, color: AppColors.textColor),))),
                            const Expanded(flex:1, child: SizedBox()),
                            ],),
                           16.sh,
                            CommonTextPoppins(text: "Expense Amount",talign: TextAlign.left, fontweight: FontWeight.w500, fontsize: 12, color: AppColors.hintTextColor),
                            5.sh,
                           Container(padding:const EdgeInsets.symmetric(horizontal: 20,vertical: 10),alignment: Alignment.centerLeft,height: 50, decoration: BoxDecoration(border: Border.all(color: AppColors.textColor.withOpacity(.25)), color: AppColors.fillColor, borderRadius: BorderRadius.circular(8)), child:CommonTextPoppins(talign: TextAlign.left, text: adminExpenseRequestProvider.searchlist[index].expense.toString(), fontweight: FontWeight.w400, fontsize: 14, color: AppColors.textColor)),
                            16.sh,
                            CommonTextPoppins(text: "Expense Category",talign: TextAlign.left, fontweight: FontWeight.w500, fontsize: 12, color: AppColors.hintTextColor),
                            5.sh,
                           Container(padding:const EdgeInsets.symmetric(horizontal: 20,vertical: 10),alignment: Alignment.centerLeft,height: 50, decoration: BoxDecoration(border: Border.all(color: AppColors.textColor.withOpacity(.25)), color: AppColors.fillColor, borderRadius: BorderRadius.circular(8)), child:CommonTextPoppins(talign: TextAlign.left, text: adminExpenseRequestProvider.searchlist[index].expenseCategory.toString(), fontweight: FontWeight.w400, fontsize: 14, color: AppColors.textColor)),
                            16.sh,
                            CommonTextPoppins(text: "Reason",talign: TextAlign.left, fontweight: FontWeight.w500, fontsize: 12, color: AppColors.hintTextColor),
                            5.sh,
                            Container(padding:const EdgeInsets.symmetric(horizontal: 20,vertical: 10),alignment: Alignment.centerLeft, decoration: BoxDecoration(border: Border.all(color: AppColors.textColor.withOpacity(.25)), color: AppColors.fillColor, borderRadius: BorderRadius.circular(8)), child:CommonTextPoppins(talign: TextAlign.left, text: adminExpenseRequestProvider.searchlist[index].comment.toString()=='null'?"Not Found":adminExpenseRequestProvider.searchlist[index].comment.toString(), fontweight: FontWeight.w400, fontsize: 14, color: AppColors.textColor)),
                            ],),
                        ),
                        ],),
                        16.sh,
                        CommonTextPoppins(
                        text: "STATUS",
                        talign: TextAlign.start,
                        fontweight: FontWeight.w500,
                        fontsize: 12,
                        color: AppColors.hintTextColor),
                         4.sh,
                        SizedBox(
                        height: 50,width: 90,child: Center(child: 
                        Container(height: 30,width: 90, decoration: BoxDecoration(borderRadius: BorderRadius.circular(8),
                        //color:status==1? AppColors.success:status==2?const Color(0XFFE34A4A):status==3?AppColors.primaryColor:AppColors.whiteColor,),
                        color:adminExpenseRequestProvider.searchlist[index].status.toString()=="approved"? AppColors.success:adminExpenseRequestProvider.searchlist[index].status.toString()=="Denied"||adminExpenseRequestProvider.searchlist[index].status.toString()=="rejected"? AppColors.redColor:adminExpenseRequestProvider.searchlist[index].status.toString()=="pending"?AppColors.primaryColor:adminExpenseRequestProvider.searchlist[index].status.toString()=="Canceled"?Colors.orange.withOpacity(.5):AppColors.whiteColor),
                        child: Center(child: Text(adminExpenseRequestProvider.searchlist[index].status.toString(),style: TextStyle(color: AppColors.whiteColor),))))),
                          Consumer<AdminExpenseRequestsProvider>(
                            builder: (context, adminExpenseRequestProvider, child) {
                              return adminExpenseRequestProvider.decisionLoading
                                      ? const Center(
                                          child: CircularProgressIndicator.adaptive(),
                                        )
                                      :
                                  Padding(padding: const EdgeInsets.symmetric(horizontal:25.0),
                                    child: Column(mainAxisSize: MainAxisSize.min, children: [
                                    CommonButtonImage(
                                      onPressed: () {
                                        adminExpenseRequestProvider.approveDenyAdminExpenseRequests(
                                          context: context, 
                                          status: "approved", 
                                          expenseId:adminExpenseRequestProvider.searchlist[index].id.toString(),
                                          employeeId:adminExpenseRequestProvider.searchlist[index].employeeId.toString(),
                                          expense_type_id:adminExpenseRequestProvider.searchlist[index].expenseTypeId.toString() ,
                                          decision_by: AppConstants.loginmodell!.userData!.id.toString(),
                                          );
                                      },
                                      width: MediaQuery.of(context).size.width,
                                      text: "Approve",
                                      color: AppColors.primaryColor,
                                      image: ImagePath.approveIcon),
                                  20.sh,
                                  DenyButton(
                                      text: "Deny",
                                      ontap: () {
                                        adminExpenseRequestProvider.approveDenyAdminExpenseRequests(
                                          context: context, 
                                          status: "rejected", 
                                          expenseId:adminExpenseRequestProvider.searchlist[index].id.toString(),
                                          employeeId:adminExpenseRequestProvider.searchlist[index].employeeId.toString(),
                                          expense_type_id:adminExpenseRequestProvider.searchlist[index].expenseTypeId.toString() ,
                                          decision_by: AppConstants.loginmodell!.userData!.id.toString(),
                                          );
                                      },
                                      imagePath: ImagePath.denyIcon)
                      ]),
                                    );
                            },
                          )
                    ]),
                  ))
                          ));                     
                        
                        },);
                      },);
                      }else{
                      return Column(
                        children: [
                          20.sh,
                          Center(
                            child: CommonTextPoppins(
                                        text: "No Search Found",
                                        fontweight: FontWeight.w600,
                                        talign: TextAlign.center,
                                        fontsize: 15,
                                        color: AppColors.primaryColor),
                          ),
                          20.sh,
                        ],
                      );}                    
                    }  
                  },
                ),
                  ])));
              
                
                }}, 
        buttonOnPressed: () {
          CommonBottomSheet(
              context: context,
              widget: Consumer<ExpenseRequestProvider>(
                builder: (context, ERProvider, child) {
                  return Container(
                    margin: const EdgeInsets.only(
                        left: 0, right: 0, top: 0, bottom: 10),
                    padding: const EdgeInsets.symmetric(horizontal: 0),
                    child: SingleChildScrollView(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Center(
                            child: Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: CommonTextPoppins(
                                  text: "Create Expense Request",
                                  fontweight: FontWeight.w600,
                                  fontsize: 18,
                                  color: AppColors.textColor),
                            ),
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.only(left: 24.0, right: 24.0),
                            child: Container(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  CommonTextPoppins(
                                      text: "Expense Category",
                                      talign: TextAlign.left,
                                      fontweight: FontWeight.w500,
                                      fontsize: 12,
                                      color: AppColors.hintTextColor),
                                  10.sh,
                                  CommonDropDown(
                                      width: width(context),
                                      selectedText:
                                          ERProvider.selecteCategoryType,
                                      listItem: ERProvider.categoryTypes,
                                      onchanged: (val) {
                                        ERProvider.changeCategoryTypeValue(val);
                                      }),
                                  10.sh,
                                  CommonTextPoppins(
                                      text: "Expense Type",
                                      talign: TextAlign.left,
                                      fontweight: FontWeight.w500,
                                      fontsize: 12,
                                      color: AppColors.hintTextColor),
                                  10.sh,
                                  CommonDropDown(
                                      width: width(context),
                                      selectedText:
                                          ERProvider.expenseTypeValue!,
                                      listItem: ERProvider.categoryList,
                                      onchanged: (val) {
                                        ERProvider.changeExpenseTypeValue(val);
                                      }),
                                  10.sh,
                                  CommonTextPoppins(
                                      text: "Date Range",
                                      talign: TextAlign.left,
                                      fontweight: FontWeight.w500,
                                      fontsize: 12,
                                      color: AppColors.hintTextColor),
                                  10.sh,
                                  Container(
                                    height: 50,
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(8),
                                        color: AppColors.fillColor),
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 16),
                                    child: InkWell(
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(ERProvider.dateRangeValue),
                                            SvgPicture.asset(
                                              ImagePath.CalenderIcon,
                                              color: AppColors.textColor,
                                              width: 16,
                                              height: 16,
                                            ),
                                          ],
                                        ),
                                        onTap: () {
                                          showDialog(
                                            context: context,
                                            builder: (BuildContext context) {
                                              return AlertDialog(
                                                  shape:const RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.all(
                                                              Radius.circular(
                                                                  10.0))),
                                                  content: Consumer<
                                                          ExpenseRequestProvider>(
                                                      builder: (context,
                                                          ERProvider, child) {
                                                    return SingleChildScrollView(
                                                      child: SizedBox(
                                                        width: MediaQuery.of(
                                                                context)
                                                            .size
                                                            .width,
                                                        child: Center(
                                                          child: Column(
                                                            children: [
                                                              
                                                              SfDateRangePicker(
                                                                monthViewSettings:
                                                                    const DateRangePickerMonthViewSettings(),
                                                                minDate:DateTime.now()
                                                                    ,
                                                                maxDate:
                                                                   DateTime(
                                                                        2025) ,
                                                                rangeTextStyle:
                                                                    TextStyle(
                                                                        color: AppColors
                                                                            .hintTextColor),
                                                                monthCellStyle:
                                                                    DateRangePickerMonthCellStyle(
                                                                  blackoutDatesDecoration: BoxDecoration(
                                                                      color: AppColors
                                                                          .primaryColor
                                                                          .withOpacity(
                                                                              .25),
                                                                      border: Border.all(
                                                                          color: AppColors
                                                                              .redColor,
                                                                          width:
                                                                              1),
                                                                      shape: BoxShape
                                                                          .circle),
                                                                  specialDatesDecoration: BoxDecoration(
                                                                      color: AppColors
                                                                          .primaryColor
                                                                          .withOpacity(
                                                                              .25),
                                                                      border: Border.all(
                                                                          color: AppColors
                                                                              .primaryColor,
                                                                          width:
                                                                              1),
                                                                      shape: BoxShape
                                                                          .circle),
                                                                  textStyle: TextStyle(
                                                                      color: AppColors
                                                                          .hintTextColor),
                                                                ),
                                                                rangeSelectionColor:
                                                                    const Color(
                                                                        0XFFd6ebf6),
                                                                headerStyle: DateRangePickerHeaderStyle(
                                                                    textStyle: TextStyle(
                                                                        color: AppColors
                                                                            .blackColor,
                                                                        fontSize:
                                                                            16,
                                                                        fontWeight:
                                                                            FontWeight.w600)),
                                                                selectionMode:
                                                                    DateRangePickerSelectionMode
                                                                        .range,
                                                                onSelectionChanged:
                                                                    (dateRangePickerSelectionChangedArgs) {
                                                                  ERProvider
                                                                      .changeDateFormat(
                                                                          dateRangePickerSelectionChangedArgs);
                                                                        ERProvider
                                                                          .DateRangeValueSet();  
                                                                    if (dateRangePickerSelectionChangedArgs.value != null &&
                                                                     dateRangePickerSelectionChangedArgs.value.startDate != null &&
                                                                    dateRangePickerSelectionChangedArgs.value.endDate != null) {
                                                                    ERProvider.DateRangeValueSet(); // Set the date range value
                                                                    Navigator.of(context).pop(); // Close the calendar
                                                                     }
                                                                          

                                                                },
                                                              ),
                                                           
                                                            ],
                                                          ),
                                                        ),
                                                      ),
                                                    );
                                                  }));
                                            },
                                          );
                                        }),
                                  ),
                                  CommonTextPoppins(
                                      text: (ERProvider.checkForDateRange)
                                          .toString(),
                                      talign: TextAlign.left,
                                      fontweight: FontWeight.w500,
                                      fontsize: 10,
                                      color: AppColors.redColor),
                                  CommonTextPoppins(
                                      text: "Expense Amount",
                                      talign: TextAlign.left,
                                      fontweight: FontWeight.w500,
                                      fontsize: 12,
                                      color: AppColors.hintTextColor),
                                  10.sh,
                                  CommonTextField(
                                    controller: ERProvider.expenseAmount,
                                    keyboardType: TextInputType.number,
                                    // controller: forgotPasswordProvider.nameoremail,
                                    hinttext: "Enter Expense Amount",
                                  ),
                                  CommonTextPoppins(
                                      text: (ERProvider.checkForExpenseAmount)
                                          .toString(),
                                      talign: TextAlign.left,
                                      fontweight: FontWeight.w500,
                                      fontsize: 10,
                                      color: AppColors.redColor),
                                  Row(
                                    children: [
                                      CommonTextPoppins(
                                          text: "Expense Proof",
                                          talign: TextAlign.left,
                                          fontweight: FontWeight.w500,
                                          fontsize: 12,
                                          color: AppColors.hintTextColor),
                                      CommonTextPoppins(
                                          text: " (PDF & Image only)",
                                          talign: TextAlign.left,
                                          fontweight: FontWeight.w500,
                                          fontsize: 12,
                                          color: AppColors.redColor),
                                    ],
                                  ),
                                  10.sh,
                                  Row(
                                    
                                    children: [
                                      // Container(
                                      //     height: 50,
                                      //     width: 255,
                                      //     decoration: BoxDecoration(
                                      //         borderRadius:
                                      //             BorderRadius.circular(8),
                                      //         color: AppColors.fillColor),
                                      //     padding: const EdgeInsets.all(16),
                                      //     child: ListView(
                                      //       scrollDirection: Axis.horizontal,
                                      //       children: [
                                      //         ERProvider.check
                                      //             ? (Text(
                                      //                 ERProvider.fileName))
                                      //             : Text(
                                      //                 "Choose File",
                                      //               ),
                                      //       ],
                                      //     )),
                                          
                                      InkWell(
                                        onTap: ()=>ERProvider.pickimage(source: ImageSource.camera),
                                        child: Container(
                                          height: 50,
                                          width: 50,
                                          decoration: BoxDecoration(
                                              border: Border.all(
                                                  color:
                                                      const Color(0XFFc9dbe5)),
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              color: const Color(0XFFf3f6f8)),
                                          alignment: Alignment.centerRight,
                                          child: Center(
                                            child: SvgPicture.asset(
                                              ImagePath.camraIcon,
                                              color: AppColors.primaryColor,
                                              width: 12,
                                              height: 16,
                                            ),
                                          ),
                                        ),
                                      ),10.sw,
                                      InkWell(
                                        onTap: () => ERProvider.pickFiles(),
                                        child: Container(
                                          height: 50,
                                          width: 50,
                                          decoration: BoxDecoration(
                                              border: Border.all(
                                                  color:
                                                      const Color(0XFFc9dbe5)),
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              color: const Color(0XFFf3f6f8)),
                                          alignment: Alignment.centerRight,
                                          child: Center(
                                            child: SvgPicture.asset(
                                              ImagePath.filesIcon,
                                              color: AppColors.primaryColor,
                                              width: 12,
                                              height: 16,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  15.sh,
                                   ListView.builder(
                                        physics: const NeverScrollableScrollPhysics(),
                                        shrinkWrap: true,
                                      itemCount: ERProvider.imageList.length,
                                      itemBuilder: (context,index){
                                         String extension =ERProvider.getFileExtension(ERProvider.imageList[index]);
                                          if(extension=='pdf'){
                                          String name= ERProvider.imageList[index].split('/').last.toLowerCase();
                                          return  ExpenseFileWidget(context: context,icon: ImagePath.pdfIcon,title: name,remove: index,see: ERProvider.imageList[index]);
                                     
                                          }else{
                                          String name= ERProvider.imageList[index].split('/').last.toLowerCase();
                                        return  ExpenseFileWidget(context: context,icon: ImagePath.pngIcon,title: name,remove: index,see: ERProvider.imageList[index]);
                                          }                                    
                                                                      }),
                                    10.sh,         
                                  CommonTextPoppins(
                                      text: (ERProvider.checkForExpenseProof)
                                          .toString(),
                                      talign: TextAlign.left,
                                      fontweight: FontWeight.w500,
                                      fontsize: 10,
                                      color: AppColors.redColor),
                                  Row(
                                    children: [
                                      CommonTextPoppins(
                                          text: "Comment",
                                          talign: TextAlign.left,
                                          fontweight: FontWeight.w500,
                                          fontsize: 12,
                                          color: AppColors.hintTextColor),
                                    ],
                                  ),
                                  10.sh,
                                  CommonTextField(
                                    controller: ERProvider.commenetBox,
                                    keyboardType: TextInputType.number,
                                    hinttext: "Enter comment here",
                                  ),
                                  CommonTextPoppins(
                                      text: (ERProvider.checkForComment)
                                          .toString(),
                                      talign: TextAlign.left,
                                      fontweight: FontWeight.w500,
                                      fontsize: 10,
                                      color: AppColors.redColor),
                                  10.sh,
                                  ERProvider.loading
                                      ?const Center(
                                          child: CircularProgressIndicator.adaptive(),
                                        )
                                      :
                                  Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      CommonButton(
                                      onPressed: () {
                                        ERProvider.AddExpense(context);
                                      },
                                      width: 376,
                                      text: 'Add Expense'),
                                  10.sh,
                                  CommonButton2(text: 'Cancel')],)
                                ],
                              ),
                            ),
                          ),
                          10.sh,
                        ],
                      ),
                    ),
                  );
                },
              ));
        },
        buttonTitle: "Add Employee Expense");
  }
}

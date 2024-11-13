import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:gleam_hr/Components/CommonBottomSheet.dart';
import 'package:gleam_hr/Components/CommonButton.dart';
import 'package:gleam_hr/Components/CommonDropDown.dart';
import 'package:gleam_hr/Components/CommonText.dart';
import 'package:gleam_hr/Providers/DashBoardProviders/DashBoard_Provider.dart';
import 'package:gleam_hr/Providers/DashBoardProviders/HomeProviders/AdminTimeOffRequests_Provider.dart';
import 'package:gleam_hr/Providers/DashBoardProviders/HomeProviders/TimeOff_Provider.dart';
import 'package:gleam_hr/Screens/DashBoard/Home/HomeWidgets/AdminAllCorrectionRequestRow.dart';
import 'package:gleam_hr/Screens/DashBoard/Home/HomeWidgets/CommonDashBoardCard.dart';
import 'package:gleam_hr/Screens/DashBoard/Home/HomeWidgets/CommonRequestsTableRow.dart';
import 'package:gleam_hr/Screens/DashBoard/Home/HomeWidgets/DashBoardCalander.dart';
import 'package:gleam_hr/Screens/DashBoard/Home/HomeWidgets/DashBoardExpansionTile.dart';
import 'package:gleam_hr/Screens/DashBoard/People/PeopleWidget/PeopleSearchBar.dart';
import 'package:gleam_hr/Utils/AppConstants.dart';
import 'package:gleam_hr/Utils/AppPaths.dart';
import 'package:gleam_hr/Utils/Colors.dart';
import 'package:gleam_hr/Utils/SizedBox.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class TimeOff extends StatelessWidget {
  const TimeOff({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    BuildContext contexta = context;
    return CommonDashBoardCard(
      key: context.read<DashBoardProvider>().keytimeoff,
       color: AppColors.primaryColor.withOpacity(.11),
        title: "Time Off",
        subTitle: "Hours Available : 0           ",
        //"Hours Available : ${AppConstants.timeoffmodel!.policies![0].policy!.hoursAvailable}",
        leadingPath: ImagePath.timeOff,
        items:AppConstants.loginmodell!.userRole![0].type.toString() ==
                "admin"? ["My Requests","All Requests"]:["My Requests"],
        menuOnPressed: (value) {
          if(value=="My Requests"){
            context.read<TimeOffProvider>().getAllTimeOffRequests(context: context);
            CommonBottomSheet(context: context, widget:
                 SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(
                        child: CommonTextPoppins(
                            text: "Time off Requests",
                            talign: TextAlign.left,
                            fontweight: FontWeight.w600,
                            fontsize: 20,
                            color: AppColors.textColor),
                      ),
                      30.sh,
                      Padding(
                        padding: EdgeInsets.zero,
                        child: Consumer<TimeOffProvider>(
                          builder: (context, timeoffRequestProvider, child) {
                            return Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            //dropdown
                                            Consumer<TimeOffProvider>(
                                              builder: (context, timeOffProvider, child) {
                                                if (timeOffProvider.timeOffRequestLoading) {
                                                 return Container();
                                                }else{
                                                  return CommonDropDown(width: 70, selectedText: timeoffRequestProvider.dropdownSelectedText, listItem: timeoffRequestProvider.dropdownlist, onchanged: (value){timeoffRequestProvider.changedropdown(value,context);});
                                                }
                                              },
                                            ),
                                            //CommonDropDown(width: 70, selectedText: timeoffRequestProvider.dropdownSelectedText, listItem: timeoffRequestProvider.dropdownlist, onchanged: (value){timeoffRequestProvider.changedropdown(value);}),
                                            //search
                                            SizedBox(
                                              width: width(context)*.40,
                                              child: PeopleSearchBar(controller: timeoffRequestProvider.searchController, onvaluechange: (value){
                                                                                    timeoffRequestProvider.searchlist = AppConstants.allTimeOffRequestsmodel!.data!
                                                                                    .where((element) =>
                                              DateFormat('MMM d, y').format(DateTime.parse(element.to.toString())).toLowerCase().contains(value.toString().toLowerCase()) ||
                                              element.status.toString().toLowerCase().contains(value.toString().toLowerCase()) 
                                             )
                                                                                    .toList();
                                                                                    timeoffRequestProvider.hitupdate();
                                              }),
                                            ),
                                            PopupMenuButton<String>(
                                              icon: SvgPicture.asset(ImagePath.filterIcon,height: 30),
                                              onSelected: (String value) {
                                                timeoffRequestProvider.changeFilterValue(value,context);
                                              },
                                              itemBuilder:
                                                  (BuildContext context) {
                                                return timeoffRequestProvider.items
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
                      Consumer<TimeOffProvider>(
                  builder: (context, timeoffRequestProvider, child) {
                    if (timeoffRequestProvider.timeOffRequestLoading) {
                      return const Center(child: CircularProgressIndicator.adaptive());
                    } else {
                      if(timeoffRequestProvider.searchController.text.isEmpty)
                      {
                     return ListView.builder(
                        itemCount:AppConstants.allTimeOffRequestsmodel!.data!.length,
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemBuilder:(context, index) {
                        int totalHours=AppConstants.allTimeOffRequestsmodel!.data![index].requestTimeOffDetail!.fold(0, (previousValue, element) => previousValue+element.hours!);
                        debugPrint("tthours$totalHours");
                        return CommonRequestsTableRow(rowColor: index%2==1?AppColors.tablefillColor:AppColors.tableUnfillColor,
                         date:AppConstants.allTimeOffRequestsmodel!.data![index].to.toString()=="null"? "":DateFormat('MMM d, y').format(DateTime.parse(AppConstants.allTimeOffRequestsmodel!.data![index].to.toString())), srNo: (index+1).toString(), 
                         status: AppConstants.allTimeOffRequestsmodel!.data![index].status.toString()=="approved"?1:AppConstants.allTimeOffRequestsmodel!.data![index].status.toString()=="Denied"||AppConstants.allTimeOffRequestsmodel!.data![index].status.toString()=="rejected"?2:AppConstants.allTimeOffRequestsmodel!.data![index].status.toString()=="pending"?3:AppConstants.allTimeOffRequestsmodel!.data![index].status.toString()=="Canceled"?4:0,statusText: "",
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
                            Expanded(flex: 2, child: Container(height: 50, decoration: BoxDecoration(border: Border.all(color: AppColors.textColor.withOpacity(.25)), color: AppColors.fillColor, borderRadius: BorderRadius.circular(8)), child:Center(child: CommonTextPoppins(talign: TextAlign.center, text:AppConstants.allTimeOffRequestsmodel!.data![index].to.toString()=="null"? "":DateFormat('MMMM y').format(DateTime.parse(AppConstants.allTimeOffRequestsmodel!.data![index].to.toString())), fontweight: FontWeight.w400, fontsize: 14, color: AppColors.textColor)))),
                            CommonTextPoppins(text: " - ", fontweight: FontWeight.w400, fontsize: 14, color: AppColors.textColor),
                            Expanded(flex:1, child: Container(height: 50, decoration: BoxDecoration(border: Border.all(color: AppColors.textColor.withOpacity(.25)), color: AppColors.fillColor, borderRadius: BorderRadius.circular(8)), child:Center(child: CommonTextPoppins(talign: TextAlign.center, text:AppConstants.allTimeOffRequestsmodel!.data![index].to.toString()=="null"? "":DateFormat('d').format(DateTime.parse(AppConstants.allTimeOffRequestsmodel!.data![index].to.toString())), fontweight: FontWeight.w400, fontsize: 14, color: AppColors.textColor),))),
                            //to
                            CommonTextPoppins(text: " to ", fontweight: FontWeight.w400, fontsize: 14, color: AppColors.textColor),
                            //to
                            Expanded(flex: 2, child: Container(height: 50, decoration: BoxDecoration(border: Border.all(color: AppColors.textColor.withOpacity(.25)), color: AppColors.fillColor, borderRadius: BorderRadius.circular(8)), child:Center(child: CommonTextPoppins(talign: TextAlign.center, text:AppConstants.allTimeOffRequestsmodel!.data![index].from.toString()=="null"? "":DateFormat('MMMM y').format(DateTime.parse(AppConstants.allTimeOffRequestsmodel!.data![index].from.toString())), fontweight: FontWeight.w400, fontsize: 14, color: AppColors.textColor)))),
                            CommonTextPoppins(text: " - ", fontweight: FontWeight.w400, fontsize: 14, color: AppColors.textColor),
                            Expanded(flex:1, child: Container(height: 50, decoration: BoxDecoration(border: Border.all(color: AppColors.textColor.withOpacity(.25)), color: AppColors.fillColor, borderRadius: BorderRadius.circular(8)), child:Center(child: CommonTextPoppins(talign: TextAlign.center, text:AppConstants.allTimeOffRequestsmodel!.data![index].from.toString()=="null"? "":DateFormat('d').format(DateTime.parse(AppConstants.allTimeOffRequestsmodel!.data![index].from.toString())).toString(), fontweight: FontWeight.w400, fontsize: 14, color: AppColors.textColor),))),
                            const Expanded(flex:1, child: SizedBox()),
                            ],),
                            16.sh,
                            CommonTextPoppins(text: "Hours",talign: TextAlign.left, fontweight: FontWeight.w500, fontsize: 12, color: AppColors.hintTextColor),
                            5.sh,
                            Container(padding:const EdgeInsets.symmetric(horizontal: 20,vertical: 10),alignment: Alignment.centerLeft, height: 50, decoration: BoxDecoration(border: Border.all(color: AppColors.textColor.withOpacity(.25)), color: AppColors.fillColor, borderRadius: BorderRadius.circular(8)), child:CommonTextPoppins(talign: TextAlign.left, text:totalHours.toString(), fontweight: FontWeight.w400, fontsize: 14, color: AppColors.textColor)),
                            16.sh,
                          //   CommonTextPoppins(text: "Policy Id",talign: TextAlign.left, fontweight: FontWeight.w500, fontsize: 12, color: AppColors.hintTextColor),
                          //   5.sh,
                          //  Container(padding:const EdgeInsets.symmetric(horizontal: 20,vertical: 10),alignment: Alignment.centerLeft,height: 50, decoration: BoxDecoration(border: Border.all(color: AppColors.textColor.withOpacity(.25)), color: AppColors.fillColor, borderRadius: BorderRadius.circular(8)), child:CommonTextPoppins(talign: TextAlign.left, text: AppConstants.allTimeOffRequestsmodel!.data![index].assignTimeOffPolicyId.toString(), fontweight: FontWeight.w400, fontsize: 14, color: AppColors.textColor)),
                          //   16.sh,
                            CommonTextPoppins(text: "Reason",talign: TextAlign.left, fontweight: FontWeight.w500, fontsize: 12, color: AppColors.hintTextColor),
                            5.sh,
                            Container(padding:const EdgeInsets.symmetric(horizontal: 20,vertical: 10),alignment: Alignment.centerLeft,height: 50, decoration: BoxDecoration(border: Border.all(color: AppColors.textColor.withOpacity(.25)), color: AppColors.fillColor, borderRadius: BorderRadius.circular(8)), child:CommonTextPoppins(talign: TextAlign.left, text: AppConstants.allTimeOffRequestsmodel!.data![index].note.toString(), fontweight: FontWeight.w400, fontsize: 14, color: AppColors.textColor)),
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
                        color:AppConstants.allTimeOffRequestsmodel!.data![index].status.toString()=="approved"? AppColors.success:AppConstants.allTimeOffRequestsmodel!.data![index].status.toString()=="Denied"||AppConstants.allTimeOffRequestsmodel!.data![index].status.toString()=="rejected"? AppColors.redColor:AppConstants.allTimeOffRequestsmodel!.data![index].status.toString()=="pending"?AppColors.primaryColor:AppConstants.allTimeOffRequestsmodel!.data![index].status.toString()=="Canceled"? Colors.orange.withOpacity(.5):AppColors.whiteColor),
                        child: Center(child: Text(AppConstants.allTimeOffRequestsmodel!.data![index].status.toString(),style: TextStyle(color: AppColors.whiteColor),))))),
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
                      else if(timeoffRequestProvider.searchlist.isNotEmpty)
                     {
                      return ListView.builder(
                        itemCount: timeoffRequestProvider.searchlist.length,
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemBuilder:(context, index) {
                       int totalHours=timeoffRequestProvider.searchlist[index].requestTimeOffDetail!.fold(0, (previousValue, element) => previousValue+element.hours!);
                        return CommonRequestsTableRow(rowColor: index%2==1?AppColors.tablefillColor:AppColors.tableUnfillColor, 
                        date: timeoffRequestProvider.searchlist[index].to.toString()=="null"? "":DateFormat('MMM d, y').format(DateTime.parse( timeoffRequestProvider.searchlist[index].to.toString())),
                        srNo: (index+1).toString(), status: timeoffRequestProvider.searchlist[index].status.toString()=="approved"?1:timeoffRequestProvider.searchlist[index].status.toString()=="Denied"||timeoffRequestProvider.searchlist[index].status.toString()=="rejected"?2:timeoffRequestProvider.searchlist[index].status.toString()=="pending"?3:timeoffRequestProvider.searchlist[index].status.toString()=="Canceled"?4:0,statusText: "",
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
                            Expanded(flex: 2, child: Container(height: 50, decoration: BoxDecoration(border: Border.all(color: AppColors.textColor.withOpacity(.25)), color: AppColors.fillColor, borderRadius: BorderRadius.circular(8)), child:Center(child: CommonTextPoppins(talign: TextAlign.center, text:timeoffRequestProvider.searchlist[index].to.toString()=="null"? "":DateFormat('MMMM y').format(DateTime.parse(timeoffRequestProvider.searchlist[index].to.toString())), fontweight: FontWeight.w400, fontsize: 14, color: AppColors.textColor)))),
                            CommonTextPoppins(text: " - ", fontweight: FontWeight.w400, fontsize: 14, color: AppColors.textColor),
                            Expanded(flex:1, child: Container(height: 50, decoration: BoxDecoration(border: Border.all(color: AppColors.textColor.withOpacity(.25)), color: AppColors.fillColor, borderRadius: BorderRadius.circular(8)), child:Center(child: CommonTextPoppins(talign: TextAlign.center, text:timeoffRequestProvider.searchlist[index].to.toString()=="null"? "":DateFormat('d').format(DateTime.parse(timeoffRequestProvider.searchlist[index].to.toString())), fontweight: FontWeight.w400, fontsize: 14, color: AppColors.textColor),))),
                            //to
                            CommonTextPoppins(text: " to ", fontweight: FontWeight.w400, fontsize: 14, color: AppColors.textColor),
                            //to
                            Expanded(flex: 2, child: Container(height: 50, decoration: BoxDecoration(border: Border.all(color: AppColors.textColor.withOpacity(.25)), color: AppColors.fillColor, borderRadius: BorderRadius.circular(8)), child:Center(child: CommonTextPoppins(talign: TextAlign.center, text:timeoffRequestProvider.searchlist[index].from.toString()=="null"? "":DateFormat('MMMM y').format(DateTime.parse(timeoffRequestProvider.searchlist[index].from.toString())), fontweight: FontWeight.w400, fontsize: 14, color: AppColors.textColor)))),
                            CommonTextPoppins(text: " - ", fontweight: FontWeight.w400, fontsize: 14, color: AppColors.textColor),
                            Expanded(flex:1, child: Container(height: 50, decoration: BoxDecoration(border: Border.all(color: AppColors.textColor.withOpacity(.25)), color: AppColors.fillColor, borderRadius: BorderRadius.circular(8)), child:Center(child: CommonTextPoppins(talign: TextAlign.center, text:timeoffRequestProvider.searchlist[index].from.toString()=="null"? "":DateFormat('d').format(DateTime.parse(timeoffRequestProvider.searchlist[index].from.toString())).toString(), fontweight: FontWeight.w400, fontsize: 14, color: AppColors.textColor),))),
                            const Expanded(flex:1, child: SizedBox()),
                            ],),
                            16.sh,
                            CommonTextPoppins(text: "Hours",talign: TextAlign.left, fontweight: FontWeight.w500, fontsize: 12, color: AppColors.hintTextColor),
                            5.sh,
                            Container(padding:const EdgeInsets.symmetric(horizontal: 20,vertical: 10),alignment: Alignment.centerLeft, height: 50, decoration: BoxDecoration(border: Border.all(color: AppColors.textColor.withOpacity(.25)), color: AppColors.fillColor, borderRadius: BorderRadius.circular(8)), child:CommonTextPoppins(talign: TextAlign.left, text:totalHours.toString(), fontweight: FontWeight.w400, fontsize: 14, color: AppColors.textColor)),
                            16.sh,
                            // CommonTextPoppins(text: "Policy Id",talign: TextAlign.left, fontweight: FontWeight.w500, fontsize: 12, color: AppColors.hintTextColor),
                            // 5.sh,
                            // Container(padding:const EdgeInsets.symmetric(horizontal: 20,vertical: 10),alignment: Alignment.centerLeft,height: 50, decoration: BoxDecoration(border: Border.all(color: AppColors.textColor.withOpacity(.25)), color: AppColors.fillColor, borderRadius: BorderRadius.circular(8)), child:CommonTextPoppins(talign: TextAlign.left, text: timeoffRequestProvider.searchlist[index].assignTimeOffPolicyId.toString(), fontweight: FontWeight.w400, fontsize: 14, color: AppColors.textColor)),
                            // 16.sh,
                            CommonTextPoppins(text: "Reason",talign: TextAlign.left, fontweight: FontWeight.w500, fontsize: 12, color: AppColors.hintTextColor),
                            5.sh,
                            Container(padding:const EdgeInsets.symmetric(horizontal: 20,vertical: 10),alignment: Alignment.centerLeft,height: 50, decoration: BoxDecoration(border: Border.all(color: AppColors.textColor.withOpacity(.25)), color: AppColors.fillColor, borderRadius: BorderRadius.circular(8)), child:CommonTextPoppins(talign: TextAlign.left, text: timeoffRequestProvider.searchlist[index].note.toString(), fontweight: FontWeight.w400, fontsize: 14, color: AppColors.textColor)),
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
                        color:timeoffRequestProvider.searchlist[index].status.toString()=="approved"? AppColors.success:timeoffRequestProvider.searchlist[index].status.toString()=="Denied"||timeoffRequestProvider.searchlist[index].status.toString()=="rejected"? AppColors.redColor:timeoffRequestProvider.searchlist[index].status.toString()=="pending"?AppColors.primaryColor:timeoffRequestProvider.searchlist[index].status.toString()=="Canceled"?Colors.orange.withOpacity(.5):AppColors.whiteColor),
                        child: Center(child: Text(timeoffRequestProvider.searchlist[index].status.toString(),style: TextStyle(color: AppColors.whiteColor),))))),
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
                      
                  ])));}
                  else if(value=="All Requests"){
                   context.read<AdminTimeOffRequestsProvider>().getAdminTimeOffRequests(context: context);
                CommonBottomSheet(context: context, widget:
                 SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(
                        child: CommonTextPoppins(
                            text: "All Time Off Requests",
                            talign: TextAlign.left,
                            fontweight: FontWeight.w600,
                            fontsize: 20,
                            color: AppColors.textColor),
                      ),
                      30.sh,
                      Padding(
                        padding: EdgeInsets.zero,
                        child: Consumer<AdminTimeOffRequestsProvider>(
                          builder: (context, adminTimeOffRequestProvider, child) {
                            return Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            //dropdown
                                            CommonDropDown(width: 70, selectedText: adminTimeOffRequestProvider.dropdownSelectedText, listItem: adminTimeOffRequestProvider.dropdownlist, onchanged: (value){adminTimeOffRequestProvider.changedropdown(value,context);}),
                                            //search
                                            SizedBox(
                                              width: width(context)*.40,
                                              child: PeopleSearchBar(controller: adminTimeOffRequestProvider.searchController, onvaluechange: (value){
                                                                                    adminTimeOffRequestProvider.searchlist = AppConstants.allTimeOffRequestsmodel!.data!
                                                                                    .where((element) =>
                                              DateFormat('MMM d, y').format(DateTime.parse(element.to.toString())).toLowerCase().contains(value.toString().toLowerCase()) ||
                                              DateFormat('MMM d, y').format(DateTime.parse(element.from.toString())).toLowerCase().contains(value.toString().toLowerCase()) ||
                                              element.employee!.fullName.toString().toLowerCase().contains(value.toString().toLowerCase()) ||
                                              element.status.toString().toLowerCase().contains(value.toString().toLowerCase()))
                                                                                    .toList();
                                                                                    adminTimeOffRequestProvider.hitupdate();
                                              }),
                                            ),
                                            PopupMenuButton<String>(
                                              icon: SvgPicture.asset(ImagePath.filterIcon,height: 30),
                                              onSelected: (String value) {
                                                adminTimeOffRequestProvider.changeFilterValue(value,context);
                                              },
                                              itemBuilder:
                                                  (BuildContext context) {
                                                return adminTimeOffRequestProvider.items
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
                      Consumer<AdminTimeOffRequestsProvider>(
                  builder: (context, adminTimeOffRequestProvider, child) {
                    if (adminTimeOffRequestProvider.allTimeOffRequestLoading) {
                      return const Center(child: CircularProgressIndicator.adaptive());
                    } else {
                      if(adminTimeOffRequestProvider.searchController.text.isEmpty)
                      {
                     return ListView.builder(
                        itemCount:AppConstants.allTimeOffRequestsmodel!.data!.length,
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemBuilder:(context, index) {
                         int totalHours=AppConstants.allTimeOffRequestsmodel!.data![index].requestTimeOffDetail!.fold(0, (previousValue, element) => previousValue+element.hours!);
                        return AdminAllCorrectionRequestRow(
                          requestFor:AppConstants.allTimeOffRequestsmodel!.data![index].from.toString()=="null"? "":DateFormat('MMM d, y').format(DateTime.parse(AppConstants.allTimeOffRequestsmodel!.data![index].from.toString())),
                           employeeName: AppConstants.allTimeOffRequestsmodel!.data![index].employee!.firstname.toString(), 
                           rowColor: index%2==1?AppColors.tablefillColor:AppColors.tableUnfillColor, 
                           date: AppConstants.allTimeOffRequestsmodel!.data![index].from.toString()=="null"? "":DateFormat('MMM d, y').format(DateTime.parse(AppConstants.allTimeOffRequestsmodel!.data![index].to.toString())), 
                           status: AppConstants.allTimeOffRequestsmodel!.data![index].status.toString()=="approved"?1:AppConstants.allTimeOffRequestsmodel!.data![index].status.toString()=="rejected"||AppConstants.allTimeOffRequestsmodel!.data![index].status.toString()=="Denied"?2:AppConstants.allTimeOffRequestsmodel!.data![index].status.toString()=="pending"?3:AppConstants.allTimeOffRequestsmodel!.data![index].status.toString()=="Denied"?4:0,statusText: "",
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
                                text: "Time Off Requests Decision",
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
                            Expanded(flex: 2, child: Container(height: 50, decoration: BoxDecoration(border: Border.all(color: AppColors.textColor.withOpacity(.25)), color: AppColors.fillColor, borderRadius: BorderRadius.circular(8)), child:Center(child: CommonTextPoppins(talign: TextAlign.center, text:AppConstants.allTimeOffRequestsmodel!.data![index].to.toString()=="null"? "":DateFormat('MMMM y').format(DateTime.parse(AppConstants.allTimeOffRequestsmodel!.data![index].to.toString())), fontweight: FontWeight.w400, fontsize: 14, color: AppColors.textColor)))),
                            CommonTextPoppins(text: " - ", fontweight: FontWeight.w400, fontsize: 14, color: AppColors.textColor),
                            Expanded(flex:1, child: Container(height: 50, decoration: BoxDecoration(border: Border.all(color: AppColors.textColor.withOpacity(.25)), color: AppColors.fillColor, borderRadius: BorderRadius.circular(8)), child:Center(child: CommonTextPoppins(talign: TextAlign.center, text:AppConstants.allTimeOffRequestsmodel!.data![index].to.toString()=="null"? "":DateFormat('d').format(DateTime.parse(AppConstants.allTimeOffRequestsmodel!.data![index].to.toString())), fontweight: FontWeight.w400, fontsize: 14, color: AppColors.textColor),))),
                            //to
                            CommonTextPoppins(text: " to ", fontweight: FontWeight.w400, fontsize: 14, color: AppColors.textColor),
                            //to
                            Expanded(flex: 2, child: Container(height: 50, decoration: BoxDecoration(border: Border.all(color: AppColors.textColor.withOpacity(.25)), color: AppColors.fillColor, borderRadius: BorderRadius.circular(8)), child:Center(child: CommonTextPoppins(talign: TextAlign.center, text:AppConstants.allTimeOffRequestsmodel!.data![index].from.toString()=="null"? "":DateFormat('MMMM y').format(DateTime.parse(AppConstants.allTimeOffRequestsmodel!.data![index].from.toString())), fontweight: FontWeight.w400, fontsize: 14, color: AppColors.textColor)))),
                            CommonTextPoppins(text: " - ", fontweight: FontWeight.w400, fontsize: 14, color: AppColors.textColor),
                            Expanded(flex:1, child: Container(height: 50, decoration: BoxDecoration(border: Border.all(color: AppColors.textColor.withOpacity(.25)), color: AppColors.fillColor, borderRadius: BorderRadius.circular(8)), child:Center(child: CommonTextPoppins(talign: TextAlign.center, text:AppConstants.allTimeOffRequestsmodel!.data![index].from.toString()=="null"? "":DateFormat('d').format(DateTime.parse(AppConstants.allTimeOffRequestsmodel!.data![index].from.toString())).toString(), fontweight: FontWeight.w400, fontsize: 14, color: AppColors.textColor),))),
                            const Expanded(flex:1, child: SizedBox()),
                            ],),
                            16.sh,
                            CommonTextPoppins(text: "Hours",talign: TextAlign.left, fontweight: FontWeight.w500, fontsize: 12, color: AppColors.hintTextColor),
                            5.sh,
                            Container(padding:const EdgeInsets.symmetric(horizontal: 20,vertical: 10),alignment: Alignment.centerLeft, height: 50, decoration: BoxDecoration(border: Border.all(color: AppColors.textColor.withOpacity(.25)), color: AppColors.fillColor, borderRadius: BorderRadius.circular(8)), child:CommonTextPoppins(talign: TextAlign.left, text:totalHours.toString(), fontweight: FontWeight.w400, fontsize: 14, color: AppColors.textColor)),
                            16.sh,
                          //   CommonTextPoppins(text: "Policy Id",talign: TextAlign.left, fontweight: FontWeight.w500, fontsize: 12, color: AppColors.hintTextColor),
                          //   5.sh,
                          //  Container(padding:const EdgeInsets.symmetric(horizontal: 20,vertical: 10),alignment: Alignment.centerLeft,height: 50, decoration: BoxDecoration(border: Border.all(color: AppColors.textColor.withOpacity(.25)), color: AppColors.fillColor, borderRadius: BorderRadius.circular(8)), child:CommonTextPoppins(talign: TextAlign.left, text: AppConstants.allTimeOffRequestsmodel!.data![index].assignTimeOffPolicyId.toString(), fontweight: FontWeight.w400, fontsize: 14, color: AppColors.textColor)),
                          //   16.sh,
                            CommonTextPoppins(text: "Reason",talign: TextAlign.left, fontweight: FontWeight.w500, fontsize: 12, color: AppColors.hintTextColor),
                            5.sh,
                            Container(padding:const EdgeInsets.symmetric(horizontal: 20,vertical: 10),alignment: Alignment.centerLeft, decoration: BoxDecoration(border: Border.all(color: AppColors.textColor.withOpacity(.25)), color: AppColors.fillColor, borderRadius: BorderRadius.circular(8)), child:CommonTextPoppins(talign: TextAlign.left, text: AppConstants.allTimeOffRequestsmodel!.data![index].note.toString(), fontweight: FontWeight.w400, fontsize: 14, color: AppColors.textColor)),
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
                        color:AppConstants.allTimeOffRequestsmodel!.data![index].status.toString()=="approved"? AppColors.success:AppConstants.allTimeOffRequestsmodel!.data![index].status.toString()=="Denied"||AppConstants.allTimeOffRequestsmodel!.data![index].status.toString()=="rejected"? AppColors.redColor:AppConstants.allTimeOffRequestsmodel!.data![index].status.toString()=="pending"?AppColors.primaryColor:AppConstants.allTimeOffRequestsmodel!.data![index].status.toString()=="Canceled"?Colors.orange.withOpacity(.5):AppColors.whiteColor),
                        child: Center(child: Text(AppConstants.allTimeOffRequestsmodel!.data![index].status.toString(),style: TextStyle(color: AppColors.whiteColor),))))),
                          Consumer<AdminTimeOffRequestsProvider>(
                            builder: (context, adminTimeOffrequestProvider, child) {
                              return adminTimeOffrequestProvider.decisionLoading
                                      ? const Center(
                                          child: CircularProgressIndicator.adaptive(),
                                        )
                                      :
                                  Padding(padding: const EdgeInsets.symmetric(horizontal:25.0),
                                    child: Column(mainAxisSize: MainAxisSize.min, children: [
                                    CommonButtonImage(
                                      onPressed: () {
                                        adminTimeOffrequestProvider.approveDenyAdminTimeOffRequests(context: context, status: "approved", TimeOffId: AppConstants.allTimeOffRequestsmodel!.data![index].id.toString(), employeeId: AppConstants.allTimeOffRequestsmodel!.data![index].employee!.id.toString());
                                      },
                                      width: MediaQuery.of(context).size.width,
                                      text: "Approve",
                                      color: AppColors.primaryColor,
                                      image: ImagePath.approveIcon),
                                  20.sh,
                                  DenyButton(
                                      text: "Deny",
                                      ontap: () {
                                        adminTimeOffrequestProvider.approveDenyAdminTimeOffRequests(context: context, status: "rejected", TimeOffId: AppConstants.allTimeOffRequestsmodel!.data![index].id.toString(), employeeId: AppConstants.allTimeOffRequestsmodel!.data![index].employee!.id.toString());
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
                      else if(adminTimeOffRequestProvider.searchlist.isNotEmpty)
                     {
                      return ListView.builder(
                        itemCount:adminTimeOffRequestProvider.searchlist.length,//correctionRequestProvider.dropdownSelectedText=="All"? correctionRequestProvider.searchlist.length:int.parse(correctionRequestProvider.dropdownSelectedText)<= correctionRequestProvider.searchlist.length?int.parse(correctionRequestProvider.dropdownSelectedText):correctionRequestProvider.searchlist.length,
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemBuilder:(context, index) {
                        int totalHours=adminTimeOffRequestProvider.searchlist[index].requestTimeOffDetail!.fold(0, (previousValue, element) => previousValue+element.hours!);
                        return AdminAllCorrectionRequestRow(employeeName: adminTimeOffRequestProvider.searchlist[index].employee!.fullName.toString(),
                        requestFor:adminTimeOffRequestProvider.searchlist[index].from.toString()=="null"? "":DateFormat('MMM d, y').format(DateTime.parse(adminTimeOffRequestProvider.searchlist[index].from.toString())), 
                        rowColor: index%2==1?AppColors.tablefillColor:AppColors.tableUnfillColor,
                         date: adminTimeOffRequestProvider.searchlist[index].to.toString()=="null"? "":DateFormat('MMM d, y').format(DateTime.parse(adminTimeOffRequestProvider.searchlist[index].to.toString())), 
                         status: adminTimeOffRequestProvider.searchlist[index].status.toString()=="approved"?1:adminTimeOffRequestProvider.searchlist[index].status.toString()=="rejected"||adminTimeOffRequestProvider.searchlist[index].status.toString()=="Denied"?2:adminTimeOffRequestProvider.searchlist[index].status.toString()=="pending"?3:adminTimeOffRequestProvider.searchlist[index].status.toString()=="Denied"?4:0,statusText: "",
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
                                text: "Time Off Requests Decision",
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
                            Expanded(flex: 2, child: Container(height: 50, decoration: BoxDecoration(border: Border.all(color: AppColors.textColor.withOpacity(.25)), color: AppColors.fillColor, borderRadius: BorderRadius.circular(8)), child:Center(child: CommonTextPoppins(talign: TextAlign.center, text:adminTimeOffRequestProvider.searchlist[index].to.toString()=="null"? "":DateFormat('MMMM y').format(DateTime.parse(adminTimeOffRequestProvider.searchlist[index].to.toString())), fontweight: FontWeight.w400, fontsize: 14, color: AppColors.textColor)))),
                            CommonTextPoppins(text: " - ", fontweight: FontWeight.w400, fontsize: 14, color: AppColors.textColor),
                            Expanded(flex:1, child: Container(height: 50, decoration: BoxDecoration(border: Border.all(color: AppColors.textColor.withOpacity(.25)), color: AppColors.fillColor, borderRadius: BorderRadius.circular(8)), child:Center(child: CommonTextPoppins(talign: TextAlign.center, text:adminTimeOffRequestProvider.searchlist[index].to.toString()=="null"? "":DateFormat('d').format(DateTime.parse(adminTimeOffRequestProvider.searchlist[index].to.toString())), fontweight: FontWeight.w400, fontsize: 14, color: AppColors.textColor),))),
                            //to
                            CommonTextPoppins(text: " to ", fontweight: FontWeight.w400, fontsize: 14, color: AppColors.textColor),
                            //to
                            Expanded(flex: 2, child: Container(height: 50, decoration: BoxDecoration(border: Border.all(color: AppColors.textColor.withOpacity(.25)), color: AppColors.fillColor, borderRadius: BorderRadius.circular(8)), child:Center(child: CommonTextPoppins(talign: TextAlign.center, text:adminTimeOffRequestProvider.searchlist[index].from.toString()=="null"? "":DateFormat('MMMM y').format(DateTime.parse(adminTimeOffRequestProvider.searchlist[index].from.toString())), fontweight: FontWeight.w400, fontsize: 14, color: AppColors.textColor)))),
                            CommonTextPoppins(text: " - ", fontweight: FontWeight.w400, fontsize: 14, color: AppColors.textColor),
                            Expanded(flex:1, child: Container(height: 50, decoration: BoxDecoration(border: Border.all(color: AppColors.textColor.withOpacity(.25)), color: AppColors.fillColor, borderRadius: BorderRadius.circular(8)), child:Center(child: CommonTextPoppins(talign: TextAlign.center, text:adminTimeOffRequestProvider.searchlist[index].from.toString()=="null"? "":DateFormat('d').format(DateTime.parse(adminTimeOffRequestProvider.searchlist[index].from.toString())).toString(), fontweight: FontWeight.w400, fontsize: 14, color: AppColors.textColor),))),
                            const Expanded(flex:1, child: SizedBox()),
                            ],),
                            16.sh,
                            CommonTextPoppins(text: "Hours",talign: TextAlign.left, fontweight: FontWeight.w500, fontsize: 12, color: AppColors.hintTextColor),
                            5.sh,
                            Container(padding:const EdgeInsets.symmetric(horizontal: 20,vertical: 10),alignment: Alignment.centerLeft, height: 50, decoration: BoxDecoration(border: Border.all(color: AppColors.textColor.withOpacity(.25)), color: AppColors.fillColor, borderRadius: BorderRadius.circular(8)), child:CommonTextPoppins(talign: TextAlign.left, text:totalHours.toString(), fontweight: FontWeight.w400, fontsize: 14, color: AppColors.textColor)),
                            16.sh,
                          //   CommonTextPoppins(text: "Policy Id",talign: TextAlign.left, fontweight: FontWeight.w500, fontsize: 12, color: AppColors.hintTextColor),
                          //   5.sh,
                          //  Container(padding:const EdgeInsets.symmetric(horizontal: 20,vertical: 10),alignment: Alignment.centerLeft,height: 50, decoration: BoxDecoration(border: Border.all(color: AppColors.textColor.withOpacity(.25)), color: AppColors.fillColor, borderRadius: BorderRadius.circular(8)), child:CommonTextPoppins(talign: TextAlign.left, text: adminTimeOffRequestProvider.searchlist[index].assignTimeOffPolicyId.toString(), fontweight: FontWeight.w400, fontsize: 14, color: AppColors.textColor)),
                          //   16.sh,
                            CommonTextPoppins(text: "Reason",talign: TextAlign.left, fontweight: FontWeight.w500, fontsize: 12, color: AppColors.hintTextColor),
                            5.sh,
                            Container(padding:const EdgeInsets.symmetric(horizontal: 20,vertical: 10),alignment: Alignment.centerLeft, decoration: BoxDecoration(border: Border.all(color: AppColors.textColor.withOpacity(.25)), color: AppColors.fillColor, borderRadius: BorderRadius.circular(8)), child:CommonTextPoppins(talign: TextAlign.left, text: adminTimeOffRequestProvider.searchlist[index].note.toString(), fontweight: FontWeight.w400, fontsize: 14, color: AppColors.textColor)),
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
                        color:adminTimeOffRequestProvider.searchlist[index].status.toString()=="approved"? AppColors.success:adminTimeOffRequestProvider.searchlist[index].status.toString()=="Denied"||adminTimeOffRequestProvider.searchlist[index].status.toString()=="rejected"? AppColors.redColor:adminTimeOffRequestProvider.searchlist[index].status.toString()=="pending"?AppColors.primaryColor:adminTimeOffRequestProvider.searchlist[index].status.toString()=="Canceled"?Colors.orange.withOpacity(.5):AppColors.whiteColor),
                        child: Center(child: Text(adminTimeOffRequestProvider.searchlist[index].status.toString(),style: TextStyle(color: AppColors.whiteColor),))))),
                          Consumer<AdminTimeOffRequestsProvider>(
                            builder: (context, adminTimeOffrequestProvider, child) {
                              return adminTimeOffrequestProvider.decisionLoading
                                      ? const Center(
                                          child: CircularProgressIndicator.adaptive(),
                                        )
                                      :
                                  Padding(padding: const EdgeInsets.symmetric(horizontal:25.0),
                                    child: Column(mainAxisSize: MainAxisSize.min, children: [
                                    CommonButtonImage(
                                      onPressed: () {
                                        adminTimeOffrequestProvider.approveDenyAdminTimeOffRequests(context: context, status: "approved", TimeOffId:adminTimeOffRequestProvider.searchlist[index].id.toString(), employeeId:adminTimeOffRequestProvider.searchlist[index].employee!.id.toString());
                                      },
                                      width: MediaQuery.of(context).size.width,
                                      text: "Approve",
                                      color: AppColors.primaryColor,
                                      image: ImagePath.approveIcon),
                                  20.sh,
                                  DenyButton(
                                      text: "Deny",
                                      ontap: () {
                                        adminTimeOffrequestProvider.approveDenyAdminTimeOffRequests(context: context, status: "rejected", TimeOffId:adminTimeOffRequestProvider.searchlist[index].id.toString(), employeeId:adminTimeOffRequestProvider.searchlist[index].employee!.id.toString());
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
              
                }
        },
        menurequired: true,
        bottomerror: AppConstants.loginmodell!.userRole![0].type.toString() !=
                "admin"
            ?AppConstants.loginmodell!.permissions["policy"].toString()=="[]"? CommonTextPoppins(
                    text: "You Don't Have TimeOff Permission",
                    fontsize: 12,
                    fontweight: FontWeight.w500,
                    color: AppColors.redColor,
                  ):AppConstants
                        .loginmodell!
                        .permissions["policy"]
                            [AppConstants.loginmodell!.userData!.id.toString()]
                            ["request time_off"]
                        .toString() ==
                    "can"
                ? const SizedBox()
                : CommonTextPoppins(
                    text: "You Don't Have TimeOff Permission",
                    fontsize: 12,
                    fontweight: FontWeight.w500,
                    color: AppColors.redColor,
                  )
            : const SizedBox(),
        showButton: AppConstants.loginmodell!.userRole![0].type.toString() !=
                "admin"
            ?AppConstants.loginmodell!.permissions["policy"].toString()=="[]"? false: AppConstants
                        .loginmodell!
                        .permissions["policy"]
                            [AppConstants.loginmodell!.userData!.id.toString()]
                            ["request time_off"]
                        .toString() ==
                    "can"
                ? true
                : false
            : true,
        buttonOnPressed: () {
          CommonBottomSheet(
            context: context,
            widget:Consumer<TimeOffProvider>(
                    builder: (context, dashboardprovider, child) {
                      return FutureBuilder(
               future:dashboardprovider.callinggettimeoff(context),

                        builder:(context, snapshot) {
                           if (snapshot.connectionState == ConnectionState.waiting) {
                          return const Center(child: CircularProgressIndicator.adaptive());
                        }else if (snapshot.hasError) {
                          return Center(child: CommonTextPoppins(text: "Error: ${snapshot.error}", color: AppColors.textColor, fontsize: 12, fontweight: FontWeight.w400));
                        }
                        return  SingleChildScrollView(
                  padding: const EdgeInsets.only(top:12, bottom: 32),
                  child: Consumer<DashBoardProvider>(
                    builder: (context, dashboardprovider, child) {
                      return Form(
                        key: dashboardprovider.noteFormKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            dashboardprovider.screenNumber != 0 ?
                            InkWell(
                        onTap: () {
                          if(dashboardprovider.screenNumber==2){
                          dashboardprovider.changeScreenToCalender(context,1);
            
                          }else{
                          dashboardprovider.changeScreenToCalender(context,0);
            
                          }
                       
                        },
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical:8.0,horizontal:20),
                          child: FittedBox(
                              child: Row(
                                children: [
                                  Icon(
                            Icons.arrow_back,
                            color: AppColors.primaryColor,
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: CommonTextPoppins(text: "Back", fontweight: FontWeight.w500, fontsize: 16, color: AppColors.primaryColor),
                          )
                                ],
                              )),
                        )):Container(),
                            Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: dashboardprovider.enddateformat == ""
                                ? Center(
                                    child: CommonTextPoppins(
                                      text: dashboardprovider.startdateformat,
                                      fontweight: FontWeight.w600,
                                      fontsize: 15,
                                      color: AppColors.textColor,
                                      talign: TextAlign.left,
                                    ),
                                  )
                                : Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Expanded(
                                          flex: 1,
                                          child: CommonTextPoppins(
                                            text: dashboardprovider.startdateformat,
                                            fontweight: FontWeight.w600,
                                            fontsize: 15,
                                            color: AppColors.textColor,
                                            talign: TextAlign.left,
                                          )),
                                      45.sw,
                                      Icon(
                                        Icons.arrow_forward_ios,
                                        color: AppColors.hintTextColor,
                                      ),
                                      45.sw,
                                      Expanded(
                                          flex: 1,
                                          child: CommonTextPoppins(
                                            text: dashboardprovider.enddateformat,
                                            fontweight: FontWeight.w600,
                                            fontsize: 15,
                                            color: AppColors.textColor,
                                            talign: TextAlign.left,
                                          ))
                                    ],
                                  ),
                          ),
                            dashboardprovider.screenNumber == 0
                                ? DashBoardCalander(dashboardprovider)
                                : Container(
                                    child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Container(
                                        decoration: BoxDecoration(
                                            border: Border.all(
                                                width: 1,
                                                color: AppColors.textColor
                                                    .withOpacity(.25)),
                                            color: const Color(0XFFFAFAFA),
                                            borderRadius:
                                                BorderRadius.circular(8)),
                                        margin: const EdgeInsets.only(
                                            left: 24, right: 24, top: 32),
                                        width: width(context),
                                        child: Theme(
                                          data: Theme.of(context).copyWith(
                                              dividerColor: Colors.transparent),
                                          child: DashBoardExpansionTile(
                                              dashboardprovider),
                                        ),
                                      ),
                                      dashboardprovider.screenNumber == 2
                                          ? Container(
                                              margin: const EdgeInsets.symmetric(
                                                  horizontal: 24, vertical: 8),
                                              decoration: BoxDecoration(
                                                  border: Border.all(
                                                      width: 1,
                                                      color: AppColors.textColor
                                                          .withOpacity(.25)),
                                                  color: const Color(0XFFFAFAFA),
                                                  borderRadius:
                                                      BorderRadius.circular(8)),
                                              padding: const EdgeInsets.symmetric(
                                                  horizontal: 16, vertical: 8),
                                              child: Column(
                                                children: [
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      CommonTextPoppins(
                                                          text: "Amount",
                                                          fontweight:
                                                              FontWeight.w500,
                                                          fontsize: 12,
                                                          color: AppColors
                                                              .hintTextColor),
                                                      CommonTextPoppins(
                                                          text:
                                                              //"TOTAL :${(dashboardprovider.picker.endDate!.difference(dashboardprovider.picker.startDate!).inHours / 3) + 8} HRS",
                                                              "TOTAL :${dashboardprovider.totalNumberofAmount} HRS",
                                                          fontweight:
                                                              FontWeight.w500,
                                                          fontsize: 12,
                                                          color: AppColors
                                                              .hintTextColor),
                                                    ],
                                                  ),
                                                  ListView.builder(
                                                    shrinkWrap: true,
                                                    physics:
                                                        const NeverScrollableScrollPhysics(),
                                                    itemCount: dashboardprovider
                                                        .days.length,
                                                    itemBuilder:
                                                        (context, index) {
                                                      DateTime sd =
                                                          dashboardprovider
                                                              .days[index];
                                                      return Padding(
                                                        padding:
                                                            const EdgeInsets.only(
                                                                top: 8.0),
                                                        child: Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceBetween,
                                                          children: [
                                                            CommonTextPoppins(
                                                                text: DateFormat(
                                                                        'EEEE, MMM d')
                                                                    .format(sd),
                                                                fontweight:
                                                                    FontWeight
                                                                        .w600,
                                                                fontsize: 14,
                                                                color: const Color(
                                                                    0XFF343434)),
                                                            CommonTextPoppins(
                                                                text: (AppConstants
                                                                            .timeoffmodel!
                                                                            .daysData!
                                                                            .nonWorkingDays!
                                                                            .length
                                                                            .toString() ==
                                                                        "2")
                                                                    ? sd.weekday !=
                                                                                6 &&
                                                                            sd.weekday !=
                                                                                7
                                                                        ? "${dashboardprovider.dayshours[index].toString()} hrs"
                                                                        : "0 hrs"
                                                                    : sd.weekday !=
                                                                            7
                                                                        ? "${dashboardprovider.dayshours[index].toString()} hrs"
                                                                        : "0 hrs",
                                                                fontweight:
                                                                    FontWeight
                                                                        .w600,
                                                                fontsize: 14,
                                                                color: const Color(
                                                                    0XFF343434)),
                                                          ],
                                                        ),
                                                      );
                                                    },
                                                  )
                                                ],
                                              ),
                                            )
                                          : Container(),
                                      Container(
                                        decoration: BoxDecoration(
                                            border: Border.all(
                                                width: 1,
                                                color: AppColors.textColor
                                                    .withOpacity(.25)),
                                            color: const Color(0XFFFAFAFA),
                                            borderRadius:
                                                BorderRadius.circular(8)),
                                        padding: const EdgeInsets.only(
                                            left: 16, top: 8),
                                        margin: const EdgeInsets.only(
                                            left: 24,
                                            right: 24,
                                            bottom: 30,
                                            top: 8),
                                        width: width(context),
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            CommonTextPoppins(
                                                text: "Note",
                                                talign: TextAlign.left,
                                                fontweight: FontWeight.w500,
                                                fontsize: 12,
                                                color: AppColors.hintTextColor),
                                            TextFormField(
                                              controller: dashboardprovider.note,
                                              validator: (value) {
                                                if (value!.isEmpty) {
                                                  return "Please Enter Note";
                                                } else {
                                                  return null;
                                                }
                                              },
                                              decoration: const InputDecoration(
                                                  border: InputBorder.none,
                                                  hintStyle: TextStyle(
                                                      fontSize: 14,
                                                      fontWeight: FontWeight.w400,
                                                      color: Color(0XFF343434)),
                                                  hintText:
                                                      "Write your text message here."),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  )),
                           
                          Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 40),
                              child: dashboardprovider.loading
                                      ?const Center(
                                          child: CircularProgressIndicator.adaptive(),
                                        )
                                      : CommonButton(
                                  onPressed: () async {
                                  // if (dashboardprovider.screenNumber < 2) {
                                  // if (isRedundentClick(DateTime.now())) {
                                  //                             Fluttertoast.showToast(
                                  //                                 msg: "Please wait for a while",
                                  //                                 toastLength: Toast.LENGTH_SHORT,
                                  //                                 gravity: ToastGravity.BOTTOM,
                                  //                                 timeInSecForIosWeb: 1,
                                  //                                 backgroundColor: AppColors.primaryColor,
                                  //                                 textColor: Colors.white,
                                  //                                 fontSize: 16.0);
                                  //                             return;
                                  //   } 
                                  // }
                                   if (dashboardprovider
                                          .noteFormKey.currentState!
                                          .validate()) {
                                        debugPrint("this is screen number pressed${dashboardprovider.screenNumber}");
                                        if (dashboardprovider.screenNumber < 2) {
                                          if (dashboardprovider.screenNumber ==
                                              0) {
                                            if (dashboardprovider
                                                        .picker.endDate !=
                                                    null &&
                                                dashboardprovider
                                                        .picker.startDate !=
                                                    null &&
                                                dashboardprovider.holidayfound ==
                                                    false &&
                                                dashboardprovider
                                                        .repeatationFound ==
                                                    false) {
                                              dashboardprovider
                                                  .changeScreenNumber(context);
                                            } else if (dashboardprovider
                                                .holidayfound) {
                                              Fluttertoast.showToast(
                                                  msg: "Holiday Found");
                                            } else if (dashboardprovider
                                                .repeatationFound) {
                                              Fluttertoast.showToast(
                                                  msg:
                                                      "You already apply for these dates");
                                            } else {
                                              Fluttertoast.showToast(
                                                  msg:
                                                      "Starting or End date missing");
                                            }
                                          } else if (dashboardprovider
                                                  .screenNumber ==
                                              1) {
                                            if (dashboardprovider.timeof ==
                                                "TIME OFF CATEGORY") {
                                              Fluttertoast.showToast(
                                                  msg:
                                                      "TimeOff Category is not selected");
                                            } else {
                                              dashboardprovider
                                                  .changeScreenNumber(context);
                                            }
                                          }
                                        } else if (dashboardprovider
                                                .screenNumber ==
                                            2) {
                                          await dashboardprovider
                                              .hitStoreTimeOff(contexta);
                                        }
                                      }
                                    },

                                    
                                    width: width(context),
                                    text: dashboardprovider.screenNumber < 2
                                        ? "Continue"
                                        : "Apply for LEAVE")),
                          ],
                        ),
                      );
                    },
                  ));}
            );})
          );
        },
       textColor: AppColors.primaryColor,
        buttonTitle: "Apply Now");
  }
}

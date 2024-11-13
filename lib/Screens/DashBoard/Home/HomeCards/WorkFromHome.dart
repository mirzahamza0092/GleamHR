import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:gleam_hr/Components/CommonBottomSheet.dart';
import 'package:gleam_hr/Components/CommonButton.dart';
import 'package:gleam_hr/Components/CommonDropDown.dart';
import 'package:gleam_hr/Components/CommonText.dart';
import 'package:gleam_hr/Providers/DashBoardProviders/HomeProviders/WorkFromHome_Provider.dart';
import 'package:gleam_hr/Screens/DashBoard/Home/HomeWidgets/AdminAllCorrectionRequestRow.dart';
import 'package:gleam_hr/Screens/DashBoard/Home/HomeWidgets/CommonDashBoardCard.dart';
import 'package:gleam_hr/Screens/DashBoard/Home/HomeWidgets/CommonRequestsTableRow.dart';
import 'package:gleam_hr/Screens/DashBoard/People/PeopleWidget/PeopleSearchBar.dart';
import 'package:gleam_hr/Utils/AppConstants.dart';
import 'package:gleam_hr/Utils/AppPaths.dart';
import 'package:gleam_hr/Utils/Colors.dart';
import 'package:gleam_hr/Utils/SizedBox.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

class WorkFromHome extends StatefulWidget {
  const WorkFromHome({super.key});

  @override
  State<WorkFromHome> createState() => _WorkFromHomeState();
}

class _WorkFromHomeState extends State<WorkFromHome> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final wFHProvider =
          Provider.of<WorkFromHomeProvider>(context, listen: false);
      wFHProvider.changeStatusOfdates();
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final wFHProvider =
          Provider.of<WorkFromHomeProvider>(context, listen: false);
    BuildContext contexta = context;
    return CommonDashBoardCard(
        color: AppColors.primaryColor.withOpacity(.11),
        title: "Work From Home",
        bottomerror:AppConstants.loginmodell!.userRole![0].type.toString() =="admin"?const SizedBox(): (AppConstants.loginmodell!.permissions["workFromHome"].toString() == "[]" || AppConstants.loginmodell!.permissions["workFromHome"][AppConstants.loginmodell!.userData!.id.toString()]["request work-from-home"] != "can") && (AppConstants.loginmodell!.userRole![0].type.toString() != "admin")? CommonTextPoppins(
                    text: "You Don't have Work From Home Permission",
                    fontsize: 12,
                    fontweight: FontWeight.w500,
                    color: AppColors.redColor,
                  ):const SizedBox(),
        showButton:AppConstants.loginmodell!.userRole![0].type.toString() =="admin"?true: (AppConstants.loginmodell!.permissions["workFromHome"].toString() == "[]" || AppConstants.loginmodell!.permissions["workFromHome"][AppConstants.loginmodell!.userData!.id.toString()]["request work-from-home"] != "can") && (AppConstants.loginmodell!.userRole![0].type.toString() != "admin")?false:true,
        subTitle: "You can work from anywhere",
        leadingPath: ImagePath.workFromHomeIcon,
        menurequired: true,
        cardOnPressed: () {},
        menuOnPressed: (value) {
          if(value=="My Requests"){
            context
              .read<WorkFromHomeProvider>()
              .getWFHRequests(context: context);
          CommonBottomSheet(
              context: context,
              widget: SingleChildScrollView(
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                    Center(
                      child: CommonTextPoppins(
                          text: "Work From Home Requests",
                          talign: TextAlign.left,
                          fontweight: FontWeight.w600,
                          fontsize: 20,
                          color: AppColors.textColor),
                    ),
                    30.sh,
                    Padding(
                        padding: EdgeInsets.zero,
                        child: Consumer<WorkFromHomeProvider>(
                          builder: (context, wFHRequestProvider, child) {
                            return Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                //dropdown
                                Consumer<WorkFromHomeProvider>(
                                  builder: (context, wFHRequestProvider, child) {
                                    if (wFHRequestProvider.wFHRequestLoading) {
                                      return Container();
                                    } else {
                                      return CommonDropDown(
                                          width: 70,
                                          selectedText: wFHRequestProvider
                                              .dropdownSelectedText,
                                          listItem:
                                              wFHRequestProvider.dropdownlist,
                                          onchanged: (value) {
                                            wFHRequestProvider.changedropdown(
                                                value, context);
                                          });
                                    }
                                  },
                                ),
                                //CommonDropDown(width: 70, selectedText: wFHRequestProvider.dropdownSelectedText, listItem: wFHRequestProvider.dropdownlist, onchanged: (value){wFHRequestProvider.changedropdown(value);}),
                                //search
                                SizedBox(
                                  width: width(context) * .40,
                                  child: PeopleSearchBar(
                                      controller:
                                          wFHRequestProvider.searchController,
                                      onvaluechange: (value) {
                                        wFHRequestProvider
                                                .searchlist =
                                            AppConstants.wfhRequestsmodel!
                                                .data!
                                                .where((element) =>
                                                    DateFormat('MMM d, y').format(DateTime.parse(element.to.toString())).toLowerCase().contains(value.toString().toLowerCase()) ||
                                                    element.status.toString().toLowerCase().contains(value.toString().toLowerCase()))
                                                .toList();
                                        wFHRequestProvider.hitupdate();
                                      }),
                                ),
                                PopupMenuButton<String>(
                                  icon: SvgPicture.asset(ImagePath.filterIcon,
                                      height: 30),
                                  onSelected: (String value) {
                                    wFHRequestProvider.changeFilterValue(
                                        value, context);
                                  },
                                  itemBuilder: (BuildContext context) {
                                    return wFHRequestProvider.items
                                        .map((String item) {
                                      return PopupMenuItem<String>(
                                        value: item,
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            CommonTextPoppins(
                                              text: item,
                                              fontweight: FontWeight.w400,
                                              fontsize: 12,
                                              color: AppColors.blackColor,
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
                              ],
                            );
                          },
                        )),
                    20.sh,
                    CommonRequestsTableRow(
                        rowColor: AppColors.tablefillColor,
                        date: "DATE",
                        srNo: "S.R.#",
                        status: 0,
                        textColor: AppColors.primaryColor,
                        statusText: "STATUS",
                        actionTap: () {},
                        actionText: "ACTION"),
                    Consumer<WorkFromHomeProvider>(
                      builder: (context, wFHRequestProvider, child) {
                        if (wFHRequestProvider.wFHRequestLoading) {
                          return const Center(
                              child: CircularProgressIndicator.adaptive());
                        } else {
                          if (wFHRequestProvider
                              .searchController.text.isEmpty) {
                            return ListView.builder(
                              itemCount: AppConstants
                                  .wfhRequestsmodel!.data!.length,
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemBuilder: (context, index) {
                                return CommonRequestsTableRow(
                                    rowColor: index % 2 == 1
                                        ? AppColors.tablefillColor
                                        : AppColors.tableUnfillColor,
                                    date:DateFormat('MMM d, y').format(DateTime.parse(AppConstants.wfhRequestsmodel!
                                        .data![index].to.toString()
                                        .substring(0, 10),)),
                                    srNo: (index + 1).toString(),
                                    status: AppConstants.wfhRequestsmodel!
                                                .data![index].status
                                                .toString() ==
                                            "approved"
                                        ? 1
                                        : AppConstants.wfhRequestsmodel!
                                                    .data![index].status
                                                    .toString() ==
                                                "rejected"
                                            ? 2
                                            : AppConstants
                                                        .wfhRequestsmodel!
                                                        .data![index]
                                                        .status
                                                        .toString() ==
                                                    "pending"
                                                ? 3
                                                : 0,
                                    statusText: "",
                                    actionTap: () {
                                      CommonBottomSheet(
                                          context: context,
                                          widget: SingleChildScrollView(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 12),
                                              child: SizedBox(
                                                child: Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.start,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Center(
                                                        child:
                                                            CommonTextPoppins(
                                                                text: "Status",
                                                                talign:
                                                                    TextAlign
                                                                        .left,
                                                                fontweight:
                                                                    FontWeight
                                                                        .w600,
                                                                fontsize: 20,
                                                                color: AppColors
                                                                    .textColor),
                                                      ),
                                                      30.sh,
                                                      Row(
                                                        children: [
                                                          Expanded(
                                                            flex: 2,
                                                            child: Column(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .start,
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .start,
                                                              children: [
                                                                CommonTextPoppins(
                                                                    text:
                                                                        "DATE",
                                                                    talign:
                                                                        TextAlign
                                                                            .left,
                                                                    fontweight:
                                                                        FontWeight
                                                                            .w500,
                                                                    fontsize:
                                                                        12,
                                                                    color: AppColors
                                                                        .hintTextColor),
                                                                Row(
                                                                  children: [
                                                                    Expanded(
                                                                        flex: 2,
                                                                        child: Container(
                                                                            height:
                                                                                50,
                                                                            decoration: BoxDecoration(
                                                                                border: Border.all(color: AppColors.textColor.withOpacity(.25)),
                                                                                color: AppColors.fillColor,
                                                                                borderRadius: BorderRadius.circular(8)),
                                                                            child: Center(child: CommonTextPoppins(talign: TextAlign.center, text: AppConstants.wfhRequestsmodel!.data![index].from.toString() == "null" ? "" : DateFormat('MMMM y').format(DateTime.parse(AppConstants.wfhRequestsmodel!.data![index].from.toString())), fontweight: FontWeight.w400, fontsize: 14, color: AppColors.textColor)))),
                                                                    CommonTextPoppins(
                                                                        text:
                                                                            " - ",
                                                                        fontweight:
                                                                            FontWeight
                                                                                .w400,
                                                                        fontsize:
                                                                            14,
                                                                        color: AppColors
                                                                            .textColor),
                                                                    Expanded(
                                                                        flex: 1,
                                                                        child: Container(
                                                                            height: 50,
                                                                            decoration: BoxDecoration(border: Border.all(color: AppColors.textColor.withOpacity(.25)), color: AppColors.fillColor, borderRadius: BorderRadius.circular(8)),
                                                                            child: Center(
                                                                              child: CommonTextPoppins(talign: TextAlign.center, text: AppConstants.wfhRequestsmodel!.data![index].from.toString() == "null" ? "" : DateFormat('d').format(DateTime.parse(AppConstants.wfhRequestsmodel!.data![index].from.toString())), fontweight: FontWeight.w400, fontsize: 14, color: AppColors.textColor),
                                                                            ))),
                                                                    //to
                                                                    CommonTextPoppins(
                                                                        text:
                                                                            " to ",
                                                                        fontweight:
                                                                            FontWeight
                                                                                .w400,
                                                                        fontsize:
                                                                            14,
                                                                        color: AppColors
                                                                            .textColor),
                                                                    //to
                                                                    Expanded(
                                                                        flex: 2,
                                                                        child: Container(
                                                                            height:
                                                                                50,
                                                                            decoration: BoxDecoration(
                                                                                border: Border.all(color: AppColors.textColor.withOpacity(.25)),
                                                                                color: AppColors.fillColor,
                                                                                borderRadius: BorderRadius.circular(8)),
                                                                            child: Center(child: CommonTextPoppins(talign: TextAlign.center, text: AppConstants.wfhRequestsmodel!.data![index].to.toString() == "null" ? "" : DateFormat('MMMM y').format(DateTime.parse(AppConstants.wfhRequestsmodel!.data![index].to.toString())), fontweight: FontWeight.w400, fontsize: 14, color: AppColors.textColor)))),
                                                                    CommonTextPoppins(
                                                                        text:
                                                                            " - ",
                                                                        fontweight:
                                                                            FontWeight
                                                                                .w400,
                                                                        fontsize:
                                                                            14,
                                                                        color: AppColors
                                                                            .textColor),
                                                                    Expanded(
                                                                        flex: 1,
                                                                        child: Container(
                                                                            height: 50,
                                                                            decoration: BoxDecoration(border: Border.all(color: AppColors.textColor.withOpacity(.25)), color: AppColors.fillColor, borderRadius: BorderRadius.circular(8)),
                                                                            child: Center(
                                                                              child: CommonTextPoppins(talign: TextAlign.center, text: AppConstants.wfhRequestsmodel!.data![index].to.toString() == "null" ? "" : DateFormat('d').format(DateTime.parse(AppConstants.wfhRequestsmodel!.data![index].to.toString())).toString(), fontweight: FontWeight.w400, fontsize: 14, color: AppColors.textColor),
                                                                            ))),
                                                                    const Expanded(
                                                                        flex: 1,
                                                                        child:
                                                                            SizedBox()),
                                                                  ],
                                                                ),
                                                                16.sh,
                                                                CommonTextPoppins(
                                                                    text:
                                                                        "Reason",
                                                                    talign:
                                                                        TextAlign
                                                                            .left,
                                                                    fontweight:
                                                                        FontWeight
                                                                            .w500,
                                                                    fontsize:
                                                                        12,
                                                                    color: AppColors
                                                                        .hintTextColor),
                                                                5.sh,
                                                                Container(
                                                                    padding: const EdgeInsets.symmetric(
                                                                        horizontal:
                                                                            20,
                                                                        vertical:
                                                                            10),
                                                                    decoration: BoxDecoration(
                                                                        border: Border.all(
                                                                            color: AppColors.textColor.withOpacity(
                                                                                .25)),
                                                                        color: AppColors
                                                                            .fillColor,
                                                                        borderRadius:
                                                                            BorderRadius.circular(
                                                                                8)),
                                                                    child: CommonTextPoppins(
                                                                        talign: TextAlign
                                                                            .left,
                                                                        text: AppConstants
                                                                            .wfhRequestsmodel!
                                                                            .data![index]
                                                                            .reason
                                                                            .toString(),
                                                                        fontweight: FontWeight.w400,
                                                                        fontsize: 14,
                                                                        color: AppColors.textColor)),
                                                              ],
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                      16.sh,
                                                      CommonTextPoppins(
                                                          text: "STATUS",
                                                          talign:
                                                              TextAlign.start,
                                                          fontweight:
                                                              FontWeight.w500,
                                                          fontsize: 12,
                                                          color: AppColors
                                                              .hintTextColor),
                                                      4.sh,
                                                      SizedBox(
                                                          height: 50,
                                                          width: 90,
                                                          child: Center(
                                                              child: Container(
                                                                  height: 30,
                                                                  width: 90,
                                                                  decoration: BoxDecoration(
                                                                      borderRadius: BorderRadius.circular(8),
                                                                      //color:status==1? AppColors.success:status==2?const Color(0XFFE34A4A):status==3?AppColors.primaryColor:AppColors.whiteColor,),
                                                                      color: AppConstants.wfhRequestsmodel!.data![index].status.toString() == "approved"
                                                                          ? AppColors.success
                                                                          : AppConstants.wfhRequestsmodel!.data![index].status.toString() == "rejected"
                                                                              ? AppColors.redColor
                                                                              : AppConstants.wfhRequestsmodel!.data![index].status.toString() == "pending"
                                                                                  ? AppColors.primaryColor
                                                                                  : AppColors.whiteColor),
                                                                  child: Center(
                                                                      child: Text(
                                                                    AppConstants
                                                                        .wfhRequestsmodel!
                                                                        .data![
                                                                            index]
                                                                        .status
                                                                        .toString(),
                                                                    style: TextStyle(
                                                                        color: AppColors
                                                                            .whiteColor),
                                                                  ))))),
                                                      //child: Center(child: CommonTextPoppins(text:status==1? "Approved":status==2?"REJECTED":status==3?"Pending":"", fontweight: FontWeight.w500, fontsize: 12, color: AppColors.whiteColor)))),),
                                                      SizedBox(
                                                          height: 50,
                                                          child: CommonButton2(
                                                              text: "BACK")),
                                                      60.sh,
                                                    ]),
                                              )));
                                    },
                                    actionText: "");
                              },
                            );
                          } else if (wFHRequestProvider.searchlist.isNotEmpty) {
                            return ListView.builder(
                              itemCount: wFHRequestProvider.searchlist.length,
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemBuilder: (context, index) {
                                return CommonRequestsTableRow(
                                    rowColor: index % 2 == 1
                                        ? AppColors.tablefillColor
                                        : AppColors.tableUnfillColor,
                                    date:DateFormat('MMM d, y').format(DateTime.parse(wFHRequestProvider
                                        .searchlist[index].to
                                        .toString().substring(0, 10),)),
                                    srNo: (index + 1).toString(),
                                    status: wFHRequestProvider
                                                .searchlist[index].status
                                                .toString() ==
                                            "approved"
                                        ? 1
                                        : wFHRequestProvider
                                                    .searchlist[index].status
                                                    .toString() ==
                                                "rejected"
                                            ? 2
                                            : wFHRequestProvider
                                                        .searchlist[index]
                                                        .status
                                                        .toString() ==
                                                    "pending"
                                                ? 3
                                                : 0,
                                    statusText: "",
                                    actionTap: () {
                                      CommonBottomSheet(
                                          context: context,
                                          widget: SingleChildScrollView(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 12),
                                              child: SizedBox(
                                                child: Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.start,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Center(
                                                        child:
                                                            CommonTextPoppins(
                                                                text: "Status",
                                                                talign:
                                                                    TextAlign
                                                                        .left,
                                                                fontweight:
                                                                    FontWeight
                                                                        .w600,
                                                                fontsize: 20,
                                                                color: AppColors
                                                                    .textColor),
                                                      ),
                                                      30.sh,
                                                      Row(
                                                        children: [
                                                          Expanded(
                                                            flex: 2,
                                                            child: Column(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .start,
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .start,
                                                              children: [
                                                                CommonTextPoppins(
                                                                    text:
                                                                        "DATE",
                                                                    talign:
                                                                        TextAlign
                                                                            .left,
                                                                    fontweight:
                                                                        FontWeight
                                                                            .w500,
                                                                    fontsize:
                                                                        12,
                                                                    color: AppColors
                                                                        .hintTextColor),
                                                                Row(
                                                                  children: [
                                                                    Expanded(
                                                                        flex: 2,
                                                                        child: Container(
                                                                            height:
                                                                                50,
                                                                            decoration: BoxDecoration(
                                                                                border: Border.all(color: AppColors.textColor.withOpacity(.25)),
                                                                                color: AppColors.fillColor,
                                                                                borderRadius: BorderRadius.circular(8)),
                                                                            child: Center(child: CommonTextPoppins(talign: TextAlign.center, text: wFHRequestProvider.searchlist[index].to.toString() == "null" ? "" : DateFormat('MMMM y').format(DateTime.parse(wFHRequestProvider.searchlist[index].to.toString())), fontweight: FontWeight.w400, fontsize: 14, color: AppColors.textColor)))),
                                                                    CommonTextPoppins(
                                                                        text:
                                                                            " - ",
                                                                        fontweight:
                                                                            FontWeight
                                                                                .w400,
                                                                        fontsize:
                                                                            14,
                                                                        color: AppColors
                                                                            .textColor),
                                                                    Expanded(
                                                                        flex: 1,
                                                                        child: Container(
                                                                            height: 50,
                                                                            decoration: BoxDecoration(border: Border.all(color: AppColors.textColor.withOpacity(.25)), color: AppColors.fillColor, borderRadius: BorderRadius.circular(8)),
                                                                            child: Center(
                                                                              child: CommonTextPoppins(talign: TextAlign.center, text: wFHRequestProvider.searchlist[index].to.toString() == "null" ? "" : DateFormat('d').format(DateTime.parse(wFHRequestProvider.searchlist[index].to.toString())), fontweight: FontWeight.w400, fontsize: 14, color: AppColors.textColor),
                                                                            ))),
                                                                    //to
                                                                    CommonTextPoppins(
                                                                        text:
                                                                            " to ",
                                                                        fontweight:
                                                                            FontWeight
                                                                                .w400,
                                                                        fontsize:
                                                                            14,
                                                                        color: AppColors
                                                                            .textColor),
                                                                    //to
                                                                    Expanded(
                                                                        flex: 2,
                                                                        child: Container(
                                                                            height:
                                                                                50,
                                                                            decoration: BoxDecoration(
                                                                                border: Border.all(color: AppColors.textColor.withOpacity(.25)),
                                                                                color: AppColors.fillColor,
                                                                                borderRadius: BorderRadius.circular(8)),
                                                                            child: Center(child: CommonTextPoppins(talign: TextAlign.center, text: wFHRequestProvider.searchlist[index].from.toString() == "null" ? "" : DateFormat('MMMM y').format(DateTime.parse(wFHRequestProvider.searchlist[index].from.toString())), fontweight: FontWeight.w400, fontsize: 14, color: AppColors.textColor)))),
                                                                    CommonTextPoppins(
                                                                        text:
                                                                            " - ",
                                                                        fontweight:
                                                                            FontWeight
                                                                                .w400,
                                                                        fontsize:
                                                                            14,
                                                                        color: AppColors
                                                                            .textColor),
                                                                    Expanded(
                                                                        flex: 1,
                                                                        child: Container(
                                                                            height: 50,
                                                                            decoration: BoxDecoration(border: Border.all(color: AppColors.textColor.withOpacity(.25)), color: AppColors.fillColor, borderRadius: BorderRadius.circular(8)),
                                                                            child: Center(
                                                                              child: CommonTextPoppins(talign: TextAlign.center, text: wFHRequestProvider.searchlist[index].from.toString() == "null" ? "" : DateFormat('d').format(DateTime.parse(wFHRequestProvider.searchlist[index].from.toString())).toString(), fontweight: FontWeight.w400, fontsize: 14, color: AppColors.textColor),
                                                                            ))),
                                                                    const Expanded(
                                                                        flex: 1,
                                                                        child:
                                                                            SizedBox()),
                                                                  ],
                                                                ),
                                                                16.sh,
                                                                CommonTextPoppins(
                                                                    text:
                                                                        "Reason",
                                                                    talign:
                                                                        TextAlign
                                                                            .left,
                                                                    fontweight:
                                                                        FontWeight
                                                                            .w500,
                                                                    fontsize:
                                                                        12,
                                                                    color: AppColors
                                                                        .hintTextColor),
                                                                5.sh,
                                                                Container(
                                                                    padding: const EdgeInsets.symmetric(
                                                                        horizontal:
                                                                            20,
                                                                        vertical:
                                                                            10),
                                                                    decoration: BoxDecoration(
                                                                        border: Border.all(
                                                                            color: AppColors.textColor.withOpacity(
                                                                                .25)),
                                                                        color: AppColors
                                                                            .fillColor,
                                                                        borderRadius:
                                                                            BorderRadius.circular(
                                                                                8)),
                                                                    child: CommonTextPoppins(
                                                                        talign: TextAlign
                                                                            .left,
                                                                        text: AppConstants
                                                                            .wfhRequestsmodel!
                                                                            .data![index]
                                                                            .reason
                                                                            .toString(),
                                                                        fontweight: FontWeight.w400,
                                                                        fontsize: 14,
                                                                        color: AppColors.textColor)),
                                                              ],
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                      16.sh,
                                                      CommonTextPoppins(
                                                          text: "STATUS",
                                                          talign:
                                                              TextAlign.start,
                                                          fontweight:
                                                              FontWeight.w500,
                                                          fontsize: 12,
                                                          color: AppColors
                                                              .hintTextColor),
                                                      4.sh,
                                                      SizedBox(
                                                          height: 50,
                                                          width: 90,
                                                          child: Center(
                                                              child: Container(
                                                                  height: 30,
                                                                  width: 90,
                                                                  decoration: BoxDecoration(
                                                                      borderRadius: BorderRadius.circular(8),
                                                                      //color:status==1? AppColors.success:status==2?const Color(0XFFE34A4A):status==3?AppColors.primaryColor:AppColors.whiteColor,),
                                                                      color: wFHRequestProvider.searchlist[index].status.toString() == "approved"
                                                                          ? AppColors.success
                                                                          : wFHRequestProvider.searchlist[index].status.toString() == "rejected"
                                                                              ? AppColors.redColor
                                                                              : wFHRequestProvider.searchlist[index].status.toString() == "pending"
                                                                                  ? AppColors.primaryColor
                                                                                  : AppColors.whiteColor),
                                                                  child: Center(
                                                                      child: Text(
                                                                    AppConstants
                                                                        .wfhRequestsmodel!
                                                                        .data![
                                                                            index]
                                                                        .status
                                                                        .toString(),
                                                                    style: TextStyle(
                                                                        color: AppColors
                                                                            .whiteColor),
                                                                  ))))),
                                                      //child: Center(child: CommonTextPoppins(text:status==1? "Approved":status==2?"REJECTED":status==3?"Pending":"", fontweight: FontWeight.w500, fontsize: 12, color: AppColors.whiteColor)))),),
                                                      SizedBox(
                                                          height: 50,
                                                          child: CommonButton2(
                                                              text: "BACK")),
                                                      60.sh,
                                                    ]),
                                              )));
                                    },
                                    actionText: "");
                              },
                            );
                          } else {
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
                            );
                          }
                        }
                      },
                    ),
                  ])));
          }else{
            context
              .read<WorkFromHomeProvider>()
              .getAllWFHRequests(context: context);
          CommonBottomSheet(
              context: context,
              widget: SingleChildScrollView(
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                    Center(
                      child: CommonTextPoppins(
                          text: "Work From Home Requests",
                          talign: TextAlign.left,
                          fontweight: FontWeight.w600,
                          fontsize: 20,
                          color: AppColors.textColor),
                    ),
                    30.sh,
                    Padding(
                        padding: EdgeInsets.zero,
                        child: Consumer<WorkFromHomeProvider>(
                          builder: (context, wFHRequestProvider, child) {
                            return Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                //dropdown
                                Consumer<WorkFromHomeProvider>(
                                  builder: (context, wfhProvider, child) {
                                    if (wfhProvider.wFHRequestLoading) {
                                      return Container();
                                    } else {
                                      return CommonDropDown(
                                          width: 70,
                                          selectedText: wfhProvider
                                              .dropdownAllSelectedText,
                                          listItem:
                                              wfhProvider.dropdownlist,
                                          onchanged: (value) {
                                            wfhProvider.changealldropdown(
                                                value, context);
                                          });
                                    }
                                  },
                                ),
                                //CommonDropDown(width: 70, selectedText: wFHRequestProvider.dropdownSelectedText, listItem: wFHRequestProvider.dropdownlist, onchanged: (value){wFHRequestProvider.changedropdown(value);}),
                                //search
                                SizedBox(
                                  width: width(context) * .40,
                                  child: PeopleSearchBar(
                                      controller:
                                          wFHRequestProvider.searchAllController,
                                      onvaluechange: (value) {
                                        wFHRequestProvider
                                                .searchlist =
                                            AppConstants.wfhRequestsmodel!
                                                .data!
                                                .where((element) =>
                                                    DateFormat('MMM d, y').format(DateTime.parse(element.to.toString())).toLowerCase().contains(value.toString().toLowerCase()) ||
                                                    DateFormat('MMM d, y').format(DateTime.parse(element.from.toString())).toLowerCase().contains(value.toString().toLowerCase()) ||
                                                    element.status.toString().toLowerCase().contains(value.toString().toLowerCase()) ||
                                                    element.employee!.firstname.toString().toLowerCase().contains(value.toString().toLowerCase()))
                                                .toList();
                                        wFHRequestProvider.hitupdate();
                                      }),
                                ),
                                PopupMenuButton<String>(
                                  icon: SvgPicture.asset(ImagePath.filterIcon,
                                      height: 30),
                                  onSelected: (String value) {
                                    wFHRequestProvider.changeallFilterValue(
                                        value, context);
                                  },
                                  itemBuilder: (BuildContext context) {
                                    return wFHRequestProvider.allitems
                                        .map((String item) {
                                      return PopupMenuItem<String>(
                                        value: item,
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            CommonTextPoppins(
                                              text: item,
                                              fontweight: FontWeight.w400,
                                              fontsize: 12,
                                              color: AppColors.blackColor,
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
                              ],
                            );
                          },
                        )),
                    20.sh,
                    CommonRequestsTableRow(
                        rowColor: AppColors.tablefillColor,
                        date: "Start Date",
                        srNo: "Employee",
                        status: 0,
                        textColor: AppColors.primaryColor,
                        statusText: "End Date",
                        actionTap: () {},
                        actionText: "Status"),
                    Consumer<WorkFromHomeProvider>(
                      builder: (context, wFHRequestProvider, child) {
                        if (wFHRequestProvider.wFHRequestLoading) {
                          return const Center(
                              child: CircularProgressIndicator.adaptive());
                        } else {
                          if (wFHRequestProvider
                              .searchAllController.text.isEmpty) {
                            return ListView.builder(
                              itemCount: AppConstants
                                  .wfhRequestsmodel!.data!.length,
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemBuilder: (context, index) {
                                return AdminAllCorrectionRequestRow(
                                    rowColor: index % 2 == 1
                                        ? AppColors.tablefillColor
                                        : AppColors.tableUnfillColor,
                                    date: DateFormat('MMM d, y').format(DateTime.parse(AppConstants.wfhRequestsmodel!.data![index].from.toString().substring(0, 10),)),                              
                                    employeeName: AppConstants.wfhRequestsmodel!.data![index].employee!.firstname.toString(),
                                    requestFor:DateFormat('MMM d, y').format(DateTime.parse(AppConstants.wfhRequestsmodel!.data![index].to.toString().substring(0, 10),)),      
                                    status: AppConstants.wfhRequestsmodel!
                                                .data![index].status
                                                .toString() ==
                                            "approved"
                                        ? 1
                                        : AppConstants.wfhRequestsmodel!
                                                    .data![index].status
                                                    .toString() ==
                                                "rejected"
                                            ? 2
                                            : AppConstants
                                                        .wfhRequestsmodel!
                                                        .data![index]
                                                        .status
                                                        .toString() ==
                                                    "pending"
                                                ? 3
                                                : 0,
                                    statusText: "",
                                    actionTap: () {
                                      CommonBottomSheet(
                                          context: context,
                                          widget: SingleChildScrollView(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 12),
                                              child: SizedBox(
                                                child: Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.start,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Center(
                                                        child:
                                                            CommonTextPoppins(
                                                                text: "Status",
                                                                talign:
                                                                    TextAlign
                                                                        .left,
                                                                fontweight:
                                                                    FontWeight
                                                                        .w600,
                                                                fontsize: 20,
                                                                color: AppColors
                                                                    .textColor),
                                                      ),
                                                      30.sh,
                                                      Row(
                                                        children: [
                                                          Expanded(
                                                            flex: 2,
                                                            child: Column(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .start,
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .start,
                                                              children: [
                                                                CommonTextPoppins(
                                                                    text:
                                                                        "DATE",
                                                                    talign:
                                                                        TextAlign
                                                                            .left,
                                                                    fontweight:
                                                                        FontWeight
                                                                            .w500,
                                                                    fontsize:
                                                                        12,
                                                                    color: AppColors
                                                                        .hintTextColor),
                                                                Row(
                                                                  children: [
                                                                    Expanded(
                                                                        flex: 2,
                                                                        child: Container(
                                                                            height:
                                                                                50,
                                                                            decoration: BoxDecoration(
                                                                                border: Border.all(color: AppColors.textColor.withOpacity(.25)),
                                                                                color: AppColors.fillColor,
                                                                                borderRadius: BorderRadius.circular(8)),
                                                                            child: Center(child: CommonTextPoppins(talign: TextAlign.center, text: AppConstants.wfhRequestsmodel!.data![index].from.toString() == "null" ? "" : DateFormat('MMMM y').format(DateTime.parse(AppConstants.wfhRequestsmodel!.data![index].from.toString())), fontweight: FontWeight.w400, fontsize: 14, color: AppColors.textColor)))),
                                                                    CommonTextPoppins(
                                                                        text:
                                                                            " - ",
                                                                        fontweight:
                                                                            FontWeight
                                                                                .w400,
                                                                        fontsize:
                                                                            14,
                                                                        color: AppColors
                                                                            .textColor),
                                                                    Expanded(
                                                                        flex: 1,
                                                                        child: Container(
                                                                            height: 50,
                                                                            decoration: BoxDecoration(border: Border.all(color: AppColors.textColor.withOpacity(.25)), color: AppColors.fillColor, borderRadius: BorderRadius.circular(8)),
                                                                            child: Center(
                                                                              child: CommonTextPoppins(talign: TextAlign.center, text: AppConstants.wfhRequestsmodel!.data![index].from.toString() == "null" ? "" : DateFormat('d').format(DateTime.parse(AppConstants.wfhRequestsmodel!.data![index].from.toString())), fontweight: FontWeight.w400, fontsize: 14, color: AppColors.textColor),
                                                                            ))),
                                                                    //to
                                                                    CommonTextPoppins(
                                                                        text:
                                                                            " to ",
                                                                        fontweight:
                                                                            FontWeight
                                                                                .w400,
                                                                        fontsize:
                                                                            14,
                                                                        color: AppColors
                                                                            .textColor),
                                                                    //to
                                                                    Expanded(
                                                                        flex: 2,
                                                                        child: Container(
                                                                            height:
                                                                                50,
                                                                            decoration: BoxDecoration(
                                                                                border: Border.all(color: AppColors.textColor.withOpacity(.25)),
                                                                                color: AppColors.fillColor,
                                                                                borderRadius: BorderRadius.circular(8)),
                                                                            child: Center(child: CommonTextPoppins(talign: TextAlign.center, text: AppConstants.wfhRequestsmodel!.data![index].to.toString() == "null" ? "" : DateFormat('MMMM y').format(DateTime.parse(AppConstants.wfhRequestsmodel!.data![index].to.toString())), fontweight: FontWeight.w400, fontsize: 14, color: AppColors.textColor)))),
                                                                    CommonTextPoppins(
                                                                        text:
                                                                            " - ",
                                                                        fontweight:
                                                                            FontWeight
                                                                                .w400,
                                                                        fontsize:
                                                                            14,
                                                                        color: AppColors
                                                                            .textColor),
                                                                    Expanded(
                                                                        flex: 1,
                                                                        child: Container(
                                                                            height: 50,
                                                                            decoration: BoxDecoration(border: Border.all(color: AppColors.textColor.withOpacity(.25)), color: AppColors.fillColor, borderRadius: BorderRadius.circular(8)),
                                                                            child: Center(
                                                                              child: CommonTextPoppins(talign: TextAlign.center, text: AppConstants.wfhRequestsmodel!.data![index].to.toString() == "null" ? "" : DateFormat('d').format(DateTime.parse(AppConstants.wfhRequestsmodel!.data![index].to.toString())).toString(), fontweight: FontWeight.w400, fontsize: 14, color: AppColors.textColor),
                                                                            ))),
                                                                    const Expanded(
                                                                        flex: 1,
                                                                        child:
                                                                            SizedBox()),
                                                                  ],
                                                                ),
                                                                16.sh,
                                                                CommonTextPoppins(
                                                                    text:
                                                                        "Reason",
                                                                    talign:
                                                                        TextAlign
                                                                            .left,
                                                                    fontweight:
                                                                        FontWeight
                                                                            .w500,
                                                                    fontsize:
                                                                        12,
                                                                    color: AppColors
                                                                        .hintTextColor),
                                                                5.sh,
                                                                Container(
                                                                    padding: const EdgeInsets.symmetric(
                                                                        horizontal:
                                                                            20,
                                                                        vertical:
                                                                            10),
                                                                    decoration: BoxDecoration(
                                                                        border: Border.all(
                                                                            color: AppColors.textColor.withOpacity(
                                                                                .25)),
                                                                        color: AppColors
                                                                            .fillColor,
                                                                        borderRadius:
                                                                            BorderRadius.circular(
                                                                                8)),
                                                                    child: CommonTextPoppins(
                                                                        talign: TextAlign
                                                                            .left,
                                                                        text: AppConstants
                                                                            .wfhRequestsmodel!
                                                                            .data![index]
                                                                            .reason
                                                                            .toString(),
                                                                        fontweight: FontWeight.w400,
                                                                        fontsize: 14,
                                                                        color: AppColors.textColor)),
                                                              ],
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                      16.sh,
                                                      CommonTextPoppins(
                                                          text: "STATUS",
                                                          talign:
                                                              TextAlign.start,
                                                          fontweight:
                                                              FontWeight.w500,
                                                          fontsize: 12,
                                                          color: AppColors
                                                              .hintTextColor),
                                                      4.sh,
                                                      SizedBox(
                                                          height: 50,
                                                          width: 90,
                                                          child: Center(
                                                              child: Container(
                                                                  height: 30,
                                                                  width: 90,
                                                                  decoration: BoxDecoration(
                                                                      borderRadius: BorderRadius.circular(8),
                                                                      //color:status==1? AppColors.success:status==2?const Color(0XFFE34A4A):status==3?AppColors.primaryColor:AppColors.whiteColor,),
                                                                      color: AppConstants.wfhRequestsmodel!.data![index].status.toString() == "approved"
                                                                          ? AppColors.success
                                                                          : AppConstants.wfhRequestsmodel!.data![index].status.toString() == "rejected"
                                                                              ? AppColors.redColor
                                                                              : AppConstants.wfhRequestsmodel!.data![index].status.toString() == "pending"
                                                                                  ? AppColors.primaryColor
                                                                                  : AppColors.whiteColor),
                                                                  child: Center(
                                                                      child: Text(
                                                                    AppConstants
                                                                        .wfhRequestsmodel!
                                                                        .data![
                                                                            index]
                                                                        .status
                                                                        .toString(),
                                                                    style: TextStyle(
                                                                        color: AppColors
                                                                            .whiteColor),
                                                                  ))))),
                                                      //child: Center(child: CommonTextPoppins(text:status==1? "Approved":status==2?"REJECTED":status==3?"Pending":"", fontweight: FontWeight.w500, fontsize: 12, color: AppColors.whiteColor)))),),
                           Consumer<WorkFromHomeProvider>(
                            builder: (context, workFromHomeProvider, child) {
                              return workFromHomeProvider.decisionLoading
                                      ? const Center(
                                          child: CircularProgressIndicator.adaptive(),
                                        )
                                      :
                                  Padding(padding: const EdgeInsets.symmetric(horizontal:25.0),
                                    child: Column(mainAxisSize: MainAxisSize.min, children: [
                                    CommonButtonImage(
                                      onPressed: () {
                                        workFromHomeProvider.approveDenyWfhRequest(context: context, decision: "approved", requestId: AppConstants.wfhRequestsmodel!.data![index].id.toString(), employeeId: AppConstants.wfhRequestsmodel!.data![index].employee!.id.toString(), approverId: AppConstants.loginmodell!.userData!.id.toString());
                                      },
                                      width: MediaQuery.of(context).size.width,
                                      text: "Approve",
                                      color: AppColors.primaryColor,
                                      image: ImagePath.approveIcon),
                                  20.sh,
                                  DenyButton(
                                      text: "Deny",
                                      ontap: () {
                                        workFromHomeProvider.approveDenyWfhRequest(context: context, decision: "rejected", requestId: AppConstants.wfhRequestsmodel!.data![index].id.toString(), employeeId: AppConstants.wfhRequestsmodel!.data![index].employee!.id.toString(), approverId: AppConstants.loginmodell!.userData!.id.toString());
                                      },
                                      imagePath: ImagePath.denyIcon)
                                      ]),
                                    );
                                        },
                                      )
                                      ]),
                                      )));
                                    },
                                    );
                              },
                            );
                          } else if (wFHRequestProvider.searchlist.isNotEmpty) {
                            return ListView.builder(
                              itemCount: wFHRequestProvider.searchlist.length,
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemBuilder: (context, index) {
                                return AdminAllCorrectionRequestRow(
                                    rowColor: index % 2 == 1
                                        ? AppColors.tablefillColor
                                        : AppColors.tableUnfillColor,
                                    date: DateFormat('MMM d, y').format(DateTime.parse(wFHRequestProvider.searchlist[index].from.toString().substring(0, 10),)), 
                                    employeeName: wFHRequestProvider.searchlist[index].employee!.firstname.toString(),
                                    requestFor:DateFormat('MMM d, y').format(DateTime.parse(wFHRequestProvider.searchlist[index].to.toString().substring(0, 10),)), 
                                    status: wFHRequestProvider
                                                .searchlist[index].status
                                                .toString() ==
                                            "approved"
                                        ? 1
                                        : wFHRequestProvider
                                                    .searchlist[index].status
                                                    .toString() ==
                                                "rejected"
                                            ? 2
                                            : wFHRequestProvider
                                                        .searchlist[index]
                                                        .status
                                                        .toString() ==
                                                    "pending"
                                                ? 3
                                                : 0,
                                    statusText: "",
                                    actionTap: () {
                                      CommonBottomSheet(
                                          context: context,
                                          widget: SingleChildScrollView(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 12),
                                              child: SizedBox(
                                                child: Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.start,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Center(
                                                        child:
                                                            CommonTextPoppins(
                                                                text: "Status",
                                                                talign:
                                                                    TextAlign
                                                                        .left,
                                                                fontweight:
                                                                    FontWeight
                                                                        .w600,
                                                                fontsize: 20,
                                                                color: AppColors
                                                                    .textColor),
                                                      ),
                                                      30.sh,
                                                      Row(
                                                        children: [
                                                          Expanded(
                                                            flex: 2,
                                                            child: Column(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .start,
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .start,
                                                              children: [
                                                                CommonTextPoppins(
                                                                    text:
                                                                        "DATE",
                                                                    talign:
                                                                        TextAlign
                                                                            .left,
                                                                    fontweight:
                                                                        FontWeight
                                                                            .w500,
                                                                    fontsize:
                                                                        12,
                                                                    color: AppColors
                                                                        .hintTextColor),
                                                                Row(
                                                                  children: [
                                                                    Expanded(
                                                                        flex: 2,
                                                                        child: Container(
                                                                            height:
                                                                                50,
                                                                            decoration: BoxDecoration(
                                                                                border: Border.all(color: AppColors.textColor.withOpacity(.25)),
                                                                                color: AppColors.fillColor,
                                                                                borderRadius: BorderRadius.circular(8)),
                                                                            child: Center(child: CommonTextPoppins(talign: TextAlign.center, text: wFHRequestProvider.searchlist[index].from.toString() == "null" ? "" : DateFormat('MMMM y').format(DateTime.parse(wFHRequestProvider.searchlist[index].from.toString())), fontweight: FontWeight.w400, fontsize: 14, color: AppColors.textColor)))),
                                                                    CommonTextPoppins(
                                                                        text:
                                                                            " - ",
                                                                        fontweight:
                                                                            FontWeight
                                                                                .w400,
                                                                        fontsize:
                                                                            14,
                                                                        color: AppColors
                                                                            .textColor),
                                                                    Expanded(
                                                                        flex: 1,
                                                                        child: Container(
                                                                            height: 50,
                                                                            decoration: BoxDecoration(border: Border.all(color: AppColors.textColor.withOpacity(.25)), color: AppColors.fillColor, borderRadius: BorderRadius.circular(8)),
                                                                            child: Center(
                                                                              child: CommonTextPoppins(talign: TextAlign.center, text: wFHRequestProvider.searchlist[index].from.toString() == "null" ? "" : DateFormat('d').format(DateTime.parse(wFHRequestProvider.searchlist[index].from.toString())), fontweight: FontWeight.w400, fontsize: 14, color: AppColors.textColor),
                                                                            ))),
                                                                    //to
                                                                    CommonTextPoppins(
                                                                        text:
                                                                            " to ",
                                                                        fontweight:
                                                                            FontWeight
                                                                                .w400,
                                                                        fontsize:
                                                                            14,
                                                                        color: AppColors
                                                                            .textColor),
                                                                    //to
                                                                    Expanded(
                                                                        flex: 2,
                                                                        child: Container(
                                                                            height:
                                                                                50,
                                                                            decoration: BoxDecoration(
                                                                                border: Border.all(color: AppColors.textColor.withOpacity(.25)),
                                                                                color: AppColors.fillColor,
                                                                                borderRadius: BorderRadius.circular(8)),
                                                                            child: Center(child: CommonTextPoppins(talign: TextAlign.center, text: wFHRequestProvider.searchlist[index].to.toString() == "null" ? "" : DateFormat('MMMM y').format(DateTime.parse(wFHRequestProvider.searchlist[index].to.toString())), fontweight: FontWeight.w400, fontsize: 14, color: AppColors.textColor)))),
                                                                    CommonTextPoppins(
                                                                        text:
                                                                            " - ",
                                                                        fontweight:
                                                                            FontWeight
                                                                                .w400,
                                                                        fontsize:
                                                                            14,
                                                                        color: AppColors
                                                                            .textColor),
                                                                    Expanded(
                                                                        flex: 1,
                                                                        child: Container(
                                                                            height: 50,
                                                                            decoration: BoxDecoration(border: Border.all(color: AppColors.textColor.withOpacity(.25)), color: AppColors.fillColor, borderRadius: BorderRadius.circular(8)),
                                                                            child: Center(
                                                                              child: CommonTextPoppins(talign: TextAlign.center, text: wFHRequestProvider.searchlist[index].to.toString() == "null" ? "" : DateFormat('d').format(DateTime.parse(wFHRequestProvider.searchlist[index].to.toString())).toString(), fontweight: FontWeight.w400, fontsize: 14, color: AppColors.textColor),
                                                                            ))),
                                                                    const Expanded(
                                                                        flex: 1,
                                                                        child:
                                                                            SizedBox()),
                                                                  ],
                                                                ),
                                                                16.sh,
                                                                CommonTextPoppins(
                                                                    text:
                                                                        "Reason",
                                                                    talign:
                                                                        TextAlign
                                                                            .left,
                                                                    fontweight:
                                                                        FontWeight
                                                                            .w500,
                                                                    fontsize:
                                                                        12,
                                                                    color: AppColors
                                                                        .hintTextColor),
                                                                5.sh,
                                                                Container(
                                                                    padding: const EdgeInsets.symmetric(
                                                                        horizontal:
                                                                            20,
                                                                        vertical:
                                                                            10),
                                                                    decoration: BoxDecoration(
                                                                        border: Border.all(
                                                                            color: AppColors.textColor.withOpacity(
                                                                                .25)),
                                                                        color: AppColors
                                                                            .fillColor,
                                                                        borderRadius:
                                                                            BorderRadius.circular(
                                                                                8)),
                                                                    child: CommonTextPoppins(
                                                                        talign: TextAlign
                                                                            .left,
                                                                        text: AppConstants
                                                                            .wfhRequestsmodel!
                                                                            .data![index]
                                                                            .reason
                                                                            .toString(),
                                                                        fontweight: FontWeight.w400,
                                                                        fontsize: 14,
                                                                        color: AppColors.textColor)),
                                                                        16.sh,
                                                      CommonTextPoppins(
                                                          text: "STATUS",
                                                          talign:
                                                              TextAlign.start,
                                                          fontweight:
                                                              FontWeight.w500,
                                                          fontsize: 12,
                                                          color: AppColors
                                                              .hintTextColor),
                                                      4.sh,
                                                      SizedBox(
                                                          height: 50,
                                                          width: 90,
                                                          child: Center(
                                                              child: Container(
                                                                  height: 30,
                                                                  width: 90,
                                                                  decoration: BoxDecoration(
                                                                      borderRadius: BorderRadius.circular(8),
                                                                      //color:status==1? AppColors.success:status==2?const Color(0XFFE34A4A):status==3?AppColors.primaryColor:AppColors.whiteColor,),
                                                                      color: wFHRequestProvider.searchlist[index].status.toString() == "approved"
                                                                          ? AppColors.success
                                                                          : wFHRequestProvider.searchlist[index].status.toString() == "rejected"
                                                                              ? AppColors.redColor
                                                                              : wFHRequestProvider.searchlist[index].status.toString() == "pending"
                                                                                  ? AppColors.primaryColor
                                                                                  : AppColors.whiteColor),
                                                                  child: Center(
                                                                      child: Text(
                                                                    AppConstants
                                                                        .wfhRequestsmodel!
                                                                        .data![
                                                                            index]
                                                                        .status
                                                                        .toString(),
                                                                    style: TextStyle(
                                                                        color: AppColors
                                                                            .whiteColor),
                                                                  ))))),
                                        Consumer<WorkFromHomeProvider>(
                            builder: (context, workFromHomeProvider, child) {
                              return workFromHomeProvider.decisionLoading
                                      ? const Center(
                                          child: CircularProgressIndicator.adaptive(),
                                        )
                                      :
                                  Padding(padding: const EdgeInsets.symmetric(horizontal:25.0),
                                    child: Column(mainAxisSize: MainAxisSize.min, children: [
                                    CommonButtonImage(
                                      onPressed: () {
                                        workFromHomeProvider.approveDenyWfhRequest(context: context, decision: "approved", requestId: workFromHomeProvider.searchlist[index].id.toString(), employeeId: workFromHomeProvider.searchlist[index].employee!.id.toString(), approverId: AppConstants.loginmodell!.userData!.id.toString());
                                      },
                                      width: MediaQuery.of(context).size.width,
                                      text: "Approve",
                                      color: AppColors.primaryColor,
                                      image: ImagePath.approveIcon),
                                  20.sh,
                                  DenyButton(
                                      text: "Deny",
                                      ontap: () {
                                        workFromHomeProvider.approveDenyWfhRequest(context: context, decision: "rejected", requestId: workFromHomeProvider.searchlist[index].id.toString(), employeeId: workFromHomeProvider.searchlist[index].employee!.id.toString(), approverId: AppConstants.loginmodell!.userData!.id.toString());
                                      },
                                      imagePath: ImagePath.denyIcon),
                                      10.sh,
                      ]),
                                    );
                            },
                          )
                                                              ],
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                     ]),
                                              )));
                                    },
                                    );
                              },
                            );
                          } else {
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
                            );
                          }
                        }
                      },
                    ),
                  ])));
          }
          },
        items: const ["My Requests","All Requests"],
        buttonOnPressed: () {
          CommonBottomSheet(
              context: context,
              widget: FutureBuilder( 
               future:wFHProvider.callinggetWFH(context), 
                        builder:(context, snapshot) {
                           if (snapshot.connectionState == ConnectionState.waiting) {
                          return const Center(child: CircularProgressIndicator.adaptive());
                        }else if (snapshot.hasError) {
                          return Center(child: CommonTextPoppins(text: "Error: ${snapshot.error}", color: AppColors.textColor, fontsize: 12, fontweight: FontWeight.w400));
                        }
                        return Consumer<WorkFromHomeProvider>(
                  builder: (context, wfhProvider, child) {
                    return SingleChildScrollView(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: wfhProvider.enddateformat == ""
                                ? Center(
                                    child: CommonTextPoppins(
                                      text: wfhProvider.startdateformat,
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
                                            text: wfhProvider.startdateformat,
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
                                            text: wfhProvider.enddateformat,
                                            fontweight: FontWeight.w600,
                                            fontsize: 15,
                                            color: AppColors.textColor,
                                            talign: TextAlign.left,
                                          ))
                                    ],
                                  ),
                          ),
                          10.sh,
                          Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 28,
                            ),
                            child: SfDateRangePicker(
                              monthViewSettings:const DateRangePickerMonthViewSettings(
                                //peding
                                //myDates: wfhProvider.approved,
                                //specialDates: wfhProvider.approved,
                                //blackoutDates: wfhProvider.rejected,
                              ),
                              enableMultiView: false,
                              navigationMode: DateRangePickerNavigationMode.scroll,
                              minDate: DateTime.now(),
                              rangeTextStyle:
                                  TextStyle(color: AppColors.hintTextColor),
                              monthCellStyle: DateRangePickerMonthCellStyle(
                                // myDatesDecoration: BoxDecoration(
                                //     color:
                                //         AppColors.primaryColor.withOpacity(.25),
                                //     border: Border.all(
                                //         color: AppColors.primaryColor,
                                //         width: 1),
                                //     shape: BoxShape.circle),
                                blackoutDatesDecoration: BoxDecoration(
                                    color:
                                        AppColors.primaryColor.withOpacity(.25),
                                    border: Border.all(
                                        color: AppColors.redColor, width: 1),
                                    shape: BoxShape.circle),
                                specialDatesDecoration: BoxDecoration(
                                    color:
                                        AppColors.primaryColor.withOpacity(.25),
                                    border: Border.all(
                                        color: AppColors.primaryColor, width: 1),
                                    shape: BoxShape.circle),
                                textStyle:
                                    TextStyle(color: AppColors.hintTextColor),
                              ),
                              rangeSelectionColor: const Color(0XFFd6ebf6),
                              headerStyle: DateRangePickerHeaderStyle(
                                  textStyle: TextStyle(
                                      color: AppColors.blackColor,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600)),
                              selectionMode: DateRangePickerSelectionMode.range,
                              onSelectionChanged:
                                  (dateRangePickerSelectionChangedArgs) {
                                wfhProvider.changeDateFormat(
                                    dateRangePickerSelectionChangedArgs);
                              },
                            ),
                          ),
                          wfhProvider.startdateformat == ""
                              ? const SizedBox()
                              : Container(
                                  decoration: BoxDecoration(
                                      border: Border.all(
                                          width: 1,
                                          color: AppColors.textColor
                                              .withOpacity(.25)),
                                      color: const Color(0XFFFAFAFA),
                                      borderRadius: BorderRadius.circular(8)),
                                  padding:
                                      const EdgeInsets.only(left: 16, top: 8),
                                  margin: const EdgeInsets.only(
                                      left: 24, right: 24, bottom: 30, top: 0),
                                  width: width(context),
                                  child: Form(
                                    key: wfhProvider.noteFormKey,
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        CommonTextPoppins(
                                            text: "Your Message",
                                            talign: TextAlign.left,
                                            fontweight: FontWeight.w500,
                                            fontsize: 12,
                                            color: AppColors.hintTextColor),
                                        TextFormField(
                                          controller: wfhProvider.note,
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
                                ),
                        
                        wfhProvider.startdateformat == ""
                            ? const SizedBox()
                            : Padding(
                                padding: const EdgeInsets.only(
                                    left: 48, right: 48, bottom: 30),
                                child: wfhProvider.loading
                                      ? const Center(
                                          child: CircularProgressIndicator.adaptive(),
                                        )
                                      : CommonButton(
                                    onPressed: () {
                                      if (wfhProvider.noteFormKey.currentState!
                                          .validate()) {
                                        wfhProvider.checkExistance();
                                        if (wfhProvider.alreadyExist) {
                                          Fluttertoast.showToast(
                                              msg:
                                                  "Already applied ");
                                        } else {
                                          wfhProvider
                                              .callWorkFromHome(contexta);
                                        }
                                          }},
                                      width: width(context),
                                      text: "Apply Now"),
                                )
                        ],
                      ),
                    );
                  },
                );}
              ));
        },
        textColor: AppColors.primaryColor,
        buttonTitle: "Apply Work From Home");
  }
}
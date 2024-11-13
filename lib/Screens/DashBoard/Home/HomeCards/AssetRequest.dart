import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gleam_hr/Components/CommonBottomSheet.dart';
import 'package:gleam_hr/Components/CommonButton.dart';
import 'package:gleam_hr/Components/CommonDropDown.dart';
import 'package:gleam_hr/Components/CommonText.dart';
import 'package:gleam_hr/Components/CommonTextField.dart';
import 'package:gleam_hr/Providers/DashBoardProviders/HomeProviders/AssetRequest_Provider.dart';
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

class AssetRequest extends StatelessWidget {
  const AssetRequest({super.key});

  @override
  Widget build(BuildContext context) {
    var assetProvider = Provider.of<AssetRequestProvider>(context, listen: false);
    return CommonDashBoardCard(
        color: AppColors.primaryColor.withOpacity(.11),
        title: "Assets",
        showButton: true,
        subTitle: "You can request for assets here",
        leadingPath: ImagePath.assettracking,
        menurequired: true,
        items:AppConstants.loginmodell!.userRole![0].type.toString() ==
                "admin"? ["My Requests","All Requests"]:["My Requests"],
        cardOnPressed: () {},
        menuOnPressed: (value) {
          if (value == "My Requests") {
            assetProvider.assetRequests(context: context);
            CommonBottomSheet(
              context: context,
              widget: SingleChildScrollView(
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                    Center(
                      child: CommonTextPoppins(
                          text: "Asset Requests",
                          talign: TextAlign.left,
                          fontweight: FontWeight.w600,
                          fontsize: 20,
                          color: AppColors.textColor),
                    ),
                    30.sh,
                    Padding(
                        padding: EdgeInsets.zero,
                        child: Consumer<AssetRequestProvider>(
                          builder: (context, assetProvider, child) {
                            return Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                //dropdown
                                Consumer<AssetRequestProvider>(
                                  builder: (context, assetProvider, child) {
                                    if (assetProvider.assetRequestLoading) {
                                      return Container();
                                    } else {
                                      return CommonDropDown(
                                          width: 70,
                                          selectedText: assetProvider
                                              .dropdownSelectedText,
                                          listItem:
                                              assetProvider.dropdownlist,
                                          onchanged: (value) {
                                            assetProvider.changedropdown(
                                                value, context);
                                          });
                                    }
                                  },
                                ),
                                //CommonDropDown(width: 70, selectedText: assetProvider.dropdownSelectedText, listItem: assetProvider.dropdownlist, onchanged: (value){assetProvider.changedropdown(value);}),
                                //search
                                SizedBox(
                                  width: width(context) * .40,
                                  child: PeopleSearchBar(
                                      controller:
                                          assetProvider.searchController,
                                      onvaluechange: (value) {
                                        assetProvider
                                                .searchlist =
                                            AppConstants.assetRequestsmodel!
                                                .data!
                                                .where((element) =>
                                                    element.status.toString().toLowerCase().contains(value.toString().toLowerCase())||
                                                    DateFormat('MMM d, y').format(DateTime.parse(element.createdAt.toString())).toLowerCase().contains(value.toString().toLowerCase())
                                                    )
                                                .toList();
                                        assetProvider.hitupdate();
                                      }),
                                ),
                                PopupMenuButton<String>(
                                  icon: SvgPicture.asset(ImagePath.filterIcon,
                                      height: 30),
                                  onSelected: (String value) {
                                    assetProvider.changeFilterValue(
                                        value, context);
                                  },
                                  itemBuilder: (BuildContext context) {
                                    return assetProvider.items
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
                    Consumer<AssetRequestProvider>(
                      builder: (context, assetProvider, child) {
                        if (assetProvider.assetRequestLoading) {
                          return const Center(
                              child: CircularProgressIndicator.adaptive());
                        } else {
                          if (assetProvider
                              .searchController.text.isEmpty) {
                            return ListView.builder(
                              itemCount: AppConstants
                                  .assetRequestsmodel!.data!.length,
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemBuilder: (context, index) {
                                return CommonRequestsTableRow(
                                    rowColor: index % 2 == 1
                                        ? AppColors.tablefillColor
                                        : AppColors.tableUnfillColor,
                                    date: DateFormat('MMM d, y').format(DateTime.parse(AppConstants.assetRequestsmodel!.data![index].createdAt.toString().substring(0, 10),)),
                                    srNo: (index + 1).toString(),
                                    status: AppConstants.assetRequestsmodel!
                                                .data![index].status
                                                .toString() ==
                                            "approved"
                                        ? 1
                                        : AppConstants.assetRequestsmodel!
                                                    .data![index].status
                                                    .toString() ==
                                                "rejected"
                                            ? 2
                                            : AppConstants
                                                        .assetRequestsmodel!
                                                        .data![index]
                                                        .status
                                                        .toString() ==
                                                    "pending"
                                                ? 3
                                            :AppConstants
                                                        .assetRequestsmodel!
                                                        .data![index]
                                                        .status
                                                        .toString() ==
                                                    "canceled"
                                                ? 4
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
                                                                            child: Center(child: CommonTextPoppins(talign: TextAlign.center, text: AppConstants.assetRequestsmodel!.data![index].createdAt.toString() == "null" ? "" : DateFormat('MMMM y').format(DateTime.parse(AppConstants.assetRequestsmodel!.data![index].createdAt.toString())), fontweight: FontWeight.w400, fontsize: 14, color: AppColors.textColor)))),
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
                                                                              child: CommonTextPoppins(talign: TextAlign.center, text: AppConstants.assetRequestsmodel!.data![index].createdAt.toString() == "null" ? "" : DateFormat('d').format(DateTime.parse(AppConstants.assetRequestsmodel!.data![index].createdAt.toString())), fontweight: FontWeight.w400, fontsize: 14, color: AppColors.textColor),
                                                                            ))),
                                                                    ],
                                                                ),
                                                                16.sh,
                                                                CommonTextPoppins(
                                                                    text:
                                                                        "Message",
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
                                                                            .assetRequestsmodel!
                                                                            .data![index]
                                                                            .message
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
                                                                      color: AppConstants.assetRequestsmodel!.data![index].status.toString() == "approved"
                                                                          ? AppColors.success
                                                                          : AppConstants.assetRequestsmodel!.data![index].status.toString() == "rejected"
                                                                              ? AppColors.redColor
                                                                              : AppConstants.assetRequestsmodel!.data![index].status.toString() == "pending"
                                                                                  ? AppColors.primaryColor
                                                                                  :AppConstants.assetRequestsmodel!.data![index].status.toString() == "canceled"?
                                                                                  Colors.orange.withOpacity(.5)
                                                                                  : AppColors.whiteColor),
                                                                  child: Center(
                                                                      child: Text(
                                                                    AppConstants
                                                                        .assetRequestsmodel!
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
                          } else if (assetProvider.searchlist.isNotEmpty) {
                            return ListView.builder(
                              itemCount: assetProvider.searchlist.length,
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemBuilder: (context, index) {
                                return CommonRequestsTableRow(
                                    rowColor: index % 2 == 1
                                        ? AppColors.tablefillColor
                                        : AppColors.tableUnfillColor,
                                    date: DateFormat('MMM d, y').format(DateTime.parse(assetProvider.searchlist[index].createdAt.toString().substring(0, 10),)),
                                    srNo: (index + 1).toString(),
                                    status: assetProvider
                                                .searchlist[index].status
                                                .toString() ==
                                            "approved"
                                        ? 1
                                        : assetProvider
                                                    .searchlist[index].status
                                                    .toString() ==
                                                "rejected"
                                            ? 2
                                            : assetProvider
                                                        .searchlist[index]
                                                        .status
                                                        .toString() ==
                                                    "pending"
                                                ? 3
                                                :
                                                assetProvider
                                                        .searchlist[index]
                                                        .status
                                                        .toString() ==
                                                    "canceled"
                                              ? 4 : 0,
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
                                                                            child: Center(child: CommonTextPoppins(talign: TextAlign.center, text: assetProvider.searchlist[index].createdAt.toString() == "null" ? "" : DateFormat('MMMM y').format(DateTime.parse(assetProvider.searchlist[index].createdAt.toString())), fontweight: FontWeight.w400, fontsize: 14, color: AppColors.textColor)))),
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
                                                                              child: CommonTextPoppins(talign: TextAlign.center, text: assetProvider.searchlist[index].createdAt.toString() == "null" ? "" : DateFormat('d').format(DateTime.parse(assetProvider.searchlist[index].createdAt.toString())), fontweight: FontWeight.w400, fontsize: 14, color: AppColors.textColor),
                                                                            ))),
                                                                    ],
                                                                ),
                                                                16.sh,
                                                                CommonTextPoppins(
                                                                    text:
                                                                        "Message",
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
                                                                            .assetRequestsmodel!
                                                                            .data![index]
                                                                            .message
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
                                                                      color: assetProvider.searchlist[index].status.toString() == "approved"
                                                                          ? AppColors.success
                                                                          : assetProvider.searchlist[index].status.toString() == "rejected"
                                                                              ? AppColors.redColor
                                                                              : assetProvider.searchlist[index].status.toString() == "pending"
                                                                                  ? AppColors.primaryColor
                                                                                  :assetProvider.searchlist[index].status.toString() == "canceled"?
                                                                                  Colors.orange.withOpacity(.5) : AppColors.whiteColor),
                                                                  child: Center(
                                                                      child: Text(
                                                                    AppConstants
                                                                        .assetRequestsmodel!
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
          } else {
            // assetProvider.getAllAssetRequests(context: context);//here
              assetProvider.getAllAssetRequests(context: context);
          CommonBottomSheet(
              context: context,
              widget: SingleChildScrollView(
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                    Center(
                      child: CommonTextPoppins(
                          text: "Asset Requests",
                          talign: TextAlign.left,
                          fontweight: FontWeight.w600,
                          fontsize: 20,
                          color: AppColors.textColor),
                    ),
                    30.sh,
                    Padding(
                        padding: EdgeInsets.zero,
                        child: Consumer<AssetRequestProvider>(
                          builder: (context, assetRequestProvider, child) {
                            return Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                //dropdown
                                Consumer<AssetRequestProvider>(
                                  builder: (context, assetRequestProvider, child) {
                                    if (assetRequestProvider.assetRequestLoading) {
                                      return Container();
                                    } else {
                                      return CommonDropDown(
                                          width: 70,
                                          selectedText: assetRequestProvider
                                              .dropdownAllSelectedText,
                                          listItem:
                                              assetRequestProvider.dropdownlist,
                                          onchanged: (value) {
                                            assetRequestProvider.changealldropdown(
                                                value, context);
                                          });
                                    }
                                  },
                                ),
                                //CommonDropDown(width: 70, selectedText: assetRequestProvider.dropdownSelectedText, listItem: assetRequestProvider.dropdownlist, onchanged: (value){assetRequestProvider.changedropdown(value);}),
                                //search
                                SizedBox(
                                  width: width(context) * .40,
                                  child: PeopleSearchBar(
                                      controller:
                                          assetRequestProvider.searchallController,
                                      onvaluechange: (value) {
                                        assetRequestProvider
                                                .searchlist =
                                            AppConstants.assetRequestsmodel!
                                                .data!
                                                .where((element) =>
                                                    element.employee!.firstname.toString().toLowerCase().contains(value.toString().toLowerCase()) ||
                                                    element.status.toString().toLowerCase().contains(value.toString().toLowerCase()) ||
                                                    DateFormat('MMM d, y').format(DateTime.parse(element.createdAt.toString())).toLowerCase().contains(value.toString().toLowerCase())||
                                                    element.employee!.lastname.toString().toLowerCase().contains(value.toString().toLowerCase())
                                                    )
                                                .toList();
                                        assetRequestProvider.hitupdate();
                                      }),
                                ),
                                PopupMenuButton<String>(
                                  icon: SvgPicture.asset(ImagePath.filterIcon,
                                      height: 30),
                                  onSelected: (String value) {
                                    assetRequestProvider.changeallFilterValue(
                                        value, context);
                                  },
                                  itemBuilder: (BuildContext context) {
                                    return assetRequestProvider.allitems
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
                        date: "L Name",
                        srNo: "F Name",
                        status: 0,
                        textColor: AppColors.primaryColor,
                        statusText: "Date",
                        actionTap: () {},
                        actionText: "Status"),
                    Consumer<AssetRequestProvider>(
                      builder: (context, assetRequestProvider, child) {
                        if (assetRequestProvider.assetRequestLoading) {
                          return const Center(
                              child: CircularProgressIndicator.adaptive());
                        } else {
                          if (assetRequestProvider
                              .searchallController.text.isEmpty) {
                            return ListView.builder(
                              itemCount: AppConstants
                                  .assetRequestsmodel!.data!.length,
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemBuilder: (context, index) {
                                return AdminAllCorrectionRequestRow(
                                    rowColor: index % 2 == 1
                                        ? AppColors.tablefillColor
                                        : AppColors.tableUnfillColor,
                                    requestFor: DateFormat('MMM d, y').format(DateTime.parse(AppConstants.assetRequestsmodel!.data![index].createdAt.toString().substring(0, 10),)),
                                    employeeName: AppConstants.assetRequestsmodel!.data![index].employee!.firstname.toString(),
                                    date: AppConstants.assetRequestsmodel!.data![index].employee!.lastname.toString(),
                                    status: AppConstants.assetRequestsmodel!
                                                .data![index].status
                                                .toString() =="approved"
                                        ? 1
                                        : AppConstants.assetRequestsmodel!
                                                    .data![index].status
                                                    .toString() =="rejected"
                                            ? 2
                                            : AppConstants
                                                        .assetRequestsmodel!
                                                        .data![index]
                                                        .status
                                                        .toString() =="pending"
                                                ? 3
                                                : AppConstants
                                                        .assetRequestsmodel!
                                                        .data![index]
                                                        .status
                                                        .toString() =="canceled"? 4:0,
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
                                                                            child: Center(child: CommonTextPoppins(talign: TextAlign.center, text: AppConstants.assetRequestsmodel!.data![index].createdAt.toString() == "null" ? "" : DateFormat('MMMM y').format(DateTime.parse(AppConstants.assetRequestsmodel!.data![index].createdAt.toString())), fontweight: FontWeight.w400, fontsize: 14, color: AppColors.textColor)))),
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
                                                                              child: CommonTextPoppins(talign: TextAlign.center, text: AppConstants.assetRequestsmodel!.data![index].createdAt.toString() == "null" ? "" : DateFormat('d').format(DateTime.parse(AppConstants.assetRequestsmodel!.data![index].createdAt.toString())), fontweight: FontWeight.w400, fontsize: 14, color: AppColors.textColor),
                                                                            ))),
                                                                    ],
                                                                ),
                                                                16.sh,
                                                                CommonTextPoppins(
                                                                    text:
                                                                        "Message",
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
                                                                            .assetRequestsmodel!
                                                                            .data![index]
                                                                            .message
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
                                                                      color: AppConstants.assetRequestsmodel!.data![index].status.toString() == "approved"
                                                                          ? AppColors.success
                                                                          : AppConstants.assetRequestsmodel!.data![index].status.toString() == "rejected"
                                                                              ? AppColors.redColor
                                                                              : AppConstants.assetRequestsmodel!.data![index].status.toString() == "pending"
                                                                                  ? AppColors.primaryColor
                                                                              : AppConstants.assetRequestsmodel!.data![index].status.toString() == "canceled"
                                                                              ? Colors.orange.withOpacity(.5)
                                                                                  : AppColors.whiteColor),
                                                                  child: Center(
                                                                      child: Text(
                                                                    AppConstants.assetRequestsmodel!.data![index].status.toString(),
                                                                    style: TextStyle(
                                                                        color: AppColors
                                                                            .whiteColor),
                                                                  ))))),
                                                      //child: Center(child: CommonTextPoppins(text:status==1? "Approved":status==2?"REJECTED":status==3?"Pending":"", fontweight: FontWeight.w500, fontsize: 12, color: AppColors.whiteColor)))),),
                                                      Consumer<AssetRequestProvider>(
                            builder: (context, assetRequestProvider, child) {
                              return assetRequestProvider.decisionLoading
                                      ? const Center(
                                          child: CircularProgressIndicator.adaptive(),
                                        )
                                      :
                                  Padding(padding: const EdgeInsets.symmetric(horizontal:25.0),
                                    child: Column(mainAxisSize: MainAxisSize.min, children: [
                                    CommonButtonImage(
                                      onPressed: () {
                                        assetRequestProvider.approveDenyAssetRequest(context: context, decision: "approved", requestId: AppConstants.assetRequestsmodel!.data![index].id.toString(), employeeId: AppConstants.assetRequestsmodel!.data![index].employee!.id.toString(), assetTypeId: AppConstants.assetRequestsmodel!.data![index].assetTypeId.toString());
                                      },
                                      width: MediaQuery.of(context).size.width,
                                      text: "Approve",
                                      color: AppColors.primaryColor,
                                      image: ImagePath.approveIcon),
                                  20.sh,
                                  DenyButton(
                                      text: "Deny",
                                      ontap: () {
                                        assetRequestProvider.approveDenyAssetRequest(context: context, decision: "rejected", requestId: AppConstants.assetRequestsmodel!.data![index].id.toString(), employeeId: AppConstants.assetRequestsmodel!.data![index].employee!.id.toString(), assetTypeId: AppConstants.assetRequestsmodel!.data![index].assetTypeId.toString());
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
                          } else if (assetRequestProvider.searchlist.isNotEmpty) {
                            return ListView.builder(
                              itemCount: assetRequestProvider.searchlist.length,
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemBuilder: (context, index) {
                                return AdminAllCorrectionRequestRow(
                                    rowColor: index % 2 == 1
                                        ? AppColors.tablefillColor
                                        : AppColors.tableUnfillColor,
                                    requestFor: DateFormat('MMM d, y').format(DateTime.parse(assetRequestProvider.searchlist[index].createdAt.toString().substring(0, 10),)),
                                    employeeName: assetRequestProvider.searchlist[index].employee!.firstname.toString(),
                                    date: assetRequestProvider
                                        .searchlist[index].employee!.lastname
                                        .toString(),
                                    status: assetRequestProvider
                                                .searchlist[index].status
                                                .toString() ==
                                            "approved"
                                        ? 1
                                        : assetRequestProvider
                                                    .searchlist[index].status
                                                    .toString() ==
                                                "rejected"
                                            ? 2
                                            : assetRequestProvider
                                                        .searchlist[index]
                                                        .status
                                                        .toString() ==
                                                    "pending"
                                                ? 3
                                                :assetRequestProvider
                                                        .searchlist[index]
                                                        .status
                                                        .toString() ==
                                                    "canceled"
                                                ?4: 0,
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
                                                                            child: Center(child: CommonTextPoppins(talign: TextAlign.center, text: assetRequestProvider.searchlist[index].createdAt.toString() == "null" ? "" : DateFormat('MMMM y').format(DateTime.parse(assetRequestProvider.searchlist[index].createdAt.toString())), fontweight: FontWeight.w400, fontsize: 14, color: AppColors.textColor)))),
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
                                                                              child: CommonTextPoppins(talign: TextAlign.center, text: assetRequestProvider.searchlist[index].createdAt.toString() == "null" ? "" : DateFormat('d').format(DateTime.parse(assetRequestProvider.searchlist[index].createdAt.toString())), fontweight: FontWeight.w400, fontsize: 14, color: AppColors.textColor),
                                                                            ))),
                                                                    ],
                                                                ),
                                                                16.sh,
                                                                CommonTextPoppins(
                                                                    text:
                                                                        "Message",
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
                                                                            .assetRequestsmodel!
                                                                            .data![index]
                                                                            .message
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
                                                                      color: assetRequestProvider.searchlist[index].status.toString() == "approved"
                                                                          ? AppColors.success
                                                                          : assetRequestProvider.searchlist[index].status.toString() == "rejected"
                                                                              ? AppColors.redColor
                                                                              : assetRequestProvider.searchlist[index].status.toString() == "pending"
                                                                                  ? AppColors.primaryColor
                                                                                  : assetRequestProvider.searchlist[index].status.toString() == "canceled"?
                                                                                   Colors.orange.withOpacity(.5)
                                                                                   :AppColors.whiteColor),
                                                                  child: Center(
                                                                      child: Text(
                                                                    AppConstants
                                                                        .assetRequestsmodel!
                                                                        .data![
                                                                            index]
                                                                        .status
                                                                        .toString(),
                                                                    style: TextStyle(
                                                                        color: AppColors
                                                                            .whiteColor),
                                                                  ))))),
                                        Consumer<AssetRequestProvider>(
                            builder: (context, assetRequestProvider, child) {
                              return assetRequestProvider.decisionLoading
                                      ? const Center(
                                          child: CircularProgressIndicator.adaptive(),
                                        )
                                      :
                                  Padding(padding: const EdgeInsets.symmetric(horizontal:25.0),
                                    child: Column(mainAxisSize: MainAxisSize.min, children: [
                                    CommonButtonImage(
                                      onPressed: () {
                                        assetRequestProvider.approveDenyAssetRequest(context: context, decision: "approved", requestId: assetRequestProvider.searchlist[index].id.toString(), employeeId: assetRequestProvider.searchlist[index].employee!.id.toString(), assetTypeId: assetRequestProvider.searchlist[index].assetTypeId.toString());
                                      },
                                      width: MediaQuery.of(context).size.width,
                                      text: "Approve",
                                      color: AppColors.primaryColor,
                                      image: ImagePath.approveIcon),
                                  20.sh,
                                  DenyButton(
                                      text: "Deny",
                                      ontap: () {
                                        assetRequestProvider.approveDenyAssetRequest(context: context, decision: "rejected", requestId: assetRequestProvider.searchlist[index].id.toString(), employeeId: assetRequestProvider.searchlist[index].employee!.id.toString(), assetTypeId: assetRequestProvider.searchlist[index].assetTypeId.toString());
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
        buttonOnPressed: () {
          CommonBottomSheet(
              context: context,
              widget: SingleChildScrollView(
              keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
              padding: const EdgeInsets.symmetric(horizontal: 15),
                child: Form(
                  key: assetProvider.formkey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10.0),
                          child: CommonTextPoppins(
                              text: "Request Asset",
                              fontweight: FontWeight.w600,
                              fontsize: 18,
                              color: AppColors.textColor),
                        ),
                      ),
                      15.sh,
                      FutureBuilder(
                        future: assetProvider.getAssetTypes(context: context),
                        builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return const Center(child: CircularProgressIndicator.adaptive());
                        }else if (snapshot.hasError) {
                          return Center(child: CommonTextPoppins(text: "Error: ${snapshot.error}", color: AppColors.textColor, fontsize: 12, fontweight: FontWeight.w400));
                        }
                        return Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            CommonTextPoppins(
                          text: "Asset Type",
                          fontweight: FontWeight.w400,
                          fontsize: 12,
                          color: AppColors.textColor),
                      5.sh,
                      Consumer<AssetRequestProvider>(
                        builder: (context, assetrequestProvider, child) {
                          return CommonDropDown(width: width(context), selectedText: assetrequestProvider.selectedAsset!, listItem: assetrequestProvider.assetTypes, onchanged: (value) {
                            assetrequestProvider.changeAssetType(value);
                          });
                        },
                      ),
                      15.sh,
                      CommonTextPoppins(
                          text: "Asset Message",
                          fontweight: FontWeight.w400,
                          fontsize: 12,
                          color: AppColors.textColor),
                      5.sh,
                      CommonTextField(
                        controller: assetProvider.assetMessage,
                        hinttext: 'Enter message here',
                        validator: (value) {
                          if (value.isEmpty) {
                            return "Please enter message";
                          }
                          return null;
                        },
                      ),
                      15.sh,
                      Consumer<AssetRequestProvider>(
                        builder: (context, assetRequestProvider, child) {
                          if (assetRequestProvider.isloading) {
                           return const Center(child: CircularProgressIndicator.adaptive());
                          } else {
                            return CommonButton(onPressed: (){
                            String assetId = AppConstants.assetTypes!.data!.firstWhere((element) => element.name == assetRequestProvider.selectedAsset).id.toString();
                        assetProvider.requestAsset(context: context, message: assetRequestProvider.assetMessage.text, assetId: assetId);
                      }, width: width(context), text: "Request Asset", color: AppColors.primaryColor, textColor: AppColors.whiteColor);
                          }
                        },
                      ),
                      20.sh,
                          ],
                        );
                      }),
                      
                    ],
                  ),
                ),
              ));
        },
        textColor: AppColors.primaryColor,
        buttonTitle: "Request Asset");
  }
}

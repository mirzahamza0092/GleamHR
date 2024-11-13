import 'package:flutter/material.dart';
import 'package:gleam_hr/Components/CommonBottomSheet.dart';
import 'package:gleam_hr/Components/CommonButton.dart';
import 'package:gleam_hr/Components/CommonDropDown.dart';
import 'package:gleam_hr/Components/CommonText.dart';
import 'package:gleam_hr/Providers/DashBoardProviders/HomeProviders/CorrectionRequest_Provider.dart';
import 'package:gleam_hr/Screens/DashBoard/Home/HomeWidgets/CommonDashBoardCard.dart';
import 'package:gleam_hr/Screens/DashBoard/Home/HomeWidgets/CorrectionRequestDate.dart';
import 'package:gleam_hr/Screens/DashBoard/Home/HomeWidgets/CorrectionRequestTime.dart';
import 'package:gleam_hr/Utils/AppPaths.dart';
import 'package:gleam_hr/Utils/Colors.dart';
import 'package:gleam_hr/Utils/SizedBox.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class CorrectionRequest extends StatelessWidget {
  const CorrectionRequest({super.key});

  @override
  Widget build(BuildContext context) {
    return CommonDashBoardCard(
        title: "Correction Request",
        subTitle: "Correct your attendance easily",
        leadingPath: ImagePath.payroll,
        menuOnPressed: () {},
        menurequired: false,
        buttonOnPressed: () {
          CommonBottomSheet(
              context: context,
              widget: Consumer<CorrectionRequestProvider>(
                builder: (context, correctionRequestProvider, child) {
                  return SingleChildScrollView(
                    child: Column(
                      children: [
                        Center(
                          child: CommonTextPoppins(
                              text: "Create Correction Request",
                              fontweight: FontWeight.w600,
                              fontsize: 20,
                              color: AppColors.textColor),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 24),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              32.sh,
                              ListView.builder(
                                itemCount: correctionRequestProvider.count,
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemBuilder: (context, index) {
                                  return Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      CommonTextPoppins(
                                          text: "Time In Status",
                                          talign: TextAlign.start,
                                          fontweight: FontWeight.w500,
                                          fontsize: 12,
                                          color: AppColors.hintTextColor),
                                      4.sh,
                                      CommonDropDown(
                                          width: width(context),
                                          selectedText:
                                              correctionRequestProvider
                                                  .selectedStatus[index],
                                          listItem: correctionRequestProvider
                                              .statusTypes,
                                          onchanged: (val) {
                                            correctionRequestProvider
                                                .changeDropDownValuestatus(
                                                    val, index);
                                          }),
                                      16.sh,
                                      CommonTextPoppins(
                                          text: "Event Type",
                                          talign: TextAlign.start,
                                          fontweight: FontWeight.w500,
                                          fontsize: 12,
                                          color: AppColors.hintTextColor),
                                      4.sh,
                                      CommonDropDown(
                                          width: width(context),
                                          selectedText:
                                              correctionRequestProvider
                                                  .selectedText[index],
                                          listItem: correctionRequestProvider
                                              .eventTypes,
                                          onchanged: (val) {
                                            correctionRequestProvider
                                                .changeDropDownValue(
                                                    val, index);
                                          }),
                                      16.sh,
                                      CommonTextPoppins(
                                          text: "Check In Date",
                                          talign: TextAlign.start,
                                          fontweight: FontWeight.w500,
                                          fontsize: 12,
                                          color: AppColors.hintTextColor),
                                      4.sh,
                                      //checkin date
                                      InkWell(
                                          onTap: () async {
                                            DateTime? dt =
                                                await showDatePicker(
                                                    context: context,
                                                    initialDate:
                                                        DateTime.now(),
                                                    firstDate: DateTime.now()
                                                        .subtract(
                                                      const Duration(
                                                          days: 365),
                                                    ),
                                                    lastDate: DateTime.now(),
                                                    builder:
                                                        (context, child) {
                                                      return Theme(
                                                        data:
                                                            Theme.of(context)
                                                                .copyWith(
                                                          colorScheme: ColorScheme.light(
                                                              primary: AppColors
                                                                  .primaryColor,
                                                              onPrimary: AppColors
                                                                  .whiteColor,
                                                              onSurface: AppColors
                                                                  .primaryColor),
                                                          textButtonTheme:
                                                              TextButtonThemeData(
                                                            style: TextButton
                                                                .styleFrom(
                                                              foregroundColor:
                                                                  AppColors
                                                                      .primaryColor, // button text color
                                                            ),
                                                          ),
                                                        ),
                                                        child: child!,
                                                      );
                                                    });
                                            String formattedDate =
                                                DateFormat('dd-MM-yyyy')
                                                    .format(dt!);
                                            correctionRequestProvider
                                                .changecheckindate(
                                                    formattedDate, index);
                                          },
                                          child: CorrectionRequestGetDate(
                                            text: correctionRequestProvider
                                                            .checkinDate[
                                                                index]
                                                            .toString() ==
                                                        "null" ||
                                                    correctionRequestProvider
                                                                .checkinDate[
                                                            index] ==
                                                        ""
                                                ? "Enter CheckIn Date"
                                                : correctionRequestProvider
                                                    .checkinDate[index]
                                                    .toString(),
                                          )),
                                      Visibility(
                                          visible: correctionRequestProvider
                                                      .showerror ==
                                                  true &&
                                              correctionRequestProvider
                                                      .checkinDate[index]
                                                      .toString() ==
                                                  "",
                                          child: CommonTextPoppins(
                                              text: "Please Add Checkin date",
                                              fontweight: FontWeight.w500,
                                              fontsize: 15,
                                              color: AppColors.redColor)),
                                      16.sh,
                                      CommonTextPoppins(
                                          text: "Check In Time",
                                          talign: TextAlign.start,
                                          fontweight: FontWeight.w500,
                                          fontsize: 12,
                                          color: AppColors.hintTextColor),
                                      4.sh,
                                      //checkin time
                                      InkWell(
                                          onTap: () async {
                                            TimeOfDay? td =
                                                await showTimePicker(
                                                    context: context,
                                                    initialTime:
                                                        TimeOfDay.now());
                                            DateTime tempDate =
                                                DateFormat("hh:mm").parse(
                                                    "${td!.hour}:${td.minute}");
                                            var dateFormat =
                                                DateFormat("h:mm a");
                                            correctionRequestProvider
                                                .changecheckintime(
                                                    dateFormat
                                                        .format(tempDate)
                                                        .toString(),
                                                    index);
                                          },
                                          child: CorrectionRequestTime(
                                            text: correctionRequestProvider
                                                            .checkinTime[
                                                                index]
                                                            .toString() ==
                                                        "null" ||
                                                    correctionRequestProvider
                                                                .checkinTime[
                                                            index] ==
                                                        ""
                                                ? "Enter CheckIn Time"
                                                : correctionRequestProvider
                                                    .checkinTime[index]
                                                    .toString(),
                                          )),
                                      Visibility(
                                          visible: correctionRequestProvider
                                                      .showerror ==
                                                  true &&
                                              correctionRequestProvider
                                                      .checkinTime[index]
                                                      .toString() ==
                                                  "",
                                          child: CommonTextPoppins(
                                              text: "Please Add Checkin time",
                                              fontweight: FontWeight.w500,
                                              fontsize: 15,
                                              color: AppColors.redColor)),
                                      16.sh,
                                      CommonTextPoppins(
                                          text: "Check out Date",
                                          talign: TextAlign.start,
                                          fontweight: FontWeight.w500,
                                          fontsize: 12,
                                          color: AppColors.hintTextColor),
                                      4.sh,
                                      //checkout date
                                      InkWell(
                                          onTap: () async {
                                            DateTime? dt =
                                                await showDatePicker(
                                                    context: context,
                                                    initialDate:
                                                        DateTime.now(),
                                                    firstDate: DateTime.now()
                                                        .subtract(
                                                      const Duration(
                                                          days: 365),
                                                    ),
                                                    lastDate: DateTime.now(),
                                                    builder:
                                                        (context, child) {
                                                      return Theme(
                                                        data:
                                                            Theme.of(context)
                                                                .copyWith(
                                                          colorScheme: ColorScheme.light(
                                                              primary: AppColors
                                                                  .primaryColor,
                                                              onPrimary: AppColors
                                                                  .whiteColor,
                                                              onSurface: AppColors
                                                                  .primaryColor),
                                                          textButtonTheme:
                                                              TextButtonThemeData(
                                                            style: TextButton
                                                                .styleFrom(
                                                              foregroundColor:
                                                                  AppColors
                                                                      .primaryColor, // button text color
                                                            ),
                                                          ),
                                                        ),
                                                        child: child!,
                                                      );
                                                    });
                                            String formattedDate =
                                                DateFormat('dd-MM-yyyy')
                                                    .format(dt!);
                                            correctionRequestProvider
                                                .changecheckoutdate(
                                                    formattedDate, index);
                                          },
                                          child: CorrectionRequestGetDate(
                                            text: correctionRequestProvider
                                                            .checkoutDate[
                                                                index]
                                                            .toString() ==
                                                        "null" ||
                                                    correctionRequestProvider
                                                                .checkoutDate[
                                                            index] ==
                                                        ""
                                                ? "Enter CheckOut Date"
                                                : correctionRequestProvider
                                                    .checkoutDate[index]
                                                    .toString(),
                                          )),
                                      Visibility(
                                          visible: correctionRequestProvider
                                                      .showerror ==
                                                  true &&
                                              correctionRequestProvider
                                                      .checkoutDate[index]
                                                      .toString() ==
                                                  "",
                                          child: CommonTextPoppins(
                                              text:
                                                  "Please Add Checkout date",
                                              fontweight: FontWeight.w500,
                                              fontsize: 15,
                                              color: AppColors.redColor)),
                                      16.sh,
                                      CommonTextPoppins(
                                          text: "Check Out Time",
                                          talign: TextAlign.start,
                                          fontweight: FontWeight.w500,
                                          fontsize: 12,
                                          color: AppColors.hintTextColor),
                                      4.sh,
                                      //checkout time
                                      InkWell(
                                          onTap: () async {
                                            TimeOfDay? td =
                                                await showTimePicker(
                                                    context: context,
                                                    initialTime:
                                                        TimeOfDay.now());
                                            DateTime tempDate =
                                                DateFormat("hh:mm").parse(
                                                    "${td!.hour}:${td.minute}");
                                            var dateFormat =
                                                DateFormat("h:mm a");
                                            correctionRequestProvider
                                                .changecheckouttime(
                                                    dateFormat
                                                        .format(tempDate)
                                                        .toString(),
                                                    index);
                                          },
                                          child: CorrectionRequestTime(
                                            text: correctionRequestProvider
                                                            .checkoutTime[
                                                                index]
                                                            .toString() ==
                                                        "null" ||
                                                    correctionRequestProvider
                                                                .checkoutTime[
                                                            index] ==
                                                        ""
                                                ? "Enter CheckOut Time"
                                                : correctionRequestProvider
                                                    .checkoutTime[index]
                                                    .toString(),
                                          )),
                                      Visibility(
                                          visible: correctionRequestProvider
                                                      .showerror ==
                                                  true &&
                                              correctionRequestProvider
                                                      .checkoutTime[index]
                                                      .toString() ==
                                                  "",
                                          child: CommonTextPoppins(
                                              text:
                                                  "Please Add Checkout time",
                                              fontweight: FontWeight.w500,
                                              fontsize: 15,
                                              color: AppColors.redColor)),
                                      const Divider(
                                        thickness: 2,
                                      ),
                                      16.sh,
                                    ],
                                  );
                                },
                              ),
                              // remove index
                              correctionRequestProvider.count != 1
                                  ? InkWell(
                                      onTap: () {
                                        correctionRequestProvider
                                            .removeCount();
                                      },
                                      child: CommonTextPoppins(
                                          text: "Remove",
                                          fontweight: FontWeight.w600,
                                          fontsize: 16,
                                          color: AppColors.primaryColor),
                                    )
                                  : const SizedBox(),
                              correctionRequestProvider.count != 1
                                  ? 16.sh
                                  : 0.sh,
                              //add more time button
                              AddMoreButton(
                                  text: "Add More Attendance",
                                  ontap: () {
                                    correctionRequestProvider.addcount();
                                  },
                                  imagePath: ImagePath.moreAttandanceIcon),
                              16.sh,
                              //create correction request button
                              CommonButton(
                                  onPressed: () {
                                    correctionRequestProvider.showError();
                                    if (correctionRequestProvider.showerror ==
                                        false) {
                                      correctionRequestProvider
                                          .correctionRequest(context);
                                    }
                                    //Navigator.pop(context);
                                    // correctionRequestProvider.clear();
                                    // showDialog(
                                    //     context: context,
                                    //     builder: (BuildContext context) {
                                    //       return Center(
                                    //         child: CustomDialogBox(
                                    //           title:
                                    //               "Your Correction Request for scheduled time complete sent for approval",
                                    //           text: "OK",
                                    //           img: Image.asset(
                                    //               ImagePath.dialogBoxImage),
                                    //         ),
                                    //       );
                                    //     });
                                  },
                                  width: width(context),
                                  text: "Create Correction Request"),
                              32.sh,
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ));
        },
        buttonTitle: "Create Correction Request");
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gleam_hr/Components/CommonBottomSheet.dart';
import 'package:gleam_hr/Components/CommonButton.dart';
import 'package:gleam_hr/Components/CommonDropDown.dart';
import 'package:gleam_hr/Components/CommonText.dart';
import 'package:gleam_hr/Providers/DashBoardProviders/HomeProviders/CorrectionRequest_Provider.dart';
import 'package:gleam_hr/Screens/DashBoard/Home/HomeWidgets/CorrectionRequestDate.dart';
import 'package:gleam_hr/Screens/DashBoard/Home/HomeWidgets/CorrectionRequestTime.dart';
import 'package:gleam_hr/Utils/AppPaths.dart';
import 'package:gleam_hr/Utils/Colors.dart';
import 'package:gleam_hr/Utils/SizedBox.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

TableRow CommonTableRow({
  required BuildContext context,
  required Color color,
  required String date,
  required String checkin,
  required String checkout,
  required String hours,
  String? id,
  Color? textColor = const Color(0XFF929292),
}) {
  return TableRow(decoration: BoxDecoration(color: color), children: [
    InkWell(
     onLongPress: () {
                  var correctionRequestProvider =
                      Provider.of<CorrectionRequestProvider>(context,
                          listen: false);
                  correctionRequestProvider.setDate(id!);
                  Navigator.pop(context);
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
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 24),
                                  child: Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      32.sh,
                                      ListView.builder(
                                        itemCount:
                                            correctionRequestProvider.count,
                                        shrinkWrap: true,
                                        physics:
                                            const NeverScrollableScrollPhysics(),
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
                                                  color: AppColors
                                                      .hintTextColor),
                                              4.sh,
                                              CommonDropDown(
                                                  width: width(context),
                                                  selectedText:
                                                      correctionRequestProvider
                                                              .selectedStatus[
                                                          index],
                                                  listItem:
                                                      correctionRequestProvider
                                                          .statusTypes,
                                                  onchanged: (val) {
                                                    correctionRequestProvider
                                                        .changeDropDownValuestatus(
                                                            val, index);
                                                  }),
                                              16.sh,
                                              Row(children: [
                                              SizedBox(
                                                  width: width(context)*.5,
                                                  child: CommonTextPoppins(
                                                    text: "Check In Date",
                                                    talign: TextAlign.start,
                                                    fontweight: FontWeight.w500,
                                                    fontsize: 12,
                                                    color: AppColors
                                                        .hintTextColor),
                                                ),
                                              SizedBox(
                                                width: width(context)*.32,
                                                child: CommonTextPoppins(
                                                    text: "Check In Time",
                                                    talign: TextAlign.start,
                                                    fontweight: FontWeight.w500,
                                                    fontsize: 12,
                                                    color: AppColors
                                                        .hintTextColor),
                                              ),
                                              ],),
                                              4.sh,
                                              Row(
                                                children: [
                                                SizedBox(
                                                  width: width(context)*.5,
                                                  child: InkWell(
                                                        onTap: () async {
                                                          DateTime? dt =
                                                              await showDatePicker(
                                                                  context: context,
                                                                  initialDate:
                                                                      DateTime
                                                                          .now(),
                                                                  firstDate:
                                                                      DateTime.now()
                                                                          .subtract(
                                                                    const Duration(
                                                                        days: 365),
                                                                  ),
                                                                  lastDate: DateTime
                                                                      .now(),
                                                                  builder: (context,
                                                                      child) {
                                                                    return Theme(
                                                                      data: Theme.of(
                                                                              context)
                                                                          .copyWith(
                                                                        colorScheme: ColorScheme.light(
                                                                            primary:
                                                                                AppColors
                                                                                    .primaryColor,
                                                                            onPrimary:
                                                                                AppColors
                                                                                    .whiteColor,
                                                                            onSurface:
                                                                                AppColors.primaryColor),
                                                                        textButtonTheme:
                                                                            TextButtonThemeData(
                                                                          style: TextButton
                                                                              .styleFrom(
                                                                            foregroundColor:
                                                                                AppColors.primaryColor, // button text color
                                                                          ),
                                                                        ),
                                                                      ),
                                                                      child: child!,
                                                                    );
                                                                  });
                                                          String formattedDate =
                                                              DateFormat(
                                                                      'yyyy-MM-dd')
                                                                  .format(dt!);
                                                          correctionRequestProvider
                                                              .changecheckindate(
                                                                  formattedDate,
                                                                  index);
                                                        },
                                                        child: Row(
                                                      children: [
                                                          Expanded(flex: 2, child: Container(height: 50, decoration: BoxDecoration(border: Border.all(color: AppColors.textColor.withOpacity(.25)), color: AppColors.fillColor, borderRadius: BorderRadius.circular(8)),child: CorrectionRequestGetDate(
                                                          text: correctionRequestProvider.checkinDate[index].toString() == "null" || correctionRequestProvider.checkinDate[index] == ""
                                                              ? "-"
                                                              : DateFormat('MMMM yyyy').format(DateTime.parse(correctionRequestProvider.checkinDate[index].toString())),
                                                        ),)),
                                                        CommonTextPoppins(text: " - ", fontweight: FontWeight.w400, fontsize: 14, color: AppColors.textColor),
                                                          Expanded(flex: 1, child: Container(height: 50, decoration: BoxDecoration(border: Border.all(color: AppColors.textColor.withOpacity(.25)), color: AppColors.fillColor, borderRadius: BorderRadius.circular(8)),child: CorrectionRequestGetDate(
                                                          text: correctionRequestProvider.checkinDate[index].toString() == "null" || correctionRequestProvider.checkinDate[index] == ""
                                                              ? "-"
                                                              : DateFormat('dd').format(DateTime.parse(correctionRequestProvider.checkinDate[index].toString())),
                                                        ),)),
                                                          ],),
                                                            ),
                                                ),
                                                10.sw,
                                                SizedBox(
                                                  width: width(context)*.32,
                                                  child: InkWell(
                                                    onTap: () async {
                                                      TimeOfDay? td =
                                                          await showTimePicker(
                                                              context: context,
                                                              initialTime:
                                                                  TimeOfDay
                                                                      .now());
                                                      DateTime tempDate =
                                                          DateFormat("hh:mm").parse(
                                                              "${td!.hour}:${td.minute}");
                                                      var dateFormat =
                                                          DateFormat("h:mm a");
                                                      correctionRequestProvider
                                                          .changecheckintime(
                                                              dateFormat
                                                                  .format(
                                                                      tempDate)
                                                                  .toString(),
                                                              index);
                                                    },
                                                    child:Row(
                                                      mainAxisSize: MainAxisSize.min,
                                                      children: [
                                                      Expanded(child: Container(height: 50, decoration: BoxDecoration(border: Border.all(color: AppColors.textColor.withOpacity(.25)), color: AppColors.fillColor, borderRadius: BorderRadius.circular(8)), child: CorrectionRequestTime(
                                                      text: correctionRequestProvider
                                                                      .checkinTime[
                                                                          index]
                                                                      .toString() ==
                                                                  "null" ||
                                                              correctionRequestProvider
                                                                          .checkinTime[
                                                                      index] ==
                                                                  ""
                                                          ? "-"
                                                          : DateFormat('h').parse(correctionRequestProvider.checkinTime[index].toString()).hour.toString(),
                                                    ),)),
                                                    CommonTextPoppins(text: " : ", fontweight: FontWeight.w400, fontsize: 14, color: AppColors.textColor),
                                                    Expanded(child: Container(height: 50, decoration: BoxDecoration(border: Border.all(color: AppColors.textColor.withOpacity(.25)), color: AppColors.fillColor, borderRadius: BorderRadius.circular(8)), child: CorrectionRequestTime(
                                                      text: correctionRequestProvider
                                                                      .checkinTime[
                                                                          index]
                                                                      .toString() ==
                                                                  "null" ||
                                                              correctionRequestProvider
                                                                          .checkinTime[
                                                                      index] ==
                                                                  ""
                                                          ? "-"
                                                          : DateFormat('mm a').format(DateFormat('h:mm a').parse(correctionRequestProvider.checkinTime[index].toString())),
                                                    ),))
                                                      ],),
                                                  ),
                                                )   
                                                
                                                ],
                                              ),
                                              
                                              Row(children: [
                                                SizedBox(width: width(context)*.5,
                                                child: Visibility(
                                                  visible: correctionRequestProvider
                                                              .showerror ==
                                                          true &&
                                                      correctionRequestProvider
                                                              .checkinDate[
                                                                  index]
                                                              .toString() ==
                                                          "",
                                                  child: CommonTextPoppins(
                                                      text:
                                                          "Please Add Checkin date",
                                                      fontweight:
                                                          FontWeight.w500,
                                                      fontsize: 12,
                                                      talign: TextAlign.start,
                                                      color: AppColors
                                                          .redColor)),
                                                ),
                                                SizedBox(width: width(context)*.32,
                                                child: Visibility(
                                                  visible: correctionRequestProvider
                                                              .showerror ==
                                                          true &&
                                                      correctionRequestProvider
                                                              .checkinTime[
                                                                  index]
                                                              .toString() ==
                                                          "",
                                                  child: CommonTextPoppins(
                                                      text:
                                                          "Please Add Checkin time",
                                                      fontweight:
                                                          FontWeight.w500,
                                                      fontsize: 12,
                                                      talign: TextAlign.start,
                                                      color: AppColors
                                                          .redColor)),
                                                )
                                              ],),
                                              16.sh,
                                              //checkin time
                                              16.sh,
                                              Row(children: [
                                              SizedBox(
                                                  width: width(context)*.5,
                                                  child: CommonTextPoppins(
                                                    text: "Check Out Date",
                                                    talign: TextAlign.start,
                                                    fontweight: FontWeight.w500,
                                                    fontsize: 12,
                                                    color: AppColors
                                                        .hintTextColor),
                                                ),
                                              SizedBox(
                                                width: width(context)*.32,
                                                child: CommonTextPoppins(
                                                    text: "Check Out Time",
                                                    talign: TextAlign.start,
                                                    fontweight: FontWeight.w500,
                                                    fontsize: 12,
                                                    color: AppColors
                                                        .hintTextColor),
                                              ),
                                              ],),
                                              4.sh,
                                              //checkout date
                                              
                                              Row(children: [
                                                SizedBox(width: width(context)*.5,
                                                child: InkWell(
                                                  onTap: () async {
                                                    DateTime? dt =
                                                        await showDatePicker(
                                                            context: context,
                                                            initialDate:
                                                                DateTime
                                                                    .now(),
                                                            firstDate:
                                                                DateTime.now()
                                                                    .subtract(
                                                              const Duration(
                                                                  days: 365),
                                                            ),
                                                            lastDate: DateTime
                                                                .now(),
                                                            builder: (context,
                                                                child) {
                                                              return Theme(
                                                                data: Theme.of(
                                                                        context)
                                                                    .copyWith(
                                                                  colorScheme: ColorScheme.light(
                                                                      primary:
                                                                          AppColors
                                                                              .primaryColor,
                                                                      onPrimary:
                                                                          AppColors
                                                                              .whiteColor,
                                                                      onSurface:
                                                                          AppColors.primaryColor),
                                                                  textButtonTheme:
                                                                      TextButtonThemeData(
                                                                    style: TextButton
                                                                        .styleFrom(
                                                                      foregroundColor:
                                                                          AppColors.primaryColor, // button text color
                                                                    ),
                                                                  ),
                                                                ),
                                                                child: child!,
                                                              );
                                                            });
                                                    String formattedDate =
                                                        DateFormat(
                                                                'yyyy-MM-dd')
                                                            .format(dt!);
                                                    correctionRequestProvider
                                                        .changecheckoutdate(
                                                            formattedDate,
                                                            index);
                                                  },
                                                  child:Row(
                                                      children: [
                                                          Expanded(flex: 2, child: Container(height: 50, decoration: BoxDecoration(border: Border.all(color: AppColors.textColor.withOpacity(.25)), color: AppColors.fillColor, borderRadius: BorderRadius.circular(8)),child: CorrectionRequestGetDate(
                                                    text: correctionRequestProvider
                                                                    .checkoutDate[
                                                                        index]
                                                                    .toString() ==
                                                                "null" ||
                                                            correctionRequestProvider
                                                                        .checkoutDate[
                                                                    index] ==
                                                                ""
                                                        ? "-"
                                                        : DateFormat('MMMM yyyy').format(DateTime.parse(correctionRequestProvider.checkoutDate[index].toString())),
                                                  ),)),
                                                        CommonTextPoppins(text: " - ", fontweight: FontWeight.w400, fontsize: 14, color: AppColors.textColor),
                                                          Expanded(flex: 1, child: Container(height: 50, decoration: BoxDecoration(border: Border.all(color: AppColors.textColor.withOpacity(.25)), color: AppColors.fillColor, borderRadius: BorderRadius.circular(8)),child: CorrectionRequestGetDate(
                                                    text: correctionRequestProvider
                                                                    .checkoutDate[
                                                                        index]
                                                                    .toString() ==
                                                                "null" ||
                                                            correctionRequestProvider
                                                                        .checkoutDate[
                                                                    index] ==
                                                                ""
                                                        ? "-"
                                                        : DateFormat('dd').format(DateTime.parse(correctionRequestProvider.checkoutDate[index].toString())),
                                                  ),)),
                                                          ],),
                                                      ),
                                                ),
                                                10.sw,
                                                SizedBox(width: width(context)*.32,
                                                child: InkWell(
                                                  onTap: () async {
                                                    TimeOfDay? td =
                                                        await showTimePicker(
                                                            context: context,
                                                            initialTime:
                                                                TimeOfDay
                                                                    .now());
                                                    DateTime tempDate =
                                                        DateFormat("hh:mm").parse(
                                                            "${td!.hour}:${td.minute}");
                                                    var dateFormat =
                                                        DateFormat("h:mm a");
                                                    correctionRequestProvider
                                                        .changecheckouttime(
                                                            dateFormat
                                                                .format(
                                                                    tempDate)
                                                                .toString(),
                                                            index);
                                                  },
                                                  child:Row(
                                                      mainAxisSize: MainAxisSize.min,
                                                      children: [
                                                      Expanded(child: Container(height: 50, decoration: BoxDecoration(border: Border.all(color: AppColors.textColor.withOpacity(.25)), color: AppColors.fillColor, borderRadius: BorderRadius.circular(8)), child: CorrectionRequestTime(
                                                    text: correctionRequestProvider
                                                                    .checkoutTime[
                                                                        index]
                                                                    .toString() ==
                                                                "null" ||
                                                            correctionRequestProvider
                                                                        .checkoutTime[
                                                                    index] ==
                                                                ""
                                                        ? "-"
                                                        : DateFormat('h').parse(correctionRequestProvider.checkoutTime[index].toString()).hour.toString(),
                                                  ),)),
                                                    CommonTextPoppins(text: " : ", fontweight: FontWeight.w400, fontsize: 14, color: AppColors.textColor),
                                                    Expanded(child: Container(height: 50, decoration: BoxDecoration(border: Border.all(color: AppColors.textColor.withOpacity(.25)), color: AppColors.fillColor, borderRadius: BorderRadius.circular(8)), child: CorrectionRequestTime(
                                                    text: correctionRequestProvider
                                                                    .checkoutTime[
                                                                        index]
                                                                    .toString() ==
                                                                "null" ||
                                                            correctionRequestProvider
                                                                        .checkoutTime[
                                                                    index] ==
                                                                ""
                                                        ? "-"
                                                        :DateFormat('mm a').format(DateFormat('h:mm a').parse(correctionRequestProvider.checkoutTime[index].toString())),
                                                  ),))
                                                      ],),
                                                      ),
                                                ),
                                              ],),
                                              16.sh,
                                              Row(children: [
                                                SizedBox(width: width(context)*.5,
                                                child: Visibility(
                                                  visible: correctionRequestProvider
                                                              .showerror ==
                                                          true &&
                                                      correctionRequestProvider
                                                              .checkoutDate[
                                                                  index]
                                                              .toString() ==
                                                          "" || (correctionRequestProvider.dateTimeValidationCheck && correctionRequestProvider.errorString[index]=="error"),
                                                  child: CommonTextPoppins(
                                                      text:correctionRequestProvider.dateTimeValidationCheck && correctionRequestProvider.errorString[index]=="error"?"Checkout date and time must be before checkin date and time":
                                                          "Please Add Checkout date",
                                                      fontweight:
                                                          FontWeight.w500,
                                                      fontsize: 12,
                                                      talign: TextAlign.start,
                                                      color: AppColors
                                                          .redColor)),
                                                ),
                                                SizedBox(width: width(context)*.32,
                                                child: Visibility(
                                                  visible: correctionRequestProvider
                                                              .showerror ==
                                                          true &&
                                                      correctionRequestProvider
                                                              .checkoutTime[
                                                                  index]
                                                              .toString() ==
                                                          "",
                                                  child: CommonTextPoppins(
                                                      text:
                                                          "Please Add Checkout time",
                                                      fontweight:
                                                          FontWeight.w500,
                                                      fontsize: 12,
                                                      talign: TextAlign.start,
                                                      color: AppColors
                                                          .redColor)),
                                                )
                                              ],),
                                              4.sh,
                                              //checkout time                                            
                                              16.sh,
                                              CommonTextPoppins(
                                                  text: "Event Type",
                                                  talign: TextAlign.start,
                                                  fontweight: FontWeight.w500,
                                                  fontsize: 12,
                                                  color: AppColors
                                                      .hintTextColor),
                                              4.sh,
                                              CommonDropDown(
                                                  width: width(context),
                                                  selectedText:
                                                      correctionRequestProvider
                                                              .selectedText[
                                                          index],
                                                  listItem:
                                                      correctionRequestProvider
                                                          .eventTypes,
                                                  onchanged: (val) {
                                                    correctionRequestProvider
                                                        .changeDropDownValue(
                                                            val, index);
                                                  }),
                                              16.sh,
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
                                                  color:
                                                      AppColors.primaryColor),
                                            )
                                          : const SizedBox(),
                                      correctionRequestProvider.count != 1
                                          ? 16.sh
                                          : 0.sh,
                                      //add more time button
                                      InkWell(
                                          child: Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        SvgPicture.asset(
                                          ImagePath.moreAttandanceIcon,
                                          color: AppColors.textColor,
                                          width: 16,
                                          height: 16,
                                        ),
                                        10.sw,
                                        CommonTextPoppins(
                                            text: "ADD MORE ATTENDANCE",
                                            fontweight: FontWeight.w500,
                                            fontsize: 14,
                                            color: AppColors.textColor),
                                          ],
                                        ),
                                          onTap: () {
                                            correctionRequestProvider
                                                .addcount();
                                          },
                                          ),
                                      16.sh,
                                      //create correction request button
                                     correctionRequestProvider.correctionRequestLoading?
                                     const Center(
                                      child:
                                       CircularProgressIndicator.adaptive()): 
                                       Column(
                                         children: [
                                           CommonButton(
                                              onPressed:() {
                                                correctionRequestProvider
                                                    .showError();
                                                if (correctionRequestProvider
                                                        .showerror ==
                                                    false && correctionRequestProvider.dateTimeValidationCheck == false) {
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
                                               16.sh,
                                          CommonButton2(text: 'Cancel'),
                                         ],
                                       ),
                                         
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
      child: Padding(
        padding: const EdgeInsets.only(left:18.0,right: 18.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SizedBox(
                height: 50,
                width: width(context) * .2,
                child: Center(
                  child: CommonTextPoppins(
                      text: date,
                      talign: TextAlign.left,
                      fontweight: FontWeight.w600,
                      fontsize: 11,
                      color: textColor!),
                )),
                SizedBox(
                height: 50,
                width: width(context) * .2,
          child: Center(
            child: CommonTextPoppins(
                text: checkin,
                talign: TextAlign.left,
                fontweight: FontWeight.w600,
                fontsize: 11,
                color: textColor),
          )),
          SizedBox(
          height: 50,
                width: width(context) * .2,
          child: Center(
            child: CommonTextPoppins(
                text: checkout,
                talign: TextAlign.left,
                fontweight: FontWeight.w600,
                fontsize: 11,
                color: textColor),
          )),
           SizedBox(
          height: 50,
                width: width(context) * .2,
          child: Center(
            child: CommonTextPoppins(
                text: hours,
                talign: TextAlign.left,
                fontweight: FontWeight.w600,
                fontsize: 11,
                color: textColor),
          )),    
          ],
        ),
      ),
    ),   
  ]);
}

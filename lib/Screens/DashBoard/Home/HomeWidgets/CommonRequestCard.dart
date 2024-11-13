import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gleam_hr/Components/CommonText.dart';
import 'package:gleam_hr/Utils/AppPaths.dart';
import 'package:gleam_hr/Utils/Colors.dart';
import 'package:gleam_hr/Utils/SizedBox.dart';

class CommonRequestCard extends StatelessWidget {
  // for hiding button according to attendance permission
  String NameTitle, dates, hours;
  var onPressedRequest;
  CommonRequestCard({
    required this.NameTitle,
    required this.hours,
    required this.dates,
    required this.onPressedRequest,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          InkWell(
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: AppColors.whiteColor),
              padding: const EdgeInsets.all(14),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  // mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    SizedBox(
                      width: MediaQuery.of(context).size.width,
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            CommonTextPoppins(
                                text: NameTitle.toString(),
                                talign: TextAlign.left,
                                fontweight: FontWeight.w500,
                                fontsize: 16,
                                color: AppColors.blackColor),
                            20.sh,
                            Row(
                              children: [
                                Container(
                                  child: Row(
                                    children: [
                                      SizedBox(
                                          width: 16,
                                          height: 16,
                                          child: SvgPicture.asset(
                                            ImagePath.requestCalenderIcon,
                                            width: 16,
                                            height: 16,
                                          )),
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(left: 8.0),
                                        child: CommonTextPoppins(
                                            text: dates.toString(),
                                            talign: TextAlign.left,
                                            fontweight: FontWeight.w500,
                                            fontsize: 14,
                                            color: AppColors.hintTextColor),
                                      ),
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(left: 24.0),
                                  child: Container(
                                    child: Row(
                                      children: [
                                        SizedBox(
                                            width: 16,
                                            height: 16,
                                            child: SvgPicture.asset(
                                              ImagePath.requestTimeIcon,
                                              width: 16,
                                              height: 16,
                                            )),
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(left: 8.0),
                                          child: CommonTextPoppins(
                                              text: hours.toString(),
                                              talign: TextAlign.left,
                                              fontweight: FontWeight.w500,
                                              fontsize: 14,
                                              color: AppColors.hintTextColor),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            )
                          ]),
                    )
                  ],
                ),
              ),
            ),
            onTap: onPressedRequest,
          ),
        ],
      ),
    );
  }
}

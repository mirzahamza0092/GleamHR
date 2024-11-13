import 'package:expansion_tile_card/expansion_tile_card.dart';
import 'package:flutter/material.dart';
import 'package:gleam_hr/Components/CommonText.dart';
import 'package:gleam_hr/Providers/DashBoardProviders/DashBoard_Provider.dart';
import 'package:gleam_hr/Utils/AppConstants.dart';
import 'package:gleam_hr/Utils/Colors.dart';
import 'package:gleam_hr/Utils/SizedBox.dart';

ExpansionTileCard DashBoardExpansionTile(DashBoardProvider dashboardprovider) {
  return ExpansionTileCard(
      key: dashboardprovider.cardexpandabletile,
      // childrenPadding:
      //     const EdgeInsets.symmetric(
      //         horizontal: 16),
      // tilePadding:
      //     const EdgeInsets.symmetric(
      //         horizontal: 24),
      onExpansionChanged: (value) {
        debugPrint(value.toString());
      },
      title: CommonTextPoppins(
          text: dashboardprovider.timeof,
          talign: TextAlign.left,
          fontweight: FontWeight.w500,
          fontsize: 12,
          color: AppColors.hintTextColor),
      children: [
        SizedBox(
          height: 200,
          child: ListView.builder(
            itemCount: AppConstants.timeoffmodel!.policies!.length,
            itemBuilder: (context, index) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                  InkWell(
            splashColor: AppColors.primaryColor,
            onTap: () {
              dashboardprovider.changeTimeOfCategory("${AppConstants.timeoffmodel!.policies![index].policy!.policyName}(${AppConstants.timeoffmodel!.policies![index].policy!.oneTimeLimit.toString()}hrs available)",AppConstants.timeoffmodel!.policies![index].timeoffPolicyId.toString());
            },
            child: Row(
              children: [
                20.sw,
                CommonTextPoppins(
                    text: "${AppConstants.timeoffmodel!.policies![index].policy!.policyName.toString()}""(${AppConstants.timeoffmodel!.policies![index].policy!.oneTimeLimit.toString()}hrs available)",
                    talign: TextAlign.start,
                    fontweight: FontWeight.w600,
                    fontsize: 14,
                    color: const Color(0XFF343434))
              ],
            )),
        16.sh,
              ],
              );
            },
          ),
        )
      ]
      // [
      //   InkWell(
      //       splashColor: AppColors.primaryColor,
      //       onTap: () {
      //         dashboardprovider.changeTimeOfCategory("Paid (32hrs available)");
      //         debugPrint("Paid (32hrs available)");
      //       },
      //       child: Row(
      //         children: [
      //           20.sw,
      //           CommonTextPoppins(
      //               text: "Paid (32hrs available)",
      //               talign: TextAlign.start,
      //               fontweight: FontWeight.w600,
      //               fontsize: 14,
      //               color: const Color(0XFF343434))
      //         ],
      //       )),
      //   16.sh,
      //   InkWell(
      //       onTap: () {
      //         dashboardprovider.changeTimeOfCategory("Unpaid (32hrs available)");
      //       },
      //       child: Row(
      //         children: [
      //           20.sw,
      //           CommonTextPoppins(
      //               text: "Unpaid (32hrs available)",
      //               talign: TextAlign.start,
      //               fontweight: FontWeight.w600,
      //               fontsize: 14,
      //               color: const Color(0XFF343434))
      //         ],
      //       )),
      //   16.sh,
      //   InkWell(
      //       onTap: () {
      //         dashboardprovider
      //             .changeTimeOfCategory("Maternity (32hrs available)");
      //       },
      //       child: Row(
      //         children: [
      //           20.sw,
      //           CommonTextPoppins(
      //               text: "Maternity (32hrs available)",
      //               talign: TextAlign.start,
      //               fontweight: FontWeight.w600,
      //               fontsize: 14,
      //               color: const Color(0XFF343434))
      //         ],
      //       )),
      //   16.sh,
      //   InkWell(
      //       onTap: () {
      //         dashboardprovider
      //             .changeTimeOfCategory("Paternity (32hrs available)");
      //       },
      //       child: Row(
      //         children: [
      //           20.sw,
      //           CommonTextPoppins(
      //               text: "Paternity (32hrs available)",
      //               talign: TextAlign.start,
      //               fontweight: FontWeight.w600,
      //               fontsize: 14,
      //               color: const Color(0XFF343434))
      //         ],
      //       )),
      // ],

      );
}

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gleam_hr/Components/CommonButton.dart';
import 'package:gleam_hr/Components/CommonText.dart';
import 'package:gleam_hr/Components/CommonTextField.dart';
import 'package:gleam_hr/Providers/DashBoardProviders/AppbarProviders/Inbox_Provider.dart';
import 'package:gleam_hr/Utils/AppPaths.dart';
import 'package:gleam_hr/Utils/Colors.dart';
import 'package:gleam_hr/Utils/SizedBox.dart';
import 'package:provider/provider.dart';

class AssetRequestCard extends StatelessWidget {
  // for hiding button according to attendance permission
  String leadingPath,
      message,
      reason,
      requesterName,
      notifiableId,
      status,
      notificationId;
      dynamic notifiableObject;
  AssetRequestCard({
    required this.leadingPath,
    required this.message,
    required this.requesterName,
    required this.notifiableId,
    required this.notificationId,
    required this.status,
    required this.reason,
    required this.notifiableObject,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
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
                  child: Consumer<InboxProvider>(
                    builder: (context, inboxProvider, child) {
                      return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: SizedBox(
                            width: MediaQuery.of(context).size.width,
                            child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  CommonTextPoppins(
                                      text: message.toString(),
                                      talign: TextAlign.left,
                                      fontweight: FontWeight.w500,
                                      fontsize: 14,
                                      color: AppColors.hintTextColor),
                                  10.sh,
                                  CommonTextPoppins(
                                      text: "Request Message",
                                      talign: TextAlign.left,
                                      fontweight: FontWeight.w500,
                                      fontsize: 14,
                                      color: AppColors.blackColor),
                                  10.sh,
                                  CommonTextPoppins(
                                      text: reason,
                                      talign: TextAlign.left,
                                      fontweight: FontWeight.w500,
                                      fontsize: 14,
                                      color: AppColors.hintTextColor),
                                  20.sh,
                                  Row(
                                    children: [
                                      SizedBox(
                                          width: 16,
                                          height: 16,
                                          child: SvgPicture.asset(
                                            ImagePath.alertIcon,
                                            width: 16,
                                            height: 16,
                                          )),
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(left: 8.0),
                                        child: CommonTextPoppins(
                                            text: "Requested by ",
                                            talign: TextAlign.center,
                                            fontweight: FontWeight.w500,
                                            fontsize: 12,
                                            color: AppColors.hintTextColor),
                                      ),
                                      CommonTextPoppins(
                                          text: requesterName.toString(),
                                          talign: TextAlign.center,
                                          fontweight: FontWeight.w500,
                                          fontsize: 13,
                                          color: AppColors.greyColor),
                                    ],
                                  ),
                                  40.sh,
                                  CommonTextPoppins(
                                      text: "Approval Comment",
                                      talign: TextAlign.left,
                                      fontweight: FontWeight.w500,
                                      fontsize: 14,
                                      color: AppColors.blackColor),
                                  10.sh,
                                  CommonTextField(
                                    hinttext: "Approval Comment",
                                    controller: inboxProvider.comment,
                                  ),
                                  20.sh,
                                  status!="Pending"?
                                  CommonButton(
                                      onPressed: () {},
                                      width: MediaQuery.of(context).size.width,
                                      text: status,
                                      shadowneeded: false,
                                      color: status=="Denied"? AppColors.redColor:AppColors.success,
                                      ):
                                  inboxProvider.requestIsLoading
                                      ? const Center(
                                          child: CircularProgressIndicator.adaptive(),
                                        )
                                      :
                                  Column(mainAxisSize: MainAxisSize.min, children: [
                                    CommonButtonImage(
                                      onPressed: () {
                                        inboxProvider.reqestDecision(
                                            context: context,
                                            decision: "true",
                                            notifiableId: notifiableId,
                                            notificationId: notificationId,
                                            comment: inboxProvider.comment.text,
                                            notifyObject: notifiableObject);
                                      },
                                      width: MediaQuery.of(context).size.width,
                                      text: "Approve",
                                      color: AppColors.primaryColor,
                                      image: ImagePath.approveIcon),
                                  20.sh,
                                  DenyButton(
                                      text: "Deny",
                                      ontap: () {
                                        inboxProvider.reqestDecision(
                                            context: context,
                                            decision: "false",
                                            notifiableId: notifiableId,
                                            notificationId: notificationId,
                                            comment: inboxProvider.comment.text,
                                            notifyObject: notifiableObject);
                                      },
                                      imagePath: ImagePath.denyIcon)
                                  ],),
                                ]),
                          ),
                        )
              ]);
                    },
                  ) )
              
      ]),
          ),
      
    )],
    );
  }
}

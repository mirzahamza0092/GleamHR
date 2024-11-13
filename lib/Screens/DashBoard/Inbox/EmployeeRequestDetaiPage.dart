import 'package:flutter/material.dart';
import 'package:gleam_hr/Components/CommonAppBar.dart';
import 'package:gleam_hr/Components/CommonText.dart';
import 'package:gleam_hr/Providers/DashBoardProviders/DashBoard_Provider.dart';
import 'package:gleam_hr/Providers/DashBoardProviders/AppbarProviders/Inbox_Provider.dart';
import 'package:gleam_hr/Screens/DashBoard/Inbox/InboxCards/AssetRequestCard.dart';
import 'package:gleam_hr/Screens/DashBoard/Inbox/InboxCards/ReimbRequestCard.dart';
import 'package:gleam_hr/Screens/DashBoard/Inbox/InboxCards/TimeoffCard.dart';
import 'package:gleam_hr/Screens/DashBoard/Inbox/InboxCards/WorkFromHomeRequestCard.dart';
import 'package:gleam_hr/Utils/AppConstants.dart';
import 'package:gleam_hr/Utils/AppPaths.dart';
import 'package:gleam_hr/Utils/Colors.dart';
import 'package:gleam_hr/Utils/SizedBox.dart';
import 'package:provider/provider.dart';

class EmployeeRequestDetailPage extends StatelessWidget {
  dynamic data;
  dynamic notifiableObject;
  String notificationId, notifiableId;
  EmployeeRequestDetailPage(
      {super.key,
      required this.data,
      required this.notificationId,
      required this.notifiableId,
      required this.notifiableObject});

  @override
  Widget build(BuildContext context) {
   // debugPrint(data!.approvalType.toUpperCase().contains("TIME OFF REQUEST"));// 1= wfh, 2=timeoff, 3=reimb,
    return WillPopScope(
      onWillPop: ()async{
      WidgetsBinding.instance.addPostFrameCallback((_) {
      final inboxProvider = Provider.of<InboxProvider>(context, listen: false);
      //  inboxProvider.getAllNotifications(context);
      // inboxProvider.refreshInboxIndicatorKey.currentState!.show();

      inboxProvider.scrollController.addListener(() {
        if (inboxProvider.scrollController.position.maxScrollExtent ==
            inboxProvider.scrollController.position.pixels) {
          debugPrint("firing");

          inboxProvider.getAllNotifications(context);
        }
      });
    });
        return true;
      },
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        backgroundColor: AppColors.pageBackgroundColor,
        appBar: PreferredSize(
            preferredSize: Size(width(context), 120),
            child: Consumer<DashBoardProvider>(
              builder: (context, dashBoardProvider, child) {
                return CommonAppBar(
                    subtitle:
                        "${AppConstants.loginmodell!.userData!.firstname} ${(AppConstants.loginmodell!.userData!.lastname).toString() == "null" ? "" : AppConstants.loginmodell!.userData!.lastname} ",
                    trailingimagepath:
                        "https://${Keys.domain}.gleamhrm.com/${AppConstants.loginmodell!.userData!.picture}");
              },
            )),
        body: SingleChildScrollView(
          child: Column(
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 20.0, left: 20),
                    child: Row(
                      children: [
                        InkWell(
                           onTap: () {
                          WidgetsBinding.instance.addPostFrameCallback((_) {
                                final inboxProvider = Provider.of<InboxProvider>(context, listen: false);
                                //  inboxProvider.getAllNotifications(context);
                                // inboxProvider.refreshInboxIndicatorKey.currentState!.show();

                                inboxProvider.scrollController.addListener(() {
                                  if (inboxProvider.scrollController.position.maxScrollExtent ==
                                      inboxProvider.scrollController.position.pixels) {
                                    debugPrint("firing");

                                    inboxProvider.getAllNotifications(context);
                                  }
                                });
                              }); 
                              Navigator.pop(context);
                                },
                          child: Padding(
                            padding: const EdgeInsets.only(right: 8.0),
                            child: Icon(
                              Icons.arrow_back_ios,
                              color: AppColors.blackColor,
                            ),
                          ),
                        ),
                        CommonTextPoppins(
                            text: data!.title,
                            talign: TextAlign.left,
                            fontweight: FontWeight.w500,
                            fontsize: 14,
                            color: AppColors.hintTextColor),
                      ],
                    ),
                  ),
                ],
              ),
              // 1= wfh, 2=timeoff, 3=reimb, 4=assetrequest, else=5;
              data!.approvalType.toUpperCase().contains("WORK FROM HOME REQUEST")?
              WorkFromHomeRequestCard(
                leadingPath: ImagePath.timeOff,
                date: data.requestedInformation.toString()=="null"? ["",""]:data.requestedInformation.date.split(" to "),//data.requestedInformation.date.toString(),
                status: data!.status,
                hours: "40 Hours",
                title: data.body.toString(),
                leaveType: "Paid Leave",
                message:data.requestedInformation.toString()=="null"?"" :data!.requestedInformation.reason,
                requesterName: data!.requester,
                notifiableId: notifiableId,
                notificationId: notificationId,
                notifiableObject: notifiableObject,
              ):
              data!.approvalType.toUpperCase().contains("TIME OFF REQUEST")?
              TimeoffCard(
                leadingPath: ImagePath.timeOff,
                //date: data.requestedInformation.toString()=="null"? ["",""]:data.requestedInformation.date.split(" to "),//data.requestedInformation.date.toString(),
                hours: "40 Hours",
                status: data!.status,
                leaveType: "Paid Leave",
                message: data!.message,
                requesterName: data!.requester,
                notifiableId: notifiableId,
                notificationId: notificationId,
                notifiableObject: notifiableObject,
              ):
              data!.approvalType.toUpperCase().contains("REIMBURSEMENT REQUESTS REQUEST")?
              ReimbRequestCard(leadingPath: ImagePath.timeOff,
              status: data!.status,
              ammount: data!.requestedInformation.expenseAmount,
              expanseType: data!.requestedInformation.expenseCategory,
              date: data.requestedInformation.toString()=="null"? ["",""]:data.requestedInformation.date.split(" to "),//data.requestedInformation.date.toString(),
              message: data!.message,
              requesterName: data!.requester,
              notifiableId: notifiableId,
              notificationId: notificationId,
              notifiableObject: notifiableObject,
              expanseproof: data.requestedInformation.expenseProof,
              ):
              data!.approvalType.toUpperCase().contains("ASSET REQUESTS")?
              AssetRequestCard(leadingPath: ImagePath.timeOff,
              message: data!.message,
              status: data!.status,
              reason: data.requestedInformation.toString()=="null"?"":data.requestedInformation.message.toString(),
              requesterName: data!.requester,
              notifiableId: notifiableId,
              notificationId: notificationId,
              notifiableObject: notifiableObject,
              ):
              Container(child: const Text("All Other"),),            
            ],
          ),
        ),
      ),
    );
  }
}

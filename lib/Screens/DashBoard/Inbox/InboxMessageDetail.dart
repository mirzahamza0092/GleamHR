import 'package:flutter/material.dart';
import 'package:gleam_hr/Components/CommonAppBar.dart';
import 'package:gleam_hr/Components/CommonText.dart';
import 'package:gleam_hr/Providers/DashBoardProviders/AppbarProviders/Inbox_Provider.dart';
import 'package:gleam_hr/Utils/AppConstants.dart';
import 'package:gleam_hr/Utils/AppPaths.dart';
import 'package:gleam_hr/Utils/Colors.dart';
import 'package:gleam_hr/Utils/SizedBox.dart';
import 'package:provider/provider.dart';

class InboxMessageDetail extends StatelessWidget {
String title,message;
  InboxMessageDetail({required this.title,required this.message, super.key});

  @override
  Widget build(BuildContext context) {
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
        backgroundColor: AppColors.pageBackgroundColor,
        appBar: PreferredSize(
            preferredSize: Size(width(context), 120),
            child: CommonAppBar(
              subtitle:
                  "${AppConstants.loginmodell!.userData!.firstname} ${(AppConstants.loginmodell!.userData!.lastname).toString() == "null" ? "" : AppConstants.loginmodell!.userData!.lastname}",
              trailingimagepath:
                  "https://${Keys.domain}.gleamhrm.com/${AppConstants.loginmodell!.userData!.picture}",
              inboxIconNeeded: false,
              announcementIconNeeded: true,
            )),
        body: SingleChildScrollView(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ListTile(
                            minLeadingWidth: 0,
                            contentPadding: EdgeInsets.zero,
                            leading: InkWell(
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
                                child: FittedBox(
                                    child: Icon(
                                  Icons.arrow_back_ios,
                                  color: AppColors.textColor,
                                ))),
                            title: CommonTextPoppins(
                                //here
                                text: title,
                                talign: TextAlign.start,
                                fontweight: FontWeight.w500,
                                fontsize: 14,
                                color: AppColors.textColor),
                          ),
                          Container(
                            margin: const EdgeInsets.only(
                              top: 16,
                            ),
                            width: width(context),
                            padding: const EdgeInsets.all(24),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(
                                  width: 1,
                                  color: AppColors.textColor.withOpacity(.25),
                                ),
                                color: const Color(0XFFfafafa)),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                CommonTextPoppins(
                                  text:
                                      "Hi ${AppConstants.loginmodell!.userData!.firstname}",
                                  fontweight: FontWeight.w500,
                                  fontsize: 14,
                                  color: AppColors.textColor,
                                  talign: TextAlign.left,
                                ),
                                CommonTextPoppins(
                                  text: message,
                                  fontweight: FontWeight.w400,
                                  fontsize: 12,
                                  color: AppColors.hintTextColor,
                                  talign: TextAlign.left,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    ),
    );
      }
}
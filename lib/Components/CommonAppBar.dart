import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gleam_hr/Components/CommonText.dart';
import 'package:gleam_hr/Screens/DashBoard/Inbox/InboxScreen.dart';
import 'package:gleam_hr/Utils/AppConstants.dart';
import 'package:gleam_hr/Utils/AppPaths.dart';
import 'package:gleam_hr/Utils/Colors.dart';
import 'package:gleam_hr/Utils/GradiendWidget.dart';
import 'package:gleam_hr/Utils/SizedBox.dart';
import 'package:page_transition/page_transition.dart';
import '../Screens/DashBoard/Inbox/AnnouncementsScreen.dart';

class CommonAppBar extends StatelessWidget {
  String subtitle, title, trailingimagepath;
  bool inboxIconNeeded,announcementIconNeeded;
  CommonAppBar({
    super.key,
    required this.subtitle,
    this.title = "Welcome",
    this.inboxIconNeeded = true,
    this.announcementIconNeeded=true,
    required this.trailingimagepath,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(bottom: 10, top: 40,left: 15,right: 5),
      decoration: BoxDecoration(
          gradient: horizontalgradientwidget,
          borderRadius: const BorderRadius.only(
              bottomLeft: Radius.circular(24),
              bottomRight: Radius.circular(24))),
      child: ListTile(
        horizontalTitleGap: 10,
        tileColor: Colors.transparent,
        title: CommonTextPoppins(
          text: title,
          fontweight: FontWeight.w400,
          fontsize: 14,
          color: AppColors.whiteColor.withOpacity(.75),
          talign: TextAlign.left,
        ),
        subtitle: CommonTextPoppins(
          text: subtitle,
          fontweight: FontWeight.w500,
          fontsize: 18,
          color: AppColors.whiteColor,
          talign: TextAlign.left,
        ),
        leading: InkWell(
          onTap: () {},
          child: Transform.translate(
            offset: const Offset(-10, 0),
            child: CachedNetworkImage(
                imageUrl: trailingimagepath.toString(),
                imageBuilder: (context, imageProvider) => Container(
                      padding: const EdgeInsets.all(10),
                      width: 45,
                      height: 45,
                      decoration: BoxDecoration(
                        image: DecorationImage(image: imageProvider),
                        boxShadow: [
                          BoxShadow(
                              color: AppColors.whiteColor.withOpacity(.25),
                              spreadRadius: 5,
                              offset: const Offset(0, 0)),
                        ],
                        shape: BoxShape.circle,
                        color: AppColors.whiteColor,
                      ),
                      //child: imageProvider,
                    ),
                placeholder: (context, url) => AppConstants
                            .loginmodell!.userData!.picture
                            .toString() ==
                        "null"
                    ? Container(
                        padding: const EdgeInsets.all(10),
                        width: 45,
                        height: 45,
                        decoration: BoxDecoration(
                          image: DecorationImage(
                              image: AssetImage(
                            ImagePath.profiledummyimage,
                          )),
                          boxShadow: [
                            BoxShadow(
                                color: AppColors.whiteColor.withOpacity(.25),
                                spreadRadius: 5,
                                offset: const Offset(0, 0)),
                          ],
                          shape: BoxShape.circle,
                          color: AppColors.whiteColor,
                        ),
                      )
                    : CircularProgressIndicator(color: AppColors.whiteColor),
                errorWidget: (context, url, error) {
                  debugPrint("objecterror$url");
                  return Container(
                    padding: const EdgeInsets.all(10),
                    width: 45,
                    height: 45,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                          image: AssetImage(
                        ImagePath.profiledummyimage,
                      )),
                      boxShadow: [
                        BoxShadow(
                            color: AppColors.whiteColor.withOpacity(.25),
                            spreadRadius: 5,
                            offset: const Offset(0, 0)),
                      ],
                      shape: BoxShape.circle,
                      color: AppColors.whiteColor,
                    ),
                    // child: SvgPicture.asset(
                    //   ImagePath.profileIcon,
                    // ),
                  );
                }
                // const Icon(Icons.error),
                ),
          ),
        ),
      trailing: Column(
        children: [
          20.sh,
          Row(
            mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.end,
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            announcementIconNeeded?InkWell(
              onTap: () {
                // announcement screen
                Navigator.push(
                            context,
                            PageTransition(
                            type: PageTransitionType.bottomToTop,
                            child: const  AnnuncementScreen(),
                            duration: const Duration(milliseconds: 600)));
              },
              child: SvgPicture.asset(ImagePath.announcementIcon,color: AppColors.whiteColor,width: 20,height: 20,)):const SizedBox(),
            inboxIconNeeded?15.sw:const SizedBox(),
            inboxIconNeeded?InkWell(
              onTap: () {
                // inboxscreen
                Navigator.push(
                            context,
                            PageTransition(
                            type: PageTransitionType.bottomToTop,
                            child: const InboxScreen(),
                            duration: const Duration(milliseconds: 600)));
              },
              child: Icon(Icons.notifications_none,color: AppColors.whiteColor,)):const SizedBox(),
          ],
          ),
        ],
      ),
      ),
    );
  }
}

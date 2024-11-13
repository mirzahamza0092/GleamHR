import 'package:flutter/material.dart';
import 'package:gleam_hr/Components/CommonAppBar.dart';
import 'package:gleam_hr/Components/CommonText.dart';
import 'package:gleam_hr/Routes/Routes.dart' as route;
import 'package:gleam_hr/Screens/Auth/LoginOnboarding.dart';
import 'package:gleam_hr/Screens/DashBoard/More/MoreWidget/MoreMenuWidget.dart';
import 'package:gleam_hr/Utils/AppConstants.dart';
import 'package:gleam_hr/Utils/AppPaths.dart';
import 'package:gleam_hr/Utils/Colors.dart';
import 'package:gleam_hr/Utils/SizedBox.dart';

class MoreScreen extends StatelessWidget {
  const MoreScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: AppColors.whiteColor,
        appBar: PreferredSize(
            preferredSize: Size(width(context), 120),
            // child: CommonAppBar(
            //       subtitle: "${AppConstants.loginmodell!.userData.firstname} ${AppConstants.loginmodell!.userData.lastname}",
            //       trailingimagepath:"https://${Keys.domain}.gleamhrm.com/${peopledetails!.userData.picture}"),
            child: InkWell(
              onTap: () {
                //           Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) =>
                // DomainScreen()), (route) => false);
              },
              child: CommonAppBar(
                  subtitle:
                      "${AppConstants.loginmodell!.userData!.firstname} ${(AppConstants.loginmodell!.userData!.lastname).toString() == "null" ? "" : AppConstants.loginmodell!.userData!.lastname}",
                  trailingimagepath:
                      "https://${Keys.domain}.gleamhrm.com/${AppConstants.loginmodell!.userData!.picture}"),
            )),
        body: SingleChildScrollView(
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Padding(
               padding: const EdgeInsets.only(left: 25,top: 25.0, bottom: 15),
               child: CommonTextPoppins(
                                 text: "More",
                                 fontweight: FontWeight.w700,
                                 fontsize: 20,
                                 color: AppColors.textColor),
                          ),
                       moreMenu(
                        icon: ImagePath.tourIcon, 
                        text: "Tour", 
                        onclick: () {
                          Navigator.of(context)
                .push(MaterialPageRoute(builder:(context) =>  const LoginOnboarding(),),);
                        }),
                         
                      //  moreMenu(
                      //   icon: ImagePath.toolTipsIcon,
                      //   text: "Tool-tips",
                      //   onclick: () {}),
                         
                          // moreMenu(
                          // icon: ImagePath.termConditionIcon,
                          // text: "Term & Conditions",
                          // onclick: () {}),
                          
                          moreMenu(
                  icon: ImagePath.settingIcon, text: "Settings", onclick: () {
                    Navigator.of(context).pushNamed(route.settingScreen);
                  }),
                      
                        ]),
              
        ));
  }
}

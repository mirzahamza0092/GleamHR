import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gleam_hr/Components/CommonButton.dart';
import 'package:gleam_hr/Components/CommonText.dart';
import 'package:gleam_hr/Utils/AppConstants.dart';
import 'package:gleam_hr/Utils/AppPaths.dart';
import 'package:gleam_hr/Utils/Colors.dart';
import 'package:gleam_hr/Utils/SizedBox.dart';
import 'package:gleam_hr/Routes/routes.dart' as route;

class DomainOnboarding2 extends StatelessWidget {
  const DomainOnboarding2({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView.builder(
          itemCount: 1,
          itemBuilder: (context, index) {
            return SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: SafeArea(
                child: Column(
                  children: [
                    SizedBox(
                      height: height(context) * .025,
                    ),
                    Row(
                      children: [
                        GestureDetector(
                          onTap: () => Navigator.of(context).pop(),
                          child: Icon(
                            Icons.arrow_back,
                            size: 30,
                            color: AppColors.primaryColor,
                          ),
                        ),
                        const Spacer(),
                        SvgPicture.asset(ImagePath.logobluesvg),
                        const Spacer(),
                      ],
                    ),
                    25.sh,
                    SvgPicture.asset(
                      ImagePath.domainOnboarding2,
                    ),
                    25.sh,
                    CommonTextPoppins(
                        text:
                            "What’s my domain?",
                        fontweight: FontWeight.w500,
                        talign: TextAlign.center,
                        fontsize: 20,
                        color: AppColors.greyColor),
                    7.sh,
                    CommonTextPoppins(
                        text:
                            "Good question. If you take a look at your address bar when you are logged in on a computer, the text just before .gleamhrm.com is your domain ",
                        fontweight: FontWeight.w500,
                        fontsize: 14,
                        talign: TextAlign.center,
                        color: AppColors.greyColor),
                    20.sh,
                    SvgPicture.asset(ImagePath.domainOnboarding2staging),
                    20.sh,
                    CommonTextPoppins(
                        text:
                            'In this example, you would enter "yourcompany" in the domain field. Hope that helps.',
                        fontweight: FontWeight.w400,
                        fontsize: 14,
                        talign: TextAlign.center,
                        color: AppColors.textColor),
                    SizedBox(
                      height: height(context) * .1,
                    ),
                    CommonButton(onPressed: (){
                      Navigator.of(context).pushNamedAndRemoveUntil(
                route.domainscreen, (Route route) => false);
                    }, width: width(context), text: "GOT IT"),
                    const SizedBox(
                      height: 20,
                    ),
                    Align(
                              alignment: Alignment.bottomCenter,
                              child: CommonTextPoppins(
                                  text: "Version ${AppConstants.appPackage}",
                                  fontweight: FontWeight.w400,
                                  fontsize: 14,
                                  color: AppColors.hintTextColor),
                            ),
                  ],
                ),
              ),
            );
          }),
    );
  }
}

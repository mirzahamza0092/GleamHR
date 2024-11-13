import 'package:flutter/material.dart';
import 'package:gleam_hr/Components/BuildDots.dart';
import 'package:gleam_hr/Components/CommonText.dart';
import 'package:gleam_hr/Screens/Auth/DomainOnboarding2.dart';
import 'package:gleam_hr/Utils/AppPaths.dart';
import 'package:gleam_hr/Utils/Colors.dart';
import 'package:gleam_hr/Utils/GradiendWidget.dart';
import 'package:gleam_hr/Utils/SizedBox.dart';
import 'package:gleam_hr/Routes/routes.dart' as route;
import 'package:page_transition/page_transition.dart';

class DomainOnboarding extends StatelessWidget {
  const DomainOnboarding({Key? key}) : super(key: key);

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
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Spacer(),
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pushNamedAndRemoveUntil(
                                  route.domainscreen, (Route route) => false);
                            },
                            child: CommonTextPoppins(
                                text: "Skip",
                                talign: TextAlign.right,
                                fontweight: FontWeight.w500,
                                fontsize: 16,
                                color: const Color(0XFFB0B0B0)),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 8.0),
                            child: SizedBox(
                                height: height(context) * .5,
                                child: Image.asset(ImagePath.domainOnBoarding1,)),
                          ),
                          SizedBox(
                            height: height(context)*.1,
                          ),
                          CommonTextPoppins(text: "Hey! Thanks for trying out GleamHR. To get started, you need to enter your company's domain.", fontweight: FontWeight.w700, fontsize: 16, color: AppColors.blackColor),
                    SizedBox(
                      height: height(context) * .1,
                    ),
                    Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 50),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: List.generate(
                                  1, (index) => BuildDots(index: index)),
                            ),
                            GestureDetector(
                              onTap: () {
                                Navigator.of(context).push(PageTransition(
                                    type: PageTransitionType.rightToLeft,
                                    child: const DomainOnboarding2(),
                                    duration:
                                        const Duration(milliseconds: 600)));
                              },
                              child: Container(
                                alignment: Alignment.center,
                                height: 50,
                                width: 80,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(25),
                                    gradient: horizontalgradientwidget),
                                child: const Icon(
                                  Icons.arrow_forward_outlined,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ],
                        )),
                    const SizedBox(
                      height: 20,
                    ),
                  ],
                ),
              ),
            );
          }),
    );
  }
}

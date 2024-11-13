import 'package:flutter/material.dart';
import 'package:gleam_hr/Components/BuildDots.dart';
import 'package:gleam_hr/Components/CommonText.dart';
import 'package:gleam_hr/Models/AuthModels/OnboardingModel.dart';
import 'package:gleam_hr/Providers/AuthProviders/LoginOnboarding_Provider.dart';
import 'package:gleam_hr/Utils/Colors.dart';
import 'package:gleam_hr/Utils/GradiendWidget.dart';
import 'package:gleam_hr/Utils/SizedBox.dart';
import 'package:gleam_hr/Routes/routes.dart' as route;
import 'package:provider/provider.dart';

class LoginOnboarding extends StatelessWidget {
  const LoginOnboarding({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final onBoardingController =
        Provider.of<LoginOnboardingProvider>(context, listen: true);
    return Scaffold(
      body: PageView.builder(
          controller: onBoardingController.controller,
          itemCount: contents.length,
          onPageChanged: (index) {
            onBoardingController.setIndex();
            onBoardingController.index = index;
          },
          itemBuilder: (context, index) {
            return SingleChildScrollView(
              child: SafeArea(
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15),
                      child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                        index>0? TextButton(
                                        onPressed: () {    
                                        onBoardingController.controller.previousPage(
                                            curve: Curves.decelerate,
                                            duration: const Duration(milliseconds: 500));
                                        },
                                        child:const Text(
                                          'Back',
                                        ),
                                      ):const SizedBox(),
                        TextButton(
                                        onPressed: () {
              Navigator.of(context).pushNamedAndRemoveUntil(
                route.bottomNav, (Route route) => false);
                                        },
                                        child: const Text(
                                          'Skip',
                                        ),
                                      ),
                      ],),
                    ),
                    Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 8.0),
                            child: SizedBox(
                                height: height(context) * .5,
                                child: Image.asset(contents[index].image,)),
                          ),
                          SizedBox(
                            height: height(context)*.05,
                          ),
                          CommonTextPoppins(text: contents[index].text, fontweight: FontWeight.w700, fontsize: 16, color: AppColors.blackColor),
                    SizedBox(
                            height: height(context)*.1,
                          ),
                    Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 50),
                        child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(
                          contents.length, (index) => BuildDots(index: index)),
                    ),
                                  GestureDetector(
                                    onTap: () {
                                      if (index==contents.length-1) {
                                                    Navigator.of(context).pushNamedAndRemoveUntil(
                                        route.bottomNav, (Route route) => false);
                                      } else {
                                      onBoardingController.controller.nextPage(
                                          curve: Curves.decelerate,
                                          duration: const Duration(milliseconds: 500));  
                                      }
                                    },
                                    child: Container(
                                      alignment: Alignment.center,
                                      height: 50,
                                      width: 80,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(25),
                                        gradient: horizontalgradientwidget
                                      ),
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

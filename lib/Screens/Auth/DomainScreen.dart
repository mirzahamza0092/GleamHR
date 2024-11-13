import 'package:flutter/material.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gleam_hr/Components/CommonButton.dart';
import 'package:gleam_hr/Components/CommonText.dart';
import 'package:gleam_hr/Providers/AuthProviders/DomainScreen_Provider.dart';
import 'package:gleam_hr/Utils/AppConstants.dart';
import 'package:gleam_hr/Utils/AppPaths.dart';
import 'package:gleam_hr/Utils/Colors.dart';
import 'package:gleam_hr/Utils/SizedBox.dart';
import 'package:provider/provider.dart';

class DomainScreen extends StatelessWidget {
  const DomainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final domainScreenController =
        Provider.of<DomainScreenProvider>(context, listen: false);
    return Scaffold(
      backgroundColor: AppColors.whiteColor,
      body: Consumer<DomainScreenProvider>(builder: (context, provider, child) {
        return SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
          child: SafeArea(
            child: Center(
              child: Form(
                key: domainScreenController.domainScreenFormKey,
                child: Column(
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        20.sh,
                        SvgPicture.asset(ImagePath.logobluesvg),
                        KeyboardVisibilityBuilder(
                            builder: (p0, isKeyboardVisible) {
                          if (isKeyboardVisible) {
                            return const SizedBox();
                          } else {
                            return Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                SvgPicture.asset(ImagePath.domainlogosvg),
                                CommonTextPoppins(
                                    text: 'Enter Your Domain',
                                    fontweight: FontWeight.w500,
                                    fontsize: 20,
                                    color: AppColors.greyColor),
                              ],
                            );
                          }
                        }),
                        32.sh,
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 15),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            color: AppColors.fillColor,
                          ),
                          height: 55,
                          width: width(context),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Expanded(
                                  flex: 1,
                                  child: FittedBox(
                                    child: CommonTextPoppins(
                                        text: "https://",
                                        fontweight: FontWeight.w400,
                                        fontsize: 14,
                                        talign: TextAlign.left,
                                        color: AppColors.hintTextColor),
                                  )),
                              Expanded(
                                flex: 2,
                                child: TextFormField(
                                  controller: domainScreenController.domain,
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      domainScreenController
                                          .isDomainEntered(true);
                                    } else {
                                      domainScreenController
                                          .isDomainEntered(false);
                                    }
                                    return null;
                                  },
                                  decoration: const InputDecoration(
                                    border: InputBorder.none,
                                    hintText: 'Your domain',
                                    hintStyle: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w400),
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                              Expanded(
                                  flex: 2,
                                  child: FittedBox(
                                    child: CommonTextPoppins(
                                        text: ".gleamhr.com",
                                        fontweight: FontWeight.w400,
                                        fontsize: 14,
                                        talign: TextAlign.right,
                                        color: AppColors.hintTextColor),
                                  )),
                            ],
                          ),
                        ),
                        10.sh,
                        Consumer<DomainScreenProvider>(
                          builder: (context, provider, child) {
                            return Container(
                              padding: const EdgeInsets.only(left: 5),
                              alignment: Alignment.topLeft,
                              child: Visibility(
                                  visible: domainScreenController.domainEntered,
                                  child: CommonTextPoppins(
                                      text: "Enter Your Domain",
                                      fontweight: FontWeight.w400,
                                      talign: TextAlign.left,
                                      fontsize: 15,
                                      color: AppColors.primaryColor)),
                            );
                          },
                        ),
                        16.sh,
                        Consumer<DomainScreenProvider>(
                          builder: (context, provider, child) {
                            if (provider.isLoading == false) {
                              return CommonButton(
                                text: 'Continue',
                                width: width(context),
                                onPressed: () {
                                  domainScreenController.enterDomain(context);
                                  debugPrint(domainScreenController.domain.text);
                                  //
                                },
                              );
                            } else {
                              return const CircularProgressIndicator.adaptive();
                            }
                          },
                        ),
                      ],
                    ),
                    KeyboardVisibilityBuilder(builder: (p0, isKeyboardVisible) {
                      if (!isKeyboardVisible) {
                        return Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            SizedBox(
                              height: height(context) * .14,
                            ),
                            Align(
                              alignment: Alignment.bottomCenter,
                              child: CommonTextPoppins(
                                  text: "Version ${AppConstants.appPackage}",
                                  fontweight: FontWeight.w400,
                                  fontsize: 14,
                                  color: AppColors.hintTextColor),
                            ),
                            5.sh,
                          ],
                        );
                      } else {
                        return const SizedBox();
                      }
                    }),
                  ],
                ),
              ),
            ),
          ),
        );
      }),
    );
  }
}

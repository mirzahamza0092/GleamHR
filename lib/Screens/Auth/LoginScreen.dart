import 'package:flutter/material.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gleam_hr/Components/CommonButton.dart';
import 'package:gleam_hr/Components/CommonMessage.dart';
import 'package:gleam_hr/Components/CommonText.dart';
import 'package:gleam_hr/Components/CommonTextField.dart';
import 'package:gleam_hr/Providers/AuthProviders/LoginScreen_Provider.dart';
import 'package:gleam_hr/Providers/DashBoardProviders/MeProviders/MeScreen_Provider.dart';
import 'package:gleam_hr/Routes/Routes.dart' as route;
import 'package:gleam_hr/Utils/AppConstants.dart';
import 'package:gleam_hr/Utils/AppPaths.dart';
import 'package:gleam_hr/Utils/Colors.dart';
import 'package:gleam_hr/Utils/SizedBox.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  void initState() {
    final loginScreenProvider =
        Provider.of<LoginScreenProvider>(context, listen: false);
    // loginScreenProvider.biometric(context);
    loginScreenProvider.isbioenabled();
    loginScreenProvider.getrememberMe();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final loginScreenProvider =
        Provider.of<LoginScreenProvider>(context, listen: false);
    GlobalKey<FormState> loginscreenkey = GlobalKey();

    return Scaffold(
      backgroundColor: AppColors.whiteColor,
      body: Consumer<LoginScreenProvider>(builder: (context, provider, child) {
        return SingleChildScrollView(
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Center(
            child: SafeArea(
              child: Form(
                key: loginscreenkey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: height(context) * .025,
                    ),
                    //20.sh,
                    SvgPicture.asset(ImagePath.logobluesvg), 5.sh,
                    Consumer<MeScreenProvider>(
                        builder: (context, provider, child) {
                      return !provider.logoutCheck
                          ? Container()
                          : InkWell(
                              child: CommonMessage(
                                text: provider.logoutMsg,
                                backgroundColor: AppColors.redLightColor,
                                color: AppColors.redColor,
                                fontsize: 12,
                                fontweight: FontWeight.w500,
                              ),
                              onTap: () => {},
                            );
                    }),
                    KeyboardVisibilityBuilder(
                      builder: (p0, isKeyboardVisible) {
                        if (!isKeyboardVisible) {
                          return Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              SvgPicture.asset(
                                ImagePath.loginlogosvg,
                                width: width(context),
                                height: height(context) * .3,
                              ),

                              //Image(image: AssetImage(ImagePath.loginlogo)),
                              //20.sh,
                              SizedBox(
                                height: height(context) * .025,
                              ),

                              CommonTextPoppins(
                                  text: "Log In ",
                                  fontweight: FontWeight.w500,
                                  fontsize: 20,
                                  color: AppColors.greyColor),
                            ],
                          );
                        } else {
                          return const SizedBox(
                            height: 20,
                          );
                        }
                      },
                    ),

                    //32.sh,
                    SizedBox(
                      height: height(context) * .03,
                    ),
                    CommonTextField(
                      controller: loginScreenProvider.nameoremail,
                      hinttext: 'Email or Username ',
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Please Enter Your Email or Username';
                        }

                        final emailRegex = RegExp(
                            r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+");

                        if (emailRegex.hasMatch(value)) {
                          return null; // valid email
                        } else if (value.length < 3 || value.length > 20) {
                          return 'Username should be between 3 and 20 characters';
                        }

                        return null; // valid username
                      },
                    ),
                    SizedBox(
                      height: height(context) * .025,
                    ),
                    //20.sh,
                    Consumer<LoginScreenProvider>(
                      builder: (context, loginScreenProvider, child) {
                        return CommonTextField(
                          hinttext: 'Password',
                          suffixicon: GestureDetector(
                              onTap: () =>
                                  loginScreenProvider.changeVisibility(),
                              child: loginScreenProvider.visibility
                                  ? const Icon(Icons.visibility_off_outlined)
                                  : const Icon(Icons.visibility_outlined)),
                          controller: loginScreenProvider.password,
                          obsecure: loginScreenProvider.visibility,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "Password can't be empty";
                            } else if (value.length < 6) {
                              return "Password must be greater than 6 characters";
                            } else {
                              return null;
                            }
                          },
                        );
                      },
                    ),
                    8.sh,
                    Row(
                      children: [
                        Checkbox(
                          onChanged: (value) {
                            loginScreenProvider.setRememberMe(value!);
                          },
                          value: loginScreenProvider.rememberme,
                          ),
                        CommonTextPoppins(text: "Remember Me", fontweight: FontWeight.w400, fontsize: 12, color: AppColors.textColor),
                        const Spacer(),
                        InkWell(
                          onTap: () {
                            Navigator.of(context)
                                .pushNamed(route.forgotpasswordscreen);
                          },
                          child: CommonTextPoppins(
                            text: "Forget Password ?",
                            fontweight: FontWeight.w400,
                            fontsize: 12,
                            color: AppColors.textColor,
                            talign: TextAlign.left,
                          ),
                        ),
                      ],
                    ),
                    16.sh,
                    Consumer<LoginScreenProvider>(
                      builder: (context, loginScreenProvider, child) {
                        if (loginScreenProvider.isLoading) {
                          return const CircularProgressIndicator.adaptive();
                        } else {
                          return CommonButton(
                              onPressed: () {
                                if (loginscreenkey.currentState!.validate()) {
                                  loginScreenProvider.hitLogin(
                                      context,
                                      loginScreenProvider.nameoremail.text
                                          .toString(),
                                      loginScreenProvider.password.text
                                          .toString());
                                }
                              },
                              width: width(context),
                              text: "LOGIN");
                        }
                      },
                    ),
                    16.sh,
                    Consumer<LoginScreenProvider>(
                      builder: (context, loginScreenProvider, child) {
                        if (loginScreenProvider.isLoading) {
                          return const SizedBox();
                        } else {
                          //if (loginScreenProvider.bioenabled == "true" && loginScreenProvider.bioenabled2=="true") {
                          return ThumbButton(
                              ontap: () {
                                loginScreenProvider.biometric(
                                    context,
                                    loginScreenProvider.bioenabled == "true" &&
                                            loginScreenProvider.bioenabled2 !=
                                                "true"
                                        ? true
                                        : false);
                              },
                              text: "Login with Fingerprint");
                          //}
                          //  else {
                          //   return const SizedBox();
                          // }
                        }
                      },
                    ),

                    KeyboardVisibilityBuilder(builder: (p0, isKeyboardVisible) {
                      if (!isKeyboardVisible) {
                        return Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            40.sh,
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
                    })
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

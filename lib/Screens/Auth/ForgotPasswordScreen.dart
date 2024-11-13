import 'package:flutter/material.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gleam_hr/Components/CommonButton.dart';
import 'package:gleam_hr/Components/CommonText.dart';
import 'package:gleam_hr/Components/CommonTextField.dart';
import 'package:gleam_hr/Providers/AuthProviders/ForgotPassword_Provider.dart';
import 'package:gleam_hr/Utils/AppPaths.dart';
import 'package:gleam_hr/Utils/Colors.dart';
import 'package:gleam_hr/Utils/SizedBox.dart';
import 'package:provider/provider.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  @override
  Widget build(BuildContext context) {
    final forgotPasswordProvider =
        Provider.of<ForgotPasswordProvider>(context, listen: false);
    return Scaffold(
      backgroundColor: AppColors.whiteColor,
      body:
          Consumer<ForgotPasswordProvider>(builder: (context, provider, child) {
        return SingleChildScrollView(
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: SafeArea(
            child: Center(
              child: Form(
                key: forgotPasswordProvider.forgetPasswordkey,
                child: Column(
                  children: [
                    20.sh,
                    SvgPicture.asset(ImagePath.logobluesvg), 10.sh,
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
                                  text: 'Recover Your Password',
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
                    32.sh,
                    // Visibility(
                    //   visible: _isVisible,
                    //   child: Expanded(
                    //     child: Align(
                    //       child: Padding(
                    //         padding: const EdgeInsets.fromLTRB(24.0, 0, 24.0, 0),
                    //         child: SizedBox(
                    //           width: double.infinity,
                    //           height: 55.0,
                    //           child: DecoratedBox(
                    //             decoration: BoxDecoration(
                    //                 color: Color(0xFFFBF5E9),
                    //                 borderRadius:
                    //                     BorderRadius.all(Radius.circular(5)),
                    //                 shape: BoxShape.rectangle,
                    //                 border: Border.all(color: Color(0xFFFAAF2D))),
                    //             child: Padding(
                    //               padding: const EdgeInsets.fromLTRB(10, 18, 0, 10),
                    //               child: Text(
                    //                 'We have Email you password reset link!',
                    //                 style: TextStyle(
                    //                   color: Color(0xFFFAAF2D),
                    //                   fontSize: 16.0,
                    //                   letterSpacing: 0.4,
                    //                 ),
                    //               ),
                    //             ),
                    //           ),
                    //         ),
                    //       ),
                    //     ),
                    //   ),
                    // ),
                    CommonTextField(
                      controller: forgotPasswordProvider.nameoremail,
                      hinttext: "Email or username",
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
                    16.sh,
                    Consumer<ForgotPasswordProvider>(
                      builder: (context, forgotpassword, child) {
                        if (forgotpassword.isloading) {
                          return const CircularProgressIndicator.adaptive();
                        } else {
                          return SizedBox(
                            height: 50,
                            child: CommonButton(
                                onPressed: () {
                                  forgotPasswordProvider
                                      .hitRecoverPassword(context);
                                },
                                width: width(context),
                                text: "Recover Password"),
                          );
                        }
                      },
                    ),
                    SizedBox(
                      height: height(context) * .13,
                    ),
                    SizedBox(
                        height: 50,
                        child: CommonButton2(text: "BACK TO LOGIN")),
                    16.sh,
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

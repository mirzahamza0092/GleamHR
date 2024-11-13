import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gleam_hr/Providers/AuthProviders/ForgotPassword_Provider.dart';
import 'package:gleam_hr/Providers/AuthProviders/LoginScreen_Provider.dart';
import 'package:gleam_hr/Providers/AuthProviders/SetPassword_Provider.dart';
import 'package:flutter/material.dart';
import 'package:gleam_hr/Components/CommonButton.dart';
import 'package:gleam_hr/Components/CommonText.dart';
import 'package:gleam_hr/Components/CommonTextField.dart';
import 'package:gleam_hr/Utils/AppConstants.dart';
import 'package:gleam_hr/Utils/AppPaths.dart';
import 'package:gleam_hr/Utils/Colors.dart';
import 'package:gleam_hr/Utils/SizedBox.dart';
import 'package:provider/provider.dart';

class SetPassword extends StatelessWidget {
  const SetPassword({super.key});

  @override
  Widget build(BuildContext context) {
    final setPasswordProvider =
        Provider.of<SetPasswordProvider>(context, listen: false);
    return Scaffold(
      backgroundColor: AppColors.whiteColor,
      body: Consumer<SetPasswordProvider>(builder: (context, provider, child) {
        return SingleChildScrollView(
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: SafeArea(
            child: Center(
              child: Form(
                key: setPasswordProvider.setPasswordKey,
                child: Column(
                  children: [
                    20.sh,
                    SvgPicture.asset(ImagePath.logobluesvg),
                    KeyboardVisibilityBuilder(
                      builder: (p0, isKeyboardVisible) {
                        if (!isKeyboardVisible) {
                          return Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              SvgPicture.asset(
                                  ImagePath.recoverpasswordlogosvg),
                              SizedBox(
                                height: height(context) * .025,
                              ),
                              CommonTextPoppins(
                                  text: 'Set Your Password',
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
                    CommonTextField(
                      controller: AppConstants.fromLogin
                          ? context.read<LoginScreenProvider>().nameoremail
                          : context.read<ForgotPasswordProvider>().nameoremail,
                      isEditable: false,
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
                    16.sh,
                    CommonTextField(
                      controller: setPasswordProvider.password,
                      hinttext: "New Password",
                      obsecure: true,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Password can't be empty";
                        } else if (value.length < 8) {
                          return "Password must atleast 8 characters";
                        } else {
                          return null;
                        }
                      },
                    ),
                    16.sh,
                    CommonTextField(
                      controller: setPasswordProvider.confirmPassword,
                      hinttext: "Confirm Password",
                      obsecure: true,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Password can't be empty";
                        } else if (value.length < 8) {
                          return "Password must atleast 8 characters";
                        } else if (setPasswordProvider.password.text != value) {
                          return "Password Didn't Match";
                        } else {
                          return null;
                        }
                      },
                    ),
                    16.sh,
                    Consumer<SetPasswordProvider>(
                      builder: (context, setpasswordprovider, child) {
                        if (setpasswordprovider.isloading == false) {
                          return CommonButton(
                              onPressed: () {
                                setPasswordProvider.hitResetPassword(context);
                              },
                              width: width(context),
                              text: "Reset Password");
                        } else {
                          return const CircularProgressIndicator.adaptive();
                        }
                      },
                    ),
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

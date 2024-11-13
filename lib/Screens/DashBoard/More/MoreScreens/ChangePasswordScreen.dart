import 'package:flutter/material.dart';
import 'package:gleam_hr/Components/CommonAppBar.dart';
import 'package:gleam_hr/Components/CommonButton.dart';
import 'package:gleam_hr/Components/CommonText.dart';
import 'package:gleam_hr/Components/CommonTextField.dart';
import 'package:gleam_hr/Providers/DashBoardProviders/MoreProviders/ChangePassword_Provider.dart';
import 'package:gleam_hr/Utils/AppConstants.dart';
import 'package:gleam_hr/Utils/AppPaths.dart';
import 'package:gleam_hr/Utils/Colors.dart';
import 'package:gleam_hr/Utils/SizedBox.dart';
import 'package:provider/provider.dart';

class ChangePasswordScreen extends StatelessWidget {
  const ChangePasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final changePasswordProvider =
        Provider.of<ChangePasswordProvider>(context, listen: false);
    return WillPopScope(
      onWillPop: () async{
        changePasswordProvider.clear();
      return true;
      },
      child: Scaffold(
        appBar: PreferredSize(
            preferredSize: Size(width(context), 120),
            child: InkWell(
              onTap: () {},
              child: CommonAppBar(
                  subtitle:
                      "${AppConstants.loginmodell!.userData!.firstname} ${(AppConstants.loginmodell!.userData!.lastname).toString() == "null" ? "" : AppConstants.loginmodell!.userData!.lastname}",
                  trailingimagepath:
                      "https://${Keys.domain}.gleamhrm.com/${AppConstants.loginmodell!.userData!.picture}"),
            )),
        body: SingleChildScrollView(
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Form(
            key: changePasswordProvider.changePasswordkey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                32.sh,
                ListTile(
                  minLeadingWidth: 0,
                  contentPadding: EdgeInsets.zero,
                  leading: InkWell(
                      onTap: () {
                        Navigator.of(context).pop();
                        changePasswordProvider.clear();
                      },
                      child: FittedBox(
                          child: Icon(
                        Icons.arrow_back,
                        color: AppColors.primaryColor,
                      ))),
                  title: CommonTextPoppins(
                      text: "Change Password",
                      talign: TextAlign.start,
                      fontweight: FontWeight.w700,
                      fontsize: 20,
                      color: AppColors.textColor),
                ),
                24.sh,
                CommonTextPoppins(
                  text: "Current Password",
                  fontweight: FontWeight.w500,
                  fontsize: 12,
                  talign: TextAlign.left,
                  color: AppColors.hintTextColor,
                ),
                4.sh,
                Consumer<ChangePasswordProvider>(
                  builder: (context, changePasswordProvider, child) {
                    return CommonTextField3(
                  hinttext: "Enter Current Password",
                  obsecure: changePasswordProvider.viewPassword[0],
                  suffixIcon: GestureDetector(
                              onTap: () =>
                                  changePasswordProvider.changeViewPassword(0),
                              child: changePasswordProvider.viewPassword[0]
                                  ? const Icon(Icons.visibility_off_outlined)
                                  : const Icon(Icons.visibility_outlined)),
                  controller: changePasswordProvider.currentPassword,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Current Password can't be empty";
                    } else if (value.length < 6) {
                      return "Current Password must be greater than 6 characters";
                    } else {
                      return null;
                    }
                  },
                );
                  },
                ),
                24.sh,
                CommonTextPoppins(
                  text: "New Password",
                  fontweight: FontWeight.w500,
                  fontsize: 12,
                  talign: TextAlign.left,
                  color: AppColors.hintTextColor,
                ),
                4.sh,
                Consumer<ChangePasswordProvider>(
                  builder: (context, changePasswordProvider, child) {
                    return CommonTextField3(
                  hinttext: "Enter New Password",
                  suffixIcon: GestureDetector(
                              onTap: () =>
                                  changePasswordProvider.changeViewPassword(1),
                              child: changePasswordProvider.viewPassword[1]
                                  ? const Icon(Icons.visibility_off_outlined)
                                  : const Icon(Icons.visibility_outlined)),
                  obsecure: changePasswordProvider.viewPassword[1],
                  controller: changePasswordProvider.newPassword,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "New Password can't be empty";
                    } else if (value.length < 6) {
                      return "New Password must be greater than 6 characters";
                    } else {
                      return null;
                    }
                  },
                );
                  },
                ),
                24.sh,
                CommonTextPoppins(
                  text: "Confirm Password",
                  fontweight: FontWeight.w500,
                  fontsize: 12,
                  talign: TextAlign.left,
                  color: AppColors.hintTextColor,
                ),
                4.sh,
                Consumer<ChangePasswordProvider>(
                  builder: (context, changePasswordProvider, child) {
                    return CommonTextField3(
                  hinttext: "Enter Confirm Password",
                  obsecure: changePasswordProvider.viewPassword[2],
                  controller: changePasswordProvider.confirmPassword,
                  suffixIcon: GestureDetector(
                              onTap: () =>
                                  changePasswordProvider.changeViewPassword(2),
                              child: changePasswordProvider.viewPassword[2]
                                  ? const Icon(Icons.visibility_off_outlined)
                                  : const Icon(Icons.visibility_outlined)),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Confirm Password can't be empty";
                    } else if (value.length < 6) {
                      return "Confirm Password must be greater than 6 characters";
                    } else if (changePasswordProvider.newPassword.text != value) {
                      return "Password Didn't Match";
                    } else {
                      return null;
                    }
                  },
                );
                  },
                ),
                24.sh,
                Consumer<ChangePasswordProvider>(
                  builder: (context, changePasswordProvider, child) {
                    if (changePasswordProvider.isloading) {
                      return const Center(child: CircularProgressIndicator.adaptive());
                    } else {
                      return CommonButton(
                          onPressed: () {
                            if (changePasswordProvider
                                .changePasswordkey.currentState!
                                .validate()) {
                              changePasswordProvider.hitChangePassword(context);
                            }
                          },
                          width: width(context),
                          text: "Save");
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

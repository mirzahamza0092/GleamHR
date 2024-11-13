import 'package:flutter/material.dart';
import 'package:gleam_hr/Components/CommonText.dart';
import 'package:gleam_hr/Components/commonSnakbar.dart';
import 'package:gleam_hr/Providers/DashBoardProviders/MeProviders/MeScreen_Provider.dart';
import 'package:gleam_hr/Services/AuthServices/LogoutApi_Service.dart';
import 'package:gleam_hr/Utils/Colors.dart';
import 'package:gleam_hr/Utils/Methods.dart';
import 'package:gleam_hr/Utils/SizedBox.dart';
import 'package:provider/provider.dart';

class LogOutButton extends StatelessWidget {
  const LogOutButton({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<MeScreenProvider>(
      builder: (context, mescreenProvider, child) {
        if (mescreenProvider.logoutLoading == false) {
          return InkWell(
              onTap: () async {
                if (await checkinternetconnection()) {
                  mescreenProvider.changelogoutLoading(true);
                  await LogoutApiService.logout(context: context);
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                        appSnackBar("No Internet Connection"));
                  
                }
              },
              child: Container(
                width: width(context) * .3,
                height: 40,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: AppColors.textColor.withOpacity(.05),
                    // border:
                    //     Border.all(width: 1, color: AppColors.primaryColor)
                        ),
                child: Center(
                  child: CommonTextPoppins(
                      text: "LOGOUT",
                      fontweight: FontWeight.w500,
                      fontsize: 14,
                      color: AppColors.primaryColor),
                ),
              ));
        } else {
          return const CircularProgressIndicator.adaptive();
        }
      },
    );
  }
}

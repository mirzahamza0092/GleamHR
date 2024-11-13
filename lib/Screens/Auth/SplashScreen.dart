import 'dart:async';
import 'package:flutter/material.dart' hide Action;
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gleam_hr/Components/CommonText.dart';
import 'package:gleam_hr/Providers/DashBoardProviders/MeProviders/MeScreen_Provider.dart';
import 'package:gleam_hr/Routes/routes.dart' as route;
import 'package:gleam_hr/Screens/Auth/DomainOnboarding.dart';
import 'package:gleam_hr/Utils/AppConstants.dart';
import 'package:gleam_hr/Utils/AppPaths.dart';
import 'package:gleam_hr/Utils/Colors.dart';
import 'package:gleam_hr/Utils/GradiendWidget.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Timer(const Duration(seconds: 3), () async {
      //
      SharedPreferences prefs = await SharedPreferences.getInstance();
      if (prefs.getBool("enabledBioMetric") == true) {
        context.read<MeScreenProvider>().changeEnabledBioMetric(true);
      }
      AppConstants.token = prefs.getString(Keys.token).toString();
      Keys.domain = prefs.getString(Keys.onlydomain);
      if ((AppConstants.token.toString() == "" ||
              AppConstants.token == "null") &&
          (prefs.getString(Keys.onlydomain) == null ||
              prefs.getString(Keys.onlydomain) == "")) {
        Navigator.of(context)
                .pushAndRemoveUntil(MaterialPageRoute(builder:(context) => const DomainOnboarding(),),(Route route) => false);
        //Navigator.of(context).pushReplacementNamed(route.domainscreen);
      } else if (AppConstants.token.toString() == "" ||
          AppConstants.token == "null") {
        Navigator.of(context).pushReplacementNamed(route.login);
      } else {
        Navigator.of(context).pushReplacementNamed(route.login);
        // for auto login
        //  AppConstants.loginmodell =
        //         stagingLoginModelFromJson(prefs.getString("loginmodel").toString());
        //  AppConstants.allEmployeesDetailsModel=await prefs.getString("allempnmodel").toString() =="null"? AppConstants.allEmployeesDetailsModel: allEmployeesDetailsModelFromJson(prefs.getString("allempnmodel").toString());
        //        AppConstants.button=await prefs.getString("button");
        //  AppConstants.clocktype=await prefs.getString("clock_type");
        //   Navigator.of(context).pushReplacementNamed(route.bottomNav);
        //
      }
      //
    });

    return Scaffold(
      backgroundColor: AppColors.whiteColor,
      body: Container(
        decoration: BoxDecoration(gradient: horizontalgradientwidget),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Expanded(
                  child: Align(
                alignment: Alignment.bottomCenter,
                child: Padding(
                  padding: const EdgeInsets.only(top: 28.0),
                  child:SvgPicture.asset('assets/logo_name_white.svg'),
                ),
              )),
              Expanded(
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: Padding(
                      padding: const EdgeInsets.only(bottom: 30.0),
                      child: Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            CommonTextPoppins(
                              text: 'from',
                              fontsize: 14.0,
                              color: AppColors.whiteColor,
                              fontweight: FontWeight.w400,
                            ),
                            const Image(
                                image:
                                    AssetImage('assets/glowlogix_white.png')),
                          ])),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

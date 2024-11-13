import 'package:flutter/material.dart';
import 'package:gleam_hr/Components/CommonAppBar.dart';
import 'package:gleam_hr/Providers/AuthProviders/SettingScreen_Provider.dart';
import 'package:gleam_hr/Providers/DashBoardProviders/MeProviders/MeScreen_Provider.dart';
import 'package:gleam_hr/Routes/Routes.dart' as route;
import 'package:gleam_hr/Components/CommonText.dart';
import 'package:gleam_hr/Screens/DashBoard/Home/HomeWidgets/CustomDialogBox.dart';
import 'package:gleam_hr/Screens/DashBoard/More/MoreWidget/SettingsWidgets.dart';
import 'package:gleam_hr/Utils/AppConstants.dart';
import 'package:gleam_hr/Utils/AppPaths.dart';
import 'package:gleam_hr/Utils/Colors.dart';
import 'package:gleam_hr/Utils/SizedBox.dart';
import 'package:local_auth/local_auth.dart';
import 'package:provider/provider.dart';

class SettingScreen extends StatefulWidget {
  const SettingScreen({super.key});

  @override
  State<SettingScreen> createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  @override
  void initState() {
        AppConstants.auth.isDeviceSupported().then(
          (bool value) => context
              .read<MeScreenProvider>()
              .changeDeviceBioMetricAvailability(value),
        );
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
        body: Consumer<SettingScreenProvider>(builder: (context, provider, child) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
        children: [
           Padding(
               padding: const EdgeInsets.only(left: 25,top: 25.0),
               child: Row(
                 children: [
                  InkWell(
                      onTap: () {
                        Navigator.of(context).pop();
                      },
                      child: FittedBox(
                          child: Icon(
                        Icons.arrow_back,
                        color: AppColors.primaryColor,
                      ))),7.sw,
                   CommonTextPoppins(
                                     text: "Settings",
                                     fontweight: FontWeight.w700,
                                     fontsize: 20,
                                     color: AppColors.textColor),
                 ],
               ),
                          ),
         20.sh,
          Consumer<MeScreenProvider>(
                            builder: (context, MeScreenProvider, child) {
                              if (AppConstants.supportstate) {
                                return commonSettingListile(onclick: (){},text: "Biometric / Face Login",icon: ImagePath.thumbIcon,switcherEnabled: true, changer: MeScreenProvider.enabledBioMetric,
                                switcherTap: (bool v) async {
                                          List<BiometricType> biotypes = [];
                                          biotypes = await AppConstants.auth
                                              .getAvailableBiometrics();
                                          debugPrint("Biometric Types$biotypes");
                                         bool isauthenticate = await MeScreenProvider.userAuthorization(reason: "Please Authenticate");

                                          if (v && isauthenticate) {  
                                          MeScreenProvider
                                              .changeEnabledBioMetric(v);
                                              await showDialog(
                                                  context: context,
                                                  builder: (BuildContext context) { 
                                                    return CustomDialogBox(
                                                      title: "You have to enter credentials first time when login",
                                                      text: "OK",
                                                      img: Image.asset(ImagePath.dialogBoxImage),
                                                    );
                                                  });
                                             
                                          }else if(isauthenticate){
                                            MeScreenProvider
                                              .changeEnabledBioMetric(v);
                                          }
                                        },);
                              } else {
                                return const SizedBox();
                              }
                            },
                          ),
          //    commonSettingListile(onclick: (){},text: "Facial identification",icon: ImagePath.faceIcon,switcherEnabled: true,switcherTap: (value){
          //    provider.faceIndenty(value);  
          // },changer:provider.facialIdentification),
          //    commonSettingListile(onclick: (){},text: "Dark Mode",icon: ImagePath.darkModeIcon,switcherEnabled: true,switcherTap: (value){
          //       provider.dark(value);
          // },changer: provider.darkMode),
          commonSettingListile(onclick: (){
             Navigator.of(context).pushNamed(route.changePasswordScreen);
          },text: "Change Password",icon: ImagePath.changePasswordIcon,),
          AppConstants.loginmodell!.userRole![0].type.toString() !="admin"? const SizedBox():commonSettingListile(icon: ImagePath.faceIcon, text: "Enroll Faces", onclick: (){
            Navigator.of(context).pushNamed(route.employeeRegisterScreen);
          }),
          AppConstants.loginmodell!.userRole![0].type.toString() !="admin"? const SizedBox():commonSettingListile(iconneeded: true, iconData: Icons.location_on, text: "Set Offices Location", onclick: (){
            Navigator.of(context).pushNamed(route.setOfficeLocation);
          }),
          AppConstants.loginmodell!.userRole![0].type.toString() !="admin"? const SizedBox():commonSettingListile(iconneeded:true, iconData: Icons.location_history_sharp, text: "View Tracked Employee", onclick: (){
            Navigator.of(context).pushNamed(route.trackedEmployee);
          }),
          AppConstants.loginmodell!.userRole![0].type.toString() !="admin"? const SizedBox():commonSettingListile(iconneeded:true, iconData: Icons.location_history_sharp, text: "View Employee Shift", onclick: (){
            Navigator.of(context).pushNamed(route.employeeShift);
          }),
          AppConstants.loginmodell!.userRole![0].type.toString() !="admin"? const SizedBox():commonSettingListile(iconneeded:true, iconData: Icons.location_history_sharp, text: "Change Employee Role", onclick: (){
            Navigator.of(context).pushNamed(route.changeEmployeeRole);
          }),
          // AppConstants.loginmodell!.userRole![0].type.toString() !="admin"? const SizedBox():commonSettingListile(iconneeded:true, iconData: Icons.location_history_sharp, text: "check app state", onclick: (){
          //   Navigator.of(context).push(MaterialPageRoute(builder: (context) => CheckAppState()));
          // }),
  //         CommonButton(onPressed: ()async{
  //           if (await checkinternetconnection()) {
  //   await backgroundForegroundFetch();
  // } else {
  //   storelocalData();
  //   //here i store local data  
  // }
  //         }, width: width(context), text: "push data for testing")
        ],
      );})
    );
  }
}

import 'package:flutter/material.dart';
import 'package:gleam_hr/Providers/DashBoardProviders/MeProviders/MeScreen_Provider.dart';
import 'package:gleam_hr/Screens/DashBoard/Me/MeWidget/switchbutton.dart';
import 'package:gleam_hr/Utils/SizedBox.dart';
import 'package:provider/provider.dart';

Widget meScreenInfoWidget(){
  return Consumer<MeScreenProvider>(
      builder: (context, meScreenProvider, child) {
        return Row(children: [
    Expanded(child: SwitchButton(onPressed: (){
      meScreenProvider.changeInfoStatus(true);
    }, width: width(context), text: "Personal Info",isactivated:  meScreenProvider.personalInfo?true:false,height: 36,)),
    7.sw,
    Expanded(child: SwitchButton(onPressed: (){
      meScreenProvider.changeInfoStatus(false);
      }, width: width(context), text: "Official Info",isactivated: meScreenProvider.personalInfo?false:true,height: 36,)),
    ],);
      },
    );
}
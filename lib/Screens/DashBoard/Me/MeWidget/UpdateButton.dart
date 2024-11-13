
import 'package:flutter/material.dart';
import 'package:gleam_hr/Components/CommonText.dart';
import 'package:gleam_hr/Providers/DashBoardProviders/MeProviders/MeScreen_Provider.dart';
import 'package:gleam_hr/Utils/Colors.dart';
import 'package:gleam_hr/Utils/SizedBox.dart';
import 'package:provider/provider.dart';

class UpdateButton extends StatelessWidget {
  String text;
  var ontap;
  
  UpdateButton({
    super.key,
    required this.ontap,
    required this.text
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<MeScreenProvider>(
      builder: (context, mescreenProvider, child) {
        return InkWell(
        onTap: ontap,
        child: Container(width: width(context),height: 50,decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: AppColors.textColor.withOpacity(.05),
                    // border:
                    //     Border.all(width: 1, color: AppColors.primaryColor)
                        ),
                child: Center(child: CommonTextPoppins(text: text, fontweight: FontWeight.w600, fontsize: 14, color:AppColors.primaryColor),),));
        }
    );
  }
}
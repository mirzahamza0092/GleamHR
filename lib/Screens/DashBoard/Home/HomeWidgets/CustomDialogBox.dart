import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gleam_hr/Components/CommonButton.dart';
import 'package:gleam_hr/Components/CommonText.dart';
import 'package:gleam_hr/Utils/AppPaths.dart';
import 'package:gleam_hr/Utils/SizedBox.dart';

class CustomDialogBox extends StatelessWidget {
  final String title, text;
  final Image img;

  const CustomDialogBox({super.key, required this.title, required this.text, required this.img});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      elevation: 0,
      child: contentBox(context),
    );
  }

  contentBox(context) {
    return Stack(
      clipBehavior: Clip.none,
      children: <Widget>[
        Container(
          padding: const EdgeInsets.only(left: 5, top: 5 + 5, right: 5, bottom: 5),
          margin: const EdgeInsets.only(top: 5),
          decoration: BoxDecoration(
              shape: BoxShape.rectangle,
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              14.sh,
              SvgPicture.asset(ImagePath.info,width: 30,height: 30,),
              24.sh,
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                child: Center(
                  child: CommonTextPoppins(
                      text: title,
                      fontweight: FontWeight.w400,
                      fontsize: 16,
                      color: const Color(0XFF343434)),
                ),
              ),
              24.sh,
              SizedBox(
                width: width(context)*.3,
                height: 45,
                child: CommonButton2(text: "Ok",),
                // ElevatedButton(
                  
                //   style: ElevatedButton.styleFrom(
                  
                //     primary: AppColors.greenColor,
                //     shape: RoundedRectangleBorder(
                //       borderRadius: BorderRadius.circular(4.0),
                //     ),
                //   ),
                //   onPressed: () {
                //     Navigator.of(context).pop();
                //   },
                //   child: CommonTextPoppins(
                //       text: text,
                //       fontweight: FontWeight.w600,
                //       fontsize: 14,
                //       color: AppColors.whiteColor),
                // ),
              ),
              24.sh,
            ],
          ),
        ),
        
        // Positioned(
        //   bottom: height(context)*.11,
        //   left: 5,
        //   right: 5,
        //   child: img,
        // ),
      ],
    );
  }
}

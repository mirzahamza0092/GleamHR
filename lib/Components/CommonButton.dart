import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gleam_hr/Components/CommonText.dart';
import 'package:gleam_hr/Utils/AppPaths.dart';
import 'package:gleam_hr/Utils/Colors.dart';
import 'package:gleam_hr/Utils/GradiendWidget.dart';
import 'package:gleam_hr/Utils/SizedBox.dart';

class CommonButton extends StatelessWidget {
  var onPressed;
  double width;
  double height;
  String text;
  bool shadowneeded,gradientneeded;
  Color? color;
  Color textColor;
  CommonButton({
    required this.onPressed,
    required this.width,
    this.height = 55.0,
    required this.text,
    this.color,
    this.textColor=Colors.white,
    this.shadowneeded = true,
  this.gradientneeded=true
    // super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(

      decoration: BoxDecoration(
          boxShadow: shadowneeded
              ? [
                  BoxShadow(
                      color: AppColors.primaryColor,
                      offset: const Offset(1, 3),
                      blurRadius: 12,
                      spreadRadius: 0),
                  // BoxShadow(color: AppColors.primaryColor,offset:const Offset(0, 2),blurRadius: 10,spreadRadius: 0)
                ]
              : [],
          borderRadius: BorderRadius.circular(8),
          gradient:gradientneeded? horizontalgradientwidget:null),
      child: ElevatedButton(
          onPressed: onPressed,
          style: ElevatedButton.styleFrom(
              elevation: 0,
              backgroundColor: color,
              shadowColor: Colors.transparent,
              fixedSize: Size(width, height)),
          child: CommonTextPoppins(
              text: text,
              fontweight: FontWeight.w600,
              fontsize: 16.0,
              color: textColor)),
    );
  }
}


class CommonButton2 extends StatelessWidget {
  String text;
  CommonButton2({
    required this.text,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ButtonTheme(
      child: ElevatedButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          style: ButtonStyle(
            backgroundColor:
                MaterialStatePropertyAll<Color>(AppColors.whiteColor),
            minimumSize: const MaterialStatePropertyAll<Size>(
                Size(double.infinity, 55.0)),
            side: MaterialStateBorderSide.resolveWith(
                (Set<MaterialState> states) {
              if (states.contains(MaterialState.selected)) {
                return BorderSide(color: AppColors.primaryColor);
              }
              return BorderSide(color: AppColors.primaryColor);
            }),
          ),
          child: CommonTextPoppins(
              text: text,
              fontweight: FontWeight.w500,
              fontsize: 16,
              color: AppColors.primaryColor)),
    );
  }
}

class ThumbButton extends StatelessWidget {
  String text;
  var ontap;
  ThumbButton({
    required this.text,
    required this.ontap,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ButtonTheme(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(40),
      ),
      child: ElevatedButton(
          onPressed: ontap,
          style: ButtonStyle(
            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8.0),
            )),
            backgroundColor:
                MaterialStatePropertyAll<Color>(AppColors.whiteColor),
            minimumSize: const MaterialStatePropertyAll<Size>(
                Size(double.infinity, 55.0)),
            side: MaterialStateBorderSide.resolveWith(
                (Set<MaterialState> states) {
              if (states.contains(MaterialState.selected)) {
                return BorderSide(color: AppColors.textColor);
              }
              return BorderSide(color: AppColors.textColor);
            }),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                CommonTextPoppins(
                    text: text,
                    fontweight: FontWeight.w400,
                    fontsize: 16,
                    color: AppColors.textColor),
                SvgPicture.asset(
                  ImagePath.thumbIcon,
                  color: AppColors.textColor,
                  width: 30,
                  height: 30,
                ),
              ],
            ),
          )),
    );
  }
}

class AddMoreButton extends StatelessWidget {
  String text, imagePath;
  var ontap;

  AddMoreButton({
    required this.text,
    required this.ontap,
    required this.imagePath,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ButtonTheme(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(40),
      ),
      child: ElevatedButton(
          onPressed: ontap,
          style: ButtonStyle(
            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8.0),
            )),
            backgroundColor:
                MaterialStatePropertyAll<Color>(AppColors.whiteColor),
            minimumSize: const MaterialStatePropertyAll<Size>(
                Size(double.infinity, 55.0)),
            side: MaterialStateBorderSide.resolveWith(
                (Set<MaterialState> states) {
              if (states.contains(MaterialState.selected)) {
                return BorderSide(color: AppColors.textColor);
              }
              return BorderSide(color: AppColors.textColor);
            }),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SvgPicture.asset(
                imagePath,
                color: AppColors.textColor,
                width: 16,
                height: 16,
              ),
              10.sw,
              CommonTextPoppins(
                  text: text,
                  fontweight: FontWeight.w500,
                  fontsize: 14,
                  color: AppColors.textColor),
            ],
          )),
    );
  }
}

class DenyButton extends StatelessWidget {
  String text, imagePath;
  var ontap;

  DenyButton({
    required this.text,
    required this.ontap,
    required this.imagePath,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ButtonTheme(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(40),
      ),
      child: ElevatedButton(
          onPressed: ontap,
          style: ButtonStyle(
            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8.0),
            )),
            backgroundColor:
                MaterialStatePropertyAll<Color>(AppColors.whiteColor),
            minimumSize: const MaterialStatePropertyAll<Size>(
                Size(double.infinity, 55.0)),
            side: MaterialStateBorderSide.resolveWith(
                (Set<MaterialState> states) {
              if (states.contains(MaterialState.selected)) {
                return BorderSide(color: AppColors.primaryColor);
              }
              return BorderSide(color: AppColors.primaryColor);
            }),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SvgPicture.asset(
                imagePath,
                color: AppColors.primaryColor,
                width: 16,
                height: 16,
              ),
              10.sw,
              CommonTextPoppins(
                  text: text,
                  fontweight: FontWeight.w500,
                  fontsize: 14,
                  color: AppColors.primaryColor),
            ],
          )),
    );
  }
}

class CommonButtonImage extends StatelessWidget {
  var onPressed;
  double width;
  String text, image;
  Color color;
  bool shadowneeded;
  Color textColor;
  Color iconColor;
  CommonButtonImage({
    required this.onPressed,
    required this.width,
    required this.text,
    required this.color,
    required this.image,
    this.shadowneeded = true,
    this.textColor=Colors.white,
    this.iconColor=Colors.white
    // super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          boxShadow: shadowneeded
              ? [
                  BoxShadow(
                      color: AppColors.primaryColor,
                      offset: const Offset(1, 3),
                      blurRadius: 10,
                      spreadRadius: 0),
                  // BoxShadow(color: AppColors.primaryColor,offset:const Offset(0, 2),blurRadius: 10,spreadRadius: 0)
                ]
              : [],
          borderRadius: BorderRadius.circular(8),
          gradient: horizontalgradientwidget),
      child: ElevatedButton(
          onPressed: (){onPressed();},
          style: ElevatedButton.styleFrom(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8)),
              elevation: 0,
              backgroundColor: color,
              shadowColor: Colors.transparent,
              fixedSize: Size(width, 55.0)),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SvgPicture.asset(
                image,
                width: 16,
                height: 16,
                color: iconColor,
              ),
              5.sw,
              CommonTextPoppins(
                  text: text,
                  fontweight: FontWeight.w600,
                  fontsize: 16.0,
                  color: textColor),
            ],
          )),
    );
  }
}

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gleam_hr/Components/CommonText.dart';
import 'package:gleam_hr/Utils/AppPaths.dart';

class CommonMessage extends StatelessWidget {
  String text;
  FontWeight fontweight;
  double fontsize;
  Color color;
  Color backgroundColor;
  TextOverflow textOverflow;
  CommonMessage({
    super.key,
    required this.text,
    required this.fontweight,
    required this.fontsize,
    required this.color,
    required this.backgroundColor,
    this.textOverflow = TextOverflow.visible,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        borderRadius:const BorderRadius.all(Radius.circular(5)),
        border: Border.all(color: color),
        color: backgroundColor,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: SizedBox(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CommonTextPoppins(
                      text: text,
                      fontweight: fontweight,
                      fontsize: fontsize,
                      color: color),
                  SizedBox(
                    width: 9.6,
                    height: 8,
                    child: SvgPicture.asset(
                      ImagePath.removeIcon,
                      color: color,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

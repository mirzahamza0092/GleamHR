import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CommonTextPoppins extends StatelessWidget {
  String text;
  FontWeight fontweight;
  double fontsize;
  Color color;
  TextAlign talign;
  TextOverflow textOverflow;
  CommonTextPoppins({super.key, 
    required this.text,
    required this.fontweight,
    required this.fontsize,
    required this.color,
    this.textOverflow=TextOverflow.visible,
    this.talign = TextAlign.center,
  });

  @override
  Widget build(BuildContext context) {
    return Text(text,
        textAlign: talign,
        overflow: textOverflow,
        style: GoogleFonts.poppins(
          textStyle: TextStyle(
            color: color,
            fontWeight: fontweight,
            fontSize: fontsize,
          ),
        ));
  }
}

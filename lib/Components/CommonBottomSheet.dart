import 'package:flutter/material.dart';
import 'package:gleam_hr/Utils/Colors.dart';

Future<dynamic> CommonBottomSheet(
    {required BuildContext context, required Widget widget}) {
  return showModalBottomSheet(
    showDragHandle: true,
    shape: const RoundedRectangleBorder( // <-- SEE HERE
          borderRadius: BorderRadius.vertical( 
            top: Radius.circular(24.0),
          ),
        ),
    backgroundColor: AppColors.whiteColor,
    context: context,
    builder: (context) {
      return Container(
      padding: EdgeInsets.only(
         bottom: MediaQuery.of(context).viewInsets.bottom),
        child: widget);
    },
  );
}

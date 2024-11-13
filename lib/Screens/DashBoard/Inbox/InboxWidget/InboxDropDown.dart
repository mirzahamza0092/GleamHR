import 'package:flutter/material.dart';
import 'package:gleam_hr/Utils/Colors.dart';

class InboxDropDown extends StatelessWidget {
  String selectedText = '';
  List<String> listItem = [];
  var onchanged;
  double width;

  InboxDropDown({
    super.key,
    required this.width,
    required this.selectedText,
    required this.listItem,
    required this.onchanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 10,
      width: width,
      padding: const EdgeInsets.symmetric(horizontal: 10),
      // width: MediaQuery.of(context).size.width,
      // width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          // border: Border.all(
          //   color: Colors.black54,
          // ),
          color: AppColors.fillColor),
      child: Center(
        child: DropdownButton<String>(
          isExpanded: true,
          value: selectedText,
          underline: const Text(""),
          items: listItem.map((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(
                value,
              ),
            );
          }).toList(),
          onChanged: onchanged,
        ),
      ),
    );
  }
}

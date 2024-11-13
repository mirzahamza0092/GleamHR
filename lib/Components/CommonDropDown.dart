import 'package:flutter/material.dart';
import 'package:gleam_hr/Utils/Colors.dart';

class CommonDropDown extends StatelessWidget {
  String selectedText = '';
  List<String> listItem = [];
  var onchanged;
  double width;

  CommonDropDown({
    super.key,
    required this.width,
    required this.selectedText,
    required this.listItem,
    required this.onchanged,
  });

  @override
  Widget build(BuildContext context) {
    if (!listItem.contains(selectedText)) {
      return const SizedBox();
    }
    return Container(
      height: 50,
      width: width,
      padding: const EdgeInsets.symmetric(horizontal: 10),
      // width: MediaQuery.of(context).size.width,
      // width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        // border: Border.all(
        //   color: Colors.black54,
        // ),
        color:AppColors.fillColor
      ),
      child: DropdownButton<String>(
        isExpanded: true,
        value: selectedText,
        underline:const Text(""),
        items: listItem.map((String value) {
          return DropdownMenuItem<String>(
            
            value: value,
            child: Container(
              width: width,
              decoration: BoxDecoration(
              border: Border(
                      bottom: BorderSide(
                    color: AppColors.fillColor,
                    width: 1.5,
                  )),),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  value,
                 ),
              ),
            ),
          );
        }).toList(),
        onChanged: onchanged,
      ),
      
    );
  }
}

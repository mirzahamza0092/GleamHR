import 'package:flutter/material.dart';
import 'package:gleam_hr/Components/CommonText.dart';
import 'package:gleam_hr/Utils/Colors.dart';

class PaySlipDropDown extends StatelessWidget {
  String selectedText = '';
  List<String> listItem = [];
  var onchanged;
  double width;
  //final Widget Divider;

  PaySlipDropDown({
    super.key,
    required this.width,
    required this.selectedText,
    required this.listItem,
    required this.onchanged,
   // required this.Divider,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      width: width,
      padding: const EdgeInsets.symmetric(vertical: 12,horizontal: 12),
      // width: MediaQuery.of(context).size.width,
      // width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          // border: Border.all(
          //   color: Colors.black54,
          // ),
          color:const Color(0XFFFAFAFA) ),
      child: Center(
        child: DropdownButton<String>(
          borderRadius: BorderRadius.circular(10),
          //elevation: 18,
          isExpanded: true,
          value: selectedText,
          underline: const Text(""),
          
          items: List.generate(listItem.length, (index) {
            return DropdownMenuItem<String>(
            
              value: listItem[index],
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                
                Padding(
                  padding: const EdgeInsets.only(right:258),
                  child: CommonTextPoppins(
                    text:
                    listItem[index]
                    ,
                    fontsize: 14,
                    fontweight: FontWeight.w500,
                    color: AppColors.textColor,
                  ),
                ),
                //if (index < listItem.length ) 
                const Divider(
                  thickness: 0.0,
                  height: 4,
                ),
              ],
            ),
            
            )
            ;
          }).toList(),
          
          onChanged: onchanged,
          
          selectedItemBuilder: (BuildContext context) {
          return listItem.map<Widget>((String item) {
          return Text(item);
          }
          ).toList();
         },
         
        ), 
      ),
    );
  }
}


import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gleam_hr/Components/CommonText.dart';
import 'package:gleam_hr/Providers/DashBoardProviders/HomeProviders/ExpenseRequestProvider.dart';
import 'package:gleam_hr/Screens/DashBoard/Home/HomeWidgets/OpenImage.dart';
import 'package:gleam_hr/Screens/DashBoard/Home/OpenPdf.dart';
import 'package:gleam_hr/Utils/AppPaths.dart';
import 'package:gleam_hr/Utils/Colors.dart';
import 'package:gleam_hr/Utils/SizedBox.dart';
import 'package:provider/provider.dart';

Widget ExpenseFileWidget({
  required String icon,
  required String title,
  required BuildContext context,
  // required var download,
  required String see,
   required var remove,
}){
  return Column(
    children: [
      Container(
            height: 54,
            width: width(context),
            decoration: BoxDecoration(
              color: AppColors.fillColor.withOpacity(0.2),
              borderRadius:const BorderRadius.all(Radius.circular(8))
            ),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Image.asset(icon),
                          15.sw,
                         Container(
                          height: 50,
                             width: 150,
                               decoration: BoxDecoration(
                                  borderRadius:
                                    BorderRadius.circular(8),),
                                     padding: const EdgeInsets.only(top:10),
                                      child: ListView(
                                        scrollDirection: Axis.horizontal,
                                         children: [
                                                    CommonTextPoppins(text: title, fontweight: FontWeight.w400, fontsize: 14, color: AppColors.blackColor)
                                                    ],
                                                  )),
                                                  
                          const Spacer(),
                          //  InkWell(
                          //   onTap: (){debugPrint("downloade");},
                          //    child: SvgPicture.asset(
                          //     ImagePath.downloadIcons,
                          //     color: AppColors.primaryColor,
                          //     width: 12,
                          //     height: 12,
                          //                    ),
                          //  ),10.sw,
                           Consumer<ExpenseRequestProvider>(
                    builder: (context, ERProvider, child) {
                      return InkWell(
                             onTap: (){
                              String name=see.split('.').last.toLowerCase();
                              name=='pdf'?
                              Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => OpenPdf(dir: see),
                              )):Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => OpenImage(dir: see),
                              ));
                             
                             },
                             child: SvgPicture.asset(
                              ImagePath.visibilityIcon,
                              color: AppColors.primaryColor,
                              width: 12,
                              height: 12,
                                             ),
                           );}),10.sw,
                           Consumer<ExpenseRequestProvider>(
                    builder: (context, ERProvider, child) {
                      return  InkWell(
                             onTap: (){
                              ERProvider.removeItem(remove);
                              debugPrint("cross");},
                             child: SvgPicture.asset(
                              ImagePath.crossIcon,
                              color: AppColors.redColor,
                              width: 12,
                              height: 12,
                                             ),
                           );})
              ]),
              
            ),

          ),
          10.sh
    ],
  );
    
}
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:gleam_hr/Utils/AppConstants.dart';
import 'package:gleam_hr/Utils/AppPaths.dart';
import 'package:gleam_hr/Utils/sharedPreferenceHelper.dart';

class BottomBarIconProvider extends ChangeNotifier{
int featureCount = 0;
  List<BottomBarAddContent> bottomBarAddContent = [
    BottomBarAddContent(
        imagePath: ImagePath.clockIcon, isCheck:AppConstants.barOptions.isEmpty? true:AppConstants.barOptions[0]=="true"? true:false, title: "Time Tracking",showWidget: AppConstants.modulesmodell!.data![6].status.toString() =="1"?true:false),
    BottomBarAddContent(
        imagePath: ImagePath.payroll, isCheck: AppConstants.barOptions.isEmpty? true:AppConstants.barOptions[1]=="true"? true:false, title: "Payroll",showWidget: AppConstants.modulesmodell!.data![0].status.toString() =="1"?true:false),
    BottomBarAddContent(
        imagePath: ImagePath.workFromHomeIcon, isCheck: AppConstants.barOptions.isEmpty? true:AppConstants.barOptions[2]=="true"? true:false, title: "Work From Home",showWidget: AppConstants.modulesmodell!.data![8].status.toString() =="1"?true:false),
    BottomBarAddContent(
        imagePath: ImagePath.expanseRequestIcon, isCheck: AppConstants.barOptions.isEmpty? true:AppConstants.barOptions[3]=="true"? true:false, title: "Expense Request",showWidget: AppConstants.modulesmodell!.data![1].status.toString() =="1"?true:false),
    BottomBarAddContent(
        imagePath: ImagePath.timeOff, isCheck: AppConstants.barOptions.isEmpty? true:AppConstants.barOptions[4]=="true"? true:false, title: "Time Off",showWidget: AppConstants.modulesmodell!.data![4].status.toString() =="1"?true:false),
    BottomBarAddContent(
        imagePath: ImagePath.assettracking, isCheck: AppConstants.barOptions.isEmpty? true:AppConstants.barOptions[5]=="true"? true:false, title: "Asset Request",showWidget: AppConstants.modulesmodell!.data![2].status.toString() =="1"?true:false),
  ];

updateBottomBarAddContent(){
  bottomBarAddContent = [
    BottomBarAddContent(
        imagePath: ImagePath.clockIcon, isCheck:AppConstants.barOptions.isEmpty? true:AppConstants.barOptions[0]=="true"? true:false, title: "Time Tracking",showWidget: AppConstants.modulesmodell!.data![6].status.toString() =="1"?true:false),
    BottomBarAddContent(
        imagePath: ImagePath.payroll, isCheck: AppConstants.barOptions.isEmpty? true:AppConstants.barOptions[1]=="true"? true:false, title: "Payroll",showWidget: AppConstants.modulesmodell!.data![0].status.toString() =="1"?true:false),
    BottomBarAddContent(
        imagePath: ImagePath.workFromHomeIcon, isCheck: AppConstants.barOptions.isEmpty? true:AppConstants.barOptions[2]=="true"? true:false, title: "Work From Home",showWidget: AppConstants.modulesmodell!.data![8].status.toString() =="1"?true:false),
    BottomBarAddContent(
        imagePath: ImagePath.expanseRequestIcon, isCheck: AppConstants.barOptions.isEmpty? true:AppConstants.barOptions[3]=="true"? true:false, title: "Expense Request",showWidget: AppConstants.modulesmodell!.data![1].status.toString() =="1"?true:false),
    BottomBarAddContent(
        imagePath: ImagePath.timeOff, isCheck: AppConstants.barOptions.isEmpty? true:AppConstants.barOptions[4]=="true"? true:false, title: "Time Off",showWidget: AppConstants.modulesmodell!.data![4].status.toString() =="1"?true:false),
    BottomBarAddContent(
        imagePath: ImagePath.assettracking, isCheck: AppConstants.barOptions.isEmpty? true:AppConstants.barOptions[6]=="true"? true:false, title: "Asset Request",showWidget: AppConstants.modulesmodell!.data![2].status.toString() =="1"?true:false),
  ];
  notifyListeners();
}

changebottomBarAddContentActiveness(int index,bool activeness)async{
featureCount=0;
bottomBarAddContent.forEach((element) {
  if (element.isCheck) {
    featureCount++;
  }
});
if (featureCount>5 && activeness) {
  Fluttertoast.showToast(msg: "you can select only 5 features");
}else{
  SharedPreferencesHelper().setBottomBarFeature(index, activeness.toString());
  bottomBarAddContent[index].isCheck=activeness;
  notifyListeners();
}

}
}

class BottomBarAddContent {
  String imagePath, title;
  bool isCheck,showWidget;
  BottomBarAddContent({
    required this.imagePath,
    required this.isCheck,
    required this.title,
    required this.showWidget,
  });
}
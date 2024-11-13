import 'dart:io';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_exif_rotation/flutter_exif_rotation.dart';
import 'package:gleam_hr/Components/commonSnakbar.dart';
import 'package:gleam_hr/Models/DashBoardModels/PeopleModels/AllEmployeeDetailsModel.dart';
import 'package:gleam_hr/Models/DashBoardModels/AppbarModels/AllEmployeeEnrollStatusModel.dart';
import 'package:gleam_hr/Services/DashBoardServices/HomeServices/TimeTrackingServices/FaceRecognition_Service.dart';
import 'package:gleam_hr/Services/DashBoardServices/PeopleServices/GetAllEmployees_Service.dart';
import 'package:gleam_hr/Utils/AppConstants.dart';
import 'package:gleam_hr/Utils/Methods.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

class EmployeeRegisterationProvider extends ChangeNotifier{
  TextEditingController search = TextEditingController();
  bool isLoading = false;
  dynamic searchlist = [];
  final ImagePicker picker = ImagePicker();
  XFile? file;
  bool registerLoading = false;
  int loadingIndex = 0;
  hitupdate() {
    notifyListeners();
  }

  getAllEmployees(BuildContext context) async {
    try {
      if (await checkinternetconnection()) {
        isLoading = true;
        notifyListeners();
        var response =
            await GetAllEmployeesService.getAllEmployees(context: context);
        if (response != null) {
          if (response is AllEmployeesDetailsModel) {
            AppConstants.allEmployeesDetailsModel = response;
            var res=await FaceRecognitionService.allEmployeeStatus(context: context);
            if (res is AllEmployeeEnrollStatusModel) {
              AppConstants.allEmployeeEnrollStatusModel = res;
            }
            // SharedPreferences prefs = await SharedPreferences.getInstance();
            // await prefs.setString(
            //     "allempnmodel", allEmployeesDetailsModelToJson(allEmpModel));
            // AppConstants.allEmployeesDetailsModel =
            //     allEmployeesDetailsModelFromJson(
            //         prefs.getString("allempnmodel").toString());
            isLoading = false;
            notifyListeners();
          } else {
            isLoading = false;
            notifyListeners();
          }
        } else {
          isLoading = false;
          notifyListeners();
        }
      } else {
         ScaffoldMessenger.of(context).showSnackBar(
           appSnackBar("No Internet Connection"));
        notifyListeners();
      }
    } catch (exception) {
    if (AppConstants.livemode) {
          await Sentry.captureException(exception);
        }
      isLoading = false;
      notifyListeners();
    }
  }

 

  enrollFace({required String empId,required BuildContext context,required int index})async{
  try {
    loadingIndex = index;
    registerLoading = true;
    notifyListeners();
    // bool res = await FaceRecognitionService.check(context,empId);
    // if (res) {
    //   ScaffoldMessenger.of(context).showSnackBar(appSnackBar("Face Already Registered"));
    //   registerLoading = false;
    //   notifyListeners();
    // } else {
      // register face
      if (Platform.isIOS) {
        if (await Permission.camera.request().isGranted) {
          file = await picker.pickImage(source: ImageSource.camera);
        } else {
          await Permission.camera.request();
          file = await picker.pickImage(source: ImageSource.camera);
        // final imageBytes = await file!.readAsBytes();
        // await saveImageToGallery(imageBytes);
        }
      } else if (Platform.isAndroid) {
        final androidInfo = await DeviceInfoPlugin().androidInfo;
        if (androidInfo.version.sdkInt <= 32) {
        // await Permission.storage.request();
        file = await picker.pickImage(source: ImageSource.camera);
        // final imageBytes = await file!.readAsBytes();
        // await saveImageToGallery(imageBytes);
        } else {
          // await Permission.photos.request();
          file = await picker.pickImage(source: ImageSource.camera);
          // final imageBytes = await file!.readAsBytes();
          // await saveImageToGallery(imageBytes);     
        }
    //  }
      if (file != null && file != "") {
        File rotatedImage = await FlutterExifRotation.rotateAndSaveImage(path: file!.path);
        bool res = await FaceRecognitionService.register(
          accountId: empId,
            image: rotatedImage.path, context: context);
        if (res) {
          ScaffoldMessenger.of(context).showSnackBar(
           appSnackBar("Face Registered Successfully"));
          await getAllEmployees(context);
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
           appSnackBar("Face Not Registered"));
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
           appSnackBar("Please Select Image"));
      }
      registerLoading = false;
      notifyListeners();
    } 
  } catch (exception) {
    if (AppConstants.livemode) {
          await Sentry.captureException(exception);
        }
      registerLoading = false;
      notifyListeners();
    }
  }
}
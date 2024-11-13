import 'dart:io';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_exif_rotation/flutter_exif_rotation.dart';
import 'package:gleam_hr/Components/commonSnakbar.dart';
import 'package:gleam_hr/Services/DashBoardServices/HomeServices/TimeTrackingServices/FaceRecognition_Service.dart';
import 'package:gleam_hr/Utils/AppConstants.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

class TimeTrackingProvider extends ChangeNotifier {
  final ImagePicker picker = ImagePicker();
  XFile? file;
  bool allowAttandanceloading = false;

  Future<bool> faceAttandance(BuildContext context) async {
    allowAttandanceloading = true;
    notifyListeners();
    bool res = await FaceRecognitionService.check(context,AppConstants.loginmodell!.userData!.id.toString());
    if (res) {
      // face recognition
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
      }
      if (file != null && file != "") {
        File rotatedImage = await FlutterExifRotation.rotateAndSaveImage(path: file!.path);
        bool res2 = await FaceRecognitionService.recognizeface(
            image: rotatedImage.path, context: context);
        if (res2) {
          allowAttandanceloading = false;
          notifyListeners();
          return true;
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
                        appSnackBar("Face not recognized"));
          allowAttandanceloading = false;
          notifyListeners();
          return false;
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
                        appSnackBar("Please select image"));
        allowAttandanceloading = false;
        notifyListeners();
        return false;
      }
    } else {
        ScaffoldMessenger.of(context).showSnackBar(
                        appSnackBar("Your face is not registerd, Please register your face first"));
      allowAttandanceloading = false;
      notifyListeners();
      return false;
    }
  }
}
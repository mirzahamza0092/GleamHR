import 'dart:io';

import 'package:flutter/material.dart';
import 'package:gleam_hr/Components/commonSnakbar.dart';
import 'package:gleam_hr/Providers/DashBoardProviders/DashBoard_Provider.dart';
import 'package:gleam_hr/Services/DashBoardServices/MeServices/UpdateDetails_Service.dart';
import 'package:gleam_hr/Utils/AppConstants.dart';
import 'package:gleam_hr/Utils/Methods.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:local_auth/local_auth.dart';
import 'package:provider/provider.dart';
import 'package:sentry_flutter/sentry_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MeScreenProvider extends ChangeNotifier {
  TextEditingController firstname = TextEditingController();
  TextEditingController lastname = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController phone = TextEditingController();
  TextEditingController address = TextEditingController();
  TextEditingController gender = TextEditingController();
  TextEditingController dob = TextEditingController();
  TextEditingController martialStatus = TextEditingController();
  TextEditingController fatherName = TextEditingController();
  TextEditingController motherName = TextEditingController();
  GlobalKey<FormState> Mescreenkey = GlobalKey();
  bool logoutLoading = false, isloading = false, enabledBioMetric = false;
  String logoutMsg = "";
  bool logoutCheck = false,personalInfo=true;
//for getting image and then crop
  final ImagePicker _picker = ImagePicker();
  XFile? image;
  File? selectdFile;
//pick image
  pickimage({required ImageSource source}) async {
    image = await _picker.pickImage(source: source);
    if (image != null) {
      image = await _cropimage(imagefile: image!);
      selectdFile = File(image!.path);
    }
    notifyListeners();
  }

// crop image
  _cropimage({required XFile imagefile}) async {
    CroppedFile? croppedfile = await ImageCropper().cropImage(
        sourcePath: imagefile.path,
        aspectRatio: const CropAspectRatio(ratioX: 3, ratioY: 4));
    if (croppedfile == null) {
      return null;
    } else {
      return XFile(croppedfile.path);
    }
  }
//

  changelogoutLoading(bool value) {
    logoutLoading = value;
    notifyListeners();
  }

  changeDeviceBioMetricAvailability(bool val) {
    AppConstants.supportstate = val;
    notifyListeners();
  }
Future<bool> userAuthorization({required String reason}) async {
  return await AppConstants.auth.authenticate(
      localizedReason: reason,
      options: (const AuthenticationOptions(
          stickyAuth: true,
          biometricOnly: true,
          useErrorDialogs: true,
          sensitiveTransaction: false)));
}
  changeEnabledBioMetric(bool v) async {
    // Enabling bio metric
    final prefs = await SharedPreferences.getInstance();
    enabledBioMetric = v;  
    if (enabledBioMetric) {
      await prefs.setBool("enabledBioMetric", enabledBioMetric);
    } else {
      await prefs.setBool("enabledBioMetric", enabledBioMetric);
      await prefs.setBool("enabledBioMetric2", enabledBioMetric);
    }
    notifyListeners();
    debugPrint(prefs.getBool("enabledBioMetric").toString()); //errrrr
  }

  getEnabledBioMetricstatus() async {
    final prefs = await SharedPreferences.getInstance();
    if (prefs.getBool("enabledBioMetric") == null ||
        prefs.getBool("enabledBioMetric").toString() == "") {
      return false;
    } else {
      return prefs.getBool("enabledBioMetric");
    }
  }

  updateDetailsApi({required BuildContext context}) async {
    try {
      if (await checkinternetconnection()) {
        isloading = true;
        notifyListeners();
        var res;
        if (selectdFile == null) {
          res = await UpdateDetailsService.updateDetails(
              context: context,
              firstname: firstname.text,
              lastname: lastname.text,
              phone: phone.text,
              fatherName: fatherName.text,
              motherName: motherName.text,
              martialStatus: martialStatus.text,
              dob: dob.text,
              gender: gender.text,
              picture: "null");
        } else {
          res = await UpdateDetailsService.updateDetails(
              context: context,
              firstname: firstname.text,
              lastname: lastname.text,
              phone: phone.text,
              fatherName: fatherName.text,
              motherName: motherName.text,
              martialStatus: martialStatus.text,
              dob: dob.text,
              gender: gender.text,
              picture: selectdFile!.path);
        }
        
        if (res != null) {
          if (res["success"].toString() == "1") {
            selectdFile=null;
            ScaffoldMessenger.of(context).showSnackBar(
           appSnackBar(res["message"].toString()));
          isloading = false;
            notifyListeners();
            // update api call
            context.read<DashBoardProvider>().hitRefresh(
                context: context,
                employeeId: AppConstants.loginmodell!.userData!.id.toString());
          } else {
             ScaffoldMessenger.of(context).showSnackBar(
           appSnackBar(res["message"].toString()));
          
            isloading = false;
            notifyListeners();
          }
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
           appSnackBar(res["message"].toString()));
          
          isloading = false;
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
      isloading = false;
      notifyListeners();
      debugPrint(exception.toString());
    }
  }

  //change page of personalinfo and official info
  changeInfoStatus(bool newVal){
    personalInfo=newVal;
    notifyListeners();
  }
}

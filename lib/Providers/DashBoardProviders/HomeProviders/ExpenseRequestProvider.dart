import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:gleam_hr/Components/commonSnakbar.dart';
import 'package:gleam_hr/Models/DashBoardModels/AllExpenseRequestModel.dart'as allExpenseRequestsModel;
import 'package:gleam_hr/Models/DashBoardModels/HomeModels/ExpenseRequestTypesModel.dart';
import 'package:gleam_hr/Screens/DashBoard/Home/HomeWidgets/CustomDialogBox.dart';
import 'package:gleam_hr/Services/DashBoardServices/HomeServices/ExpenseServices/GetAllexpenseRequest_Service.dart';
import 'package:gleam_hr/Utils/AppConstants.dart';
import 'package:gleam_hr/Utils/AppPaths.dart';
import 'package:gleam_hr/Utils/Methods.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:sentry_flutter/sentry_flutter.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';
import 'package:file_picker/file_picker.dart';
import 'package:gleam_hr/Services/DashBoardServices/HomeServices/ExpenseServices/ExpenseRequest_Service.dart';

class ExpenseRequestProvider extends ChangeNotifier {
  PickerDateRange picker = const PickerDateRange(null, null);
  String startdateformat = "", enddateformat = "";
  bool alreadyExist = false,loading=false;
  GlobalKey<FormState> noteFormKey = GlobalKey();
  TextEditingController note = TextEditingController();
  String dateRangeValue = "Set Date Range";
  List<PlatformFile>? files;
  List<String> categoryList = [];
  List<String> imageList = [];
  String? extension;
  String? expenseTypeValue;
  String? expenseTypeId;
  String? message;
 bool expenseRequestLoading=false;
  List<allExpenseRequestsModel.Datum> searchlist = [];
  String dropdownSelectedText = "1",filteredValue="All";
  List<String> dropdownlist = [];
  List<String> items = ["All", "Approved", "Rejected", "Pending"];
  TextEditingController searchController = TextEditingController();
  late ExpenseRequestModel categoryModel;
  bool check = false;
    final ImagePicker _picker = ImagePicker();
  XFile? image;
  var fileName = "Choose File";
  String checkForDateRange = "",
      checkForExpenseAmount = "",
      checkForExpenseProof = "",
      checkForComment = "";
  TextEditingController expenseAmount = TextEditingController();
  TextEditingController commenetBox = TextEditingController();
  String selecteCategoryType = "Claim";
  List<String> categoryTypes = ["Claim", " Advance"];
 changedropdown(String val,BuildContext context) {
    dropdownSelectedText = val;
    getAllExpenseRequests(context: context);
    notifyListeners();
  }
  hitupdate() {
  notifyListeners();
  }
   changeFilterValue(String val,BuildContext context) {
    filteredValue=val;
    dropdownSelectedText="1";
    getAllExpenseRequests(context: context);
    notifyListeners();
  }

  changeCategoryTypeValue(value) {
    selecteCategoryType = value;

    notifyListeners();
  }

  changeExpenseTypeValue(name) {
    expenseTypeValue = name;
    for (int i = 0; i < categoryList.length; i++) {
      if (categoryModel.data![i].name.toString() == name) {
        expenseTypeId = categoryModel.data![i].id.toString();
        debugPrint(expenseTypeId.toString());
      }
    }
    notifyListeners();
  }

  FetchCategory(BuildContext context) async {
    try {
      if (await checkinternetconnection()) {
        var response = await ExpenseRequestServices.ExpenseRequestService();
        if (response is ExpenseRequestModel) {
          categoryModel = response;

          categoryModel.data!.forEach((element) {
            expenseTypeValue = categoryModel.data![0].name.toString();
            expenseTypeId = categoryModel.data![0].id.toString();
            categoryList.add(element.name.toString());
          });

          debugPrint("listttt $categoryList");
          ExpenseRequestModel? demologinmodel;
          demologinmodel = response;
          AppConstants.expenseRequestModel = demologinmodel;
          notifyListeners();
        } else {
          Navigator.maybePop(context);
          notifyListeners();
        }
      } else {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
           appSnackBar("No Internet Connection"));
        notifyListeners();
      }
    } catch (exception) {
    if (AppConstants.livemode) {
          await Sentry.captureException(exception);
        }
      debugPrint(exception.toString());
      notifyListeners();
    }
  }

  FetchMessage(BuildContext context) async {
    try {
      if (await checkinternetconnection()) {
        loading =true;
        notifyListeners();
        var expense = expenseAmount.text.toString();
        var comment = commenetBox.text.toString();
        var res = await ExpenseRequestServices.ExpenseRequestSend(
          dateRangeValue,
          selecteCategoryType,
          expense,
          comment,
          expenseTypeId!,
          imageList,
        );
        if (res["success"].toString() == "1") {
           checkForExpenseAmount = "";
          expenseAmount.text = '0';
          commenetBox.text = "";
          startdateformat = "";
          enddateformat = "";
          dateRangeValue = "Set Date Range";
          checkForDateRange = "";
          fileName = "Choose File";
          checkForComment = "";
          checkForComment = "";
          checkForExpenseProof="";
          imageList=[];
          Navigator.of(context).pop();
          loading = false;
          notifyListeners();
          message = res["message"].toString();
          showDialog(
              context: context,
              builder: (BuildContext context) {
                return CustomDialogBox(
                  title: '$message',
                  text: "OK",
                  img: Image.asset(ImagePath.dialogBoxImage),
                );
              });
        }else{
           checkForExpenseAmount = "";
          expenseAmount.text = '0';
          commenetBox.text = "";
          startdateformat = "";
          enddateformat = "";
          dateRangeValue = "Set Date Range";
          checkForDateRange = "";
          fileName = "Choose File";
          checkForComment = "";
          checkForComment = "";
          checkForExpenseProof="";
          imageList=[];
          Navigator.of(context).pop();
          loading = false;
          notifyListeners();
          message = "Expense Request Failed to Send";
          showDialog(
              context: context,
              builder: (BuildContext context) {
                return CustomDialogBox(
                  title: '$message',
                  text: "OK",
                  img: Image.asset(ImagePath.dialogBoxImage),
                );
              });
        }
      } else {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
           appSnackBar("No Internet Connection"));
        notifyListeners();
      }
    } catch (exception) {
    if (AppConstants.livemode) {
          await Sentry.captureException(exception);
        }
      loading = false;
      debugPrint(exception.toString());
      notifyListeners();
    }
  }
DateTime? parseApiDate(String dateString) { 
  try {
    return DateTime.parse(dateString);
  } catch (e) { 
  } 
  List<String> formats = ['dd-MM-yyyy', 'yyyy-MM-dd'];
  for (var formatString in formats) {
    try {
      final format = DateFormat(formatString);
      return format.parse(dateString);
    } catch (e) {
    }
  }  print('Failed to parse date string: $dateString');
  return null;
}
  changeDateFormat(
      DateRangePickerSelectionChangedArgs dateRangePickerSelectionChangedArgs) {
    picker = dateRangePickerSelectionChangedArgs.value;
    if (picker.startDate != null) {
      DateTime sd = picker.startDate!;
      startdateformat = DateFormat('yyyy-MM-dd').format(sd);
      debugPrint(startdateformat);
      notifyListeners();
    }
    if (picker.endDate != null) {
      DateTime ed = picker.endDate!;
      enddateformat = DateFormat('yyyy-MM-dd').format(ed);
      debugPrint(enddateformat);
      notifyListeners();
    }
    if (picker.startDate != null && picker.endDate != null) {
      DateTime sd = picker.startDate!;
      DateTime ed = picker.endDate!;
      enddateformat = DateFormat('yyyy-MM-dd').format(ed);
      startdateformat = DateFormat('yyyy-MM-dd').format(sd);
      debugPrint(enddateformat);
      debugPrint(startdateformat);
      notifyListeners();
    }
  }
String getFileExtension(String filePath) {
  // Use the path package to extract the file extension
  return filePath.split('.').last.toLowerCase();
}
  DateRangeValueSet() {
    if (enddateformat=="") {
    dateRangeValue = startdateformat;
    } else {
    dateRangeValue = '$startdateformat to $enddateformat';
    }
    notifyListeners();
  }
removeItem(int index){
  imageList.removeAt(index);
  notifyListeners();
}

  Future<void> pickFiles() async {
     files=[];
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        allowMultiple: true,
        type: FileType.custom,
        allowedExtensions: ['pdf', 'png', 'jpg', 'jpeg'],
      );

      if (result != null) {
        List<PlatformFile> validFiles = result.files
            .where((file) => ['pdf', 'png', 'jpg', 'jpeg']
                .contains(file.extension?.toLowerCase()))
            .toList();
       
        if (validFiles.isNotEmpty) {
          files = validFiles;
          fileName = "";
          for (int i = 0; i < files!.length; i++) {
            fileName += ('File ${i + 1}: ${files![i].name} ' + " ");
            if(imageList.isEmpty){
               if (files![i].extension?.toLowerCase() == 'pdf') {
                checkForExpenseProof="";
                imageList.add('${files![i].path}');
               }else{
                 XFile? croppedFile = await _cropimage(imagefile:XFile(files![i].path!));
                  checkForExpenseProof="";
                  imageList.add(croppedFile!.path);
               } 
            }
            else if(imageList!=[]){
              if (files![i].extension?.toLowerCase() == 'pdf') {
                 String name=files![i].path.toString();               
                if(imageList.contains(name)){
                  checkForExpenseProof="Already matched!";
                }else{
                   checkForExpenseProof="";
                   fileName = "";
                imageList.add('${files![i].path}');
                notifyListeners();
                }
               }else{
                String name=files![i].path.toString();               
                if(imageList.contains(name)){
                  checkForExpenseProof="Already matched!";
                }else{
                   XFile? croppedFile = await _cropimage(imagefile:XFile(files![i].path!)); 
                   checkForExpenseProof="";
                   fileName = "";
                   imageList.add(croppedFile!.path);
                notifyListeners();
                }
               }
                
            } 
            notifyListeners();
          }
          debugPrint(imageList.length.toString());
          check = true;
        } else {
          checkForExpenseProof = "Choose PDF & Image only";
          check = false;
        }
      }
    } catch (exception) {
    if (AppConstants.livemode) {
          await Sentry.captureException(exception);
        }
      debugPrint('Error picking files: $exception');
    }
    notifyListeners();
  }
  //pick image
  pickimage({required ImageSource source}) async {
    image = await _picker.pickImage(source: source);
    if (image != null) {
       image = await _cropimage(imagefile: image!);
       XFile? compressedImage = await compressImage(File(image!.path));
     imageList.add(compressedImage!.path);
     fileName="";
    }
    notifyListeners();
  }
  //crop image
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
Future<XFile?> compressImage(File imageFile) async {
    final result = await FlutterImageCompress.compressAndGetFile(
      imageFile.absolute.path,
      '${imageFile.absolute.path}_compressed.jpg',
      quality: 80, // Adjust quality as needed (0-100)
    );
    return result;
  }
  void AddExpense(BuildContext context) {
    int? ExpVAlue;
    if (expenseAmount.text != "") {
      ExpVAlue = int.parse(expenseAmount.text);
    } else {
      ExpVAlue = 0;
    }
    if (startdateformat.isEmpty && enddateformat.isEmpty ||
        expenseAmount.text.isEmpty ||
        ExpVAlue == 0 ||
        ExpVAlue < 0 ||
        fileName == "Choose File" ||
        commenetBox.text.isEmpty) {
      if (expenseAmount.text.isEmpty || ExpVAlue == 0 || ExpVAlue < 0) {
        checkForExpenseAmount = "Enter valid Expense Amount";
      } else {
        checkForExpenseAmount = "";
      }
      if (startdateformat.isEmpty && enddateformat.isEmpty) {
        checkForDateRange = "Set Date Range";
        notifyListeners();
      } else {
        checkForDateRange = "";
      }
      if (fileName == "Choose File") {
        checkForExpenseProof = "Choose PDF & Image only";
      } else {
        checkForExpenseProof = "";
      }
      if (commenetBox.text.isEmpty) {
        checkForComment = "Enter Something Here";
      } else {
        checkForComment = "";
      }

      notifyListeners();
    } else {
      var expense = expenseAmount.text.toString();
      var comment = commenetBox.text.toString();
      message = "";
      FetchMessage(context);
     
    }
    notifyListeners();
  }



  getAllExpenseRequests({required BuildContext context}) async {
    try {
      expenseRequestLoading = true;
      notifyListeners();
      if (await checkinternetconnection()) {
        var response =
            await GetAllExpenseRequestService.getAllExpenseRequests(
                userId: AppConstants.loginmodell!.userData!.id.toString(),
                status:filteredValue,
                page: dropdownSelectedText,
                context: context);
        if (response is allExpenseRequestsModel.AllExpenseRequestsModel) {
          AppConstants.allExpenseRequestsmodel = response;
          
          if (AppConstants.allExpenseRequestsmodel!.totalPages! >= 1) {
            dropdownlist=[];
          dropdownlist = List.generate(AppConstants.allExpenseRequestsmodel!.totalPages!, (index) => (index + 1).toString());
          dropdownSelectedText=AppConstants.allExpenseRequestsmodel!.currentPage.toString();
          notifyListeners();
          }
          expenseRequestLoading = false;
          notifyListeners();
        } else {
          Navigator.maybePop(context);
          expenseRequestLoading = false;
          notifyListeners();
        }
      } else {
        expenseRequestLoading = false;
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
            appSnackBar("No Internet Connection"));
        notifyListeners();
      }
    } catch (exception) {
    if (AppConstants.livemode) {
          await Sentry.captureException(exception);
        }
      expenseRequestLoading = false;
      debugPrint(exception.toString());
      notifyListeners();
    }
  }

}

import 'package:flutter/material.dart';
import 'package:gleam_hr/Models/DashBoardModels/HomeModels/AllCorrectionRequestModel.dart';
import 'package:gleam_hr/Components/commonSnakbar.dart';
import 'package:gleam_hr/Screens/DashBoard/Home/HomeWidgets/CustomDialogBox.dart';
import 'package:gleam_hr/Services/DashBoardServices/HomeServices/TimeTrackingServices/CorrectionRequestService.dart';
import 'package:gleam_hr/Services/DashBoardServices/HomeServices/TimeTrackingServices/GetAllCorrectionRequests_Service.dart';
import 'package:gleam_hr/Utils/AppConstants.dart';
import 'package:gleam_hr/Utils/AppPaths.dart';
import 'package:gleam_hr/Utils/Methods.dart';
import 'package:intl/intl.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

class CorrectionRequestProvider extends ChangeNotifier {
  bool correctionRequestLoading = false;
  List<Datum> searchlist = [];
  String dropdownSelectedText = "1",filteredValue="All";
  List<String> dropdownlist = [];
  List<String> items = ["All", "Approved", "Rejected", "Pending"];
  TextEditingController searchController = TextEditingController();
  // selectedAttendanceType
  List<String> checkinDate = [""], checkoutDate = [""];
  List<String> checkinTime = [""], checkoutTime = [""];
  List<String> eventTypes = ["break", "Scheduled Time Completed"];
  List<String> statusTypes = ["late", "none"];
  List<String> selectedText = ["break"];
  List<String> selectedStatus = ["none"];
  int count = 1;
  bool showerror = false,dateTimeValidationCheck=false, enabledSendButton = false;
  List<String> dateParts = [];
  List<String> timeParts = [];
  List<String> errorString = [""];
  
  addcount() {
    count++;
    checkinDate.add("");
    checkoutDate.add("");
    checkinTime.add("");
    checkoutTime.add("");
    errorString.add("");
    selectedText.add("break");
    selectedStatus.add("none");
    showerror = false;
    notifyListeners();
  }

  removeCount() {
    count--;
    checkinDate.removeLast();
    checkoutDate.removeLast();
    checkinTime.removeLast();
    checkoutTime.removeLast();
    errorString.removeLast();
    selectedText.removeLast();
    selectedStatus.removeLast();
    showerror = false;
    notifyListeners();
  }

  changeDropDownValue(String value, int index) {
    selectedText[index] = value;
    enabledSendButton=false;
    selectedText.forEach((element) {
      if (element == "Scheduled Time Completed") {
        enabledSendButton=true;
      }
    });
    notifyListeners();
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
  changeDropDownValuestatus(String value, int index) {
    selectedStatus[index] = value;
    notifyListeners();
  }

  changecheckindate(String newdate, int index) {
    checkinDate[index] = newdate;
    notifyListeners();
  }

  changecheckoutdate(String newdate, int index) {
    checkoutDate[index] = newdate;
    notifyListeners();
  }

  changecheckintime(String newtime, int index) {
    checkinTime[index] = newtime;
    notifyListeners();
  }

  changecheckouttime(String newtime, int index) {
    checkoutTime[index] = newtime;
    notifyListeners();
  }

  clear() {
    checkinDate = [""];
    checkoutDate = [""];
    checkinTime = [""];
    checkoutTime = [""];
    errorString = [""];
    eventTypes = ["break", "Scheduled Time Completed"];
    statusTypes = ["late", "none"];
    selectedText = ["break"];
    selectedStatus = ["none"];
    count = 1;
    showerror = false;
    enabledSendButton=false;
    notifyListeners();
  }

  correctionRequest(BuildContext context) async {
    try {
      Map<String, dynamic> timeindate = {};
      Map<String, dynamic> timein = {};
      Map<String, dynamic> timeoutDate = {};
      Map<String, dynamic> timeout = {};
      Map<String, dynamic> timeinStatus = {};
      Map<String, dynamic> attandancestatus = {};
      Map<String, dynamic> reasonforLeaving = {};
      Map<String, dynamic> takenabreak = {};

      for (var i = 0; i < count; i++) {
        timeindate[i.toString()] = convertDate(checkinDate[i].toString());
        timein[i.toString()] = convertTime(checkinTime[i].toString());
        timeoutDate[i.toString()] = convertDate(checkoutDate[i].toString());
        timeout[i.toString()] = convertTime(checkoutTime[i].toString());
        timeinStatus[i.toString()] = selectedStatus[i].toString();
        attandancestatus[i.toString()] = "Present";
        reasonforLeaving[i.toString()] = selectedText[i].toString();
        takenabreak[i.toString()] = selectedText[i].toString();
      }
      if (await checkinternetconnection()) {
        correctionRequestLoading=true;
        notifyListeners();
        var res = await CorrectionRequestService.storeCorrectionRequest(
            context: context,
            userid: AppConstants.loginmodell!.userData!.id.toString(),
            firstCheckinDate: checkinDate[0].toString(),
            totalEnteries: count.toString(),
            timeInDate: timeindate,
            timeIn: timein,
            timeOutDate: timeoutDate,
            timeOut: timeout,
            timeInStatus: timeinStatus,
            attandanceStatus: attandancestatus,
            reasonForLeaving: reasonforLeaving,
            takenaBreak: takenabreak);
        Navigator.of(context).pop();
        if (res != null) {
          showDialog(
              context: context,
              builder: (BuildContext context) {
                return CustomDialogBox(
                  title: res.toString(),
                  text: "OK",
                  img: Image.asset(ImagePath.dialogBoxImage),
                );
              });
          notifyListeners();
        }
        correctionRequestLoading=false;
        clear();
      } else {
        Navigator.of(context).pop();
       ScaffoldMessenger.of(context).showSnackBar(
           appSnackBar("No Internet Connection"));
        
        notifyListeners();
      }
    } catch (exception) {
    if (AppConstants.livemode) {
          await Sentry.captureException(exception);
        }
      debugPrint(exception.toString());
    }
  }

  convertTime(String input) {
    timeParts = input.split(RegExp(r'[:\s]'));
    int hour = int.parse(timeParts[0]);
    int minute = int.parse(timeParts[1]);
    if (input.toLowerCase().contains("pm")) {
      hour += 12;
    }
    return '${hour.toString().padLeft(2, '0')}:${minute.toString().padLeft(2, '0')}';
  }

  convertDate(String input) {
    dateParts = input.split("-");
    return "${dateParts[2]}-${dateParts[1]}-${dateParts[0]}";
  }

  showError() {
    showerror=false;
    dateTimeValidationCheck=false;
    errorString=[];
    for (var i = 0; i < count; i++) {
      if (checkinDate[i].toString() == "" ||
          checkoutDate[i].toString() == "" ||
          checkinTime[i].toString() == "" ||
          checkoutTime[i].toString() == "") {
        debugPrint("go$i");
        showerror = true;
      }
      if (!showerror) {
        bool status =validateDateTime(checkinDate[i], checkinTime[i], checkoutDate[i], checkoutTime[i]);
        if (status) {
          dateTimeValidationCheck=status;
          errorString.add("error");
        }else{
          errorString.add("");
        }
      }else{
        errorString.add("");
      }
        
    }
    notifyListeners();
  }

  setDate(String id) {
    checkinDate[0] = id;
    checkoutDate[0] = id;
    notifyListeners();
  }

  getAllCorrectionRequests({required BuildContext context}) async {
    try {
      correctionRequestLoading = true;
      notifyListeners();
      if (await checkinternetconnection()) {
        var response =
            await GetAllCorrectionRequestService.getAllCorrectionRequests(
                userId: AppConstants.loginmodell!.userData!.id.toString(),
                status:filteredValue,
                page: dropdownSelectedText,
                context: context);
        if (response is AllCorrectionRequestsModel) {
          AppConstants.allCorrectionRequestsmodel = response;
          
          if (AppConstants.allCorrectionRequestsmodel!.totalPages! >= 1) {
            dropdownlist=[];
          dropdownlist = List.generate(AppConstants.allCorrectionRequestsmodel!.totalPages!, (index) => (index + 1).toString());
          dropdownSelectedText=AppConstants.allCorrectionRequestsmodel!.currentPage.toString();
          notifyListeners();
          }
          correctionRequestLoading = false;
          notifyListeners();
        } else {
          Navigator.maybePop(context);
          correctionRequestLoading = false;
          notifyListeners();
        }
      } else {
        correctionRequestLoading = false;
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
            appSnackBar("No Internet Connection"));
        notifyListeners();
      }
    } catch (exception) {
    if (AppConstants.livemode) {
          await Sentry.captureException(exception);
        }
      correctionRequestLoading = false;
      debugPrint(exception.toString());
      notifyListeners();
    }
  }

  search() {}

  changedropdown(String val,BuildContext context) {
    dropdownSelectedText = val;
    getAllCorrectionRequests(context: context);
    notifyListeners();
  }

  changeFilterValue(String val,BuildContext context) {
    filteredValue=val;
    dropdownSelectedText="1";
    getAllCorrectionRequests(context: context);
    notifyListeners();
  }

  hitupdate() {
    notifyListeners();
  }


  DateTime parseTime(String dateString, String timeString) {
    List<String> timeParts = timeString.split(' ');
    List<String> hourMinute = timeParts[0].split(':');
    int hour = int.parse(hourMinute[0]);
    int minute = int.parse(hourMinute[1]);
    if (timeParts[1] == 'PM' && hour != 12) {
      hour += 12;
    }
    return DateTime.parse('$dateString ${hour.toString().padLeft(2, '0')}:${minute.toString().padLeft(2, '0')}:00');
  }

  validateDateTime(String checkinDate, String checkinTime,String checkoutDate, String checkoutTime) {
  DateTime checkinDateTime = parseTime(checkinDate, checkinTime);
  DateTime checkoutDateTime = parseTime(checkoutDate, checkoutTime);
  if (checkinDateTime.isBefore(checkoutDateTime)) {
    return false;
    } else {
    return true;
    }
  }
}
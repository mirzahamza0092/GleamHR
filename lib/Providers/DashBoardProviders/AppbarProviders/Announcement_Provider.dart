import 'package:flutter/material.dart';
import 'package:gleam_hr/Components/commonSnakbar.dart';
import 'package:gleam_hr/Services/AppBarServices/ReadSpecificNotification_Service.dart';
import 'package:gleam_hr/Utils/AppConstants.dart';
import 'package:gleam_hr/Utils/Methods.dart';
import 'package:sentry_flutter/sentry_flutter.dart';
import '../../../Models/DashBoardModels/AppbarModels/AllAnnouncementsModel.dart';
import '../../../Services/AppBarServices/GetAllAnnouncement_Service.dart';

class AnnouncementProvider extends ChangeNotifier {
  bool isLoading = false, hasmore = true, readAllLoading = false;
  dynamic searchlist = [];
  ScrollController scrollController = ScrollController();
  int pageval = 0, index = 0, paggingPageNumber = 1;
  int type = 0; //0 is normal 1 is search and
  int page = 1;
  String? filteredValue;
  List<Datum> allnotificationdata = [];
  List<String> items = [
    'All',
    'Inbox',
    'Time Off Request',
    'Attendance Request',
    'Profile Updated',
    'Work From Home Request',
    'Correction Request Decision',
    'Role Assigned',
  ];
  TextEditingController comment = TextEditingController();
  TextEditingController search = TextEditingController();
  final GlobalKey<RefreshIndicatorState> refreshInboxIndicatorKey =
      GlobalKey<RefreshIndicatorState>();
  hitupdate() {
    notifyListeners();
  }
  pageIncrement(){
    page++;
    notifyListeners();
  }
  resetpage(){
    page=1;
    notifyListeners();
  }

  getAllAnnouncments(BuildContext context,bool pageincrement) async {
    try {
      if (await checkinternetconnection()) {
        isLoading = true;
        notifyListeners();
        var response = await AnnouncementService.getAllAnnouncements(
          page: page.toString(),
          context: context,
        );
        if (response != null) {
          if (response is AnnouncementModel) {
            //here
          if (page<=1) {
            AppConstants.announcementModel = response;
          }else{
            AppConstants.announcementModel!.data!.addAll(response.data!);
          }
          pageIncrement();
          allnotificationdata = [];
            for (var element in AppConstants.announcementModel!.data!) {
              allnotificationdata.add(element);
            }
            debugPrint(
                "allnotificationDetailsdata${allnotificationdata.length}");
            // AppConstants.allnotificationDetailsModel!.notifications!.data
            //     !.addAll(allEmpModel.notifications!.data!);
            // for (int i = 0; i < allEmpModel.notifications!.data!.length; i++) {
            //   debugPrint("heyyy");
            //   AppConstants.allnotificationDetailsModel!.notifications!.data!
            //       .add(allEmpModel.notifications!.data![index]);
            // }

            //SharedPreferences prefs = await SharedPreferences.getInstance();
            // await prefs.setString(
            //     "allnotifmodel",
            //     allNotificationsModelToJson(
            //         AppConstants.allnotificationDetailsModel!)).toString();
            // AppConstants.allnotificationDetailsModel =
            //     allNotificationsModelFromJson(
            //         prefs.getString("allnotifmodel").toString());
            isLoading = false;
            notifyListeners();
          } else {
            //page = 1;
            isLoading = false;
            notifyListeners();
          }
        } else {
          hasmore = false;
          isLoading = true;
          notifyListeners();
        }
      } else {
        ScaffoldMessenger.of(context)
            .showSnackBar(appSnackBar("No Internet Connection"));
        notifyListeners();
      }
    } catch (exception) {
      if (AppConstants.livemode) {
        await Sentry.captureException(exception);
      }
      debugPrint(exception.toString());
      isLoading = true;
      notifyListeners();
    }
  }

  readSpecificNotification(
      {required BuildContext context, required String notificationId}) async {
    try {
      if (await checkinternetconnection()) {
        // isLoading=true;
        // notifyListeners();
        var response = await ReadSpecificNotificationService.readNotification(
            context: context,
            userId: AppConstants.loginmodell!.userData!.id.toString(),
            notificationId: notificationId);
        if (response == true) {
          debugPrint("Notificationread");
          // isLoading=false;
          // notifyListeners();
        } else {
          // isLoading=true;
          // notifyListeners();
        }
      } else {
        ScaffoldMessenger.of(context)
            .showSnackBar(appSnackBar("No Internet Connection"));
        notifyListeners();
      }
    } catch (exception) {
      if (AppConstants.livemode) {
        await Sentry.captureException(exception);
      }
      debugPrint(exception.toString());
      // isLoading=true;
      // notifyListeners();
    }
  }

  void Filter(String val) {
    debugPrint("valuuuuuu-$val");
    filteredValue = val;
    notifyListeners();
  }

  List<bool> _isChecked = List.generate(8, (index) => false);
  List<bool> get isChecked => _isChecked;

  void setChecked(bool newValue, int index) {
    if (index == 0) {
      _isChecked = List.generate(_isChecked.length, (index) => newValue);
    } else {
      _isChecked[index] = newValue;
    }

    notifyListeners();
  }
}

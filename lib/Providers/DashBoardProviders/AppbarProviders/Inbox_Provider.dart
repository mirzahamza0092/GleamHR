import 'package:flutter/material.dart';
import 'package:gleam_hr/Components/commonSnakbar.dart';
import 'package:gleam_hr/Models/DashBoardModels/AppbarModels/AllNotificationsModel.dart';
import 'package:gleam_hr/Screens/DashBoard/Home/HomeWidgets/CustomDialogBox.dart';
import 'package:gleam_hr/Services/ApprovalRequestDecision_Service.dart';
import 'package:gleam_hr/Services/AppBarServices/GetAllNotification_Service.dart';
import 'package:gleam_hr/Services/AppBarServices/ReadAllNotification_Service.dart';
import 'package:gleam_hr/Services/AppBarServices/ReadSpecificNotification_Service.dart';
import 'package:gleam_hr/Utils/AppConstants.dart';
import 'package:gleam_hr/Utils/AppPaths.dart';
import 'package:gleam_hr/Utils/Methods.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

class InboxProvider extends ChangeNotifier {
  bool isLoading = false, hasmore = true,requestIsLoading = false, readAllLoading = false;
  dynamic searchlist = [];
  ScrollController scrollController = ScrollController();
  int pageval = 0, index = 0, paggingPageNumber = 1;
  int type = 0; //0 is normal 1 is search and
  int page = 1;
  String? filteredValue;
  bool readAllCheck=false;
  List<Datum> allnotificationDetailsdata = [];
  List<String> items = [
    'All',
    'Emergency Announcement',
    'Policy Update Annoncement',
    'Celebration Announcement',
    'Standard Announcement',
    'Welcome Announcement',
    'Holiday Announcement',
    'Training  Announcement'
  ];
  TextEditingController comment = TextEditingController();
  TextEditingController search = TextEditingController();
  final GlobalKey<RefreshIndicatorState> refreshInboxIndicatorKey =
      GlobalKey<RefreshIndicatorState>();
  hitupdate() {
    notifyListeners();
  }

  // changepage(int newval, int index, int newtype) {
  //   pageval = newval;
  //   this.index = index;
  //   type = newtype;
  //   notifyListeners();
  // }

  // changePaggeingNumber(int newval) {
  //   paggingPageNumber = newval;
  //   notifyListeners();
  // }

  getAllNotifications(BuildContext context) async {
    try {
      if (await checkinternetconnection()) {
        isLoading = true;
        notifyListeners();
        var response = await GetAllNotificationService.getAllNotifications(
            page: page.toString(),
            context: context,
            userid: AppConstants.loginmodell!.userData!.id.toString());
        if (response != null) {

          if (response is AllNotificationsModel) {
            AllNotificationsModel? allEmpModel;
            allEmpModel = response;
            //here
            AppConstants.allnotificationDetailsModel = allEmpModel;

            for (var element in allEmpModel.notifications!.data!) {
              allnotificationDetailsdata.add(element);
              if(element.readAt==null){
                readAllCheck=true;
                notifyListeners();
              }
            }
            debugPrint(
                "allnotificationDetailsdata${allnotificationDetailsdata.length}");
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
            page++;
            isLoading = false;
            notifyListeners();
            // dosort=false;
            // notifyListeners();
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
          readAllCheck=false;
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

  readAllNotification({
    required BuildContext context,
  }) async {
    try {
      if (await checkinternetconnection()) {
         readAllLoading=true;
         notifyListeners();
        var response = await ReadAllNotificationService.readAllNotification(
          context: context,
          userId: AppConstants.loginmodell!.userData!.id.toString(),
        );
        if (response == true) {
          refreshInboxIndicatorKey.currentState?.show();
          debugPrint("ALLNotificationread");
          readAllLoading=false;
          readAllCheck=false;
          notifyListeners();
        } else {
          readAllLoading=true;
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
      readAllLoading=true;
      notifyListeners();
    }
  }

  void Filter(String val) {
    debugPrint("valuuuuuu-$val");
    filteredValue = val;
    notifyListeners();
  }

  //List<bool> _isChecked;

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

  reqestDecision(
      {required BuildContext context,
      required String decision,
      required String notifiableId,
      required String notificationId,
      required String comment,
      required dynamic notifyObject}) async {
    try {
      requestIsLoading =true;
      notifyListeners();
      if (await checkinternetconnection()) {
        var response = await ApprovalRequestDecisionService.approveDecision(
            context: context,
            userId: AppConstants.loginmodell!.userData!.id.toString(),
            decision: decision,
            notifiableId: notifiableId,
            notificationId: notificationId,
            comment: comment,
            notifyObject: notifyObject);
        Navigator.of(context).pop();
        this.comment.clear();
        if (response.toString() != "null") {
          showDialog(
              context: context,
              builder: (BuildContext context) {
                return CustomDialogBox(
                  title: response.toString(),
                  text: "OK",
                  img: Image.asset(ImagePath.dialogBoxImage),
                );
              });
        } else {
          showDialog(
              context: context,
              builder: (BuildContext context) {
                return Center(
                  child: CustomDialogBox(
                    title: "Decision Failed",
                    text: "OK",
                    img: Image.asset(ImagePath.dialogBoxImage),
                  ),
                );
              });
        }
      }
      requestIsLoading =false;
      notifyListeners();
    } catch (exception) {
    if (AppConstants.livemode) {
          await Sentry.captureException(exception);
        }
      notifyListeners();
      debugPrint(exception.toString());
    }
  }
}

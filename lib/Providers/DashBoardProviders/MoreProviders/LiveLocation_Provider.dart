import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:gleam_hr/Components/commonSnakbar.dart';
import 'package:gleam_hr/Models/DashBoardModels/MoreModels/GetLocationTrackingEnabledEmployeesModel.dart';
import 'package:gleam_hr/Services/DashBoardServices/MoreServices/GetLocationTrackingEnabledEmployees_Service.dart';
import 'package:gleam_hr/Utils/AppConstants.dart';
import 'package:gleam_hr/Utils/Methods.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

class LiveLocationProvider extends ChangeNotifier {
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  bool isLoading = false;
  int page = 1;
  List<String> emplat=[],emplng=[];

  getEmployeeTodaysLocation(String empid){
  emplat=[];
  emplng=[];
  DateTime now = DateTime.now();
  DateTime startOfDay = DateTime(now.year, now.month, now.day, 0, 0, 0); // Start of today
  DateTime endOfDay = DateTime(now.year, now.month, now.day, 23, 59, 59); // End of today
    firestore.collection("Users").where("user_id",isEqualTo: empid ).where("timestamp", isGreaterThanOrEqualTo: Timestamp.fromDate(startOfDay))
    .where("timestamp", isLessThanOrEqualTo: Timestamp.fromDate(endOfDay)).get().then((value) {
      if(value.docs.isNotEmpty){
        value.docs.forEach((element) {
          debugPrint("latitude${element["latitude"]}");
          debugPrint("longitude${element["longitude"]}");
        });
      }
    });
  }

  getAllTrackedEmployee(BuildContext context) async {
    try {
      if (await checkinternetconnection()) {
        isLoading = true;
        notifyListeners();
        var response =
            await GetLocationTrackingEnabledEmployeesService.getEmployees(
                page: page.toString(), context: context);
        if (response != null) {
          if (response is GetLocationTrackingEnabledEmployeesModel) {
            if (page <= 1) {
              AppConstants.allTrackedEmployee = response;
            } else {
              AppConstants.allTrackedEmployee!.data!.data!
                  .addAll(response.data!.data!);
            }
            pageIncrement();
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
        ScaffoldMessenger.of(context)
            .showSnackBar(appSnackBar("No Internet Connection"));
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

  pageIncrement() {
    page++;
    notifyListeners();
  }

  resetpage() {
    page = 1;
    notifyListeners();
  }
}

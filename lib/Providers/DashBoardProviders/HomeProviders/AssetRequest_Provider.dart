import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:gleam_hr/Components/commonSnakbar.dart';
import 'package:gleam_hr/Models/DashBoardModels/HomeModels/AssetRequestModel.dart' as assetRequestModel;
import 'package:gleam_hr/Models/DashBoardModels/HomeModels/AssetTypeModel.dart';
import 'package:gleam_hr/Services/DashBoardServices/HomeServices/AssetServices/GetAssetTypes_Service.dart';
import 'package:gleam_hr/Utils/AppConstants.dart';
import 'package:gleam_hr/Utils/Colors.dart';
import 'package:gleam_hr/Utils/Methods.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

class AssetRequestProvider extends ChangeNotifier {
  bool isloading = false,assetRequestLoading=false,decisionLoading=false;
  String dropdownSelectedText = "1",filteredValue="All";
  String dropdownAllSelectedText = "1",filteredAllValue="All";
  TextEditingController searchController=TextEditingController();
  TextEditingController searchallController=TextEditingController();
  String? selectedAsset;
  List<assetRequestModel.Datum> searchlist=[];
  List<String> dropdownlist = [];
  GlobalKey<FormState> formkey = GlobalKey();
  List<String> items = ["All", "Approved", "Rejected", "Pending"];
  List<String> allitems = ["All", "Approved", "Rejected", "Pending"];
  TextEditingController assetMessage = TextEditingController();
  List<String> assetTypes = [];

  changeAssetType(String value) {
    selectedAsset = value;
    notifyListeners();
  }

  // view my requests
  changedropdown(String val,BuildContext context) {
    dropdownSelectedText = val;
    assetRequests(context: context);
    notifyListeners();
  }

  changeFilterValue(String val,BuildContext context) {
    filteredValue=val;
    dropdownSelectedText="1";
    assetRequests(context: context);
    notifyListeners();
  }

  requestAsset({required BuildContext context,required String message,required String assetId}) async {
    try {
      if (formkey.currentState!.validate()) {
        if (await checkinternetconnection()) {
          isloading = true;
          notifyListeners();

          var response = await AssetRequestService.storeAssetRequest(
              assetId: assetId,
              message: message,
              empId: AppConstants.loginmodell!.userData!.id.toString(),
              context: context);

          if (response) {
            ScaffoldMessenger.of(context)
                .showSnackBar(appSnackBar("Asset request is added successfully"));
          } else {
            ScaffoldMessenger.of(context)
                .showSnackBar(appSnackBar("Failed to add asset request"));
          }
          Navigator.of(context).maybePop();
          isloading = false;
          notifyListeners();
        } else {
          ScaffoldMessenger.of(context)
              .showSnackBar(appSnackBar("No Internet Connection"));
        }
      }
    } catch (exception) {
      Navigator.of(context).maybePop();
      isloading = false;
      notifyListeners();
      if (AppConstants.livemode) {
        await Sentry.captureException(exception);
      }
    }
  }

  getAssetTypes({required BuildContext context}) async {
    try {
      if (await checkinternetconnection()) {
        assetMessage.clear();
        var response =
            await AssetRequestService.getAssetTypesService(context: context);
        if (response != null) {
          if (response is AssetTypesModel) {
            assetTypes = [];
            AppConstants.assetTypes = response;
            selectedAsset = response.data![0].name.toString();
            response.data!.forEach((element) {
              assetTypes.add(element.name.toString());
            });
          } else {
            Navigator.of(context).maybePop();
          }
        }
      } else {
        ScaffoldMessenger.of(context)
            .showSnackBar(appSnackBar("No Internet Connection"));
      }
    } catch (exception) {
      Navigator.of(context).maybePop();
      if (AppConstants.livemode) {
        await Sentry.captureException(exception);
      }
    }
  }

  assetRequests({required BuildContext context}) async {
    try {
      assetRequestLoading = true;
      notifyListeners();
      if (await checkinternetconnection()) {
        var response =
            await AssetRequestService.getAssetRequest(userId: AppConstants.loginmodell!.userData!.id.toString(), status: filteredValue, page: dropdownSelectedText, context: context);
        if (response is assetRequestModel.AssetRequestModel) {
          AppConstants.assetRequestsmodel = response;
          dropdownlist=[];
          if (AppConstants.assetRequestsmodel!.totalPages! >= 1) {
          dropdownlist = List.generate(AppConstants.assetRequestsmodel!.totalPages!, (index) => (index + 1).toString());
          }
          assetRequestLoading = false;
          notifyListeners();
        } else {
          Navigator.maybePop(context);
          assetRequestLoading = false;
          notifyListeners();
        }
      } else {
        assetRequestLoading = false;
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
            appSnackBar("No Internet Connection"));
        notifyListeners();
      }
    } catch (exception) {
    if (AppConstants.livemode) {
          await Sentry.captureException(exception);
        }
      assetRequestLoading = false;
      debugPrint(exception.toString());
      notifyListeners();
    }
  }

  // view all requests
  changealldropdown(String val,BuildContext context) {
    dropdownAllSelectedText = val;
    getAllAssetRequests(context: context);
    notifyListeners();
  }

  changeallFilterValue(String val,BuildContext context) {
    filteredAllValue=val;
    dropdownAllSelectedText="1";
    getAllAssetRequests(context: context);
    notifyListeners();
  }
  getAllAssetRequests({required BuildContext context}) async {
    try {
      assetRequestLoading = true;
      notifyListeners();
      if (await checkinternetconnection()) {
        var response = await AssetRequestService.getAllAssetRequest(status: filteredAllValue, page: dropdownAllSelectedText, context: context);
        if (response is assetRequestModel.AssetRequestModel) {
          AppConstants.assetRequestsmodel = response;
          dropdownlist=[];
          if (AppConstants.assetRequestsmodel!.totalPages! > 1) {
          dropdownlist = List.generate(AppConstants.assetRequestsmodel!.totalPages!, (index) => (index + 1).toString());
          }
          assetRequestLoading = false;
          notifyListeners();
        } else {
          Navigator.maybePop(context);
          assetRequestLoading = false;
          notifyListeners();
        }
      } else {
        assetRequestLoading = false;
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
            appSnackBar("No Internet Connection"));
        notifyListeners();
      }
    } catch (exception) {
    if (AppConstants.livemode) {
          await Sentry.captureException(exception);
        }
      assetRequestLoading = false;
      debugPrint(exception.toString());
      notifyListeners();
    }
  }

approveDenyAssetRequest({required BuildContext context,required String decision,required String requestId,required String employeeId,required String assetTypeId}) async {
    try {
      if (await checkinternetconnection()) {
        decisionLoading=true;
        notifyListeners();
        var response =
            await AssetRequestService.approveDenyAssetRequests(context: context, id: requestId, employeeId: employeeId, assetTypeId: assetTypeId, decision: decision);
        if (response == true) {
          decisionLoading=false;
          Navigator.of(context).pop();
          Fluttertoast.showToast(
            msg: "Asset request decision is updated successfully",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: AppColors.primaryColor,
            textColor: Colors.white,
            fontSize: 16.0);
          getAllAssetRequests(context: context);
        } else {
          decisionLoading=false;
          Navigator.of(context).pop();
          Fluttertoast.showToast(
            msg: "Asset request decision failed to update",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: AppColors.primaryColor,
            textColor: Colors.white,
            fontSize: 16.0);
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
      decisionLoading=false;
      notifyListeners();
    }
  }

hitupdate(){
  notifyListeners();
}
}

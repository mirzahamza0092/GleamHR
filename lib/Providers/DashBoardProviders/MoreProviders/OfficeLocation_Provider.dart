import 'package:gleam_hr/Models/DashBoardModels/MoreModels/AllOfficeModel.dart';
import 'package:flutter/material.dart';
import 'package:gleam_hr/Components/commonSnakbar.dart';
import 'package:gleam_hr/Services/DashBoardServices/MoreServices/GetAllOfficeLocations_Service.dart';
import 'package:gleam_hr/Services/DashBoardServices/MoreServices/UpdateOfficeLocationService.dart';
import 'package:gleam_hr/Utils/AppConstants.dart';
import 'package:gleam_hr/Utils/Methods.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geocoding/geocoding.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

class OfficeLocationProvider extends ChangeNotifier {
  LatLng? location;
  int page = 1;
  double sliderRadius = 80;
  GlobalKey<FormState> setLocationKey = GlobalKey();
  TextEditingController street = TextEditingController();
  TextEditingController country = TextEditingController();
  TextEditingController state = TextEditingController();
  TextEditingController city = TextEditingController();
  TextEditingController locationName = TextEditingController();
  TextEditingController phoneNumber = TextEditingController();
  TextEditingController zipcode = TextEditingController();
  String? lat, lng;
  bool isLoading = false,updateLoading=false;
  dynamic searchlist = [];

  hitupdate() {
    notifyListeners();
  }

  resetpage() {
    page = 1;
    notifyListeners();
  }

  pageIncrement() {
    page++;
    notifyListeners();
  }

  getAllOffices(BuildContext context) async {
    try {
      if (await checkinternetconnection()) {
        isLoading = true;
        notifyListeners();
        var response = await GetAllOfficeLocationsService.getAlloffice(
            page: page.toString(), context: context);
        if (response != null) {
          if (response is AllOfficeLocationModel) {
            if (page <= 1) {
              AppConstants.allOfficeLocationModel = response;
            } else {
              AppConstants.allOfficeLocationModel!.data!.data!
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


  getCurrentLocation(LatLng newLocation) {
    location = newLocation;
    notifyListeners();
    getLocationDetails(newLocation.latitude, newLocation.longitude);
  }
//maps functions
  updateMarker(LatLng newLocation) {
    location = newLocation;
    notifyListeners();
    getLocationDetails(newLocation.latitude, newLocation.longitude);
  }

  Future<void> getLocationDetails(double latitude, double longitude) async {
    try {
      lat = latitude.toString();
      lng = longitude.toString();
      List<Placemark> placemarks =
          await placemarkFromCoordinates(latitude, longitude);
      if (placemarks != null && placemarks.isNotEmpty) {
        Placemark placemark = placemarks[0];
        street.text = placemark.street!;
        country.text = placemark.country!;
        state.text = placemark.administrativeArea!;
        city.text = placemark.subAdministrativeArea!;
        // zipcode.text = placemark.postalCode!;
        // locationName.text = placemark.name!;
      } else {
        debugPrint('No location details found');
      }
    } catch (e) {
      debugPrint('Error getting location details: $e');
    }
  }

  updateSlider(double value) {
    sliderRadius = value;
    notifyListeners();
  }

initialize(Datum mapData,bool removeLoc) {
    locationName.text = mapData.name.toString()=="null"?"":mapData.name.toString();
    sliderRadius = mapData.geoRadius.toString()=="null"?0:double.parse(mapData.geoRadius.toString());
    phoneNumber.text = mapData.phoneNumber.toString()=="null"?"":mapData.phoneNumber.toString();
    state.text = mapData.state.toString()=="null"?"":mapData.state.toString();
    country.text = mapData.country.toString()=="null"?"":mapData.country.toString();
    city.text = mapData.city.toString()=="null"?"":mapData.city.toString();
    street.text = mapData.street1.toString()=="null"?"":mapData.street1.toString();
    street.text = mapData.zipCode.toString()=="null"?"":mapData.zipCode.toString();
    location = LatLng(double.parse(mapData.latitude.toString()),double.parse(mapData.longitude.toString()));
    if(removeLoc){
    //   location=null;
      notifyListeners();
    }
  }
  reset() {
    notifyListeners();
  }
  updateLocation({required BuildContext context,required String locId}) async{
      try {
      if (await checkinternetconnection()) {
        if (setLocationKey.currentState!.validate()) { {
        updateLoading=true;
        notifyListeners();
        var response=await UpdateLocationDetailsService.updateLocDetails(context: context, name: locationName.text, city: city.text, state: state.text, street: street.text, id: locId, postalcode: zipcode.text, country: country.text, lat: location!.latitude.toString(), lng: location!.longitude.toString(), phoneNumber: phoneNumber.text, radius: sliderRadius.toString());
        if (response == true) {
          Navigator.of(context).pop();
          updateLoading=false;
          notifyListeners();
          ScaffoldMessenger.of(context)
            .showSnackBar(appSnackBar("Location updated successfully"));
          resetpage();
          getAllOffices(context);
        } else {
        ScaffoldMessenger.of(context)
            .showSnackBar(appSnackBar("Location failed to update"));
          updateLoading=false;
          notifyListeners();
        }  
        }}
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
      updateLoading=false;
      notifyListeners();
    }  
  }
}

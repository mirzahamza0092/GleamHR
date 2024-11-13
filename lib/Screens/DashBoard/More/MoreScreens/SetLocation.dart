// ignore_for_file: prefer_collection_literals

import 'package:flutter/material.dart';
import 'package:gleam_hr/Components/CommonButton.dart';
import 'package:gleam_hr/Components/CommonText.dart';
import 'package:gleam_hr/Components/CommonTextField.dart';
import 'package:gleam_hr/Providers/DashBoardProviders/MoreProviders/OfficeLocation_Provider.dart';
import 'package:gleam_hr/Utils/Colors.dart';
import 'package:gleam_hr/Utils/SizedBox.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:gleam_hr/Models/DashBoardModels/MoreModels/AllOfficeModel.dart';

class SetLocation extends StatefulWidget {
  Datum mapData;
  SetLocation({required this.mapData, super.key});

  @override
  State<SetLocation> createState() => _SetLocationState();
}

class _SetLocationState extends State<SetLocation> {
  @override
  void initState() {
        WidgetsBinding.instance.addPostFrameCallback((_) {
      final officeLocationProvider =
          Provider.of<OfficeLocationProvider>(context, listen: false);
          officeLocationProvider.initialize(widget.mapData,false);
          });
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(body: Consumer<OfficeLocationProvider>(
      builder: (context, officeLocationProvider, child) {
        return SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: height(context)/2,
                child: GoogleMap(
                  onTap: (argument) {
                    officeLocationProvider.updateMarker(argument);
                  },
                  onCameraMove: (position) {},
                  circles: Set.from([
                    officeLocationProvider.location == null
                        ?const Circle(circleId: CircleId("")):Circle(
                            circleId:const CircleId('2'),
                            center: LatLng(
                                double.parse(officeLocationProvider.location!.latitude.toString()),
                                double.parse(officeLocationProvider.location!.longitude.toString())),
                            radius: officeLocationProvider.sliderRadius,
                            strokeWidth: 1,
                            strokeColor: AppColors.primaryColor,
                          ),
                         widget.mapData.geoRadius.toString()=="null"?
                         const Circle(circleId: CircleId("3")):
                         Circle(
                            circleId:const CircleId('1'),
                            center: LatLng(
                                double.parse(widget.mapData.latitude.toString()),
                                double.parse(widget.mapData.longitude.toString())),
                            radius: double.parse(widget.mapData.geoRadius.toString()),
                            strokeWidth: 1,
                            strokeColor: AppColors.primaryColor,
                          )
                  ]),
                  markers: Set<Marker>.of([
                    officeLocationProvider.location == null
                        ?const Marker(markerId: MarkerId("3")):
                    Marker(
                            markerId:const MarkerId('2'),
                            position: LatLng(
                                double.parse(officeLocationProvider.location!.latitude.toString()),
                                double.parse(officeLocationProvider.location!.longitude.toString())),
                            infoWindow: InfoWindow(title: officeLocationProvider.locationName.text.toString())),
                       Marker(
                            markerId:const MarkerId('1'),
                            position: LatLng(
                                double.parse(widget.mapData.latitude.toString()),
                                double.parse(widget.mapData.longitude.toString())),
                            infoWindow: InfoWindow(title: widget.mapData.name.toString()),
                )]),
                  initialCameraPosition: CameraPosition(
                    target: LatLng(double.parse(widget.mapData.latitude.toString()),double.parse(widget.mapData.longitude.toString()),),
                    zoom: 14.4746,
                  ),
                  mapType: MapType.normal,
                  onMapCreated: (GoogleMapController controller) {
                    //_controller.complete(controller);
                  },
                ),
              ),
              SizedBox(
                height: height(context)/2,
                child: Padding(
                  padding:const EdgeInsets.symmetric(horizontal: 20),
                  child: Form(
                    key: officeLocationProvider.setLocationKey,
                    child: ListView(
                      children: [
                        Align(
                          alignment: Alignment.topRight,
                          child: CommonButton(
                            shadowneeded: false,
                            onPressed: (){
                            officeLocationProvider.initialize(widget.mapData,true);
                            // officeLocationProvider.reset();
                          }, width: width(context)/4, text: "Reset"),
                        ),
                    CommonTextPoppins(text: "Radius (In Meters)", fontweight: FontWeight.w500, fontsize: 14, color: AppColors.textColor,talign: TextAlign.start),
                          Slider.adaptive(divisions: 1000,value: officeLocationProvider.sliderRadius,label: officeLocationProvider.sliderRadius.toString(), max: 1000,min: 0,activeColor: AppColors.primaryColor, onChanged: (value) {
                            officeLocationProvider.updateSlider(value);
                          }),
                          CommonTextField(hinttext: "Name", controller: officeLocationProvider.locationName,isEditable: true,validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return "Please Enter Name";
                                    }
                                    return null;
                                  },),
                          10.sh,
                          CommonTextField(hinttext: "ZipCode", controller: officeLocationProvider.zipcode,isEditable: true,validator: (value){
                            if (value == null || value.isEmpty) {
                              return "Please enter zipcode";
                            }else if(value.length>5 || value.length<5){
                              return "Please enter valid zipcode";
                            }
                            return null;
                          },),
                          10.sh,
                          CommonTextField(hinttext: "Country", controller: officeLocationProvider.country,isEditable: false,),
                          10.sh,
                          CommonTextField(hinttext: "State", controller: officeLocationProvider.state,isEditable: false,),
                          10.sh,
                          CommonTextField(hinttext: "City", controller: officeLocationProvider.city,isEditable: false,),
                          10.sh,
                          CommonTextField(hinttext: "Street", controller: officeLocationProvider.street,isEditable: false,),
                          10.sh,
                          CommonTextField(hinttext: "Phone Number", controller: officeLocationProvider.phoneNumber,keyboardType: TextInputType.number,
                          validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return "Please enter phone number";
                                    }
                                    return null;
                                  },),
                          10.sh,
                          officeLocationProvider.updateLoading?const Center(child: CircularProgressIndicator.adaptive(),):
                          Column(mainAxisSize: MainAxisSize.min,
                          children: [
                          CommonButton(
                            onPressed: () {
                              if (officeLocationProvider.setLocationKey.currentState!.validate()) {
                              officeLocationProvider.updateLocation(context: context,locId: widget.mapData.id.toString());
                              }
                            },
                            text: "Update Location", width: width(context),
                          ),
                          10.sh,
                          CommonButton2(
                            text: "Cancel",
                          ),
                          ],
                          )
                          ],
                    ),
                  ),
                ),
              ),          
            ],
          ),
        );
      },
    ));
  }
}

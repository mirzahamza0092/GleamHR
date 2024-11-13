import 'package:flutter/material.dart';
import 'package:gleam_hr/Components/CommonAppBar.dart';
import 'package:gleam_hr/Components/CommonButton.dart';
import 'package:gleam_hr/Components/CommonText.dart';
import 'package:gleam_hr/Providers/DashBoardProviders/MoreProviders/OfficeLocation_Provider.dart';
import 'package:gleam_hr/Screens/DashBoard/More/MoreScreens/SetLocation.dart';
import 'package:gleam_hr/Utils/AppConstants.dart';
import 'package:gleam_hr/Utils/AppPaths.dart';
import 'package:gleam_hr/Utils/Colors.dart';
import 'package:gleam_hr/Utils/SizedBox.dart';
import 'package:lazy_load_scrollview/lazy_load_scrollview.dart';
import 'package:provider/provider.dart';

class OfficesList extends StatefulWidget {
  const OfficesList({super.key});

  @override
  State<OfficesList> createState() => _OfficesListState();
}

class _OfficesListState extends State<OfficesList> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final officeLocationProvider =
          Provider.of<OfficeLocationProvider>(context, listen: false);
          officeLocationProvider.resetpage();
    officeLocationProvider.getAllOffices(context);
          });
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
          preferredSize: Size(width(context), 120),
          child: CommonAppBar(
              subtitle:
                  "${AppConstants.loginmodell!.userData!.firstname} ${(AppConstants.loginmodell!.userData!.lastname).toString() == "null" ? "" : AppConstants.loginmodell!.userData!.lastname}",
              trailingimagepath:
                  "https://${Keys.domain}.gleamhrm.com/${AppConstants.loginmodell!.userData!.picture}")),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
                 padding: const EdgeInsets.only(left: 18,top: 25.0),
                 child: Row(
                   children: [
                    InkWell(
                        onTap: () {
                          Navigator.of(context).pop();
                        },
                        child: FittedBox(
                            child: Icon(
                          Icons.arrow_back,
                          color: AppColors.primaryColor,
                        ))),7.sw,
                     CommonTextPoppins(
                                       text: "Set Offices Location",
                                       fontweight: FontWeight.w700,
                                       fontsize: 20,
                                       color: AppColors.textColor),
                   ],
                 ),
                            ),
           20.sh,
            Consumer<OfficeLocationProvider>(
              builder: (context, officeLocationProvider, child) {
                if (officeLocationProvider.isLoading && officeLocationProvider.page==1) {
                  return const Center(
                    child: CircularProgressIndicator.adaptive(),
                  );
                }else{
                return LazyLoadScrollView(
                  onEndOfPage: () {
                  debugPrint("objectlll");
                  if ((AppConstants.allOfficeLocationModel!.data!.lastPage!) >= (officeLocationProvider.page)) {
                if (!officeLocationProvider.isLoading) {
                 officeLocationProvider.getAllOffices(context);
                }
                }
                  },
                  child: ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: AppConstants.allOfficeLocationModel!.data!.data!.length+1,
                    itemBuilder: (context, index) {
                    if (index<AppConstants.allOfficeLocationModel!.data!.data!.length) {
                      return ListTile(
                      title: CommonTextPoppins(text: AppConstants.allOfficeLocationModel!.data!.data![index].name.toString()=="null"?"No Name Available":AppConstants.allOfficeLocationModel!.data!.data![index].name.toString(), color: AppColors.textColor,fontsize: 14, fontweight: FontWeight.w500,talign: TextAlign.start,),
                      subtitle: CommonTextPoppins(text: AppConstants.allOfficeLocationModel!.data!.data![index].street1.toString()=="null"?"":AppConstants.allOfficeLocationModel!.data!.data![index].street1.toString(), fontweight: FontWeight.w400, fontsize: 12,talign: TextAlign.start, color: AppColors.textColor),
                      trailing: CommonButton(onPressed: (){
                        Navigator.push(context, MaterialPageRoute(builder: (context) => SetLocation(mapData:AppConstants.allOfficeLocationModel!.data!.data![index], ),));
                      }, width: width(context)*.35,
                       height: height(context)*.06,
                       text: "Set Location",shadowneeded: false,),
                    );
                    }else{
                      if (officeLocationProvider.isLoading) {
                    return const Center(child:  CircularProgressIndicator.adaptive());
                  }else{
                    return const SizedBox();
                  }
                    }                
                    }),
                );
                }
              },
            ),
          ],
        ),
      )
    );
  }
}
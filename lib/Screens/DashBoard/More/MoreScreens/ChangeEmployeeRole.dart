import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:gleam_hr/Components/CommonAppBar.dart';
import 'package:gleam_hr/Components/CommonDropDown.dart';
import 'package:gleam_hr/Components/CommonText.dart';
import 'package:gleam_hr/Providers/DashBoardProviders/MoreProviders/ChangeEmployeeRole_Provider.dart';
import 'package:gleam_hr/Screens/DashBoard/People/PeopleWidget/PeopleSearchBar.dart';
import 'package:gleam_hr/Utils/AppConstants.dart';
import 'package:gleam_hr/Utils/AppPaths.dart';
import 'package:gleam_hr/Utils/Colors.dart';
import 'package:gleam_hr/Utils/SizedBox.dart';
import 'package:provider/provider.dart';

class ChangeEmployeeRole extends StatefulWidget {
  const ChangeEmployeeRole({super.key});

  @override
  State<ChangeEmployeeRole> createState() => _ChangeEmployeeRoleState();
}

class _ChangeEmployeeRoleState extends State<ChangeEmployeeRole> {
  @override
  void initState() {
    final empdetailProvider =
        Provider.of<ChangeEmployeeRoleProvider>(context, listen: false);
        empdetailProvider.getEmployeerole(context);
        empdetailProvider.getAllEmployees(context);
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
                  "https://${Keys.domain}.gleamhrm.com/${AppConstants.loginmodell!.userData!.picture}")
                  ),
      body:Consumer<ChangeEmployeeRoleProvider>(
        builder: (context, empdetailProvider, child) {
          if (empdetailProvider.isLoading) {
            return const Center(child: CircularProgressIndicator.adaptive());
          } else {
            return SingleChildScrollView(
        keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
        child: Column(
          children: [
          15.sh,
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15.0),
            child: Column(
              children: [
                Row(
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
                                      talign: TextAlign.left,
                                      text: "Change Employee Role",
                                      fontweight: FontWeight.w600,
                                      fontsize: 20,
                                      color: AppColors.textColor),
                ],
                ),10.sh,
                PeopleSearchBar(
                  controller: empdetailProvider.search,
                  onvaluechange: (value) {
                    if (value.isEmpty) {
                      empdetailProvider.searchlist = [];
                      empdetailProvider.hitupdate();
                      return;
                    }
                    empdetailProvider.searchlist = AppConstants.allEmployeesDetailsModel!.employees!
                        .where((element) => element.firstname
                            .toString()
                            .toLowerCase()
                            .contains(value.toString().toLowerCase()))
                        .toList();
                    empdetailProvider.hitupdate();
                  },
          
                ),
              ],
            ),
          ),
          15.sh,
          SizedBox(
            height: height(context)*.7,
            child:empdetailProvider.search.text.isEmpty? 
            Padding(
              padding: const EdgeInsets.only(bottom:18.0),
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: AppConstants.allEmployeesDetailsModel!.employees!.length,
                itemBuilder: (context, index) {
                  debugPrint("object${AppConstants.allEmployeesDetailsModel!.employees![index].fullName}");
                if(AppConstants.allEmployeesDetailsModel!.employees![index].status.toString()=="1"){
                  return ListTile(
                  leading: AppConstants.allEmployeesDetailsModel!.employees![index]
                                                                .picture
                                                                .toString() ==
                                                            "null"
                                                        ? Container(
                                                            padding:
                                                                const EdgeInsets
                                                                    .all(10),
                                                            width: 34,
                                                            height: 34,
                                                            decoration:
                                                                BoxDecoration(
                                                              image:
                                                                  DecorationImage(
                                                                      image:
                                                                          AssetImage(
                                                                ImagePath
                                                                    .profiledummyimage,
                                                              )),
                                                              shape:
                                                                  BoxShape.circle,
                                                              color: AppColors
                                                                  .whiteColor,
                                                            ),
                                                          )
                                                        : CachedNetworkImage(
                                                            imageUrl:
                                                                "https://${Keys.domain}.gleamhrm.com/${AppConstants.allEmployeesDetailsModel!.employees![index].picture}",
                                                            imageBuilder: (context,
                                                                    imageProvider) =>
                                                                Container(
                                                                  padding:
                                                                      const EdgeInsets
                                                                          .all(10),
                                                                  width: 40,
                                                                  height: 40,
                                                                  decoration:
                                                                      BoxDecoration(
                                                                    image: DecorationImage(
                                                                        image:
                                                                            imageProvider),
                                                                    shape: BoxShape
                                                                        .circle,
                                                                    color: AppColors
                                                                        .whiteColor,
                                                                  ),
                                                                  //child: imageProvider,
                                                                ),
                                                            placeholder: (context,
                                                                    url) =>
                                                                const CircularProgressIndicator
                                                                    .adaptive(),
                                                            errorWidget: (context,
                                                                url, error) {
                                                              debugPrint(
                                                                  "objecterror$url");
                                                              return Container(
                                                                padding:
                                                                    const EdgeInsets
                                                                        .all(10),
                                                                width: 35,
                                                                height: 35,
                                                                decoration:
                                                                    BoxDecoration(
                                                                  image:
                                                                      DecorationImage(
                                                                          image:
                                                                              AssetImage(
                                                                    ImagePath
                                                                        .profiledummyimage,
                                                                  )),
                                                                  shape: BoxShape
                                                                      .circle,
                                                                  color: AppColors
                                                                      .whiteColor,
                                                                ),
                                                              );
                                                            }),
                  title: CommonTextPoppins(text: AppConstants.allEmployeesDetailsModel!.employees![index].firstname.toString(), color: AppColors.textColor,fontsize: 14, fontweight: FontWeight.w500,talign: TextAlign.start),
                  subtitle: CommonTextPoppins(text: AppConstants.allEmployeesDetailsModel!.employees![index].designation.toString()!="null"? AppConstants.allEmployeesDetailsModel!.employees![index].designation!.designationName.toString():"No designation", fontweight: FontWeight.w300, fontsize: 12, color: AppColors.textColor,talign: TextAlign.start),
                  trailing: CommonDropDown(width: width(context)*.35, selectedText: AppConstants.allEmployeesDetailsModel!.employees![index].roles!.isEmpty?"Not Available": AppConstants.allEmployeesDetailsModel!.employees![index].roles![0].name.toString(), listItem: empdetailProvider.roles, onchanged: (value){
                    empdetailProvider.changeRole(context: context, employeeId: AppConstants.allEmployeesDetailsModel!.employees![index].id.toString(), roleId: value);
                  }));
                }else{
                  return const SizedBox();
                }
              }),
            ):empdetailProvider.searchlist.isNotEmpty?
            Padding(
              padding: const EdgeInsets.only(bottom:18.0),
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: empdetailProvider.searchlist.length,
                itemBuilder: (context, index) {
               if(true){
                 return ListTile(
                  leading: empdetailProvider.searchlist[index]
                                                                .picture
                                                                .toString() ==
                                                            "null"
                                                        ? Container(
                                                            padding:
                                                                const EdgeInsets
                                                                    .all(10),
                                                            width: 34,
                                                            height: 34,
                                                            decoration:
                                                                BoxDecoration(
                                                              image:
                                                                  DecorationImage(
                                                                      image:
                                                                          AssetImage(
                                                                ImagePath
                                                                    .profiledummyimage,
                                                              )),
                                                              shape:
                                                                  BoxShape.circle,
                                                              color: AppColors
                                                                  .whiteColor,
                                                            ),
                                                          )
                                                        : CachedNetworkImage(
                                                            imageUrl:
                                                                "https://${Keys.domain}.gleamhrm.com/${empdetailProvider.searchlist[index].picture}",
                                                            imageBuilder: (context,
                                                                    imageProvider) =>
                                                                Container(
                                                                  padding:
                                                                      const EdgeInsets
                                                                          .all(10),
                                                                  width: 40,
                                                                  height: 40,
                                                                  decoration:
                                                                      BoxDecoration(
                                                                    image: DecorationImage(
                                                                        image:
                                                                            imageProvider),
                                                                    shape: BoxShape
                                                                        .circle,
                                                                    color: AppColors
                                                                        .whiteColor,
                                                                  ),
                                                                  //child: imageProvider,
                                                                ),
                                                            placeholder: (context,
                                                                    url) =>
                                                                const CircularProgressIndicator
                                                                    .adaptive(),
                                                            errorWidget: (context,
                                                                url, error) {
                                                              debugPrint(
                                                                  "objecterror$url");
                                                              return Container(
                                                                padding:
                                                                    const EdgeInsets
                                                                        .all(10),
                                                                width: 35,
                                                                height: 35,
                                                                decoration:
                                                                    BoxDecoration(
                                                                  image:
                                                                      DecorationImage(
                                                                          image:
                                                                              AssetImage(
                                                                    ImagePath
                                                                        .profiledummyimage,
                                                                  )),
                                                                  shape: BoxShape
                                                                      .circle,
                                                                  color: AppColors
                                                                      .whiteColor,
                                                                ),
                                                              );
                                                            }),
                  title: CommonTextPoppins(text: empdetailProvider.searchlist[index].firstname.toString(), color: AppColors.textColor,fontsize: 14, fontweight: FontWeight.w500,talign: TextAlign.start),
                  subtitle: CommonTextPoppins(text: empdetailProvider.searchlist[index].designation.toString()!="null"? empdetailProvider.searchlist[index].designation!.designationName.toString():"No designation", fontweight: FontWeight.w300, fontsize: 12, color: AppColors.textColor,talign: TextAlign.start),
                  trailing: CommonDropDown(width: width(context)*.35, selectedText: empdetailProvider.searchlist[index].roles!.isEmpty?"Not Available":empdetailProvider.searchlist[index].roles![0].name.toString(), listItem: empdetailProvider.roles, onchanged: (value){
                    empdetailProvider.changeRole(context: context, employeeId: empdetailProvider.searchlist[index].id.toString(), roleId: value);
                  })
                );
               }
              }),
            ):CommonTextPoppins(
                                  text: "No Search Found",
                                  fontweight: FontWeight.w600,
                                  fontsize: 22,
                                  color: AppColors.primaryColor),
          ),
        ],)
        );
          }
        },
      )
    );
  }
}

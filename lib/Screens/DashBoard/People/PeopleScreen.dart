import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:gleam_hr/Components/CommonAppBar.dart';
import 'package:gleam_hr/Components/CommonText.dart';
import 'package:gleam_hr/Providers/DashBoardProviders/PeopleProviders/PeopleProvider.dart';
import 'package:gleam_hr/Screens/DashBoard/People/PeopleDetailScreen.dart';
import 'package:gleam_hr/Screens/DashBoard/People/PeopleWidget/PeopleSearchBar.dart';
import 'package:gleam_hr/Utils/AppConstants.dart';
import 'package:gleam_hr/Utils/AppPaths.dart';
import 'package:gleam_hr/Utils/Colors.dart';
import 'package:gleam_hr/Utils/SizedBox.dart';
import 'package:provider/provider.dart';

class PeopleScreen extends StatefulWidget {
  const PeopleScreen({super.key});

  @override
  State<PeopleScreen> createState() => _PeopleScreenState();
}

class _PeopleScreenState extends State<PeopleScreen> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final peopleProvider =
          Provider.of<PeopleProvider>(context, listen: false);
      if (AppConstants.allEmployeesDetailsModel == null) {
        peopleProvider.getAllEmployees(context);
      } else {
        peopledetails = AppConstants.allEmployeesDetailsModel;
        peopledetails!.employees.sort((a, b) {
          return a.firstname.toString().compareTo(b.firstname.toString());
        });
        peopleProvider.changedosort(true);
      }
    });
    super.initState();
  }

  dynamic peopledetails;
//for time being
  @override
  Widget build(BuildContext context) {
    peopledetails = AppConstants.loginmodell;
    final peoplesProvider = Provider.of<PeopleProvider>(context, listen: false);
    if (peoplesProvider.dosort) {
      peopledetails = AppConstants.allEmployeesDetailsModel;
      peopledetails!.employees.sort((a, b) {
        return a.firstname.toString().compareTo(b.firstname.toString());
      });
      peopledetails!.employees.sort((a, b) {
        return a.designation.toString().compareTo(b.designation.toString());
      });
    }
    return Scaffold(
      backgroundColor: AppColors.pageBackgroundColor,
      appBar: PreferredSize(
          preferredSize: Size(width(context), 220),
          // child: CommonAppBar(
          //       subtitle: "${AppConstants.loginmodell!.userData.firstname} ${AppConstants.loginmodell!.userData.lastname}",
          //       trailingimagepath:"https://${Keys.domain}.gleamhrm.com/${peopledetails!.userData.picture}"),
          child: InkWell(
            onTap: () {
              //           Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) =>
              // DomainScreen()), (route) => false);
            },
            child: Column(
              children: [
              CommonAppBar(
                    subtitle:
                        "${AppConstants.loginmodell!.userData!.firstname} ${(AppConstants.loginmodell!.userData!.lastname).toString() == "null" ? "" : AppConstants.loginmodell!.userData!.lastname}",
                    trailingimagepath:
                        "https://${Keys.domain}.gleamhrm.com/${AppConstants.loginmodell!.userData!.picture}"),
              Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                  17.sh,
                  CommonTextPoppins(
                                text: "All Employee",
                                fontweight: FontWeight.w600,
                                fontsize: 20,
                                color: AppColors.textColor),
                                17.sh,
                                PeopleSearchBar(
                            controller: peoplesProvider.search,
                            onvaluechange: (value) {
                              if (value.isEmpty) {
                                peoplesProvider.searchlist = [];
                                debugPrint("valueempty");
                                peoplesProvider.hitupdate();
                                return;
                              }
                              peoplesProvider.searchlist = peopledetails!.employees
                              .where((element) =>
                                element.firstname.toString().toLowerCase().contains(value.toString().toLowerCase()) ||
                                element.designation != null &&
                                element.designation.designationName.toString().toLowerCase().contains(value.toString().toLowerCase())
                              )
                              .toList();
                           peoplesProvider.hitupdate();
                            },
                          
                          ),
                          
                   ],
                 ),
               ),
              ],
            ),
          )),
      body: Consumer<PeopleProvider>(builder: (context, provider, child) {
        return SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 0),
            child: Consumer<PeopleProvider>(
              builder: (context, peopleProvider, child) {
                if (peoplesProvider.dosort != null && peoplesProvider.dosort) {
                  peopledetails = AppConstants.allEmployeesDetailsModel;
                  peopledetails!.employees.sort((a, b) {
                    return a.firstname
                        .toString()
                        .compareTo(b.firstname.toString());
                  });
                }
                
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      //const SizedBox(),
                      //22.sh,
                      // Row(
                      //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      //   children: [
                      //     3.sw,
                      //             // DropdownButton(items: [], onChanged: (value) {})
                      //             // Consumer<PeopleProvider>(
                      //             //   builder: (context, peopleProvider, child) {
                      //             //     return PopupMenuButton<String>(
                      //             //       color: AppColors.pageBackgroundColor,
                      //             //       shape: RoundedRectangleBorder(
                      //             //     borderRadius: BorderRadius.all(
                      //             //       Radius.circular(15.0),
                      //             //       ),
                      //             //      ),
                      //             //       icon: SvgPicture.asset(
                      //             //           ImagePath.filterIcon,
                      //             //           height: 40),
                      //             //       onSelected: (String value) {
                      //             //         peopleProvider.Filter("b");
                      //             //       },
                      //             //       itemBuilder: (BuildContext context) {
                      //             //         return peopleProvider.items
                      //             //             .asMap()
                      //             //             .entries
                      //             //             .map((entry) {
                      //             //           final int index = entry.key;
                      //             //           final String item = entry.value;
                      //             //           return PopupMenuItem<String>(
                      //             //             value: item,
                      //             //             child: Consumer<PeopleProvider>(
                      //             //                 builder: (context,
                      //             //                     peopleProvider, child) {
                      //             //               return Column(
                      //             //                 crossAxisAlignment:
                      //             //                     CrossAxisAlignment.start,
                      //             //                 children: [
                      //             //                   Row(
                      //             //                     children: [
                      //             //                       Checkbox(
                      //             //                         shape: const RoundedRectangleBorder(
                      //             //                         borderRadius: BorderRadius.all(
                      //             //                          Radius.circular(5.0),
                      //             //                           ),

                      //             //                         ),
                      //             //                         value: peopleProvider
                      //             //                             .isChecked[index],
                      //             //                         onChanged:
                      //             //                             (bool? newValue) {
                      //             //                           peopleProvider
                      //             //                               .setChecked(
                      //             //                                   newValue ??
                      //             //                                       false,
                      //             //                                   index);
                      //             //                         },
                      //             //                         activeColor: const Color(0XFF024a69),
                      //             //                         //checkColor: AppColors.primaryColor.withOpacity(0.05),
                      //             //                        // fillColor:  Color(0XFFF2F2F2),
                      //             //                         // checkColor: Colors.red,
                      //             //                       ),
                      //             //                       CommonTextPoppins(
                      //             //                         text: item,
                      //             //                         fontweight:
                      //             //                             FontWeight.w400,
                      //             //                         fontsize: 14,
                      //             //                         color: AppColors
                      //             //                             .blackColor,
                      //             //                         talign:
                      //             //                             TextAlign.left,
                      //             //                       ),
                      //             //                     ],
                      //             //                   ),
                      //             //                   const Divider(
                      //             //                     height: 2,
                      //             //                   )
                      //             //                 ],
                      //             //               );
                      //             //             }
                      //             //             ),

                      //             //           );
                      //             //         }).toList();
                      //             //       },
                      //             //     );
                      //             //   },
                      //             // ),
                        
                      //   ],
                      // ),
                     // 12.sh,
                      //Center(child: CommonTextPoppins(text: "No Employees Available", fontweight: FontWeight.w500, fontsize: 15, color: AppColors.primaryColor,talign: TextAlign.center,)),

                      // for all employees
                      peopleProvider.search.text.isEmpty
                          ? peopleProvider.dosort == false
                              ? const Center(
                                  child: CircularProgressIndicator.adaptive())
                              : ListView.builder(
                                  itemCount: peopledetails!.employees.length,
                                  shrinkWrap: true,
                                  physics: const NeverScrollableScrollPhysics(),
                                  //itemExtent: 80,
                                  itemBuilder: (context, index) {
                                    peoplesProvider.go = true;
                                    if (peoplesProvider.alp ==
                                        peopledetails!
                                            .employees[index].fullName[0]) {
                                      //if (peopledetails!.employees[index].status==1) {
                                      peoplesProvider.go = true;
                                      // }
                                    } else if (peopledetails!
                                            .employees[index].status ==
                                        1) {
                                      peoplesProvider.go = false;
                                      peoplesProvider.alp = peopledetails!
                                          .employees[index].fullName[0];
                                    }
                                    return Column(
                                      mainAxisSize: MainAxisSize.min,
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        peopledetails!
                                                    .employees[index].status ==
                                                0
                                            ? const SizedBox()
                                            : 14.sh,
                                        peoplesProvider.go
                                            ? const SizedBox()
                                            : CommonTextPoppins(
                                                text: peopledetails!
                                                    .employees[index]
                                                    .fullName[0],
                                                fontweight: FontWeight.w400,
                                                talign: TextAlign.left,
                                                fontsize: 12,
                                                color: AppColors.hintTextColor),
                                        peopledetails!
                                                    .employees[index].status ==
                                                0
                                            ?
                                             const SizedBox()
                                             :Container(
                                                height: 68,
                                                decoration: BoxDecoration(
                                                    border: Border(
                                                        bottom: BorderSide(
                                                  color: AppColors.hintTextColor
                                                      .withOpacity(.5),
                                                  width: 1,
                                                ))),
                                                child: ListTile(
                                                     minLeadingWidth: 0,
                                                     //right: 6.0)
                                                
                                                  onTap: () async {
                                                              Navigator.push(
                                                                   context,
                                                         MaterialPageRoute(
                                                          builder: (context) => PeopleDetailScreen(
                                                                                              name: AppConstants.allEmployeesDetailsModel!.employees![index].fullName != null
                                                                                              ?AppConstants.allEmployeesDetailsModel!.employees![index].fullName.toString() == 'No Name Available' ? 'No Name Available' 
                                                                                              : AppConstants.allEmployeesDetailsModel!.employees![index].fullName.toString() : 'No Name Available',

                                                                                              email: AppConstants.allEmployeesDetailsModel!.employees![index].officialEmail!= null
                                                                                              ?AppConstants.allEmployeesDetailsModel!.employees![index].officialEmail.toString() == 'No Mail Available' ? 'No Mail Available' 
                                                                                              : AppConstants.allEmployeesDetailsModel!.employees![index].officialEmail.toString() : 'No Mail Available',

                                                                                              phoneNo: AppConstants.allEmployeesDetailsModel!.employees![index].contactNo != null
                                                                                              ?AppConstants.allEmployeesDetailsModel!.employees![index].contactNo.toString() == 'No contact Available' ? 'No contact Available' 
                                                                                              : AppConstants.allEmployeesDetailsModel!.employees![index].contactNo.toString() : 'No Contact Available',

                                                                                              id:AppConstants.allEmployeesDetailsModel!.employees![index].managerId != null
                                                                                              ? AppConstants.allEmployeesDetailsModel!.employees![index].id.toString() : '',
                                                                                               )
                                                                  ) );
                                                    
                                                    // peoplesProvider
                                                    //     .changeScreenNumber(
                                                    //         2,
                                                    //         peopledetails!
                                                    //             .employees[
                                                    //                 index]
                                                    //             .fullName
                                                    //             .toString(),
                                                    //         peopledetails!
                                                    //             .employees[
                                                    //                 index]
                                                    //             .officialEmail
                                                    //             .toString(),
                                                    //         peopledetails!
                                                    //             .employees[
                                                    //                 index]
                                                    //             .contactNo
                                                    //             .toString());
                                                  },
                                                    //                         final newContact = Contact()
                                                    //   ..name.first = 'John'
                                                    //   ..name.last = 'Smith'
                                                    //   ..phones = [Phone('+923345759955')];
                                                    // await newContact.insert();
                                                
                                                    // Uri phoneno = Uri.parse(
                                                    //     'tel:${AppConstants.allEmployeesDetailsModel!.employees![index].contactNo.toString()}');
                                                    // if (await launchUrl(phoneno)) {
                                                    //   //dialer opened
                                                    // } else {
                                                    //   //dailer is not opened
                                                    // }
                                                //  },
                                                  //contentPadding:
                                                    //  EdgeInsets.zero,
                                                  leading: peopledetails!
                                                              .employees[index]
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
                                                              "https://${Keys.domain}.gleamhrm.com/${peopledetails!.employees[index].picture}",
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
                                                   contentPadding:const EdgeInsets.only(
                                                    left: 0,
                                                    right: 18,
                                                    ),
                                                  title: CommonTextPoppins(
                                                      text: peopledetails!
                                                          .employees[index]
                                                          .firstname
                                                          .toString(),
                                                      fontweight:
                                                          FontWeight.w400,
                                                      talign: TextAlign.left,
                                                      fontsize: 16,
                                                      color:
                                                          AppColors.textColor),
                                                  subtitle: CommonTextPoppins(
                                                      text: (AppConstants
                                                                      .allEmployeesDetailsModel!
                                                                      .employees![
                                                                          index]
                                                                      .designation)
                                                                  .toString() ==
                                                              "null"
                                                          ? "No Designation"  
                                                          : AppConstants
                                                              .allEmployeesDetailsModel!
                                                              .employees![index]
                                                              .designation!
                                                              .designationName
                                                              .toString(),
                                                      fontweight:
                                                          FontWeight.w400,
                                                      talign: TextAlign.left,
                                                      fontsize: 12,
                                                      color: AppColors
                                                          .hintTextColor),
                                                ),
                                            )
                                      ],
                                    );
                                  },
                                )
                          : peopleProvider.searchlist.isNotEmpty
                              ? peopleProvider.dosort == false
                                  ? const Center(
                                      child:
                                          CircularProgressIndicator.adaptive())
                                  : ListView.builder(
                                      itemCount:
                                          peopleProvider.searchlist.length,
                                      shrinkWrap: true,
                                      physics:
                                          const NeverScrollableScrollPhysics(),
                                      //itemExtent: 80,
                                      itemBuilder: (context, index) {
                                        return peopleProvider
                                                    .searchlist[index].status ==
                                                0
                                            ? const SizedBox()
                                            : Column(
                                                mainAxisSize: MainAxisSize.min,
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  14.sh,
                                                  Container(
                                                    decoration: BoxDecoration(
                                                        border: Border(
                                                            bottom: BorderSide(
                                                      color: AppColors
                                                          .hintTextColor
                                                          .withOpacity(.5),
                                                      width: 2,
                                                    ))),
                                                    child: ListTile(
                                                      onTap: () async {
                                                        // peoplesProvider
                                                        //     .changeScreenNumber(
                                                        //         2,
                                                        //         peopleProvider
                                                        //             .searchlist[
                                                        //                 index]
                                                        //             .fullName
                                                        //             .toString(),
                                                        //         peopleProvider
                                                        //             .searchlist[
                                                        //                 index]
                                                        //             .officialEmail
                                                        //             .toString(),
                                                        //         peopleProvider
                                                        //             .searchlist[
                                                        //                 index]
                                                        //             .contactNo
                                                        //             .toString());
                                                                    Navigator.push(
                                                                   context,
                                                         MaterialPageRoute(
                                                          builder: (context) => PeopleDetailScreen(name: peopleProvider.searchlist[index].fullName.toString(),
                                                                                     //index: index,
                                                                                     email: peopleProvider.searchlist[index].officialEmail.toString(),
                                                                                    phoneNo: peopleProvider.searchlist[index].contactNo.toString(),
                                                                                     //photo: peopleProvider.searchlist[index].picture.toString(),]
                                                                                     id:peopleProvider.searchlist[index].managerId==null?"": peopleProvider.searchlist[index].managerId.toString(),
                                                                                    
                                                                                     )),
                                                                );
                                                      },
                                                        //                         final newContact = Contact()
                                                        //   ..name.first = 'John'
                                                        //   ..name.last = 'Smith'
                                                        //   ..phones = [Phone('+923345759955')];
                                                        // await newContact.insert();
                                                        // Uri phoneno = Uri.parse(
                                                        //     'tel:${AppConstants.allEmployeesDetailsModel!.employees![index].contactNo.toString()}');
                                                        // if (await launchUrl(
                                                        //     phoneno)) {
                                                        //   //dialer opened
                                                        // } else {
                                                        //   //dailer is not opened
                                                        // }
                                                     // },
                                                      contentPadding:
                                                          EdgeInsets.zero,
                                                      //   leading: Container(
                                                      // padding: const EdgeInsets.all(10),
                                                      // width: 45,
                                                      // height: 45,
                                                      // decoration: BoxDecoration(
                                                      //   image: DecorationImage(image: AssetImage(ImagePath.profiledummyimage,)),
                                                      //   boxShadow: [
                                                      //     BoxShadow(
                                                      //         color: AppColors.whiteColor.withOpacity(.25),
                                                      //         spreadRadius: 5,
                                                      //         offset:const Offset(0, 0)),
                                                      //   ],
                                                      //   shape: BoxShape.circle,
                                                      //   color: AppColors.whiteColor,
                                                      // ),
                                                      // ),
                                                      leading: peopleProvider
                                                                  .searchlist[
                                                                      index]
                                                                  .picture
                                                                  .toString() ==
                                                              "null"
                                                          ? Container(
                                                              padding:
                                                                  const EdgeInsets
                                                                      .all(10),
                                                              width: 45,
                                                              height: 45,
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
                                                            )
                                                          : CachedNetworkImage(
                                                              imageUrl:
                                                                  "https://${Keys.domain}.gleamhrm.com/${peopleProvider.searchlist[index].picture}",
                                                              imageBuilder:
                                                                  (context,
                                                                          imageProvider) =>
                                                                      Container(
                                                                        padding:
                                                                            const EdgeInsets.all(10),
                                                                        width:
                                                                            50,
                                                                        height:
                                                                            50,
                                                                        decoration:
                                                                            BoxDecoration(
                                                                          image:
                                                                              DecorationImage(image: imageProvider),
                                                                          shape:
                                                                              BoxShape.circle,
                                                                          color:
                                                                              AppColors.whiteColor,
                                                                        ),
                                                                        //child: imageProvider,
                                                                      ),
                                                              placeholder: (context,
                                                                      url) =>
                                                                  const CircularProgressIndicator
                                                                      .adaptive(),
                                                              errorWidget:
                                                                  (context, url,
                                                                      error) {
                                                                debugPrint(
                                                                    "objecterror$url");
                                                                return Container(
                                                                  padding:
                                                                      const EdgeInsets
                                                                          .all(10),
                                                                  width: 45,
                                                                  height: 45,
                                                                  decoration:
                                                                      BoxDecoration(
                                                                    image: DecorationImage(
                                                                        image: AssetImage(
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
                                                    
                                                      title: CommonTextPoppins(
                                                          text: peopleProvider
                                                              .searchlist[index]
                                                              .firstname
                                                              .toString(),
                                                          fontweight:
                                                              FontWeight.w400,
                                                          talign:
                                                              TextAlign.left,
                                                          fontsize: 14,
                                                          color: AppColors
                                                              .textColor),
                                                      subtitle: CommonTextPoppins(
                                                          text: (peopleProvider
                                                                          .searchlist[
                                                                              index]
                                                                          .designation)
                                                                      .toString() ==
                                                                  "null"
                                                              ? "No Designation"
                                                              : peopleProvider
                                                                  .searchlist[index]
                                                                  .designation!.toString()=="null" || peopleProvider.searchlist[index].designation!.designationName.toString()=="null"?"Not Available":
                                                                  peopleProvider.searchlist[index].designation!.designationName
                                                                  .toString(),
                                                          fontweight:
                                                              FontWeight.w400,
                                                          talign:
                                                              TextAlign.left,
                                                          fontsize: 12,
                                                          color: AppColors
                                                              .hintTextColor),
                                                    ),
                                                  ),
                                                ],
                                              ); //Text(llist[index]);
                                      },
                                    )
                              : CommonTextPoppins(
                                  text: "No Search Found",
                                  fontweight: FontWeight.w600,
                                  fontsize: 22,
                                  color: AppColors.primaryColor),
                      80.sh,
                    ],
                  );
                
              },
            )
            );
      }
      ),
    );
  }
}

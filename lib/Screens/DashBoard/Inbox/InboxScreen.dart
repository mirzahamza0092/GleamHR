import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gleam_hr/Components/CommonAppBar.dart';
import 'package:gleam_hr/Components/CommonText.dart';
import 'package:gleam_hr/Components/commonSnakbar.dart';
import 'package:gleam_hr/Providers/DashBoardProviders/AppbarProviders/Inbox_Provider.dart';
import 'package:gleam_hr/Screens/DashBoard/Inbox/EmployeeRequestDetaiPage.dart';
import 'package:gleam_hr/Screens/DashBoard/Inbox/InboxMessageDetail.dart';
import 'package:gleam_hr/Screens/DashBoard/Inbox/InboxWidget/InboxCommonNotificationTile.dart';
import 'package:gleam_hr/Screens/DashBoard/People/PeopleWidget/PeopleSearchBar.dart';
import 'package:gleam_hr/Utils/AppConstants.dart';
import 'package:gleam_hr/Utils/AppPaths.dart';
import 'package:gleam_hr/Utils/Colors.dart';
import 'package:gleam_hr/Utils/Methods.dart';
import 'package:gleam_hr/Utils/SizedBox.dart';
import 'package:provider/provider.dart';

class InboxScreen extends StatefulWidget {
  const InboxScreen({super.key});

  @override
  State<InboxScreen> createState() => _InboxScreenState();
}

class _InboxScreenState extends State<InboxScreen> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final inboxProvider = Provider.of<InboxProvider>(context, listen: false);
      //  inboxProvider.getAllNotifications(context);
      inboxProvider.refreshInboxIndicatorKey.currentState!.show();

      inboxProvider.scrollController.addListener(() {
        if (inboxProvider.scrollController.position.maxScrollExtent ==
            inboxProvider.scrollController.position.pixels) {
          debugPrint("firing");

          inboxProvider.getAllNotifications(context);
        }
      });
    });
    print("ascbas");
    super.initState();
  }

  dynamic inboxdetails;
  @override
  Widget build(BuildContext context) {
    if (!mounted) {}
    final inboxProvider = Provider.of<InboxProvider>(context, listen: false);
    return Scaffold(
      backgroundColor: AppColors.pageBackgroundColor,
      appBar: PreferredSize(
          preferredSize: Size(width(context), 120),
          child: CommonAppBar(
            subtitle:
                "${AppConstants.loginmodell!.userData!.firstname} ${(AppConstants.loginmodell!.userData!.lastname).toString() == "null" ? "" : AppConstants.loginmodell!.userData!.lastname}",
            trailingimagepath:
                "https://${Keys.domain}.gleamhrm.com/${AppConstants.loginmodell!.userData!.picture}",
            inboxIconNeeded: false,
            announcementIconNeeded: false,
          )),
      body: Consumer<InboxProvider>(builder: (context, provider, child) {
        return RefreshIndicator(
          key: inboxProvider.refreshInboxIndicatorKey,
          onRefresh: () {
            inboxProvider.hasmore = true;
            inboxProvider.allnotificationDetailsdata = [];
            inboxProvider.page = 1;
            return inboxProvider.getAllNotifications(context);
          },
          child: SingleChildScrollView(
              child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 30),
            color: AppColors.pageBackgroundColor,
            child: Consumer<InboxProvider>(
              builder: (context, inboxProvider, child) {
                //if (inboxProvider.pageval == 0) {
                  return Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 18),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                   InkWell(
                      onTap: () {
                        Navigator.of(context).pop();
                      },
                      child: FittedBox(
                          child: Icon(
                        Icons.arrow_back,
                        color: AppColors.primaryColor,
                      ))),
                                  CommonTextPoppins(
                                      talign: TextAlign.left,
                                      text: "Notifications",
                                      fontweight: FontWeight.w600,
                                      fontsize: 20,
                                      color: AppColors.textColor),
                                  Row(
                                    children: [
                                      InkWell(
                                          onTap: () async {
                                            //Read all Function
                                            // inboxProvider.readAllNotification(
                                            // context: context);
                                      inboxProvider.readAllCheck?
                                      showDialog(
                                                context: context,
                                                builder:
                                                    (BuildContext context) {
                                                  return AlertDialog(
                                                    shape:
                                                        RoundedRectangleBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        9)),
                                                    title: SvgPicture.asset(
                                                        ImagePath.info),
                                                    content: CommonTextPoppins(
                                                        text:
                                                            "Are you sure you want to read all notifications ?",
                                                        fontsize: 14,
                                                        fontweight:
                                                            FontWeight.w400,
                                                        color: AppColors
                                                            .textColor),
                                                    actions: [
                                                      Consumer<InboxProvider>(
                                                        builder: (context, inboxProvider, child) {
                                                          if (inboxProvider.readAllLoading) {
                                                            return const Center(
                                                              child: CircularProgressIndicator.adaptive(),
                                                            );
                                                          }else{
                                                            return Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceEvenly,
                                                        children: [
                                                          TextButton(
                                                            onPressed:
                                                                () async {
                                                              await inboxProvider
                                                                  .readAllNotification(
                                                                      context:
                                                                          context);
                                                              Navigator.of(
                                                                      context)
                                                                  .pop();
                                                            },
                                                            child: Container(
                                                              height: 55,
                                                              width: 100,
                                                              decoration: BoxDecoration(
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              10),
                                                                  border: Border.all(
                                                                      width: 1,
                                                                      color: Colors
                                                                          .blue)),
                                                              child: Center(
                                                                child:
                                                                    CommonTextPoppins(
                                                                  text: "YES",
                                                                  fontsize: 14,
                                                                  fontweight:
                                                                      FontWeight
                                                                          .w400,
                                                                  color: Colors
                                                                      .blue,
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                          TextButton(
                                                            onPressed: () {
                                                              Navigator.of(
                                                                      context)
                                                                  .pop(); // Close the dialog
                                                            },
                                                            child:
                                                                CommonTextPoppins(
                                                              text: "NO",
                                                              fontsize: 14,
                                                              fontweight:
                                                                  FontWeight
                                                                      .w400,
                                                              color: Colors.red,
                                                            ),
                                                          ),
                                                        ],
                                                      );
                                                          }
                                                        },
                                                      )
                                                      ],
                                                  );
                                                }):  ScaffoldMessenger.of(context)
                                                     .showSnackBar(appSnackBar("Already Read"));
                                          },
                                          child: Container(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 12),
                                              height: 42,
                                              decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                  color: AppColors.primaryColor
                                                      .withOpacity(.09),
                                                  border: Border.all(
                                                      width: 1,
                                                      color: AppColors
                                                          .primaryColor
                                                          .withOpacity(.09))),
                                              child: Center(
                                                child: CommonTextPoppins(
                                                    text: "MARK ALL AS READ",
                                                    fontweight: FontWeight.w600,
                                                    fontsize: 14,
                                                    color:
                                                        AppColors.primaryColor),
                                              ))),
                                      // Padding(
                                      //   padding: const EdgeInsets.only(left: 8.0),
                                      //   child: Container(
                                      //     padding: const EdgeInsets.symmetric(
                                      //         horizontal: 1),
                                      //     height: 42,
                                      //     decoration: BoxDecoration(
                                      //         borderRadius:
                                      //             BorderRadius.circular(10),
                                      //         color:
                                      //             AppColors.pageBackgroundColor,
                                      //         border: Border.all(
                                      //             width: 1,
                                      //             color:
                                      //                 AppColors.hintTextColor)),
                                      //     child: Center(
                                      //       child: PopupMenuButton<String>(
                                      //         icon: SvgPicture.asset(
                                      //           ImagePath.filterIcon,
                                      //           color: AppColors.hintTextColor,
                                      //         ),
                                      //         onSelected: (String newValue) {
                                      //           inboxProvider.Filter(newValue);
                                      //         },
                                      //         itemBuilder:
                                      //             (BuildContext context) {
                                      //           return inboxProvider.items
                                      //               .map((String item) {
                                      //             return PopupMenuItem<String>(
                                      //               value: item,
                                      //               child: Column(
                                      //                 crossAxisAlignment:
                                      //                     CrossAxisAlignment
                                      //                         .start,
                                      //                 children: [
                                      //                   CommonTextPoppins(
                                      //                     text: item,
                                      //                     fontweight:
                                      //                         FontWeight.w400,
                                      //                     fontsize: 12,
                                      //                     color: AppColors
                                      //                         .blackColor,
                                      //                     talign: TextAlign.left,
                                      //                   ),
                                      //                   const Divider(
                                      //                     height: 2,
                                      //                   )
                                      //                 ],
                                      //               ),
                                      //             );
                                      //           }).toList();
                                      //         },
                                      //       ),
                                      //     ),
                                      //   ),
                                      // )
                                    ],
                                  ),
                                ],
                              ),
                              14.sh,
                              Row(
                                children: [
                                  Expanded(
                                    flex: 1,
                                    child: PeopleSearchBar(
                                      controller: inboxProvider.search,
                                      onvaluechange: (value) {
                                        //inboxProvider.changePaggeingNumber(1);
                                        if (value.isEmpty) {
                                          inboxProvider.searchlist = [];
                                          debugPrint("valueempty");
                                          inboxProvider.hitupdate();
                                          return;
                                        }
                                        inboxProvider.searchlist = inboxProvider
                                            .allnotificationDetailsdata
                                            .where((element) => element
                                                .data!.title
                                                .toString()
                                                .toLowerCase()
                                                .contains(value
                                                    .toString()
                                                    .toLowerCase()))
                                            .toList();
                                        inboxProvider.hitupdate();
                                      },
                                    ),
                                  ),
                                  4.sw,
                                  // DropdownButton(items: [], onChanged: (value) {})
                                  // Consumer<InboxProvider>(
                                  //   builder: (context, inboxProvider, child) {
                                  //     return PopupMenuButton<String>(
                                  //       color: AppColors.pageBackgroundColor,
                                  //       shape: const RoundedRectangleBorder(
                                  //     borderRadius: BorderRadius.all(
                                  //       Radius.circular(15.0),
                                  //       ),
                                  //      ),
                                  //       icon: SvgPicture.asset(
                                  //           ImagePath.filterIcon,
                                  //           height: 40),
                                  //       onSelected: (String value) {
                                  //         inboxProvider.Filter("b");
                                  //       },
                                  //       itemBuilder: (BuildContext context) {
                                  //         return inboxProvider.items
                                  //             .asMap()
                                  //             .entries
                                  //             .map((entry) {
                                  //           final int index = entry.key;
                                  //           final String item = entry.value;
                                  //           return PopupMenuItem<String>(
                                  //             value: item,
                                  //             child: Consumer<InboxProvider>(
                                  //                 builder: (context,
                                  //                     inboxProvider, child) {
                                  //               return Column(
                                  //                 crossAxisAlignment:
                                  //                     CrossAxisAlignment.start,
                                  //                 children: [
                                  //                   Row(
                                  //                     children: [
                                  //                       Checkbox(
                                  //                         shape: const RoundedRectangleBorder(
                                  //                         borderRadius: BorderRadius.all(
                                  //                          Radius.circular(5.0),
                                  //                           ),

                                  //                         ),
                                  //                         value: inboxProvider
                                  //                             .isChecked[index],
                                  //                         onChanged:
                                  //                             (bool? newValue) {
                                  //                           inboxProvider
                                  //                               .setChecked(
                                  //                                   newValue ??
                                  //                                       false,
                                  //                                   index);
                                  //                         },
                                  //                         activeColor: const Color(0XFF024a69),
                                  //                         //checkColor: AppColors.primaryColor.withOpacity(0.05),
                                  //                        // fillColor:  Color(0XFFF2F2F2),
                                  //                         // checkColor: Colors.red,
                                  //                       ),
                                  //                       CommonTextPoppins(
                                  //                         text: item,
                                  //                         fontweight:
                                  //                             FontWeight.w400,
                                  //                         fontsize: 14,
                                  //                         color: AppColors
                                  //                             .blackColor,
                                  //                         talign:
                                  //                             TextAlign.left,
                                  //                       ),
                                  //                     ],
                                  //                   ),
                                  //                   const Divider(
                                  //                     height: 2,
                                  //                   )
                                  //                 ],
                                  //               );
                                  //             }),
                                  //           );
                                  //         }).toList();
                                  //       },
                                  //     );
                                  //   },
                                  // ),
                                
                                ],
                              ),
                            ],
                          ),
                        ),
                        16.sh,
                        Column(
                          children: [
                            // InkWell(
                            //     onTap: () => Navigator.push(
                            //         context,
                            //         MaterialPageRoute(
                            //           builder: (context) =>
                            //               employeeRequestDetailPage(),
                            //         )),
                            //     child: Text("Tap and see Notification Detail!")),
                            Consumer<InboxProvider>(
                              builder: (context, inboxProvider, child) {
                                if (inboxProvider.isLoading &&
                                    inboxProvider.page == 1) {
                                  return const SizedBox();
                                  // const Center(
                                  //   child: CircularProgressIndicator.adaptive(),
                                  // );
                                } else {
                                  if (inboxProvider.search.text.isEmpty) {
                                    return Column(
                                      children: [
                                        //Container(height: 10, width: 10),
                                        SizedBox(
                                          height: height(context) * .6,
                                          child: ListView.builder(
                                              scrollDirection: Axis.vertical,
                                              controller: inboxProvider
                                                  .scrollController,
                                              shrinkWrap: true,
                                              primary: false,
                                              itemCount: inboxProvider
                                                              .allnotificationDetailsdata
                                                              .toString() ==
                                                          "null" ||
                                                      inboxProvider
                                                              .allnotificationDetailsdata ==
                                                          []
                                                  ? 0
                                                  : inboxProvider.allnotificationDetailsdata
                                                                  .toString() ==
                                                              "null" ||
                                                          inboxProvider
                                                                  .allnotificationDetailsdata ==
                                                              []
                                                      ? 0
                                                      : inboxProvider
                                                              .allnotificationDetailsdata
                                                              .length +
                                                          1,
                                              // itemCount: AppConstants
                                              //             .allnotificationDetailsModel
                                              //             .toString() ==
                                              //         "null"
                                              //     ? 0
                                              //     : (AppConstants
                                              //                         .allnotificationDetailsModel!
                                              //                         .notifications!
                                              //                         .length /
                                              //                     10)
                                              //                 .ceil() ==
                                              //             inboxProvider
                                              //                 .paggingPageNumber
                                              //         ? AppConstants
                                              //                 .allnotificationDetailsModel!
                                              //                 .notifications!
                                              //                 .length %
                                              //             10
                                              //         : 10,
                                              itemBuilder: (context, index) {
                                                if (index <
                                                    inboxProvider
                                                        .allnotificationDetailsdata
                                                        .length) {
                                                  return Container(
                                                    color: inboxProvider
                                                                .allnotificationDetailsdata[
                                                                    index]
                                                                .readAt
                                                                .toString() ==
                                                            "null"
                                                        ? const Color(
                                                            0XFFe6f2ff)
                                                        : AppColors
                                                            .pageBackgroundColor,
                                                    child: InkWell(
                                                        onTap: () {
                                                          //read specific notification
                                                          inboxProvider.readSpecificNotification(
                                                              context: context,
                                                              notificationId:
                                                                  inboxProvider
                                                                      .allnotificationDetailsdata[
                                                                          index]
                                                                      .id
                                                                      .toString());
                                                          if (inboxProvider
                                                                  .allnotificationDetailsdata[
                                                                      index]
                                                                  .data!.approveUrl
                                                                  
                                                                  .toString() !=
                                                              "null") {
                                                            Navigator.push(
                                                                context,
                                                                MaterialPageRoute(
                                                                    builder:
                                                                        (context) =>
                                                                            EmployeeRequestDetailPage(
                                                                              data: inboxProvider.allnotificationDetailsdata[index].data,
                                                                              notifiableId: inboxProvider.allnotificationDetailsdata[index].notifiableId.toString(),
                                                                              notificationId: inboxProvider.allnotificationDetailsdata[index].id.toString(),
                                                                              notifiableObject: inboxProvider.allnotificationDetailsdata[index].data,
                                                                            )));
                                                          } else {
                                                         Navigator.push(
                                                                  context,
                                                                  MaterialPageRoute(
                                                                    builder:
                                                                        (context) =>
                                                                           InboxMessageDetail(title: inboxProvider.allnotificationDetailsdata[index].data!.title.toString(),
                                                                            message: inboxProvider.allnotificationDetailsdata[index].data!.message.toString())                                                                  )); 
                                                          // inboxProvider
                                                          //     .changepage(
                                                          //         1, index, 0);
                                                          }
                                                        },
                                                        child:
                                                            InboxCommonNotificationTile(
                                                          title: inboxProvider
                                                              .allnotificationDetailsdata[
                                                                  index]
                                                              .data!
                                                              .title
                                                              .toString(),
                                                          time: Functions.timeAgo(
                                                              inboxProvider
                                                                  .allnotificationDetailsdata[
                                                                      index]
                                                                  .createdAt!),
                                                          readat: inboxProvider
                                                              .allnotificationDetailsdata[
                                                                  index]
                                                              .readAt
                                                              .toString(),
                                                        )
                                                        ),
                                                  );
                                                } else {
                                                  // inboxProvider
                                                  //     .getAllNotifications(context);
                                                  if (inboxProvider.hasmore) {
                                                    return const Align(
                                                        alignment:
                                                            Alignment.center,
                                                        child:
                                                            CircularProgressIndicator
                                                                .adaptive());
                                                  } else {
                                                    return const SizedBox();
                                                  }
                                                }
                                              }),
                                        ),
                                      ],
                                    );
                                  } else if (inboxProvider
                                      .searchlist.isNotEmpty) {
                                    return Column(
                                      children: [
                                        Consumer<InboxProvider>(
                                          builder: (context, inbPro, child) {
                                            return SizedBox(
                                              height: height(context) * .5,
                                              child: ListView.builder(
                                                  itemCount:
                                                      inbPro.searchlist.length,
                                                  // itemCount: (inbPro.searchlist
                                                  //                     .length /
                                                  //                 10)
                                                  //             .ceil() ==
                                                  //         inbPro.paggingPageNumber
                                                  //     ? inbPro.searchlist.length %
                                                  //         10
                                                  //     : 10,
                                                  itemBuilder:
                                                      (context, index) {
                                                    debugPrint(inboxProvider
                                                        .searchlist![
                                                            (inbPro.paggingPageNumber -
                                                                        1) *
                                                                    10 +
                                                                index]
                                                        .data!
                                                        .title
                                                        .toString());
                                                    return Container(
                                                      color: inboxProvider
                                                                  .allnotificationDetailsdata[
                                                                      index]
                                                                  .readAt
                                                                  .toString() ==
                                                              "null"
                                                          ? const Color(
                                                              0XFFe6f2ff)
                                                          : AppColors
                                                              .pageBackgroundColor,
                                                      child: InkWell(
                                                          onTap: () {
                                                            debugPrint(inboxProvider
                                                                .searchlist![
                                                                    (inbPro.paggingPageNumber -
                                                                                1) *
                                                                            10 +
                                                                        index]
                                                                .data!
                                                                .title
                                                                .toString());
                                                            //read specific notification
                                                            inboxProvider.readSpecificNotification(
                                                                context:
                                                                    context,
                                                                notificationId: inboxProvider
                                                                    .searchlist![
                                                                        (inbPro.paggingPageNumber - 1) *
                                                                                10 +
                                                                            index]
                                                                    .id
                                                                    .toString());
                                                            debugPrint(
                                                                "check${inboxProvider.searchlist![(inbPro.paggingPageNumber - 1) * 10 + index].data.approveUrl}");
                                                            if (inboxProvider
                                                                    .searchlist![
                                                                        (inbPro.paggingPageNumber - 1) *
                                                                                10 +
                                                                            index]
                                                                    .data
                                                                    .approveUrl
                                                                    .toString() !=
                                                                "null") {
                                                              Navigator.push(
                                                                  context,
                                                                  MaterialPageRoute(
                                                                    builder:
                                                                        (context) =>
                                                                            EmployeeRequestDetailPage(
                                                                      data: inboxProvider
                                                                          .searchlist![(inbPro.paggingPageNumber - 1) * 10 +
                                                                              index]
                                                                          .data,
                                                                      notifiableId: inboxProvider
                                                                          .searchlist![(inbPro.paggingPageNumber - 1) * 10 +
                                                                              index]
                                                                          .notifiableId
                                                                          .toString(),
                                                                      notificationId: inboxProvider
                                                                          .searchlist![(inbPro.paggingPageNumber - 1) * 10 +
                                                                              index]
                                                                          .id
                                                                          .toString(),
                                                                      notifiableObject: inboxProvider
                                                                          .searchlist![(inbPro.paggingPageNumber - 1) * 10 +
                                                                              index]
                                                                          .data,
                                                                    ),
                                                                  ));
                                                            } else {
                                                            Navigator.push(
                                                                  context,
                                                                  MaterialPageRoute(
                                                                    builder:
                                                                        (context) =>
                                                                           InboxMessageDetail(title: inboxProvider.searchlist![(inbPro.paggingPageNumber - 1) * 10 + index].data.title, message: inboxProvider.searchlist![(inbPro.paggingPageNumber - 1) * 10 + index].data.message)
                                                                  ));
                                                              // inboxProvider.changepage(
                                                              //     1,
                                                              //     (inbPro.paggingPageNumber -
                                                              //                 1) *
                                                              //             10 +
                                                              //         index,
                                                              //     1);
                                                            }
                                                          },
                                                          child:
                                                              InboxCommonNotificationTile(
                                                            title: inboxProvider
                                                                .searchlist![
                                                                    (inbPro.paggingPageNumber -
                                                                                1) *
                                                                            10 +
                                                                        index]
                                                                .data!
                                                                .title
                                                                .toString(),
                                                            //subtitle: "",
                                                            time: Functions.timeAgo(
                                                                inboxProvider
                                                                    .searchlist![
                                                                        (inbPro.paggingPageNumber - 1) *
                                                                                10 +
                                                                            index]
                                                                    .createdAt!),
                                                            readat: inboxProvider
                                                                .searchlist![
                                                                    (inbPro.paggingPageNumber -
                                                                                1) *
                                                                            10 +
                                                                        index]
                                                                .readAt
                                                                .toString(),
                                                          )),
                                                    );
                                                  }),
                                            );
                                          },
                                        ),
                                      ],
                                    );
                                  } else {
                                    return Padding(
                                      padding:
                                          const EdgeInsets.only(left: 25.0),
                                      child: CommonTextPoppins(
                                          text: "No Search Found",
                                          fontweight: FontWeight.w600,
                                          fontsize: 22,
                                          color: AppColors.primaryColor),
                                    );
                                  }
                                }
                              },
                            ),
                            80.sh,
                          ],
                        )
                      ]);
                //}
                //  else {
                //   //notification details
                //   return Padding(
                //     padding: const EdgeInsets.symmetric(horizontal: 24),
                //     child: Column(
                //       mainAxisAlignment: MainAxisAlignment.start,
                //       crossAxisAlignment: CrossAxisAlignment.start,
                //       children: [
                //         ListTile(
                //           minLeadingWidth: 0,
                //           contentPadding: EdgeInsets.zero,
                //           leading: InkWell(
                //               onTap: () {
                //                 // inboxProvider
                //                 //     .refreshInboxIndicatorKey.currentState
                //                 //     ?.show();
                //                 // inboxProvider.changepage(
                //                 //     0, 0, inboxProvider.type);
                //                 //inboxProvider.changePaggeingNumber(1);
                //               },
                //               child: FittedBox(
                //                   child: Icon(
                //                 Icons.arrow_back_ios,
                //                 color: AppColors.textColor,
                //               ))),
                //           title: FittedBox(
                //               child: CommonTextPoppins(
                //                   //here
                //                   text: inboxProvider.type == 0
                //                       ? inboxProvider
                //                           .allnotificationDetailsdata[
                //                               inboxProvider.index]
                //                           .data!
                //                           .title
                //                           .toString()
                //                       : inboxProvider
                //                           .searchlist![inboxProvider.index]!
                //                           .data!
                //                           .title
                //                           .toString(),
                //                   talign: TextAlign.start,
                //                   fontweight: FontWeight.w500,
                //                   fontsize: 14,
                //                   color: AppColors.textColor)),
                //         ),
                //         Container(
                //           margin: const EdgeInsets.only(
                //             top: 16,
                //           ),
                //           padding: const EdgeInsets.all(24),
                //           decoration: BoxDecoration(
                //               borderRadius: BorderRadius.circular(8),
                //               border: Border.all(
                //                 width: 1,
                //                 color: AppColors.textColor.withOpacity(.25),
                //               ),
                //               color: const Color(0XFFfafafa)),
                //           child: Column(
                //             mainAxisSize: MainAxisSize.min,
                //             mainAxisAlignment: MainAxisAlignment.start,
                //             crossAxisAlignment: CrossAxisAlignment.start,
                //             children: [
                //               CommonTextPoppins(
                //                 text:
                //                     "Hi ${AppConstants.loginmodell!.userData!.firstname}",
                //                 fontweight: FontWeight.w500,
                //                 fontsize: 14,
                //                 color: AppColors.textColor,
                //                 talign: TextAlign.left,
                //               ),
                //               CommonTextPoppins(
                //                 text: inboxProvider.type == 0
                //                     ? inboxProvider
                //                         .allnotificationDetailsdata[
                //                             inboxProvider.index]
                //                         .data!
                //                         .message
                //                         .toString()
                //                     : inboxProvider
                //                         .searchlist![inboxProvider.index]!
                //                         .data!
                //                         .message
                //                         .toString(),
                //                 fontweight: FontWeight.w400,
                //                 fontsize: 12,
                //                 color: AppColors.hintTextColor,
                //                 talign: TextAlign.left,
                //               ),
                //             ],
                //           ),
                //         ),
                //       ],
                //     ),
                //   );
                // }
              },
            ),
          )),
        );
      }),
    );
  }
}

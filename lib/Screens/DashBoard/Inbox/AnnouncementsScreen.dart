import 'package:flutter/material.dart';
import 'package:gleam_hr/Components/CommonAppBar.dart';
import 'package:gleam_hr/Components/CommonText.dart';
import 'package:gleam_hr/Screens/DashBoard/Inbox/InboxMessageDetail.dart';
import 'package:gleam_hr/Screens/DashBoard/Inbox/InboxWidget/InboxCommonNotificationTile.dart';
import 'package:gleam_hr/Screens/DashBoard/People/PeopleWidget/PeopleSearchBar.dart';
import 'package:gleam_hr/Utils/AppConstants.dart';
import 'package:gleam_hr/Utils/AppPaths.dart';
import 'package:gleam_hr/Utils/Colors.dart';
import 'package:gleam_hr/Utils/Methods.dart';
import 'package:gleam_hr/Utils/SizedBox.dart';
import 'package:lazy_load_scrollview/lazy_load_scrollview.dart';
import 'package:provider/provider.dart';
import '../../../Providers/DashBoardProviders/AppbarProviders/Announcement_Provider.dart';

class AnnuncementScreen extends StatefulWidget {
  const AnnuncementScreen({super.key});

  @override
  State<AnnuncementScreen> createState() => _AnnuncementScreenState();
}

class _AnnuncementScreenState extends State<AnnuncementScreen> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
    final announcemetProvider = Provider.of<AnnouncementProvider>(context, listen: false);
    announcemetProvider.resetpage();
    announcemetProvider.getAllAnnouncments(context,true);
    });
    super.initState();
  }

  dynamic inboxdetails;
  @override
  Widget build(BuildContext context) {
    if (!mounted) {}
    final announcemetProvider = Provider.of<AnnouncementProvider>(context, listen: false);
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
      body: Consumer<AnnouncementProvider>(builder: (context, provider, child) {
        return SingleChildScrollView(
            child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 30),
          color: AppColors.pageBackgroundColor,
          child: Consumer<AnnouncementProvider>(
            builder: (context, announcemetProvider, child) {
              //if (announcemetProvider.pageval == 0) {
                return Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 24),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
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
                                    text: "Inbox",
                                    fontweight: FontWeight.w600,
                                    fontsize: 20,
                                    color: AppColors.textColor),
                                ],
                            ),
                            14.sh,
                            Row(
                              children: [
                                Expanded(
                                  flex: 1,
                                  child: PeopleSearchBar(
                                    controller: announcemetProvider.search,
                                    onvaluechange: (value) {
                                      //announcemetProvider.changePaggeingNumber(1);
                                      if (value.isEmpty) {
                                        announcemetProvider.searchlist = [];
                                        debugPrint("valueempty");
                                        announcemetProvider.hitupdate();
                                        return;
                                      }
                                      announcemetProvider.searchlist = announcemetProvider
                                          .allnotificationdata
                                          .where((element) => element
                                              .title
                                              .toString()
                                              .toLowerCase()
                                              .contains(value
                                                  .toString()
                                                  .toLowerCase()))
                                          .toList();
                                      announcemetProvider.hitupdate();
                                    },
                                  ),
                                ),
                                4.sw,
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
                          Consumer<AnnouncementProvider>(
                            builder: (context, announcemetProvider, child) {
                              if (announcemetProvider.isLoading &&
                                  announcemetProvider.page == 1) {
                                return const Center(
                                  child: CircularProgressIndicator.adaptive(),
                                );
                              } else {
                                if (announcemetProvider.search.text.isEmpty) {
                                  return SizedBox(
                                    height: height(context) * .6,
                                    child: LazyLoadScrollView(
                                      onEndOfPage: () {
                                        debugPrint("tttend of page");
                                        debugPrint("tttpage${announcemetProvider.page}");
                                        debugPrint("ttttotal${AppConstants.announcementModel!.totalPages}");
                                        if ((AppConstants.announcementModel!.totalPages!) >= (announcemetProvider.page)) {
                                        if (!announcemetProvider.isLoading) {
                                        announcemetProvider.getAllAnnouncments(context,true);
                                        }
                                        }
                                      },
                                      child: ListView.builder(
                                          scrollDirection: Axis.vertical,
                                          controller: announcemetProvider
                                              .scrollController,
                                          shrinkWrap: true,
                                          primary: false,
                                          itemCount: announcemetProvider.allnotificationdata.length + 1,
                                          itemBuilder: (context, index) {
                                            if (index<AppConstants.announcementModel!.data!.length) {
                                              return Container(
                                                color: AppColors
                                                          .pageBackgroundColor,
                                                child: InkWell(
                                                    onTap: () {
                                                      //read specific notification
                                                      announcemetProvider.readSpecificNotification(
                                                          context: context,
                                                          notificationId:
                                                              announcemetProvider
                                                                  .allnotificationdata[
                                                                      index]
                                                                  .id
                                                                  .toString());
                                                      
                                                        Navigator.push(
                                                            context,
                                                            MaterialPageRoute(
                                                                builder:
                                                                    (context) =>
                                                                        InboxMessageDetail(title: announcemetProvider.allnotificationdata[index].title.toString(),
                                                                        message: announcemetProvider.allnotificationdata[index].description.toString()
                                                                        ) 
                                                                        )
                                                                        );
                                                    },
                                                    child:
                                                        InboxCommonNotificationTile(
                                                      title: announcemetProvider
                                                          .allnotificationdata[
                                                              index]
                                                          .title
                                                          .toString(),
                                                      time: Functions.timeAgo(
                                                          announcemetProvider
                                                              .allnotificationdata[
                                                                  index]
                                                              .createdAt!), readat: '',
                                                    )
                                                    ),
                                              );
                                            } else {
                                              if (announcemetProvider.isLoading) {
                                                return const Center(child: CircularProgressIndicator.adaptive());
                                              }else{
                                                return const SizedBox();
                                              }
                                            }
                                          }),
                                    ),
                                  );
                                } else if (announcemetProvider
                                    .searchlist.isNotEmpty) {
                                  return Column(
                                    children: [
                                      Consumer<AnnouncementProvider>(
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
                                                  return InkWell(
                                                    onTap: () {
                                                      Navigator.push(
                                                            context,
                                                            MaterialPageRoute(
                                                                builder:
                                                                    (context) =>
                                                                        InboxMessageDetail(title: announcemetProvider.allnotificationdata[index].title.toString(),
                                                                        message: announcemetProvider.allnotificationdata[index].description.toString()
                                                                        ) 
                                                                        )
                                                                        );
                                                    },
                                                    child: Container(
                                                      color: AppColors
                                                              .pageBackgroundColor,
                                                      child: InboxCommonNotificationTile(
                                                            title: announcemetProvider.searchlist[index].title.toString(),
                                                            //subtitle: "",
                                                            time: Functions.timeAgo(
                                                        announcemetProvider.searchlist[index].createdAt),
                                                            readat: '',
                                                          ),
                                                    ),
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
              //                 // announcemetProvider
              //                 //     .refreshInboxIndicatorKey.currentState
              //                 //     ?.show();
              //                 // announcemetProvider.changepage(
              //                 //     0, 0, announcemetProvider.type);
              //                 //announcemetProvider.changePaggeingNumber(1);
              //               },
              //               child: FittedBox(
              //                   child: Icon(
              //                 Icons.arrow_back_ios,
              //                 color: AppColors.textColor,
              //               ))),
              //           title: FittedBox(
              //               child: CommonTextPoppins(
              //                   //here
              //                   text: announcemetProvider.type == 0
              //                       ? announcemetProvider
              //                           .allnotificationdata[
              //                               announcemetProvider.index]
              //                           .data!
              //                           .title
              //                           .toString()
              //                       : announcemetProvider
              //                           .searchlist![announcemetProvider.index]!
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
              //                 text: announcemetProvider.type == 0
              //                     ? announcemetProvider
              //                         .allnotificationdata[
              //                             announcemetProvider.index]
              //                         .data!
              //                         .message
              //                         .toString()
              //                     : announcemetProvider
              //                         .searchlist![announcemetProvider.index]!
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
        ));
      }),
    );
  }
}

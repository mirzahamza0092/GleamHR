import 'package:cached_network_image/cached_network_image.dart';
import 'package:gleam_hr/Providers/DashBoardProviders/MoreProviders/LiveLocation_Provider.dart';
import 'package:flutter/material.dart';
import 'package:gleam_hr/Components/CommonAppBar.dart';
import 'package:gleam_hr/Components/CommonButton.dart';
import 'package:gleam_hr/Components/CommonText.dart';
import 'package:gleam_hr/Screens/DashBoard/More/MoreScreens/ViewEmplyeeLocation.dart';
import 'package:gleam_hr/Utils/AppConstants.dart';
import 'package:gleam_hr/Utils/AppPaths.dart';
import 'package:gleam_hr/Utils/Colors.dart';
import 'package:gleam_hr/Utils/SizedBox.dart';
import 'package:lazy_load_scrollview/lazy_load_scrollview.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';

class TrackedEmployees extends StatefulWidget {
  const TrackedEmployees({super.key});

  @override
  State<TrackedEmployees> createState() => _TrackedEmployeesState();
}

class _TrackedEmployeesState extends State<TrackedEmployees> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final liveLocationProvider =
          Provider.of<LiveLocationProvider>(context, listen: false);
      liveLocationProvider.resetpage();
      liveLocationProvider.getAllTrackedEmployee(context);
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
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: Column(children: [
            15.sh,
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
                    ))),
                7.sw,
                CommonTextPoppins(
                    talign: TextAlign.left,
                    text: "Tracked Employees",
                    fontweight: FontWeight.w600,
                    fontsize: 20,
                    color: AppColors.textColor),
              ],
            ),
            10.sh,
            SizedBox(
                height: height(context) * .75,
                child: Consumer<LiveLocationProvider>(
                    builder: (context, liveLocationProvider, child) {
                  if (liveLocationProvider.isLoading &&
                      liveLocationProvider.page == 1) {
                    return const Center(
                      child: CircularProgressIndicator.adaptive(),
                    );
                  } else {
                    return LazyLoadScrollView(
                        onEndOfPage: () {
                          if ((AppConstants
                                  .allTrackedEmployee!.data!.lastPage!) >=
                              (liveLocationProvider.page)) {
                            if (!liveLocationProvider.isLoading) {
                              liveLocationProvider
                                  .getAllTrackedEmployee(context);
                            }
                          }
                        },
                        child: ListView.builder(
                            itemCount: AppConstants
                                    .allTrackedEmployee!.data!.data!.length +
                                1,
                            // physics: const NeverScrollableScrollPhysics(),
                            itemBuilder: (context, index) {
                              if (index <
                                  AppConstants
                                      .allTrackedEmployee!.data!.data!.length) {
                                return ListTile(
                                  contentPadding:const EdgeInsets.only(bottom: 15),
                                  leading: AppConstants.allTrackedEmployee!.data!.data![index].picture.toString() ==
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
                                                                  "https://${Keys.domain}.gleamhrm.com/${AppConstants.allTrackedEmployee!.data!.data![index].picture.toString()}",
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
                                    text: AppConstants.allTrackedEmployee!.data!
                                        .data![index].firstname
                                        .toString(),
                                    color: AppColors.textColor,
                                    fontsize: 16,
                                    fontweight: FontWeight.w500,
                                    talign: TextAlign.start,
                                  ),
                                  trailing: CommonButton(
                                    onPressed: () {
                                      Navigator.of(context).push(PageTransition(
                                      type: PageTransitionType.bottomToTop,
                                      child: ViewEmplyeeLocation(userId: AppConstants.allTrackedEmployee!.data!.data![index].id.toString(),),
                                      duration: const Duration(milliseconds: 600)));
                                    },
                                    width: width(context) * .35,
                                    height: height(context) * .06,
                                    text: "View Location",
                                    shadowneeded: false,
                                  ),
                                );
                              } else {
                                if (liveLocationProvider.isLoading) {
                                  return const Center(
                                      child:
                                          CircularProgressIndicator.adaptive());
                                } else {
                                  return const SizedBox();
                                }
                              }
                            }));
                  }
                }))
          ]),
        ));
  }
}

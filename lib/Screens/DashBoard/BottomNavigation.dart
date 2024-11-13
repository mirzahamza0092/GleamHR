import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gleam_hr/Components/CommonText.dart';
import 'package:gleam_hr/Providers/BottomNavigationProvider/BottomBarIcon_Provider.dart';
import 'package:gleam_hr/Providers/BottomNavigationProvider/BottomNavigation_Provider.dart';
import 'package:gleam_hr/Utils/Colors.dart';
import 'package:gleam_hr/Utils/GradiendWidget.dart';
import 'package:gleam_hr/Utils/SizedBox.dart';
import 'package:provider/provider.dart';

class BottomNavigation extends StatelessWidget {
  const BottomNavigation({super.key});

  @override
  Widget build(BuildContext context) {
    final bottomNavProvider =
        Provider.of<BottomNavigationProvider>(context, listen: false);
    return WillPopScope(
      onWillPop: () async {
        return await showDialog(
          context: context,
          builder: (context) => AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            elevation: 0,
            title:const Text('Exit App'),
            content:const Text('Do you want to exit GleamHR?'),
            actions: [
              ElevatedButton(
                onPressed: () => Navigator.of(context).pop(false),
                //return false when click on "NO"
                child: const Text('No'),
              ),
              ElevatedButton(
                onPressed: () => Navigator.of(context).pop(true),
                //return true when click on "Yes"
                child: const Text('Yes'),
              ),
            ],
          ),
        );
      },
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: AppColors.pageBackgroundColor,
        body: SizedBox(
          height: height(context),
          child: Stack(
            alignment: Alignment.bottomCenter,
            children: [
              Consumer<BottomNavigationProvider>(
                builder: (context, navProvider, child) {
                  return navProvider.screenlist[navProvider.bottomnavindex];
                },
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                              color: AppColors.hintTextColor.withOpacity(.25),
                              spreadRadius: -4,
                              blurRadius: 32,
                              offset: const Offset(0, 3))
                        ],
                        borderRadius: BorderRadius.circular(8),
                        color: Colors.white,
                      ),
                      margin: const EdgeInsets.symmetric(horizontal: 20),
                      child: Consumer<BottomNavigationProvider>(
                        builder: (context, bottomNavProvider, child) {
                          return AnimatedBottomNavigationBar.builder(
                            safeAreaValues:
                                const SafeAreaValues(top: false, bottom: false),
                            elevation: 0,
                            height: 65,
                            backgroundColor: Colors.transparent,
                            activeIndex: bottomNavProvider.bottomnavindex,
                            gapLocation: GapLocation.center,
                            notchSmoothness: NotchSmoothness.defaultEdge,
                            // leftCornerRadius: 24,
                            // rightCornerRadius: 24,
                            onTap: (index) {
                              bottomNavProvider.onPagechanged(index);
                            },
                            itemCount: 4,
                            tabBuilder: (int index, bool isActive) {
                              return Column(
                                mainAxisSize: MainAxisSize.min,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Image.asset(
                                    bottomNavProvider.iconslist[index],
                                    color: isActive? AppColors.primaryColor:AppColors.hintTextColor,
                                    width: 20,
                                    height: 20,
                                  ),
                                  CommonTextPoppins(
                                      text: bottomNavProvider.textlist[index],
                                      fontweight: FontWeight.w500,
                                      fontsize: 12,
                                      color: isActive
                                          ? AppColors.primaryColor
                                          : AppColors.hintTextColor
                                              .withOpacity(0.75)),
                                  isActive
                                      ? Container(
                                          width: 4,
                                          height: 4,
                                          decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            color: AppColors.primaryColor,
                                          ),
                                        )
                                      : Container(),
                                ],
                              );
                            },
                            //other params
                          );
                        },
                      ),
                    ),
                    Container(
                      color: AppColors.pageBackgroundColor,
                      height: 20,
                    ),
                  ],
                ),
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                          gradient: horizontalgradientwidget,
                          // boxShadow: [
                          //   BoxShadow(
                          //       offset: const Offset(0, 5),
                          //       blurRadius: 0,
                          //       spreadRadius: 4,
                          //       color: AppColors.pageBackgroundColor),
                          // ],
                          shape: BoxShape.circle),
                      child: FloatingActionButton(
                        child:const Icon(Icons.add),
                        onPressed: () {
                        // write code for shuffle cards
                        showModalBottomSheet(
                          shape: const RoundedRectangleBorder( // <-- SEE HERE
                            borderRadius: BorderRadius.vertical( 
                              top: Radius.circular(24.0),
                            ),
                          ),
                          showDragHandle: true,
                          elevation: 0,
                          useRootNavigator: true,
                          useSafeArea: true,
                          context: context, builder: (context) {
                          return Container(
                          height: height(context)*.75,
                          width: width(context),
                          padding:const EdgeInsets.symmetric(horizontal: 24),
                          color: AppColors.whiteColor,
                          child: SingleChildScrollView(
                            child: Column(
                              children: [
                                CommonTextPoppins(text: "You can select Only 5 widgets at once", fontweight: FontWeight.w500, fontsize: 12, color: AppColors.hintTextColor),
                                16.sh,
                                Consumer<BottomBarIconProvider>(
                                  builder: (context, bottomNavProvider, child) {
                                    return SizedBox(
                                  child: GridView.builder(shrinkWrap: true,
                                      padding: EdgeInsets.zero,
                                      physics:const NeverScrollableScrollPhysics(),
                                      gridDelegate:
                                      const SliverGridDelegateWithMaxCrossAxisExtent(
                                    maxCrossAxisExtent: 200,
                                     mainAxisExtent: 100,
                                     childAspectRatio: 2,
                                     crossAxisSpacing: 16,
                                     mainAxisSpacing: 18
                                    ),
                                    itemCount: bottomNavProvider.bottomBarAddContent.length,
                                  itemBuilder: (context, index) {
                                      return Visibility(visible: bottomNavProvider.bottomBarAddContent[index].showWidget, child: InkWell(
                                      onTap: () {
                                        
                                      },
                                      child: Stack(
                                        children: [
                                          Container(
                                            child: Center(child: Column(
                                              mainAxisSize: MainAxisSize.min,
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              crossAxisAlignment: CrossAxisAlignment.center,
                                              children: [
                                              SvgPicture.asset(bottomNavProvider.bottomBarAddContent[index].imagePath),
                                              16.sh,
                                              CommonTextPoppins(text: bottomNavProvider.bottomBarAddContent[index].title, fontweight: FontWeight.w400, fontsize: 14, color: AppColors.textColor),
                                            ],)),
                                            decoration: BoxDecoration(boxShadow: [BoxShadow(blurRadius: 4,spreadRadius: 0,offset:const Offset(0, 4),color: AppColors.blackColor.withOpacity(.09))], borderRadius: BorderRadius.circular(12),color: AppColors.whiteColor,),
                                            ),
                                            Positioned(right: 5, child: Container(decoration: BoxDecoration(borderRadius: BorderRadius.circular(50)), child: Checkbox(shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(5)), value: bottomNavProvider.bottomBarAddContent[index].isCheck,activeColor:const Color(0XFF024a69), onChanged: (value){
                                              bottomNavProvider.changebottomBarAddContentActiveness(index, value!);
                                            }))),
                                        ],
                                      ),
                                    ));
                                    
                                    },),
                                );
                             
                                  },
                                ),
                                 ],
                            ),
                          ),

                          );
                        },);
                        },
                      ),
                    ),
                    26.sh,
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
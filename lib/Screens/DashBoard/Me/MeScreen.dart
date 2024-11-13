import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gleam_hr/Components/CommonAppBar.dart';
import 'package:gleam_hr/Components/CommonText.dart';
import 'package:gleam_hr/Components/CommonTextField.dart';
import 'package:gleam_hr/Providers/DashBoardProviders/DashBoard_Provider.dart';
import 'package:gleam_hr/Providers/DashBoardProviders/MeProviders/MeScreen_Provider.dart';
import 'package:gleam_hr/Screens/DashBoard/Me/MeWidget/LogOutButton.dart';
import 'package:gleam_hr/Screens/DashBoard/Me/MeWidget/UpdateButton.dart';
import 'package:gleam_hr/Screens/DashBoard/Me/MeWidget/meScreenInfoWidget.dart';
import 'package:gleam_hr/Utils/AppConstants.dart';
import 'package:gleam_hr/Utils/AppPaths.dart';
import 'package:gleam_hr/Utils/Colors.dart';
import 'package:gleam_hr/Utils/DialogBoxes.dart';
import 'package:gleam_hr/Utils/SizedBox.dart';
import 'package:provider/provider.dart';

import '../../../Components/commonSnakbar.dart';

class MeScreen extends StatefulWidget {
  const MeScreen({super.key});

  @override
  State<MeScreen> createState() => _MeScreenState();
}

class _MeScreenState extends State<MeScreen> {
  @override
  void initState() {
    AppConstants.auth.isDeviceSupported().then(
          (bool value) => context
              .read<MeScreenProvider>()
              .changeDeviceBioMetricAvailability(value),
        );
    context.read<MeScreenProvider>().firstname.text =
        AppConstants.loginmodell!.userData!.firstname.toString() == "null"
            ? ""
            : "${AppConstants.loginmodell!.userData!.firstname}";
    context.read<MeScreenProvider>().lastname.text =
        AppConstants.loginmodell!.userData!.lastname.toString() == "null"
            ? ""
            : "${AppConstants.loginmodell!.userData!.lastname}";
    context.read<MeScreenProvider>().email.text =
        AppConstants.loginmodell!.userData!.officialEmail.toString() == "null"
            ? "No Email Found"
            : AppConstants.loginmodell!.userData!.officialEmail.toString();
    context.read<MeScreenProvider>().gender.text =
        AppConstants.loginmodell!.userData!.gender.toString() == "null"
            ? "Not Found"
            : "${AppConstants.loginmodell!.userData!.gender}";
    context.read<MeScreenProvider>().dob.text =
        AppConstants.loginmodell!.userData!.dateOfBirth.toString() == "null"
            ? "Not Found"
            : AppConstants.loginmodell!.userData!.dateOfBirth.toString().substring(0,10);
            context.read<MeScreenProvider>().martialStatus.text =
    AppConstants.loginmodell!.userData!.maritalStatus.toString() == "null"
            ? "Not Found"
            : "${AppConstants.loginmodell!.userData!.maritalStatus}";
    context.read<MeScreenProvider>().phone.text =
        AppConstants.loginmodell!.userData!.contactNo.toString() == "null"
            ? "No Contact Found"
            : AppConstants.loginmodell!.userData!.contactNo.toString();
    context.read<MeScreenProvider>().address.text =
        AppConstants.loginmodell!.userData!.currentAddress.toString() == "null"
            ? "No Address Found"
            : AppConstants.loginmodell!.userData!.currentAddress.toString();
    context.read<MeScreenProvider>().fatherName.text =
        AppConstants.loginmodell!.userData!.fatherName.toString() == "null"
            ? ""
            : AppConstants.loginmodell!.userData!.fatherName.toString();
    context.read<MeScreenProvider>().motherName.text =
        AppConstants.loginmodell!.userData!.motherName.toString() == "null"
            ? ""
            : AppConstants.loginmodell!.userData!.motherName.toString();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final meScreenProvider =
        Provider.of<MeScreenProvider>(context, listen: false);

    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: AppColors.whiteColor,
      appBar: PreferredSize(
          preferredSize: Size(width(context), 120),
          child: Consumer<DashBoardProvider>(
            builder: (context, dashBoardProvider, child) {
              return CommonAppBar(
                  subtitle:
                      "${AppConstants.loginmodell!.userData!.firstname} ${(AppConstants.loginmodell!.userData!.lastname).toString() == "null" ? "" : AppConstants.loginmodell!.userData!.lastname} ",
                  trailingimagepath:
                      "https://${Keys.domain}.gleamhrm.com/${AppConstants.loginmodell!.userData!.picture}");
            },
          )),
      body: Consumer<MeScreenProvider>(builder: (context, provider, child) {
        return SingleChildScrollView(
          // physics: NeverScrollableScrollPhysics(),
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
          padding:
              const EdgeInsets.only(left: 24, right: 24, top: 12, bottom: 12),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CommonTextPoppins(
                      text: "My Profile",
                      fontweight: FontWeight.w600,
                      fontsize: 20,
                      color: AppColors.textColor),
                  const LogOutButton(),
                ],
              ),
              10.sh,
              Form(
                  key: meScreenProvider.Mescreenkey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15),
                              color: AppColors.primaryColor,
                              image: DecorationImage(
                                colorFilter: ColorFilter.mode(
                                    Colors.black.withOpacity(0.2),
                                    BlendMode.dstATop),
                                fit: BoxFit.cover,
                                image: NetworkImage(
                                  {
                                            AppConstants
                                                .loginmodell!.userData!.picture
                                                .toString()
                                          } ==
                                          "null"
                                      ? ""
                                      : "https://${Keys.domain}.gleamhrm.com/${AppConstants.loginmodell!.userData!.picture}",
                                ),
                              ),
                            ),
                            width: width(context),
                            child: Row(
                              children: [
                                Consumer<MeScreenProvider>(
                                  builder: (context, meScreenProvider, child) {
                                    if (meScreenProvider.selectdFile != null) {
                                      return Stack(
                                        children: [
                                          Container(
                                            margin: const EdgeInsets.symmetric(
                                                vertical: 10, horizontal: 10),
                                            width: 80,
                                            height: 80,
                                            decoration: BoxDecoration(
                                              image: DecorationImage(
                                                  fit: BoxFit.fill,
                                                  image: FileImage(
                                                    meScreenProvider
                                                        .selectdFile!,
                                                  )),
                                              boxShadow: [
                                                BoxShadow(
                                                    color: AppColors.whiteColor
                                                        .withOpacity(.25),
                                                    spreadRadius: 5,
                                                    offset: const Offset(0, 0)),
                                              ],
                                              shape: BoxShape.circle,
                                              color: AppColors.whiteColor,
                                            ),
                                          ),
                                          Positioned(
                                              right: 5,
                                              top: 10,
                                              child: InkWell(
                                                onTap: () {
                                                  CommonDialogBoxes
                                                      .pickImageDialog(context,
                                                          meScreenProvider);
                                                },
                                                child: Container(
                                                  height: 26,
                                                  width: 26,
                                                  decoration:
                                                      const BoxDecoration(
                                                          shape:
                                                              BoxShape.circle,
                                                          color: Colors.white),
                                                  child: const Center(
                                                    child: Icon(
                                                      CupertinoIcons.camera,
                                                      size: 18,
                                                    ),
                                                  ),
                                                ),
                                              ))
                                        ],
                                      );
                                    } else {
                                      return Expanded(
                                          flex: 2,
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 0, horizontal: 10),
                                            child: Stack(
                                              children: [
                                                CachedNetworkImage(
                                                    imageUrl:
                                                        "https://${Keys.domain}.gleamhrm.com/${AppConstants.loginmodell!.userData!.picture.toString()}",
                                                    imageBuilder: (context,
                                                            imageProvider) =>
                                                        Container(
                                                          margin:
                                                              const EdgeInsets
                                                                      .symmetric(
                                                                  vertical: 10),
                                                          width: 80,
                                                          height: 80,
                                                          decoration:
                                                              BoxDecoration(
                                                            image: DecorationImage(
                                                                fit:
                                                                    BoxFit.fill,
                                                                image:
                                                                    imageProvider),
                                                            boxShadow: [
                                                              BoxShadow(
                                                                  color: AppColors
                                                                      .whiteColor
                                                                      .withOpacity(
                                                                          .25),
                                                                  spreadRadius:
                                                                      5,
                                                                  offset:
                                                                      const Offset(
                                                                          0,
                                                                          0)),
                                                            ],
                                                            shape:
                                                                BoxShape.circle,
                                                            color: AppColors
                                                                .whiteColor,
                                                          ),
                                                          //child: imageProvider,
                                                        ),
                                                    placeholder: (context,
                                                            url) =>
                                                        AppConstants
                                                                    .loginmodell!
                                                                    .userData!
                                                                    .picture
                                                                    .toString() ==
                                                                "null"
                                                            ? Container(
                                                                margin: const EdgeInsets
                                                                        .symmetric(
                                                                    vertical:
                                                                        10),
                                                                width: 80,
                                                                height: 80,
                                                                decoration:
                                                                    BoxDecoration(
                                                                  image:
                                                                      DecorationImage(
                                                                          image:
                                                                              AssetImage(
                                                                    ImagePath
                                                                        .profiledummyimage,
                                                                  )),
                                                                  boxShadow: [
                                                                    BoxShadow(
                                                                        color: AppColors
                                                                            .whiteColor
                                                                            .withOpacity(
                                                                                .25),
                                                                        spreadRadius:
                                                                            5,
                                                                        offset: const Offset(
                                                                            0,
                                                                            0)),
                                                                  ],
                                                                  shape: BoxShape
                                                                      .circle,
                                                                  color: AppColors
                                                                      .whiteColor,
                                                                ),
                                                              )
                                                            : CircularProgressIndicator(
                                                                color: AppColors
                                                                    .whiteColor),
                                                    errorWidget:
                                                        (context, url, error) {
                                                      debugPrint("objecterror$url");
                                                      return Container(
                                                        margin: const EdgeInsets
                                                                .symmetric(
                                                            vertical: 10),
                                                        width: 80,
                                                        height: 80,
                                                        decoration:
                                                            BoxDecoration(
                                                          image: DecorationImage(
                                                              fit: BoxFit.fill,
                                                              image: AssetImage(
                                                                ImagePath
                                                                    .profiledummyimage,
                                                              )),
                                                          boxShadow: [
                                                            BoxShadow(
                                                                color: AppColors
                                                                    .whiteColor
                                                                    .withOpacity(
                                                                        .25),
                                                                spreadRadius: 5,
                                                                offset:
                                                                    const Offset(
                                                                        0, 0)),
                                                          ],
                                                          shape:
                                                              BoxShape.circle,
                                                          color: AppColors
                                                              .whiteColor,
                                                        ),
                                                        // child: SvgPicture.asset(
                                                        //   ImagePath.profileIcon,
                                                        // ),
                                                      );
                                                    }),
                                                Positioned(
                                                    right: 5,
                                                    top: 10,
                                                    child: InkWell(
                                                      onTap: () {
                                                        CommonDialogBoxes
                                                            .pickImageDialog(
                                                                context,
                                                                meScreenProvider);
                                                      },
                                                      child: Container(
                                                        height: 26,
                                                        width: 26,
                                                        decoration:
                                                            const BoxDecoration(
                                                                shape: BoxShape
                                                                    .circle,
                                                                color: Colors
                                                                    .white),
                                                        child: const Center(
                                                          child: Icon(
                                                            CupertinoIcons
                                                                .camera,
                                                            size: 18,
                                                          ),
                                                        ),
                                                      ),
                                                    )
                                                    )
                                              ],
                                            ),
                                          )
                                          );
                                    }
                                  },
                                ),
                                Expanded(
                                  flex: 4,
                                  child: Container(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 0, horizontal: 10),
                                      child: Consumer<DashBoardProvider>(
                                        builder: (context, dashboardprovider,
                                            child) {
                                          return Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              CommonTextPoppins(
                                                  text:
                                                      "${AppConstants.loginmodell!.userData!.firstname} ${(AppConstants.loginmodell!.userData!.lastname).toString() == "null" ? "" : AppConstants.loginmodell!.userData!.lastname} ",
                                                  fontweight: FontWeight.w600,
                                                  fontsize: 16,
                                                  talign: TextAlign.left,
                                                  color: AppColors.whiteColor),
                                              CommonTextPoppins(
                                                  text: AppConstants
                                                              .loginmodell!
                                                              .userData!
                                                              .designation
                                                              .toString() ==
                                                          "null"
                                                      ? "No Designation"
                                                      : AppConstants
                                                          .loginmodell!
                                                          .userData!
                                                          .designation[
                                                              "designation_name"]
                                                          .toString(),
                                                  fontweight: FontWeight.w400,
                                                  talign: TextAlign.left,
                                                  fontsize: 14,
                                                  color: AppColors.whiteColor),
                                            ],
                                          );
                                        },
                                      )),
                                ),
                              ],
                            ),
                          ),
                          20.sh,
                          //enable bio metric widget
                          // Consumer<MeScreenProvider>(
                          //   builder: (context, MeScreenProvider, child) {
                          //     if (AppConstants.supportstate) {
                          //       return Row(
                          //         mainAxisAlignment:
                          //             MainAxisAlignment.spaceBetween,
                          //         children: [
                          //           const Text("Enable BioMetric"),
                          //           Switch.adaptive(
                          //               value:
                          //                   MeScreenProvider.enabledBioMetric,
                          //               onChanged: (bool v) async {
                          //                 List<BiometricType> biotypes = [];
                          //                 biotypes = await AppConstants.auth
                          //                     .getAvailableBiometrics();
                          //                 debugPrint("Biometric Types$biotypes");
                          //                 MeScreenProvider
                          //                     .changeEnabledBioMetric(v);
                          //                 if (v) {
                          //                   showDialog(
                          //                       context: context,
                          //                       builder:
                          //                           (BuildContext context) {
                          //                         return CustomDialogBox(
                          //                           title:
                          //                               "You have to enter credentials first time when login",
                          //                           text: "OK",
                          //                           img: Image.asset(ImagePath
                          //                               .dialogBoxImage),
                          //                         );
                          //                       });
                          //                 }
                          //               }),
                          //         ],
                          //       );
                          //     } else {
                          //       return const SizedBox();
                          //     }
                          //   },
                          // ),
                          meScreenInfoWidget(),
                          13.sh, 
                          meScreenProvider.personalInfo==false?
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                          CommonTextPoppins(
                            text: "Official Email",
                            fontweight: FontWeight.w500,
                            fontsize: 12,
                            color: AppColors.hintTextColor,
                            talign: TextAlign.left,
                          ),
                          4.sh,
                          CommonTextField2(
                            hinttext: "",
                            controller: TextEditingController(text: AppConstants.loginmodell!.userData!.personalEmail.toString()=="null"?"Not found":AppConstants.loginmodell!.userData!.personalEmail.toString()),
                            isEditable: false,
                          ),
                          16.sh,
                          Row(children: [
                            Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                              CommonTextPoppins(
                            text: "Designation",
                            fontweight: FontWeight.w500,
                            fontsize: 12,
                            color: AppColors.hintTextColor,
                            talign: TextAlign.left,
                          ),
                          4.sh,
                          CommonTextField2(
                            hinttext: "",
                            controller: TextEditingController(text: AppConstants.loginmodell!.userData!.designation.toString()=="null"?"Not found":AppConstants.loginmodell!.userData!.designation["designation_name"].toString()),
                            isEditable: false,
                          ),
                            ],)),
                            10.sw,
                            Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                              CommonTextPoppins(
                            text: "Department",
                            fontweight: FontWeight.w500,
                            fontsize: 12,
                            color: AppColors.hintTextColor,
                            talign: TextAlign.left,
                          ),
                          4.sh,
                          CommonTextField2(
                            hinttext: "",
                            controller: TextEditingController(text: AppConstants.loginmodell!.userData!.department.toString()=="null"?"Not found":AppConstants.loginmodell!.userData!.department["department_name"].toString()),
                            isEditable: false,
                          ),
                            ],)),
                            ],),
                          16.sh,
                          Row(children: [
                            Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                              CommonTextPoppins(
                            text: "Report To",
                            fontweight: FontWeight.w500,
                            fontsize: 12,
                            color: AppColors.hintTextColor,
                            talign: TextAlign.left,
                          ),
                          4.sh,
                          CommonTextField2(
                            hinttext: "",
                            controller: TextEditingController(text: "Not Available"),
                            isEditable: false,
                          ),
                            ],)),
                            10.sw,
                            Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                              CommonTextPoppins(
                            text: "Employment Status",
                            fontweight: FontWeight.w500,
                            fontsize: 12,
                            color: AppColors.hintTextColor,
                            talign: TextAlign.left,
                          ),
                          4.sh,
                          CommonTextField2(
                            hinttext: "",
                            controller: TextEditingController(text: "Not Available"),
                            isEditable: false,
                          ),
                            ],)),
                            ],),
                          16.sh,
                          CommonTextPoppins(
                            text: "Leads To",
                            fontweight: FontWeight.w500,
                            fontsize: 12,
                            color: AppColors.hintTextColor,
                            talign: TextAlign.left,
                          ),
                          4.sh,
                          CommonTextField2(
                            hinttext: "",
                            controller: TextEditingController(text: "Not Found"),
                            isEditable: false,
                          ),
                          16.sh,
                          Row(children: [
                            Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [CommonTextPoppins(
                            text: "Work Schedule",
                            fontweight: FontWeight.w500,
                            fontsize: 12,
                            color: AppColors.hintTextColor,
                            talign: TextAlign.left,
                          ),
                          4.sh,
                          CommonTextField2(
                            hinttext: "",
                            controller: TextEditingController(text: AppConstants.loginmodell!.userWorkSchedule.toString()=="null"?"Not found":AppConstants.loginmodell!.userWorkSchedule!.workSchedule["title"].toString()),
                            isEditable: false,
                          ),],)),
                            10.sw,
                            Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                              CommonTextPoppins(
                            text: "Hiring Date",
                            fontweight: FontWeight.w500,
                            fontsize: 12,
                            color: AppColors.hintTextColor,
                            talign: TextAlign.left,
                          ),
                          4.sh,
                          CommonTextField2(
                            hinttext: "",
                            controller: TextEditingController(text: "Not Found"),
                            isEditable: false,
                          ),
                            ],)),
                            ],),
                          ],):
                          Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                          Row(children: [
                            Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                            CommonTextPoppins(
                            text: "First Name",
                            fontweight: FontWeight.w500,
                            fontsize: 12,
                            color: AppColors.hintTextColor,
                            talign: TextAlign.left,
                          ),
                          4.sh,
                          CommonTextField2(
                            hinttext: "First Name",
                            controller:
                                context.read<MeScreenProvider>().firstname,
                            isEditable: true,
                            validator: (value) {
                              if (value.isEmpty) {
                                return "FirstName must not \n be Empty";
                              } else if (value.length < 3) {
                                return "First Name must\n be greater than 2 \n characters";
                              } else {
                                return null;
                              }
                            },
                          ),
                            ],)),
                            20.sw,
                            Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              CommonTextPoppins(
                            text: "Last Name",
                            fontweight: FontWeight.w500,
                            fontsize: 12,
                            color: AppColors.hintTextColor,
                            talign: TextAlign.left,
                          ),
                          4.sh,
                          CommonTextField2(
                            hinttext: "Last Name",
                            controller:
                                context.read<MeScreenProvider>().lastname,
                            isEditable: true,
                            validator: (value) {
                              if (value.isEmpty) {
                                return null;
                              } else if (value.length < 3) {
                                return "Last Name must\n be greater than 2\n characters";
                              } else {
                                return null;
                              }
                            },
                          ),
                            ],)),
                          ],),
                          10.sh,
                          CommonTextPoppins(
                            text: "Email",
                            fontweight: FontWeight.w500,
                            fontsize: 12,
                            color: AppColors.hintTextColor,
                            talign: TextAlign.left,
                          ),
                          4.sh,
                          CommonTextField2(
                            hinttext: "Enter Email",
                            controller: context.read<MeScreenProvider>().email,
                            isEditable: false,
                          ),
                          24.sh,
                          Row(children: [Expanded(child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [CommonTextPoppins(
                            text: "Gender",
                            fontweight: FontWeight.w500,
                            fontsize: 12,
                            color: AppColors.hintTextColor,
                            talign: TextAlign.left,
                          ),
                          4.sh,
                          CommonTextField2(
                            hinttext: "Enter Gender",
                            controller: context.read<MeScreenProvider>().gender,
                            isEditable: false,
                          ),
                          ],)),20.sw,Expanded(child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [CommonTextPoppins(
                            text: "Date Of Birth",
                            fontweight: FontWeight.w500,
                            fontsize: 12,
                            color: AppColors.hintTextColor,
                            talign: TextAlign.left,
                          ),
                          4.sh,
                          CommonTextField2(
                            hinttext: "Enter Date Of Birth",
                            controller: context.read<MeScreenProvider>().dob,
                            isEditable: false,
                          ),],))],),
                          24.sh,
                          Row(children: [
                            Expanded(child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [CommonTextPoppins(
                            text: "Phone",
                            fontweight: FontWeight.w500,
                            fontsize: 12,
                            color: AppColors.hintTextColor,
                            talign: TextAlign.left,
                          ),
                          4.sh,
                          CommonTextField2(
                            hinttext: "Enter Phone",
                            controller: context.read<MeScreenProvider>().phone,
                            isEditable: true,
                          ),
                          ],),
                          ),
                          20.sw,
                          Expanded(child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                            CommonTextPoppins(
                            text: "Marital Status",
                            fontweight: FontWeight.w500,
                            fontsize: 12,
                            color: AppColors.hintTextColor,
                            talign: TextAlign.left,
                          ),
                          4.sh,
                          CommonTextField2(
                            hinttext: "Enter Marital Status",
                            controller: context.read<MeScreenProvider>().martialStatus,
                            isEditable: false,
                          ),
                          ],))
                          ],),
                          24.sh,
                          CommonTextPoppins(
                            text: "Address",
                            fontweight: FontWeight.w500,
                            fontsize: 12,
                            color: AppColors.hintTextColor,
                            talign: TextAlign.left,
                          ),
                          4.sh,
                          CommonTextField2(
                            hinttext: "Enter Address",
                            controller:
                                context.read<MeScreenProvider>().address,
                            isEditable: false,
                          ),
                          24.sh,
                          Row(children: [
                            Expanded(child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                          CommonTextPoppins(
                            text: "Father Name",
                            fontweight: FontWeight.w500,
                            fontsize: 12,
                            color: AppColors.hintTextColor,
                            talign: TextAlign.left,
                          ),
                          4.sh,
                          CommonTextField2(
                            hinttext: "Enter Father Name",
                            controller:
                                context.read<MeScreenProvider>().fatherName,
                            isEditable: true,
                             validator: (value) {
                              if (value.isEmpty) {
                                return null;
                              } else if (value.length < 3) {
                                return "Father Name must\n be greater than 2\n characters";
                              } else {
                                return null;
                              }
                            },
                          ),
                            ],),
                            ),
                            20.sw,
                            Expanded(child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                CommonTextPoppins(
                            text: "Mother Name",
                            fontweight: FontWeight.w500,
                            fontsize: 12,
                            color: AppColors.hintTextColor,
                            talign: TextAlign.left,
                          ),
                          4.sh,
                          CommonTextField2(
                            hinttext: "Enter Mother Name",
                            controller:
                                context.read<MeScreenProvider>().motherName,
                            isEditable: true,
                             validator: (value) {
                              if (value.isEmpty) {
                                return null;
                              } else if (value.length < 3) {
                                return "Mother Name must\n be greater than 2\n characters";
                              } else {
                                return null;
                              }
                            },
                          ),
                            ],),
                            ),
                          ],),
                          ],),
                          30.sh,
                          meScreenProvider.personalInfo==false?const SizedBox():
                          Consumer<MeScreenProvider>(
                            builder: (context, meScreenProvider, child) {
                              if (meScreenProvider.isloading == true) {
                                return const Center(
                                  child: CircularProgressIndicator
                                      .adaptive(),
                                );
                              } else {
                                return UpdateButton(
                                    ontap: () {
                                      if ((AppConstants.loginmodell!.userData!.firstname.toString()!="null"? meScreenProvider.firstname.text ==
                                          AppConstants.loginmodell!.userData!.firstname:meScreenProvider.firstname.text=="") &&
                                                  //
                                          (AppConstants.loginmodell!.userData!.lastname.toString()!="null"? meScreenProvider.lastname.text ==
                                          AppConstants.loginmodell!.userData!.lastname: meScreenProvider.lastname.text =="") &&
                                                          //
                                          (AppConstants.loginmodell!.userData!.contactNo.toString() != "null"? meScreenProvider.phone.text ==
                                          AppConstants.loginmodell!.userData!.contactNo:meScreenProvider.phone.text =="No Contact Found") &&
                                                                  //
                                          (AppConstants.loginmodell!.userData!.fatherName.toString()!="null"? meScreenProvider.fatherName.text ==
                                          AppConstants.loginmodell!.userData!.fatherName: meScreenProvider.fatherName.text =="") &&
                                                                          //
                                          (AppConstants.loginmodell!.userData!.motherName.toString()!="null"?meScreenProvider.motherName.text ==
                                          AppConstants.loginmodell!.userData!.motherName:meScreenProvider.motherName.text =="")
                                                                                  ){
                                        if (meScreenProvider.selectdFile == null) {
                                         ScaffoldMessenger.of(context).showSnackBar(
                                        appSnackBar("No changes found to update")); 
                                        } else {
                                      if (meScreenProvider
                                          .Mescreenkey.currentState!
                                          .validate()) {
                                        meScreenProvider.updateDetailsApi(
                                            context: context);
                                      }    
                                        }
                                      } else {
                                      if (meScreenProvider
                                          .Mescreenkey.currentState!
                                          .validate()) {
                                        meScreenProvider.updateDetailsApi(
                                            context: context);
                                      }  
                                      }
                                      
                                    },
                                    text: "UPDATE");
                              }
                            },
                          ),
                          SizedBox(
                            height: height(context) * .15,
                          ),
                          // //  70.sh,
                        ],
                      ),
                    ],
                  )),
            ],
          ),
        );
      }),
    );
  }
}

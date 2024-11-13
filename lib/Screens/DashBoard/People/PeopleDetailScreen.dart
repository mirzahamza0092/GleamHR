import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:gleam_hr/Components/CommonAppBar.dart';
import 'package:gleam_hr/Components/CommonButton.dart';
import 'package:gleam_hr/Components/CommonText.dart';
import 'package:gleam_hr/Components/CommonTextField.dart';
import 'package:gleam_hr/Providers/DashBoardProviders/PeopleProviders/PeopleProvider.dart';
import 'package:gleam_hr/Screens/DashBoard/People/PeopleManagerScreen.dart';
import 'package:gleam_hr/Utils/AppConstants.dart';
import 'package:gleam_hr/Utils/AppPaths.dart';
import 'package:gleam_hr/Utils/Colors.dart';
import 'package:gleam_hr/Utils/SizedBox.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:sentry_flutter/sentry_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

class PeopleDetailScreen extends StatefulWidget {
  String? name,email,phoneNo, id;
  
  PeopleDetailScreen({required this.name,required this.email, required this.phoneNo, required this.id,
    super.key});

  @override
  State<PeopleDetailScreen> createState() => _PeopleDetailScreenState();
}

class _PeopleDetailScreenState extends State<PeopleDetailScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.pageBackgroundColor,
      appBar: PreferredSize(
          preferredSize: Size(width(context), 120),
          child: InkWell(
            onTap: () {},
            child: CommonAppBar(
                subtitle:
                    "${AppConstants.loginmodell!.userData!.firstname} ${(AppConstants.loginmodell!.userData!.lastname).toString() == "null" ? "" : AppConstants.loginmodell!.userData!.lastname}",
                trailingimagepath:
                    "https://${Keys.domain}.gleamhrm.com/${AppConstants.loginmodell!.userData!.picture}"),
          )),
      body: Consumer<PeopleProvider>(builder: (context, provider, child) {
        return SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
            child: Consumer<PeopleProvider>(
              builder: (context, peopleProvider, child) {
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          InkWell(
                            onTap: (){
                              Navigator.pop(context);
                                           peopleProvider.changeScreenNumber(1, "", "", "");
                                                                },
                            child: Icon(
                              Icons.arrow_back,
                              color: AppColors.primaryColor,
                              size: 20,
                              weight: 20,
                            ),
                          ),
                          10.sw,
                          CommonTextPoppins(
                              text: "Employee Detail",
                              talign: TextAlign.start,
                              fontweight: FontWeight.w700,
                              fontsize: 20,
                              color: AppColors.textColor),
                        ],
                      ),
                      23.sh,
                      CommonTextPoppins(
                          text: "NAME",
                          talign: TextAlign.start,
                          fontweight: FontWeight.w500,
                          fontsize: 12,
                          color: AppColors.hintTextColor),
                      4.sh,
                      CommonTextField(
                        hinttext: widget.name.toString() == "" ||
                                widget.name.toString() == "null"
                            ? "No Name Found"
                            : widget.name.toString(),
                        isEditable: false,
                      ),
                      24.sh,
                      CommonTextPoppins(
                          text: "EMAIL",
                          talign: TextAlign.start,
                          fontweight: FontWeight.w500,
                          fontsize: 12,
                          color: AppColors.hintTextColor),
                      4.sh,
                    Consumer<PeopleProvider>(
                    builder: (context, pProvider, child) {
                       return  CommonTextField(
                        suffixIconChk:widget.email.toString() == "No Mail Available" ||widget.email.toString() == "null"?false: true,
                        copyIcon:pProvider.isMailCopied?const Icon(Icons.copy):Icon(Icons.check,color: AppColors.greenColor,),
                        suffixIconTap: (){
                          pProvider.copyText(context,widget.email.toString(), "Mail Copied",true,false);
                        },
                        hinttext: widget.email.toString() == "" ||
                                widget.email.toString() == "null"
                            ? "No Email Found"
                            : widget.email.toString(),
                        isEditable: false,
                      );}),
                      24.sh,
                      CommonTextPoppins(
                          text: "PHONE",
                          talign: TextAlign.start,
                          fontweight: FontWeight.w500,
                          fontsize: 12,
                          color: AppColors.hintTextColor),
                      4.sh,
                    Consumer<PeopleProvider>(
                    builder: (context, pProvider, child) {
                       return CommonTextField(
                        suffixIconChk: widget.phoneNo.toString() == "No Contact Available" ||widget.phoneNo.toString() == "null"?false: true,
                        copyIcon:pProvider.isPhoneCopied?const Icon(Icons.copy):Icon(Icons.check,color: AppColors.greenColor),
                        suffixIconTap: (){
                          pProvider.copyText(context,widget.phoneNo.toString(), "Phone Number Copied",false,true);
                        },
                        hinttext: widget.phoneNo.toString() == "" ||
                                widget.phoneNo.toString() == "null"
                            ? "No Phone Number Found"
                            : widget.phoneNo.toString(),
                        isEditable: false,
                      );}),
                      // 24.sh,
                      // CommonTextPoppins(
                      //     text: "OFFICE LOCATION",
                      //     talign: TextAlign.start,
                      //     fontweight: FontWeight.w500,
                      //     fontsize: 12,
                      //     color: AppColors.hintTextColor),
                      // 4.sh,
                      // CommonTextField(
                      //   hinttext: peopleProvider.officeLocation.toString() == "" ||
                      //           peopleProvider.officeLocation.toString() == "null"
                      //       ? "Gujrat "
                      //       : peopleProvider.officeLocation.toString(),
                      //   isEditable: false,
                      // ),
                      // 24.sh,
                      // CommonTextPoppins(
                      //     text: "CURRENT LOCAL TIME",
                      //     talign: TextAlign.start,
                      //     fontweight: FontWeight.w500,
                      //     fontsize: 12,
                      //     color: AppColors.hintTextColor),
                      // 4.sh,
                      // CommonTextField(
                      //   hinttext: peopleProvider.currentTime.toString() == "" ||
                      //           peopleProvider.currentTime.toString() == "null"
                      //       ? "12:55 pm(GMT+5) "
                      //       : peopleProvider.currentTime.toString(),
                      //   isEditable: false,
                      // ),
                      24.sh,
                        widget.id.toString()==""? const SizedBox():FutureBuilder(
                            future: peopleProvider.getEmployeeManager(context, widget.id.toString()),
                            builder: (context, snapshot) {
                                                if (snapshot.connectionState == ConnectionState.waiting) {
                                                  return const CircularProgressIndicator.adaptive();
                                                }
                                                return Column(
                                                  mainAxisAlignment: MainAxisAlignment.start,
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  mainAxisSize: MainAxisSize.min,
                                                  children: [
                                                  widget.id==""?const SizedBox():
                                                  CommonTextPoppins(
                                                      text: "REPORT TO",
                                                      talign: TextAlign.start,
                                                      fontweight: FontWeight.w500,
                                                      fontsize: 12,
                                                      color: AppColors.hintTextColor),
                                                      7.sh,
                                                    InkWell(
                                                        onTap: (){
                                                                      Navigator.pushReplacement(
                                                                       context,
                                                             MaterialPageRoute(
                                                              builder: (context) => PeopleManagerScreen(id: widget.id.toString())),
                                                                    );
                                                                    },
                                                        child: Row(
      children: [
        CachedNetworkImage(
          imageUrl: "https://${Keys.domain}.gleamhrm.com/${AppConstants.specifiEmployeescModel!.data!.picture.toString()}",
          imageBuilder: (context, imageProvider) => Container(
            padding: const EdgeInsets.all(10),
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: imageProvider,
              ),
              shape: BoxShape.circle,
              color: AppColors.whiteColor,
            ),
          ),
          placeholder: (context, url) => const CircularProgressIndicator.adaptive(),
          errorWidget: (context, url, error) {
            debugPrint("objecterror$url");
            return Container(
              padding: const EdgeInsets.all(10),
              width: 45,
              height: 45,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(ImagePath.profiledummyimage),
                ),
                shape: BoxShape.circle,
                color: AppColors.whiteColor,
              ),
            );
          },
        ),
        7.sw,
        Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CommonTextPoppins(
              text: AppConstants.specifiEmployeescModel!.data!.fullName.toString()=="null"?"Not Available":AppConstants.specifiEmployeescModel!.data!.fullName.toString(),
              talign: TextAlign.start,
              fontweight: FontWeight.w400,
              fontsize: 16,
              color: AppColors.textColor,
            ),
            CommonTextPoppins(
              text: AppConstants.specifiEmployeescModel!.data!.designation.toString()=="null" ? "Not Available":AppConstants.specifiEmployeescModel!.data!.designation!.designationName.toString()=="null"? "Not Available":AppConstants.specifiEmployeescModel!.data!.designation!.designationName.toString(),
              fontweight: FontWeight.w500,
              fontsize: 12,
              color: AppColors.hintTextColor,
            ),
          ],
        ),
      ],
    ),
       ),
                                                  ],
                                                );
                          },),
        24.sh,
                      CommonButtonImage(
                          shadowneeded: false,
                          onPressed: () async {
                            if (widget.phoneNo.toString() != "null") {
                              Uri phoneno = Uri.parse(
                                  'tel:${widget.phoneNo.toString()}');
                              if (await launchUrl(phoneno)) {
                                //dialer opened
                              } else {
                                //dailer is not opened
                              }
                            } else {
                              Fluttertoast.showToast(
                                  msg: "No Contact Available",
                                  toastLength: Toast.LENGTH_SHORT,
                                  gravity: ToastGravity.BOTTOM,
                                  timeInSecForIosWeb: 1,
                                  backgroundColor: AppColors.primaryColor,
                                  textColor: Colors.white,
                                  fontSize: 16.0);
                            }
                          },
                          width: width(context),
                          text: "CALL NOW",
                          color: AppColors.success,
                          image: ImagePath.telephoneIcon), 
                          20.sh,
                          CommonButtonImage(
                          shadowneeded: false,
                          onPressed: () async {
                            String subject = "";
                            String body = "";
                            if (widget.email.toString() != "null" && widget.email.toString() != "No Mail Available") {
                             if (await canLaunch(
                                "mailto:${widget.email.toString()}?subject=$subject&body=$body")) {
                                await launch(
                                    "mailto:${widget.email.toString()}?subject=$subject&body=$body");
                              } else {
                                throw 'Could not send email to ${widget.email.toString()}';
                              }
                            } else {
                              Fluttertoast.showToast(
                                  msg: "No Email Available",
                                  toastLength: Toast.LENGTH_SHORT,
                                  gravity: ToastGravity.BOTTOM,
                                  timeInSecForIosWeb: 1,
                                  backgroundColor: AppColors.primaryColor,
                                  textColor: Colors.white,
                                  fontSize: 16.0);
                            }
                          },
                          width: width(context),
                          text: "Email NOW",
                          color: AppColors.primaryColor,
                          image: ImagePath.emailIcon),
                      20.sh,
                      AddMoreButton(
                          text: "SAVE CONTACT",
                          ontap: () async {
                            try {
                              var status = await Permission.contacts.request();
                              if (status.isGranted &&
                                  widget.phoneNo.toString() != "null") {
                                final newContact = Contact()
                                  ..name.first = widget.name.toString()
                                  ..phones = [
                                    Phone(widget.phoneNo.toString())
                                  ]
                                  ..organizations=[Organization(company: Keys.domain.toString())
                                  ]
                                  ..emails = [
                                    Email(widget.email.toString()=="null"?"":widget.email.toString())
                                  ];
                                var res = await newContact.insert();
                                if (res.toString() != "null") {
                                  Fluttertoast.showToast(
                                      msg: "Contact Added",
                                      toastLength: Toast.LENGTH_SHORT,
                                      gravity: ToastGravity.BOTTOM,
                                      timeInSecForIosWeb: 1,
                                      backgroundColor: AppColors.primaryColor,
                                      textColor: Colors.white,
                                      fontSize: 16.0);
                                } else {
                                  Fluttertoast.showToast(
                                      msg: "Contact Didn't Add",
                                      toastLength: Toast.LENGTH_SHORT,
                                      gravity: ToastGravity.BOTTOM,
                                      timeInSecForIosWeb: 1,
                                      backgroundColor: AppColors.primaryColor,
                                      textColor: Colors.white,
                                      fontSize: 16.0);
                                }
                              } else {
                                Fluttertoast.showToast(
                                    msg: "Contact Didn't Add",
                                    toastLength: Toast.LENGTH_SHORT,
                                    gravity: ToastGravity.BOTTOM,
                                    timeInSecForIosWeb: 1,
                                    backgroundColor: AppColors.primaryColor,
                                    textColor: Colors.white,
                                    fontSize: 16.0);
                              }
                            } catch (exception) {
                              if (AppConstants.livemode) {
                                    await Sentry.captureException(exception);
                                  }
                                  debugPrint(exception.toString());
                            }
                          },
                          imagePath: ImagePath.savedContactIcon), 
                    ],
                  );
              },
            ));
      }),
    );
  }
}

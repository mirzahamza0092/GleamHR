import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:gleam_hr/Components/CommonAppBar.dart';
import 'package:gleam_hr/Components/CommonButton.dart';
import 'package:gleam_hr/Components/CommonText.dart';
import 'package:gleam_hr/Components/CommonTextField.dart';
import 'package:gleam_hr/Providers/DashBoardProviders/PeopleProviders/PeopleProvider.dart';
import 'package:gleam_hr/Utils/AppConstants.dart';
import 'package:gleam_hr/Utils/AppPaths.dart';
import 'package:gleam_hr/Utils/Colors.dart';
import 'package:gleam_hr/Utils/SizedBox.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:sentry_flutter/sentry_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

class PeopleManagerScreen extends StatefulWidget {
  String id;
  //int index;
  PeopleManagerScreen({required this.id,super.key});

  @override
  State<PeopleManagerScreen> createState() => _PeopleManagerScreenState();
}

class _PeopleManagerScreenState extends State<PeopleManagerScreen> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final peopleProvider =
          Provider.of<PeopleProvider>(context, listen: false);
          peopleProvider.getSpecificEmployee(context, widget.id);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.pageBackgroundColor,
      appBar: PreferredSize(
          preferredSize: Size(width(context), 120),
          // child: CommonAppBar(
          //       subtitle: "${AppConstants.loginmodell!.userData.firstname} ${AppConstants.loginmodell!.userData.lastname}",
          //       trailingimagepath:"https://${Keys.domain}.gleamhrm.com/${peopledetails!.userData.picture}"),
          child: InkWell(
            onTap: () {
              //           Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) =>
              // DomainScreen()), (route) => false);
            },
            child: CommonAppBar(
                subtitle:
                    "${AppConstants.loginmodell!.userData!.firstname} ${(AppConstants.loginmodell!.userData!.lastname).toString() == "null" ? "" : AppConstants.loginmodell!.userData!.lastname}",
                trailingimagepath:
                    "https://${Keys.domain}.gleamhrm.com/${AppConstants.loginmodell!.userData!.picture}"),
          )),
      body: Consumer<PeopleProvider>(builder: (context, provider, child) {
        if(provider.isLoading){
          return const Center(child: CircularProgressIndicator.adaptive());
        }else{
return SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
            child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          InkWell(
                            onTap: (){
                              Navigator.pop(context);
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
                        hinttext: AppConstants.specifiEmployeescModel!.data!.firstname  == "" ||
                                AppConstants.specifiEmployeescModel!.data!.firstname == "null"
                            ? "No Name Found"
                            : AppConstants.specifiEmployeescModel!.data!.firstname.toString()
                        ,isEditable: false,
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
                       return CommonTextField(
                        suffixIconChk:AppConstants.specifiEmployeescModel!.data!.officialEmail.toString() == "No Mail Available" ||AppConstants.specifiEmployeescModel!.data!.officialEmail.toString() == "null"?false: true,
                        copyIcon:pProvider.isMailCopied?const Icon(Icons.copy):Icon(Icons.check,color: AppColors.greenColor),
                        suffixIconTap: (){
                          pProvider.copyText(context,AppConstants.specifiEmployeescModel!.data!.officialEmail.toString(), "Mail Copied",true,false);
                        },
                        hinttext: AppConstants.specifiEmployeescModel!.data!.officialEmail.toString() == "" ||
                                AppConstants.specifiEmployeescModel!.data!.officialEmail.toString() == "null"
                            ? "No Email Found"
                            : AppConstants.specifiEmployeescModel!.data!.officialEmail.toString(),
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
                        suffixIconChk: AppConstants.specifiEmployeescModel!.data!.contactNo.toString() == "No Contact Available" ||AppConstants.specifiEmployeescModel!.data!.contactNo.toString() == "null"?false: true,
                        copyIcon:pProvider.isPhoneCopied?const Icon(Icons.copy):Icon(Icons.check,color: AppColors.greenColor),
                        suffixIconTap: (){
                          pProvider.copyText(context,AppConstants.specifiEmployeescModel!.data!.contactNo.toString(), "Phone Number Copied",false,true);
                        },
                        hinttext: AppConstants.specifiEmployeescModel!.data!.contactNo.toString() == "" ||
                                AppConstants.specifiEmployeescModel!.data!.contactNo.toString() == "null"
                            ? "No Phone Number Found"
                            : AppConstants.specifiEmployeescModel!.data!.contactNo .toString(),
                        isEditable: false,
                      );}),
                      24.sh,
                     AppConstants.specifiEmployeescModel!.data!.managerId.toString()=="null"? const SizedBox():FutureBuilder(
                            future: context.read<PeopleProvider>().getEmployeeManager(context, AppConstants.specifiEmployeescModel!.data!.managerId.toString()),
                            builder: (context, snapshot) {
                                                if (snapshot.connectionState == ConnectionState.waiting) {
                                                  return const CircularProgressIndicator.adaptive();
                                                }
                                                return Column(
                                                  mainAxisAlignment: MainAxisAlignment.start,
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  mainAxisSize: MainAxisSize.min,
                                                  children: [
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
                                                              builder: (context) => PeopleManagerScreen(id: AppConstants.specifiEmployeescModel!.data!.id.toString())),
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
                            if (AppConstants.specifiEmployeescModel!.data!.contactNo.toString() != "null") {
                              Uri phoneno = Uri.parse(
                                  'tel:${AppConstants.specifiEmployeescModel!.data!.contactNo.toString()}');
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
                            if (AppConstants.specifiEmployeescModel!.data!.officialEmail.toString()!= "null" && 
                                AppConstants.specifiEmployeescModel!.data!.officialEmail.toString()!= "No Mail Available") {
                             if (await canLaunch(
                                "mailto:${AppConstants.specifiEmployeescModel!.data!.officialEmail.toString()}?subject=$subject&body=$body")) {
                                await launch(
                                    "mailto:${AppConstants.specifiEmployeescModel!.data!.officialEmail.toString()}?subject=$subject&body=$body");
                              } else {
                                throw 'Could not send email to ${AppConstants.specifiEmployeescModel!.data!.officialEmail.toString()}';
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
                                  AppConstants.specifiEmployeescModel!.data!.contactNo.toString() != "null") {
                                final newContact = Contact()
                                  ..name.first = AppConstants.specifiEmployeescModel!.data!.fullName.toString()
                                  ..phones = [
                                    Phone(AppConstants.specifiEmployeescModel!.data!.contactNo.toString())
                                  ]
                                  ..organizations=[Organization(company: Keys.domain.toString())
                                  ]
                                  ..emails = [
                                    Email(AppConstants.specifiEmployeescModel!.data!.officialEmail.toString())
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
            
                  ),

            );
      }
        }),
    );
  }
}

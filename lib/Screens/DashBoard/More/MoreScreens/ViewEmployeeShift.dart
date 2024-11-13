import 'package:flutter/material.dart';
import 'package:gleam_hr/Utils/SizedBox.dart';
import 'package:provider/provider.dart';
import '../../../../Components/CommonAppBar.dart';
import '../../../../Components/CommonText.dart';
import '../../../../Components/CommonTextField.dart';
import '../../../../Providers/DashBoardProviders/MoreProviders/EmployeeShift_Provider.dart';
import '../../../../Utils/AppConstants.dart';
import '../../../../Utils/AppPaths.dart';
import '../../../../Utils/Colors.dart';

class ViewEmployeeShift extends StatefulWidget {
  String id;
   ViewEmployeeShift({required this.id,super.key});

  @override
  
  State<ViewEmployeeShift> createState() => _ViewEmployeeShiftState();
}

class _ViewEmployeeShiftState extends State<ViewEmployeeShift> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final employeeShiftProvider =
          Provider.of<EmployeeShiftProvider>(context, listen: false);
          employeeShiftProvider.getEmployeeShift(context,widget.id);
    });
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: PreferredSize(
          preferredSize: Size(width(context), 120),
          child: CommonAppBar(
              subtitle:
                  "${AppConstants.loginmodell!.userData!.firstname} ${(AppConstants.loginmodell!.userData!.lastname).toString() == "null" ? "" : AppConstants.loginmodell!.userData!.lastname}",
              trailingimagepath:
                  "https://${Keys.domain}.gleamhrm.com/${AppConstants.loginmodell!.userData!.picture}"
                  ,inboxIconNeeded: false,
                  announcementIconNeeded: false,)
                  ),
      body: SingleChildScrollView(
        child:Consumer<EmployeeShiftProvider>(
          builder: (context, employeeShiftProvider, child) {
            if (employeeShiftProvider.isLoading) {
              return const Center(
                child: CircularProgressIndicator.adaptive(),
              );
            } else {
              return Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children:
         [
          25.sh,
            Padding(
              padding: const EdgeInsets.only(left :20.0),
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
                                          talign: TextAlign.left,
                                          text: "View Shift details",
                                          fontweight: FontWeight.w600,
                                          fontsize: 20,
                                          color: AppColors.textColor),
                    ],
                    ),
            ),
          25.sh,
          Padding(
            padding: const EdgeInsets.only(left:20),
            child: CommonTextPoppins(
                            text: "Title :",
                            talign: TextAlign.start,
                            fontweight: FontWeight.w700,
                            fontsize: 12,
                            color: AppColors.hintTextColor),
          ),  
                          CommonTextField(hinttext: AppConstants.employeeShiftModel!.data!.workSchedule!.title.toString() == "" ||
                            AppConstants.employeeShiftModel!.data!.workSchedule!.title.toString() == "null"
                        ? "Not Found"
                        : AppConstants.employeeShiftModel!.data!.workSchedule!.title.toString(),
                        isEditable: false,),
                     10.sh,
                      Padding(
                        padding: const EdgeInsets.only(left:20),
                        child: CommonTextPoppins(
                            text: "Schedule start time :",
                            talign: TextAlign.start,
                            fontweight: FontWeight.w700,
                            fontsize: 12,
                            color: AppColors.hintTextColor),
                      ),  
                          CommonTextField(hinttext: AppConstants.employeeShiftModel!.data!.workSchedule!.scheduleStartTime.toString() == "" ||
                            AppConstants.employeeShiftModel!.data!.workSchedule!.scheduleStartTime.toString() == "null"
                        ? "Not Found"
                        : AppConstants.employeeShiftModel!.data!.workSchedule!.scheduleStartTime.toString(),
                        isEditable: false,),
                      10.sh,
                      Padding(
                        padding: const EdgeInsets.only(left:20),
                        child: CommonTextPoppins(
                            text: "Flex time in :",
                            talign: TextAlign.start,
                            fontweight: FontWeight.w700,
                            fontsize: 12,
                            color: AppColors.hintTextColor),
                      ),  
                          CommonTextField(hinttext: AppConstants.employeeShiftModel!.data!.workSchedule!.flexTimeIn.toString() == "" ||
                            AppConstants.employeeShiftModel!.data!.workSchedule!.flexTimeIn.toString() == "null"
                        ? "Not Found"
                        : AppConstants.employeeShiftModel!.data!.workSchedule!.flexTimeIn.toString(),
                        isEditable: false,),
                     10.sh,
                      Padding(
                        padding: const EdgeInsets.only(left:20),
                        child: CommonTextPoppins(
                            text: "Schedule break time :",
                            talign: TextAlign.start,
                            fontweight: FontWeight.w700,
                            fontsize: 12,
                            color: AppColors.hintTextColor),
                      ),  
                          CommonTextField(hinttext: AppConstants.employeeShiftModel!.data!.workSchedule!.scheduleBreakTime.toString() == "" ||
                            AppConstants.employeeShiftModel!.data!.workSchedule!.scheduleBreakTime.toString() == "null"
                        ? "Not Found"
                        : AppConstants.employeeShiftModel!.data!.workSchedule!.scheduleBreakTime.toString(),
                        isEditable: false,),
                      10.sh,
                      Padding(
                        padding: const EdgeInsets.only(left:20),
                        child: CommonTextPoppins(
                            text: "Schedule back time :",
                            talign: TextAlign.start,
                            fontweight: FontWeight.w700,
                            fontsize: 12,
                            color: AppColors.hintTextColor),
                      ),  
                          CommonTextField(hinttext: AppConstants.employeeShiftModel!.data!.workSchedule!.scheduleBackTime.toString() == "" ||
                            AppConstants.employeeShiftModel!.data!.workSchedule!.scheduleBackTime.toString() == "null"
                        ? "Not Found"
                        : AppConstants.employeeShiftModel!.data!.workSchedule!.scheduleBackTime.toString(),
                        isEditable: false,),
                       10.sh,
                      Padding(
                        padding: const EdgeInsets.only(left:20),
                        child: CommonTextPoppins(
                            text: "Schedule end time :",
                            talign: TextAlign.start,
                            fontweight: FontWeight.w700,
                            fontsize: 12,
                            color: AppColors.hintTextColor),
                      ),  
                          CommonTextField(hinttext: AppConstants.employeeShiftModel!.data!.workSchedule!.scheduleEndTime.toString() == "" ||
                            AppConstants.employeeShiftModel!.data!.workSchedule!.scheduleEndTime.toString() == "null"
                        ? "Not Found"
                        : AppConstants.employeeShiftModel!.data!.workSchedule!.scheduleEndTime.toString(),
                        isEditable: false,
                        ),
                      10.sh,
                      Padding(
                        padding: const EdgeInsets.only(left:20),
                        child: CommonTextPoppins(
                            text: "Scheduled Hours :",
                            talign: TextAlign.start,
                            fontweight: FontWeight.w700,
                            fontsize: 12,
                            color: AppColors.hintTextColor),
                      ), 
                          CommonTextField(hinttext: AppConstants.employeeShiftModel!.data!.workSchedule!.scheduleHours.toString() == "" ||
                            AppConstants.employeeShiftModel!.data!.workSchedule!.scheduleHours.toString() == "null"
                        ? "Not Found"
                        : AppConstants.employeeShiftModel!.data!.workSchedule!.scheduleHours.toString(),
                        isEditable: false,),
                      10.sh,
                       Padding(
                         padding: const EdgeInsets.only(left:20),
                         child: CommonTextPoppins(
                             text: "Non Working days :",
                             talign: TextAlign.start,
                             fontweight: FontWeight.w700,
                             fontsize: 12,
                             color: AppColors.hintTextColor),
                       ),   
                           CommonTextField(hinttext: AppConstants.employeeShiftModel!.data!.workSchedule!.nonWorkingDays.toString() == "" ||
                             AppConstants.employeeShiftModel!.data!.workSchedule!.nonWorkingDays.toString() == "null"
                         ? "Not Found"
                         : AppConstants.employeeShiftModel!.data!.workSchedule!.nonWorkingDays.toString(),
                         isEditable: false,),
                      10.sh,
                      Padding(
                        padding: const EdgeInsets.only(left:20),
                        child: CommonTextPoppins(
                            text: "Flex end time :",
                            talign: TextAlign.start,
                            fontweight: FontWeight.w700,
                            fontsize: 12,
                            color: AppColors.hintTextColor),
                      ),  
                          CommonTextField(hinttext: AppConstants.employeeShiftModel!.data!.workSchedule!.flexEndTime.toString() == "" ||
                            AppConstants.employeeShiftModel!.data!.workSchedule!.flexEndTime.toString() == "null"
                        ? "Not Found"
                        : AppConstants.employeeShiftModel!.data!.workSchedule!.flexEndTime.toString(),
                        isEditable: false,),
                      10.sh,
                      Padding(
                        padding: const EdgeInsets.only(left:20),
                        child: CommonTextPoppins(
                            text: "Start schedule early time :",
                            talign: TextAlign.start,
                            fontweight: FontWeight.w700,
                            fontsize: 12,
                            color: AppColors.hintTextColor),
                      ),  
                          CommonTextField(hinttext: AppConstants.employeeShiftModel!.data!.workSchedule!.startScheduleEarlyTime.toString() == "" ||
                            AppConstants.employeeShiftModel!.data!.workSchedule!.startScheduleEarlyTime.toString() == "null"
                        ? "Not Found"
                        : AppConstants.employeeShiftModel!.data!.workSchedule!.startScheduleEarlyTime.toString(),
                        isEditable: false,),
                        10.sh,
                      Padding(
                        padding: const EdgeInsets.only(left:20),
                        child: CommonTextPoppins(
                            text: "End schedule late time :",
                            talign: TextAlign.start,
                            fontweight: FontWeight.w700,
                            fontsize: 12,
                            color: AppColors.hintTextColor),
                      ),                          
                          CommonTextField(hinttext: AppConstants.employeeShiftModel!.data!.workSchedule!.endScheduleLateTime.toString() == "" ||
                            AppConstants.employeeShiftModel!.data!.workSchedule!.endScheduleLateTime.toString() == "null"
                        ? "Not Found"
                        : AppConstants.employeeShiftModel!.data!.workSchedule!.endScheduleLateTime.toString(),
                        isEditable: false,),
                         20.sh,
        ]);
            }
           },
        ) ),
      
    );
    
  }
}
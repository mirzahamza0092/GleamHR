import 'package:flutter/material.dart';
import 'package:gleam_hr/Providers/DashBoardProviders/DashBoard_Provider.dart';
import 'package:gleam_hr/Utils/Colors.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

Widget DashBoardCalander(DashBoardProvider dashboardprovider) {
  return Padding(
    padding: const EdgeInsets.only(left: 28,right: 28,top: 0),
    child: SfDateRangePicker(
      minDate: DateTime.now(),
      rangeTextStyle: TextStyle(color: AppColors.hintTextColor),
      navigationMode: DateRangePickerNavigationMode.scroll,
      monthCellStyle: DateRangePickerMonthCellStyle(
        textStyle: TextStyle(color: AppColors.hintTextColor),
      ),
      rangeSelectionColor: const Color(0XFFd6ebf6),
      headerStyle: DateRangePickerHeaderStyle(
          textStyle: TextStyle(
              color: AppColors.primaryColor,
              fontSize: 16,
              fontWeight: FontWeight.w600)),
      selectionMode: DateRangePickerSelectionMode.range,
      onSelectionChanged: (dateRangePickerSelectionChangedArgs) {
        dashboardprovider.changeDateFormat(dateRangePickerSelectionChangedArgs);
      },
    ),
  );
}

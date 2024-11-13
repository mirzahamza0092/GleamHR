import 'package:flutter/material.dart';
import 'package:gleam_hr/Utils/Colors.dart';

class PeopleSearchBar extends StatelessWidget {
  final controller;
  var onvaluechange;
  PeopleSearchBar(
      {super.key, required this.controller, required this.onvaluechange});
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      onChanged: onvaluechange,
      controller: controller,
      decoration: InputDecoration(
        prefixIcon: const Icon(Icons.search),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(
            width: 0.15,
            color: AppColors.textColor.withOpacity(.25),
            style: BorderStyle.none,
          ),
        ),
        contentPadding: const EdgeInsets.only(left: 20),
        // border: InputBorder.none,
        hintText: "Search",
        hintStyle: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w400,
            color: AppColors.hintTextColor),
        filled: true,
        fillColor: AppColors.fillColor,
      ),
      textAlign: TextAlign.left,
    );
  }
}

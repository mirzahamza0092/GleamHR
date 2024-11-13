import 'package:flutter/material.dart';
import 'package:gleam_hr/Utils/Colors.dart';
import 'package:gleam_hr/Utils/SizedBox.dart';

class CommonTextField extends StatelessWidget {
  String hinttext;
  bool obsecure, isEditable;
  final controller;
  var validator,newvalue;
  var suffixIconTap;
  Widget copyIcon;
  bool suffixIconChk;
  Widget suffixicon;
  TextInputType? keyboardType;
  CommonTextField({
    this.controller,
    this.obsecure = false,
    this.validator,
    this.newvalue,
    this.isEditable = true,
    this.suffixIconTap,
    this.suffixIconChk=false,
    this.suffixicon = const SizedBox(),
    this.copyIcon=const SizedBox(),
    required this.hinttext,
    super.key,
    keyboardType = TextInputType.none,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: Row(
        children: [
          Expanded(
            flex: 1,
            child: TextFormField(
              keyboardType: keyboardType,
              validator: validator,
              onChanged: newvalue,
              obscureText: obsecure,
              controller: controller,
              decoration: InputDecoration(
                enabled: isEditable,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: const BorderSide(
                    width: 0,
                    style: BorderStyle.none,
                  ),
                ),
                contentPadding: const EdgeInsets.only(left: 24),
                // border: InputBorder.none,
                suffixIcon: suffixicon,
                hintText: hinttext,
                hintStyle: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    color: AppColors.hintTextColor),
                filled: true,
                fillColor: AppColors.fillColor,
              ),
              textAlign: TextAlign.left,
            ),
          ),
         suffixIconChk?5.sw:const SizedBox(),
          suffixIconChk?InkWell(
            onTap: (){
              suffixIconTap();
            },
            child: Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: AppColors.fillColor,
                borderRadius: BorderRadius.circular(8),
              ),
              child:copyIcon,
            ),
          ):const SizedBox()
        ],
      ),
    );
  }
}

class CommonTextField2 extends StatelessWidget {
  String hinttext;
  bool obsecure, isEditable;
  final controller;
  var validator;
  CommonTextField2({
    this.controller,
    this.obsecure = false,
    this.validator,
    this.isEditable = true,
    required this.hinttext,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      validator: validator,
      obscureText: obsecure,
      controller: controller,
      decoration: InputDecoration(
        enabled: isEditable,
        suffixIcon: isEditable
            ? Icon(Icons.mode_edit_outlined,color: AppColors.primaryColor,)
            : const SizedBox(),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide:const BorderSide(
            width: 0.5,
            style: BorderStyle.solid,
          ),
        ),
        contentPadding: const EdgeInsets.only(left: 24),
        // border: InputBorder.none,
        hintText: hinttext,
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(
            color: AppColors.hintTextColor,
            width: 0.5,
            style: BorderStyle.solid,
          ),
        ),
        hintStyle: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w400,
            color: AppColors.hintTextColor),
        filled: true,
        fillColor:const Color(0XFFFAFAFA),
      ),
      textAlign: TextAlign.left,
    );
  }
}

class CommonTextField3 extends StatelessWidget {
  String hinttext;
  bool obsecure;
  Widget suffixIcon;
  final controller;
  var validator;
  CommonTextField3({
    this.controller,
    this.obsecure = false,
    this.validator,
    this.suffixIcon=const SizedBox(),
    required this.hinttext,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      validator: validator,
      obscureText: obsecure,
      controller: controller,
      decoration: InputDecoration(
        suffixIcon:suffixIcon,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide:const BorderSide(
            width: 0.5,
            style: BorderStyle.solid,
          ),
        ),
        contentPadding: const EdgeInsets.only(left: 24),
        // border: InputBorder.none,
        hintText: hinttext,
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(
            color: AppColors.hintTextColor,
            width: 0.5,
            style: BorderStyle.solid,
          ),
        ),
        hintStyle: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w400,
            color: AppColors.hintTextColor),
        filled: true,
        fillColor:const Color(0XFFFAFAFA),
      ),
      textAlign: TextAlign.left,
    );
  }
}

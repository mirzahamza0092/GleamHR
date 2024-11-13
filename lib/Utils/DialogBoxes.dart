import 'dart:io';

import 'package:flutter/material.dart';
import 'package:gleam_hr/Components/CommonText.dart';
import 'package:gleam_hr/Providers/DashBoardProviders/MeProviders/MeScreen_Provider.dart';
import 'package:gleam_hr/Utils/Colors.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

class CommonDialogBoxes {
  static Future<dynamic> pickImageDialog(
      BuildContext context, MeScreenProvider meScreenProvider) {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: CommonTextPoppins(
                text: "Select Image Source",
                fontweight: FontWeight.w500,
                fontsize: 15,
                color: AppColors.primaryColor),
            content: Container(
                padding:
                    const EdgeInsets.symmetric(vertical: 13, horizontal: 20),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(6),
                    color: AppColors.whiteColor),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  // mainAxisSize: MainAxisSize.min,
                  children: [
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primaryColor),
                      onPressed: () async {
                        if (Platform.isIOS) {
                          if (await Permission.mediaLibrary
                              .request()
                              .isGranted) {
                            meScreenProvider.pickimage(
                              source: ImageSource.gallery,
                            );
                          } else {
                            await Permission.mediaLibrary.request();
                            meScreenProvider.pickimage(
                              source: ImageSource.gallery,
                            );
                          }
                        } else if (Platform.isAndroid) {
                          meScreenProvider.pickimage(
                            source: ImageSource.gallery,
                          );
                        }
                        Navigator.maybePop(context);
                      },
                      child: CommonTextPoppins(
                          text: "Gallary",
                          fontweight: FontWeight.w400,
                          fontsize: 15,
                          color: AppColors.whiteColor),
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primaryColor),
                      onPressed: () async {
                        if (Platform.isIOS) {
                          if (await Permission.camera.request().isGranted) {
                            meScreenProvider.pickimage(
                              source: ImageSource.camera,
                            );
                          } else {
                            await Permission.camera.request();
                            meScreenProvider.pickimage(
                              source: ImageSource.camera,
                            );
                          }
                        } else if (Platform.isAndroid) {
                          meScreenProvider.pickimage(
                            source: ImageSource.camera,
                          );
                        }
                        Navigator.maybePop(context);
                      },
                      child: CommonTextPoppins(
                          text: "Camera",
                          fontweight: FontWeight.w400,
                          fontsize: 15,
                          color: AppColors.whiteColor),
                    ),
                  ],
                )),
          );
        });
  }
}
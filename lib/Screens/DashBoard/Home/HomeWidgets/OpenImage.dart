import 'dart:io';
import 'package:flutter/material.dart';
import 'package:gleam_hr/Utils/Colors.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';

class OpenImage extends StatelessWidget {
  OpenImage({required this.dir, super.key});
  var dir;
  @override
  Widget build(BuildContext context) {
    // define();
    return Scaffold(
      backgroundColor: const Color(0XFF000000), floatingActionButtonLocation: FloatingActionButtonLocation.startTop,
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(top:18.0),
        child: FloatingActionButton(
          elevation: 0.0,
          onPressed: (){
          Navigator.pop(context);
        },
        child:Icon( Icons.arrow_back,color: AppColors.whiteColor,),
        backgroundColor: Colors.transparent,
         
        ),
      ),
      body: SafeArea(
        child: SizedBox(
        width: MediaQuery.of(context).size.width * 1,
        height: MediaQuery.of(context).size.height * 1,
        child:PhotoViewGallery.builder(
        itemCount: 1,
        builder: (context, index) {
          return PhotoViewGalleryPageOptions(
            imageProvider: FileImage(File(dir)),
            minScale: PhotoViewComputedScale.contained,
            maxScale: PhotoViewComputedScale.covered * 2,
          );
        },
        scrollPhysics: const BouncingScrollPhysics(),
        backgroundDecoration: const BoxDecoration(
          color: Colors.black,
        ),
        pageController: PageController(),
      ),
    )
          ),
      );
    
  }
}
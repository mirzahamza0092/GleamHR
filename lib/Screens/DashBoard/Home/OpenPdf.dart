import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:gleam_hr/Utils/Colors.dart';

class OpenPdf extends StatelessWidget {
  OpenPdf({required this.dir, super.key});
  var dir;
  @override
  Widget build(BuildContext context) {
    // define();
    return Scaffold(
      backgroundColor: const Color(0XFF000000), 
      floatingActionButtonLocation: FloatingActionButtonLocation.startTop,
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(top:18.0),
        child: FloatingActionButton(
          elevation: 0.0,
          onPressed: (){
          Navigator.pop(context);
        },
        child:Icon( Icons.arrow_back,color: AppColors.primaryColor,),
        backgroundColor: Colors.transparent,
         
        ),
      ),
      body: SafeArea(
        child: SizedBox(
        width: MediaQuery.of(context).size.width * 1,
        height: MediaQuery.of(context).size.height * 1,
        child: PDFView(
          //filePath: '${dir.path}/tal',
          onError: (error) {
            debugPrint("THIS IS EEE$error");
          },
          onPageError: (page, error) {
            debugPrint("THIS IS EEE$error");
          },
          filePath: dir//'${dir.path}/tal',
        ),
          ),
      ),
    );
  }
}
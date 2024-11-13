import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

class ShowDownloaded extends StatefulWidget {
  const ShowDownloaded({super.key});

  @override
  State<ShowDownloaded> createState() => _ShowDownloadedState();
}

class _ShowDownloadedState extends State<ShowDownloaded> {
  late List<FileSystemEntity> _folders;
  @override
  void initState() {
    getDir();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          FutureBuilder(
              //future: getDir(),
              builder: (ctx, snapshot) {
            return Center(
              child: Container(
                child: Text(snapshot.data.toString()),
              ),
            );
          }),
        ],
      ),
    );
  }

  Future getDir() async {
    final directory = await getApplicationDocumentsDirectory();
    final dir = directory.path;
    String pdfDirectory = '$dir/';
    final myDir = Directory(pdfDirectory);
    setState(() {
      _folders = myDir.listSync(recursive: true, followLinks: false);
    });
    debugPrint(_folders.toString());
  }
}

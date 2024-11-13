import 'package:flutter/material.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(body: Center(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
        InkWell(
          onTap: () {
            showDialog(context: context,builder: (BuildContext context) {
              return const Dialog(child: SizedBox(height: 200, child: Center(child: Text("dsjhsdkhjhsdj"))),);
            });},
          child: const Text("this is 1 text")),
        const Text("this is 2 text"),
        const Text("this is 3 text"),
        const Text("this is 4 text"),
        const Text("this is 5 text"),
        const Text("this is 6 text"),
        const Text("this is 7 text"),
        const Text("this is 8 text"),
        const Text("this is 9 text"),
        const Text("this is 10 text"),
      ],),
    ),);
  }

}
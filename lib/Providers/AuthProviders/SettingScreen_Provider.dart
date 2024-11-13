import 'package:flutter/material.dart';

class SettingScreenProvider extends ChangeNotifier{
   bool bioMetric=false;
   bool facialIdentification=false;
   bool darkMode=false;
void dark(value){
  darkMode=value;
  notifyListeners();
}void bio(value){
  bioMetric=value;
  notifyListeners();
}void faceIndenty(value){
  facialIdentification=value;
  notifyListeners();
}
   
   notifyListeners();
}
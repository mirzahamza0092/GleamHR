import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesHelper {
  static const String barFeatures = 'barFeatures';

  static SharedPreferencesHelper? _instance;
  SharedPreferences? _preferences;

  SharedPreferencesHelper._internal();

  factory SharedPreferencesHelper() {
    if (_instance == null) {
      _instance = SharedPreferencesHelper._internal();
    }
    return _instance!;
  }

  Future<void> init() async {
    _preferences = await SharedPreferences.getInstance();
    debugPrint(getBottomBarFeature().toString());
    List<String>? list = _preferences!.getStringList(barFeatures);
    if (list.toString() != "null") {
      if (list!.isNotEmpty) {
        if (list.length < 6) {
          list.add("true");
          if (list.length == 6) {
            _preferences!.setStringList(barFeatures, list);
          }
        }
      }
    } else if (getBottomBarFeature().toString() == "[]") {
      List<String> featureStates = List.generate(6, (index) => "true");
      _preferences!.setStringList(barFeatures, featureStates);
    }
  }

  Future<void> setBottomBarFeature(int index, String label) async {
    if (_preferences != null) {
      List<String> featuresList = getBottomBarFeature();
      featuresList[index] = label;
      await _preferences?.setStringList(barFeatures, featuresList);
    }
  }

  List<String> getBottomBarFeature() {
    return _preferences?.getStringList(barFeatures) ?? [];
  }
}

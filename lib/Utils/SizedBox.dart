import 'package:flutter/material.dart';

double height(BuildContext context) {
  return MediaQuery.of(context).size.height;
}

double width(BuildContext context) {
  return MediaQuery.of(context).size.width;
}

extension Heightwidth on num {
  SizedBox get sh => SizedBox(
        height: toDouble(),
      );
  SizedBox get sw => SizedBox(
        width: toDouble(),
      );
}

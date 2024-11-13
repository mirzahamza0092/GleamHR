import 'package:flutter/material.dart';
import 'package:gleam_hr/Providers/AuthProviders/LoginOnboarding_Provider.dart';

import 'package:provider/provider.dart';

import '../../utils/colors.dart';

class BuildDots extends StatelessWidget {
  final int index;

  const BuildDots({Key? key, required this.index}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = Provider.of<LoginOnboardingProvider>(context);
    if (controller.index == index) {
      return Container(
        padding: const EdgeInsets.all(5),
        margin: const EdgeInsets.only(right: 4),
        decoration: BoxDecoration(border: Border.all(width: 1,color: AppColors.primaryColor.withOpacity(.35)),shape: BoxShape.circle),
        child: Center(
          child: AnimatedContainer(
          duration: const Duration(milliseconds: 500),
          height: 10,
          width: controller.index == index ? 10 : 10,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: controller.index == index ? AppColors.primaryColor : AppColors.primaryColor.withOpacity(.35)),
            ),
        ),
      );
    } else {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 500),
      height: 10,
      width: 10,
      margin: const EdgeInsets.only(right: 4),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: AppColors.primaryColor.withOpacity(.35)),
    );  
    }
    
  }
}

import 'package:gleam_hr/Utils/AppPaths.dart';

class UnbordingContent {
  String image;
  String text;

  UnbordingContent({required this.text, required this.image});
}

List<UnbordingContent> contents = [
  UnbordingContent(
    image: ImagePath.onBoarding1,
    text:
        'Awesome! You can view your time tracking, time off, work from home requests, and do a whole lot more from your home screen',
  ),
  UnbordingContent(
    image: ImagePath.onBoarding2,
    text:
        'To customize what you see on your home screen, just tap the plus button at the bottom',
  ),
  UnbordingContent(
    image: ImagePath.onBoarding4,
    text:
        'To view your attendance, tap the eye button on the time tracking card',
  ),
  UnbordingContent(
    image: ImagePath.onBoarding3,
    text:
        'To create an attendance correction request, tap the eye button in the time tracking card and then tap edit',
  ),
  UnbordingContent(
    image: ImagePath.onBoarding5,
    text:
        'To see the status of your attendance correction requests, tap the three dots on the time tracking card',
  ),
];

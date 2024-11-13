import 'package:gleam_hr/Providers/AuthProviders/DomainScreen_Provider.dart';
import 'package:gleam_hr/Providers/AuthProviders/ForgotPassword_Provider.dart';
import 'package:gleam_hr/Providers/AuthProviders/LoginOnboarding_Provider.dart';
import 'package:gleam_hr/Providers/AuthProviders/LoginScreen_Provider.dart';
import 'package:gleam_hr/Providers/AuthProviders/SetPassword_Provider.dart';
import 'package:gleam_hr/Providers/AuthProviders/SettingScreen_Provider.dart';
import 'package:gleam_hr/Providers/AuthProviders/VerifyPassword_Provider.dart';
import 'package:gleam_hr/Providers/BottomNavigationProvider/BottomBarIcon_Provider.dart';
import 'package:gleam_hr/Providers/BottomNavigationProvider/BottomNavigation_Provider.dart';
import 'package:gleam_hr/Providers/DashBoardProviders/DashBoard_Provider.dart';
import 'package:gleam_hr/Providers/DashBoardProviders/HomeProviders/AdminCorrectionRequests_Provider.dart';
import 'package:gleam_hr/Providers/DashBoardProviders/HomeProviders/AdminExpenseRequests_Provider.dart';
import 'package:gleam_hr/Providers/DashBoardProviders/HomeProviders/AdminTimeOffRequests_Provider.dart';
import 'package:gleam_hr/Providers/DashBoardProviders/HomeProviders/AllCorrectionRequest_Provider.dart';
import 'package:gleam_hr/Providers/DashBoardProviders/HomeProviders/AssetRequest_Provider.dart';
import 'package:gleam_hr/Providers/DashBoardProviders/HomeProviders/CorrectionRequest_Provider.dart';
import 'package:gleam_hr/Providers/DashBoardProviders/HomeProviders/ExpenseRequestProvider.dart';
import 'package:gleam_hr/Providers/DashBoardProviders/HomeProviders/TimeOff_Provider.dart';
import 'package:gleam_hr/Providers/DashBoardProviders/HomeProviders/TimeTrackingProvider.dart';
import 'package:gleam_hr/Providers/DashBoardProviders/HomeProviders/WorkFromHome_Provider.dart';
import 'package:gleam_hr/Providers/DashBoardProviders/AppbarProviders/Inbox_Provider.dart';
import 'package:gleam_hr/Providers/DashBoardProviders/MoreProviders/ChangeEmployeeRole_Provider.dart';
import 'package:gleam_hr/Providers/DashBoardProviders/MoreProviders/LiveLocation_Provider.dart';
import 'package:gleam_hr/Providers/DashBoardProviders/MeProviders/MeScreen_Provider.dart';
import 'package:gleam_hr/Providers/DashBoardProviders/MoreProviders/ChangePassword_Provider.dart';
import 'package:gleam_hr/Providers/DashBoardProviders/MoreProviders/EmployeeRegisteration_Provider.dart';
import 'package:gleam_hr/Providers/DashBoardProviders/MoreProviders/OfficeLocation_Provider.dart';
import 'package:gleam_hr/Providers/DashBoardProviders/PeopleProviders/PeopleProvider.dart';
import 'package:provider/provider.dart';
import '../Providers/DashBoardProviders/AppbarProviders/Announcement_Provider.dart';
import '../Providers/DashBoardProviders/MoreProviders/EmployeeShift_Provider.dart';

var bindings = [
  ChangeNotifierProvider<DomainScreenProvider>(
    create: (context) => DomainScreenProvider(),
  ),
  ChangeNotifierProvider<LoginScreenProvider>(
    create: (context) => LoginScreenProvider(),
  ),
  ChangeNotifierProvider<ForgotPasswordProvider>(
    create: (context) => ForgotPasswordProvider(),
  ),
  ChangeNotifierProvider<VerifyPasswordProvider>(
    create: (context) => VerifyPasswordProvider(),
  ),
  ChangeNotifierProvider<SetPasswordProvider>(
    create: (context) => SetPasswordProvider(),
  ),
  ChangeNotifierProvider<BottomNavigationProvider>(
    create: (context) => BottomNavigationProvider(),
  ),
  ChangeNotifierProvider<DashBoardProvider>(
    create: (context) => DashBoardProvider(),
  ),
  ChangeNotifierProvider<PeopleProvider>(
    create: (context) => PeopleProvider(),
  ),
  ChangeNotifierProvider<MeScreenProvider>(
    create: (context) => MeScreenProvider(),
  ),
  ChangeNotifierProvider<AnnouncementProvider>(
    create: (context) => AnnouncementProvider(),
  ),
  ChangeNotifierProvider<InboxProvider>(
    create: (context) => InboxProvider(),
  ),
  ChangeNotifierProvider<WorkFromHomeProvider>(
    create: (context) => WorkFromHomeProvider(),
  ),
  ChangeNotifierProvider<CorrectionRequestProvider>(
    create: (context) => CorrectionRequestProvider(),
  ),
  ChangeNotifierProvider<ExpenseRequestProvider>(
    create: (context) => ExpenseRequestProvider(),
  ),
  ChangeNotifierProvider<TimeTrackingProvider>(
    create: (context) => TimeTrackingProvider(),
  ),
  ChangeNotifierProvider<LoginOnboardingProvider>(
    create: (context) => LoginOnboardingProvider(),
  ),
  ChangeNotifierProvider<ChangePasswordProvider>(
    create: (context) => ChangePasswordProvider(),
  ),
  ChangeNotifierProvider<BottomBarIconProvider>(
    create: (context) => BottomBarIconProvider(),
  ),
   ChangeNotifierProvider<SettingScreenProvider>(
    create: (context) => SettingScreenProvider(),
  ),
   ChangeNotifierProvider<TimeOffProvider>(
    create: (context) => TimeOffProvider(),
  ),
   ChangeNotifierProvider<EmployeeRegisterationProvider>(
    create: (context) => EmployeeRegisterationProvider(),
  ),
  ChangeNotifierProvider<EmployeeShiftProvider>(
    create: (context) => EmployeeShiftProvider(),
  ),
   ChangeNotifierProvider<AllCorrectionRequestsProvider>(
    create: (context) => AllCorrectionRequestsProvider(),
  ),
   ChangeNotifierProvider<AdminCorrectionRequestsProvider>(
    create: (context) => AdminCorrectionRequestsProvider(),
  ),
   ChangeNotifierProvider<OfficeLocationProvider>(
    create: (context) => OfficeLocationProvider(),
  ),
   ChangeNotifierProvider<AssetRequestProvider>(
    create: (context) => AssetRequestProvider(),
  ),
   ChangeNotifierProvider<LiveLocationProvider>(
    create: (context) => LiveLocationProvider(),
  ),
  ChangeNotifierProvider<AdminTimeOffRequestsProvider>(
    create: (context) => AdminTimeOffRequestsProvider(),
  ),
  ChangeNotifierProvider<ChangeEmployeeRoleProvider>(
    create: (context) => ChangeEmployeeRoleProvider(),),
  ChangeNotifierProvider<AdminExpenseRequestsProvider>(
    create: (context) => AdminExpenseRequestsProvider(),
  ),
];
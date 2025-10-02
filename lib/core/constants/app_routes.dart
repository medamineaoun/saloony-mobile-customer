import 'package:flutter/material.dart';
import 'package:saloony/features/Home/views/HomePageWidget.dart';
import 'package:saloony/features/auth/views/VerifyEmailWidget.dart';
import 'package:saloony/features/auth/views/widgets/VerifyResetCodeWidget.dart';
import 'package:saloony/features/splash/splash_page.dart';

import '../../data/models/user_model.dart';
import '../../features/auth/views/widgets/ForgotPasswordWidget.dart';
import '../../features/auth/views/widgets/LinkSentWidget.dart';
import '../../features/auth/views/widgets/ResetPasswordWidget.dart';
import '../../features/auth/views/widgets/SignInWidget.dart';
import '../../features/auth/views/widgets/SignUpWidget.dart';
import '../../features/auth/views/widgets/SuccessResetWidget.dart';
import '../../features/profile/views/profile_widget.dart';

class AppRoutes {
  static const String signIn = '/signIn';
  static const String splash = '/splash';

  static const String signUp = '/signUp';
  static const String forgotPassword = '/forgotPassword';
  static const String linkSent = '/linkSent';
  static const String resetPassword = '/resetPassword';
  static const String successReset = '/successReset';
  static const String home = '/home';
  static const String profile = '/profile';
static const String verifyEmail = '/verifyEmail';
static const String verifyResetCode = '/verifyResetCode';

 static Map<String, WidgetBuilder> routes = {
  signIn: (_) => const SignInWidget(),
  splash: (_) => const SaloonySplashPage(),
  signUp: (_) => const SignUpWidget(),
  forgotPassword: (_) => const ForgotPasswordWidget(),
  linkSent: (_) => const LinkSentWidget(),
  resetPassword: (_) => ResetPasswordWidget(),
  successReset: (_) => const SuccessResetWidget(),
  profile: (_) => const ProfileWidget(),
  verifyEmail: (_) => const VerifyEmailWidget(),
  verifyResetCode: (_) => const VerifyResetCodeWidget(),

  home: (_) => const HomePageWidget(), 
};

}

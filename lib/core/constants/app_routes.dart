import 'package:flutter/material.dart';
import 'package:saloony/features/Home/views/HomePageWidget.dart';
import 'package:saloony/features/auth/views/VerifyEmailWidget.dart';
import 'package:saloony/features/auth/views/VerifyResetCodeWidget.dart';
import 'package:saloony/features/profile/views/HelpCenterScreen.dart';
import 'package:saloony/features/profile/views/ResetPasswordView.dart';
import 'package:saloony/features/profile/views/email/ChangeEmailView.dart';
import 'package:saloony/features/profile/views/profile_edit_widget.dart';
import 'package:saloony/features/splash/splash_page.dart';

import '../../features/auth/views/ForgotPasswordWidget.dart';
import '../../features/auth/views/LinkSentWidget.dart';
import '../../features/auth/views/ResetPasswordWidget.dart';
import '../../features/auth/views/SignInWidget.dart';
import '../../features/auth/views/SignUpWidget.dart';
import '../../features/auth/views/SuccessResetWidget.dart';
import '../../features/profile/views/HelpCenterScreen.dart';
import '../../features/profile/views/profile_widget.dart';
import '../../features/profile/views/HelpCenterScreen.dart';

class AppRoutes {
  static const String splash = '/splash';
  static const String signIn = '/sign_in';
  static const String signUp = '/sign_up';
  static const String forgotPassword = '/forgot_password';
  static const String linkSent = '/link_sent';
  static const String resetPassword = '/reset_password';
  static const String successReset = '/success_reset';
  static const String home = '/home';
  static const String profile = '/profile';
  static const String verifyEmail = '/verifyEmail';
  static const String verifyResetCode = '/verify_reset_code';
  static const String editProfile = '/edit_profile';
  static const String resetPasswordProfile = '/reset_password_profile';
static const String HelpCenterScreen = '/faq';
static const String VerifyEmailChange = '/VerifyEmailChange';
  static Map<String, WidgetBuilder> routes = {
    splash: (_) => const SaloonySplashPage(),
    signIn: (_) => const SignInWidget(),
    signUp: (_) => const SignUpWidget(),
    forgotPassword: (_) => const ForgotPasswordWidget(),
    linkSent: (_) => const LinkSentWidget(),
    resetPassword: (_) => ResetPasswordWidget(),
    successReset: (_) => const SuccessResetWidget(),
    profile: (_) => const ProfileWidget(),
    verifyEmail: (_) => const VerifyEmailWidget(),
    verifyResetCode: (_) => const VerifyResetCodeWidget(),
    editProfile: (_) => const ProfileEditView(),
    resetPasswordProfile: (_) => const ResetPasswordViewP(),
    HelpCenterScreen: (_) => const HelpCenterScreenP(),
        VerifyEmailChange: (_) => const VerifyEmailChangeView(),

    home: (_) => const HomePage(),
  };
}

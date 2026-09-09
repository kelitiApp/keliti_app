import 'package:flutter/material.dart';

import '../../features/auth/presentation/pages/create_account_page.dart';
import '../../features/auth/presentation/pages/forgot_password_page.dart';
import '../../features/auth/presentation/pages/login_page.dart';
import '../../features/auth/presentation/pages/new_password_page.dart';
import '../../features/auth/presentation/pages/otp_verify_page.dart';
import '../../features/auth/presentation/pages/password_reset_success_page.dart';
import '../../features/family/presentation/pages/invite_family_member_page.dart';
import '../../features/notifications/presentation/pages/notifications_page.dart';
import '../../features/onboarding/presentation/pages/basic_info_page.dart';
import '../../features/onboarding/presentation/pages/dialysis_center_page.dart';
import '../../features/onboarding/presentation/pages/doctor_select_page.dart';
import '../../features/onboarding/presentation/pages/medical_info_page.dart';
import '../../features/onboarding/presentation/pages/onboarding_complete_page.dart';
import '../../features/shell/main_shell_page.dart';
import 'not_found_page.dart';
import 'routes.dart';

/// Centralized route table. Screens that need to pass rich typed objects
/// (a Medication, Appointment, etc.) are pushed directly via
/// MaterialPageRoute with typed constructor arguments from within their
/// feature — this table covers the app's primary, string-addressable
/// entry points (auth, onboarding, the main shell, notifications).
class AppRouter {
  const AppRouter._();

  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case AppRoutes.splash:
      case AppRoutes.login:
        return _page(const LoginPage(), settings);
      case AppRoutes.createAccount:
        return _page(const CreateAccountPage(), settings);
      case AppRoutes.otpVerify:
      case AppRoutes.resetOtp:
        return _page(OtpVerifyPage(args: settings.arguments as OtpVerifyArgs), settings);
      case AppRoutes.forgotPassword:
        return _page(const ForgotPasswordPage(), settings);
      case AppRoutes.newPassword:
        return _page(const NewPasswordPage(), settings);
      case AppRoutes.passwordResetSuccess:
        return _page(const PasswordResetSuccessPage(), settings);
      case AppRoutes.onboardingBasicInfo:
        return _page(const BasicInfoPage(), settings);
      case AppRoutes.onboardingMedicalInfo:
        return _page(const MedicalInfoPage(), settings);
      case AppRoutes.onboardingDialysisCenter:
        return _page(const DialysisCenterPage(), settings);
      case AppRoutes.onboardingDoctor:
        return _page(const DoctorSelectPage(), settings);
      case AppRoutes.familyInvite:
        return _page(const InviteFamilyMemberPage(isOnboardingStep: true), settings);
      case AppRoutes.onboardingComplete:
        return _page(const OnboardingCompletePage(), settings);
      case AppRoutes.mainShell:
        return _page(const MainShellPage(), settings);
      case AppRoutes.notifications:
        return _page(const NotificationsPage(), settings);
      default:
        return _page(NotFoundPage(routeName: settings.name), settings);
    }
  }

  static MaterialPageRoute<dynamic> _page(Widget child, RouteSettings settings) {
    return MaterialPageRoute(builder: (_) => child, settings: settings);
  }
}

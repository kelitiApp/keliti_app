/// Centralized route name constants. Never use raw route strings —
/// always reference `AppRoutes.*` from `Navigator.pushNamed`.
class AppRoutes {
  const AppRoutes._();

  // Splash / auth
  static const splash = '/';
  static const login = '/login';
  static const createAccount = '/create-account';
  static const otpVerify = '/otp-verify';
  static const forgotPassword = '/forgot-password';
  static const resetOtp = '/reset-otp';
  static const newPassword = '/new-password';
  static const passwordResetSuccess = '/password-reset-success';

  // Onboarding
  static const languageSelect = '/onboarding/language';
  static const onboardingBasicInfo = '/onboarding/basic-info';
  static const onboardingMedicalInfo = '/onboarding/medical-info';
  static const onboardingDialysisCenter = '/onboarding/dialysis-center';
  static const onboardingDoctor = '/onboarding/doctor';
  static const onboardingComplete = '/onboarding/complete';
  static const familyInvite = '/onboarding/family-invite';

  // Main shell (bottom nav)
  static const mainShell = '/home';

  // Medications
  static const medicationAdd = '/medications/add';
  static const medicationEdit = '/medications/edit';
  static const medicationDetail = '/medications/detail';
  static const doseConfirm = '/medications/dose-confirm';

  // Appointments
  static const appointmentAdd = '/appointments/add';
  static const appointmentDetail = '/appointments/detail';
  static const appointmentEdit = '/appointments/edit';
  static const attendanceConfirm = '/appointments/attendance-confirm';

  // Reports
  static const resultDetail = '/reports/result-detail';
  static const dialysisSessionDetail = '/reports/dialysis-session-detail';
  static const vitalsHub = '/reports/vitals';
  static const addMeasurement = '/reports/add-measurement';
  static const adherenceReport = '/reports/adherence';

  // Profile
  static const personalInfo = '/profile/personal-info';
  static const editPersonalInfo = '/profile/personal-info/edit';
  static const medicalCard = '/profile/medical-card';
  static const editMedicalCard = '/profile/medical-card/edit';
  static const familyContacts = '/profile/family-contacts';
  static const familyContactDetail = '/profile/family-contacts/detail';
  static const notificationsSettings = '/profile/notifications-settings';
  static const languageSettings = '/profile/language';
  static const helpSupport = '/profile/help-support';
  static const rateApp = '/profile/rate-app';
  static const deleteAccount = '/profile/delete-account';
  static const doctorCenterSettings = '/profile/doctor-center';
  static const changeDoctor = '/profile/doctor-center/change-doctor';
  static const changeCenter = '/profile/doctor-center/change-center';

  // Community
  static const communityHub = '/community';
  static const communityCategoryFeed = '/community/category';
  static const communityPostDetail = '/community/post';
  static const communityCreatePost = '/community/create-post';
  static const communitySettings = '/community/settings';
  static const communityIdentitySetup = '/community/identity-setup';

  // Fluids
  static const fluidsToday = '/fluids';
  static const addFluid = '/fluids/add';
  static const fluidLogList = '/fluids/log';
  static const fluidDailyLimit = '/fluids/limit';

  // Food assistant
  static const foodAssistant = '/food-assistant';
  static const foodResult = '/food-assistant/result';
  static const foodQuestionHistory = '/food-assistant/history';

  // Assistance / help
  static const assistanceHub = '/assistance';
  static const symptomReport = '/assistance/symptom-report';
  static const requestSent = '/assistance/request-sent';
  static const myRequests = '/assistance/requests';
  static const requestDetail = '/assistance/requests/detail';

  // Notifications
  static const notifications = '/notifications';
}

import 'package:flutter/material.dart';

import '../../../../core/routes/routes.dart';
import '../../../../core/widgets/widgets.dart';

class PasswordResetSuccessPage extends StatelessWidget {
  const PasswordResetSuccessPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AppResultView(
        title: 'تم تعيين كلمة المرور الجديدة بنجاح',
        description: 'الان يمكنك تسجيل الدخول',
        primaryLabel: 'تسجيل الدخول',
        onPrimary: () => Navigator.of(context).pushNamedAndRemoveUntil(AppRoutes.login, (route) => false),
      ),
    );
  }
}

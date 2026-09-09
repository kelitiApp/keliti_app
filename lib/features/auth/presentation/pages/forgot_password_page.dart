import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/routes/routes.dart';
import '../../../../core/theme/theme.dart';
import '../../../../core/widgets/widgets.dart';
import '../cubit/auth_cubit.dart';
import 'otp_verify_page.dart';

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({super.key});

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final _phoneController = TextEditingController();

  @override
  void dispose() {
    _phoneController.dispose();
    super.dispose();
  }

  Future<void> _submit(BuildContext context) async {
    final ok = await context.read<AuthCubit>().requestPasswordReset(_phoneController.text);
    if (!context.mounted) return;
    if (ok) {
      Navigator.of(context).pushNamed(
        AppRoutes.resetOtp,
        arguments: OtpVerifyArgs(phone: _phoneController.text, purpose: OtpPurpose.passwordReset),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('أدخل رقم جوال صحيح')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      body: BlocBuilder<AuthCubit, AuthState>(
        builder: (context, state) {
          final loading = state.status == AuthStatus.loading;
          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const AppPageHeader(
                title: 'نسيت كلمة المرور؟',
                subtitle: 'ادخل رقم جوالك المسجل وسنرسل لك رمز تحقق لإعادة تعيينها',
              ),
              const SizedBox(height: AppSpacing.xl),
              AppTextField(
                label: 'رقم الجوال',
                hint: '05xxxxxxxx',
                controller: _phoneController,
                keyboardType: TextInputType.phone,
                textAlign: TextAlign.right,
              ),
              const SizedBox(height: AppSpacing.xl),
              AppButton(
                label: 'تأكيد ومتابعة',
                isLoading: loading,
                onPressed: loading ? null : () => _submit(context),
              ),
            ],
          );
        },
      ),
    );
  }
}

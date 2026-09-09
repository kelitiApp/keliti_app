import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/routes/routes.dart';
import '../../../../core/theme/theme.dart';
import '../../../../core/widgets/widgets.dart';
import '../cubit/auth_cubit.dart';

enum OtpPurpose { accountVerification, passwordReset }

class OtpVerifyArgs {
  const OtpVerifyArgs({required this.phone, this.purpose = OtpPurpose.accountVerification});

  final String phone;
  final OtpPurpose purpose;
}

class OtpVerifyPage extends StatefulWidget {
  const OtpVerifyPage({super.key, required this.args});

  final OtpVerifyArgs args;

  @override
  State<OtpVerifyPage> createState() => _OtpVerifyPageState();
}

class _OtpVerifyPageState extends State<OtpVerifyPage> {
  String _code = '';
  int _secondsLeft = 167;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  void _startTimer() {
    _timer?.cancel();
    _secondsLeft = 167;
    _timer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (_secondsLeft <= 0) {
        t.cancel();
        return;
      }
      setState(() => _secondsLeft--);
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  String get _formattedTime {
    final m = (_secondsLeft ~/ 60).toString();
    final s = (_secondsLeft % 60).toString().padLeft(2, '0');
    return '$m:$s';
  }

  Future<void> _submit(BuildContext context) async {
    final ok = await context.read<AuthCubit>().verifyOtp(_code);
    if (!context.mounted) return;
    if (!ok) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('الرمز غير مكتمل')));
      return;
    }
    if (widget.args.purpose == OtpPurpose.accountVerification) {
      Navigator.of(context).pushNamedAndRemoveUntil(AppRoutes.onboardingBasicInfo, (route) => false);
    } else {
      Navigator.of(context).pushNamed(AppRoutes.newPassword);
    }
  }

  @override
  Widget build(BuildContext context) {
    final masked = widget.args.phone.length >= 4
        ? '${widget.args.phone.substring(0, widget.args.phone.length - 4)}xxxx'
        : widget.args.phone;

    return AppScaffold(
      body: BlocBuilder<AuthCubit, AuthState>(
        builder: (context, state) {
          final loading = state.status == AuthStatus.loading;
          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const AppPageHeader(title: 'تأكيد رقم الجوال'),
              Text(
                'أرسلنا رمز تحقق من 4 أرقام الى الرقم\n$masked',
                textAlign: TextAlign.right,
                style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textSecondary),
              ),
              const SizedBox(height: AppSpacing.xl),
              OtpInputField(length: 4, onChanged: (value) => setState(() => _code = value)),
              const SizedBox(height: AppSpacing.md),
              Center(
                child: Text(_formattedTime, style: AppTextStyles.titleMedium.copyWith(color: AppColors.primary)),
              ),
              const SizedBox(height: AppSpacing.xl),
              AppButton(
                label: 'ابدأ الآن',
                isLoading: loading,
                onPressed: (_code.length == 4 && !loading) ? () => _submit(context) : null,
              ),
              const SizedBox(height: AppSpacing.md),
              Center(
                child: TextButton(
                  onPressed: _secondsLeft == 0 ? _startTimer : null,
                  child: RichText(
                    text: TextSpan(
                      style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textSecondary),
                      children: [
                        const TextSpan(text: 'لم يصلك الرمز؟ '),
                        TextSpan(
                          text: 'اعادة الإرسال',
                          style: AppTextStyles.bodyMedium.copyWith(
                            color: AppColors.primary,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

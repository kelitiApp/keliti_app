import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/routes/routes.dart';
import '../../../../core/theme/theme.dart';
import '../../../../core/widgets/widgets.dart';
import '../cubit/auth_cubit.dart';
import 'otp_verify_page.dart';

class CreateAccountPage extends StatefulWidget {
  const CreateAccountPage({super.key});

  @override
  State<CreateAccountPage> createState() => _CreateAccountPageState();
}

class _CreateAccountPageState extends State<CreateAccountPage> {
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _submit(BuildContext context) async {
    final ok = await context.read<AuthCubit>().createAccount(
          fullName: _nameController.text,
          phone: _phoneController.text,
          password: _passwordController.text,
        );
    if (!context.mounted) return;
    if (ok) {
      Navigator.of(context).pushNamed(
        AppRoutes.otpVerify,
        arguments: OtpVerifyArgs(phone: _phoneController.text),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('يرجى تعبئة جميع الحقول (كلمة المرور 6 أحرف على الأقل)')),
      );
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
              AppPageHeader(
                title: 'إنشاء حساب المريض',
                subtitle: 'أدخل بياناتك الأساسية لإنشاء حسابك في كليتي',
                stepProgress: const [true, false, false, false, false],
              ),
              const SizedBox(height: AppSpacing.xl),
              AppTextField(
                label: 'الاسم الكامل',
                hint: 'مثال: أحمد محمد',
                controller: _nameController,
                textAlign: TextAlign.right,
              ),
              const SizedBox(height: AppSpacing.md),
              AppTextField(
                label: 'رقم الجوال',
                hint: '05xxxxxxxx',
                controller: _phoneController,
                keyboardType: TextInputType.phone,
                textAlign: TextAlign.right,
              ),
              const SizedBox(height: AppSpacing.md),
              AppTextField(
                label: 'أنشئ كلمة مرور',
                hint: '........',
                controller: _passwordController,
                obscureText: true,
                textAlign: TextAlign.right,
              ),
              const SizedBox(height: AppSpacing.xl),
              AppButton(
                label: 'إنشاء الحساب',
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

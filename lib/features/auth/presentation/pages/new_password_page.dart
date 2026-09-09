import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/routes/routes.dart';
import '../../../../core/theme/theme.dart';
import '../../../../core/widgets/widgets.dart';
import '../cubit/auth_cubit.dart';

class NewPasswordPage extends StatefulWidget {
  const NewPasswordPage({super.key});

  @override
  State<NewPasswordPage> createState() => _NewPasswordPageState();
}

class _NewPasswordPageState extends State<NewPasswordPage> {
  final _passwordController = TextEditingController();
  final _confirmController = TextEditingController();

  @override
  void dispose() {
    _passwordController.dispose();
    _confirmController.dispose();
    super.dispose();
  }

  Future<void> _submit(BuildContext context) async {
    final ok = await context
        .read<AuthCubit>()
        .setNewPassword(_passwordController.text, _confirmController.text);
    if (!context.mounted) return;
    if (ok) {
      Navigator.of(context).pushNamedAndRemoveUntil(AppRoutes.passwordResetSuccess, (route) => false);
    } else {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('تأكد من تطابق كلمتي المرور (6 أحرف على الأقل)')));
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
                title: 'كلمة مرور جديدة',
                subtitle: 'اختر كلمة مرور قوية لحسابك ولا تشاركها مع أحد',
                showBack: false,
              ),
              const SizedBox(height: AppSpacing.xl),
              AppTextField(
                label: 'كلمة المرور الجديدة',
                hint: '........',
                controller: _passwordController,
                obscureText: true,
                textAlign: TextAlign.right,
              ),
              const SizedBox(height: AppSpacing.md),
              AppTextField(
                label: 'تأكيد كلمة المرور',
                hint: '........',
                controller: _confirmController,
                obscureText: true,
                textAlign: TextAlign.right,
              ),
              const SizedBox(height: AppSpacing.xs),
              Text(
                'قوة كلمة المرور: متوسطة',
                textAlign: TextAlign.right,
                style: AppTextStyles.caption,
              ),
              const SizedBox(height: AppSpacing.xl),
              AppButton(
                label: 'حفظ كلمة المرور',
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

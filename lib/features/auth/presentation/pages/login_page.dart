import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/routes/routes.dart';
import '../../../../core/theme/theme.dart';
import '../../../../core/widgets/widgets.dart';
import '../cubit/auth_cubit.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool _isFamilyMember = false;
  bool _rememberMe = true;
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _phoneController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _submit(BuildContext context) async {
    final ok = await context.read<AuthCubit>().login(
          phone: _phoneController.text,
          password: _passwordController.text,
        );
    if (!context.mounted) return;
    if (ok) {
      Navigator.of(context).pushNamedAndRemoveUntil(AppRoutes.mainShell, (route) => false);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('يرجى إدخال رقم الجوال وكلمة المرور')),
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
              const SizedBox(height: AppSpacing.xxxl),
              Center(
                child: Column(
                  children: [
                    Container(
                      width: 88,
                      height: 88,
                      decoration: const BoxDecoration(color: AppColors.primaryLight, shape: BoxShape.circle),
                      child: const Icon(Icons.water_drop_rounded, color: AppColors.primary, size: 40),
                    ),
                    const SizedBox(height: AppSpacing.md),
                    Text('كليتي', style: AppTextStyles.displaySmall.copyWith(color: AppColors.primary)),
                    const SizedBox(height: AppSpacing.xxs),
                    Text(
                      'نحو حياة أكثر راحة واطمئناناً',
                      style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textSecondary),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.xxl),
              Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(color: AppColors.surfaceAlt, borderRadius: AppRadius.radiusMd),
                child: Row(
                  children: [
                    Expanded(
                      child: _RoleTab(
                        label: 'مريض',
                        selected: !_isFamilyMember,
                        onTap: () => setState(() => _isFamilyMember = false),
                      ),
                    ),
                    Expanded(
                      child: _RoleTab(
                        label: 'أحد أفراد العائلة',
                        selected: _isFamilyMember,
                        onTap: () => setState(() => _isFamilyMember = true),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.xl),
              AppTextField(
                label: 'رقم الجوال',
                hint: '05xxxxxxxx',
                controller: _phoneController,
                keyboardType: TextInputType.phone,
                textAlign: TextAlign.right,
              ),
              const SizedBox(height: AppSpacing.md),
              AppTextField(
                label: 'كلمة المرور',
                hint: '........',
                controller: _passwordController,
                obscureText: true,
                textAlign: TextAlign.right,
              ),
              const SizedBox(height: AppSpacing.sm),
              Row(
                children: [
                  TextButton(
                    onPressed: () => Navigator.of(context).pushNamed(AppRoutes.forgotPassword),
                    child: const Text('نسيت كلمة المرور؟'),
                  ),
                  const Spacer(),
                  Row(
                    children: [
                      Text('تذكرني', style: AppTextStyles.bodyMedium),
                      Checkbox(
                        value: _rememberMe,
                        activeColor: AppColors.primary,
                        onChanged: (v) => setState(() => _rememberMe = v ?? true),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.md),
              AppButton(
                label: 'تسجيل الدخول',
                isLoading: loading,
                onPressed: loading ? null : () => _submit(context),
              ),
              const SizedBox(height: AppSpacing.xl),
              Center(
                child: TextButton(
                  onPressed: () => Navigator.of(context).pushNamed(AppRoutes.createAccount),
                  child: RichText(
                    text: TextSpan(
                      style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textSecondary),
                      children: [
                        const TextSpan(text: 'ليس لديك حساب؟ '),
                        TextSpan(
                          text: 'أنشئ حسابا جديدا',
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

class _RoleTab extends StatelessWidget {
  const _RoleTab({required this.label, required this.selected, required this.onTap});

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: selected ? AppColors.primary : Colors.transparent,
          borderRadius: AppRadius.radiusSm,
        ),
        alignment: Alignment.center,
        child: Text(
          label,
          style: AppTextStyles.bodyMedium.copyWith(
            color: selected ? Colors.white : AppColors.textSecondary,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }
}

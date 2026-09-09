import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/session/patient_cubit.dart';
import '../../../../core/theme/theme.dart';
import '../../../../core/widgets/widgets.dart';

class EditPersonalInfoPage extends StatefulWidget {
  const EditPersonalInfoPage({super.key});

  @override
  State<EditPersonalInfoPage> createState() => _EditPersonalInfoPageState();
}

class _EditPersonalInfoPageState extends State<EditPersonalInfoPage> {
  late final patient = context.read<PatientCubit>().state;
  late final _nameController = TextEditingController(text: patient.fullName);
  late final _birthController = TextEditingController(text: patient.birthDate);
  late final _phoneController = TextEditingController(text: patient.phone);
  late final _addressController = TextEditingController(text: patient.address);
  late String _gender = patient.gender;
  late String _bloodType = patient.bloodType;

  @override
  void dispose() {
    _nameController.dispose();
    _birthController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  void _save() {
    context.read<PatientCubit>().updatePersonalInfo(
          fullName: _nameController.text,
          birthDate: _birthController.text,
          gender: _gender,
          bloodType: _bloodType,
          phone: _phoneController.text,
          address: _addressController.text,
        );

    showDialog<void>(
      context: context,
      builder: (dialogContext) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: AppRadius.radiusLg),
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: AppResultView(
            title: 'تم تحديث بياناتك بنجاح',
            description: 'تم حفظ معلوماتك الشخصية الجديدة.',
            primaryLabel: 'العودة إلى الملف الشخصي',
            onPrimary: () => Navigator.of(dialogContext)
              ..pop()
              ..pop(),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const AppPageHeader(title: 'تعديل البيانات'),
          const SizedBox(height: AppSpacing.lg),
          Center(
            child: Stack(
              children: [
                CircleAvatar(
                  radius: 40,
                  backgroundColor: AppColors.primaryLight,
                  child: Text(patient.fullName.substring(0, 1), style: AppTextStyles.displaySmall.copyWith(color: AppColors.primary)),
                ),
                Positioned(
                  bottom: 0,
                  left: 0,
                  child: Container(
                    width: 28,
                    height: 28,
                    decoration: const BoxDecoration(color: AppColors.primary, shape: BoxShape.circle),
                    child: const Icon(Icons.camera_alt_outlined, color: Colors.white, size: 14),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          AppTextField(label: 'الاسم الكامل', controller: _nameController, textAlign: TextAlign.right),
          const SizedBox(height: AppSpacing.md),
          AppTextField(label: 'تاريخ الميلاد', controller: _birthController, textAlign: TextAlign.right),
          const SizedBox(height: AppSpacing.md),
          Text('الجنس', style: AppTextStyles.titleSmall, textAlign: TextAlign.right),
          const SizedBox(height: AppSpacing.sm),
          Row(
            children: [
              Expanded(child: SelectableChip(label: 'أنثى', selected: _gender == 'أنثى', onTap: () => setState(() => _gender = 'أنثى'))),
              const SizedBox(width: AppSpacing.xs),
              Expanded(child: SelectableChip(label: 'ذكر', selected: _gender == 'ذكر', onTap: () => setState(() => _gender = 'ذكر'))),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          AppTextField(
            label: 'فصيلة الدم',
            controller: TextEditingController(text: _bloodType),
            textAlign: TextAlign.right,
            onChanged: (v) => _bloodType = v,
          ),
          const SizedBox(height: AppSpacing.md),
          AppTextField(label: 'رقم الهاتف', controller: _phoneController, keyboardType: TextInputType.phone, textAlign: TextAlign.right),
          const SizedBox(height: AppSpacing.md),
          AppTextField(label: 'العنوان', controller: _addressController, textAlign: TextAlign.right),
          const SizedBox(height: AppSpacing.xl),
          AppButton(label: 'حفظ التعديلات', onPressed: _save),
        ],
      ),
    );
  }
}

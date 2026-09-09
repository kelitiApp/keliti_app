import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/session/patient_cubit.dart';
import '../../../../core/theme/theme.dart';
import '../../../../core/widgets/widgets.dart';

class EditMedicalCardPage extends StatefulWidget {
  const EditMedicalCardPage({super.key});

  @override
  State<EditMedicalCardPage> createState() => _EditMedicalCardPageState();
}

class _EditMedicalCardPageState extends State<EditMedicalCardPage> {
  late final patient = context.read<PatientCubit>().state;
  late final _allergiesController = TextEditingController(text: patient.allergies);
  late final _conditionsController = TextEditingController(text: patient.additionalConditions);
  late bool _showSchedule = patient.showDialysisScheduleOnCard;
  late bool _showEmergencyContact = patient.showEmergencyContactOnCard;
  late bool _showMedications = patient.showMedicationsOnCard;

  @override
  void dispose() {
    _allergiesController.dispose();
    _conditionsController.dispose();
    super.dispose();
  }

  void _save() {
    context.read<PatientCubit>().updateMedicalCard(
          allergies: _allergiesController.text,
          additionalConditions: _conditionsController.text,
          showDialysisScheduleOnCard: _showSchedule,
          showEmergencyContactOnCard: _showEmergencyContact,
          showMedicationsOnCard: _showMedications,
        );

    showDialog<void>(
      context: context,
      builder: (dialogContext) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: AppRadius.radiusLg),
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: AppResultView(
            tone: ResultTone.error,
            icon: Icons.check_rounded,
            title: 'تم تحديث بطاقتك الطبية',
            description: 'صار الكود محدث بأخر معلوماتك — جاهزة لأي حالة طارئة.',
            primaryLabel: 'العودة للبطاقة',
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
          const AppPageHeader(title: 'تعديل البطاقة'),
          const SizedBox(height: AppSpacing.lg),
          AppTextField(label: 'الحساسيات', controller: _allergiesController, textAlign: TextAlign.right),
          const SizedBox(height: AppSpacing.md),
          AppTextField(label: 'حالات صحية إضافية', hint: 'مثال: سكري، ضغط...', controller: _conditionsController, textAlign: TextAlign.right),
          const SizedBox(height: AppSpacing.lg),
          Text('إظهار على البطاقة', style: AppTextStyles.titleSmall, textAlign: TextAlign.right),
          const SizedBox(height: AppSpacing.sm),
          AppToggleTile(title: 'جدول الغسيل', value: _showSchedule, onChanged: (v) => setState(() => _showSchedule = v)),
          const SizedBox(height: AppSpacing.sm),
          AppToggleTile(title: 'جهة اتصال الطوارئ', value: _showEmergencyContact, onChanged: (v) => setState(() => _showEmergencyContact = v)),
          const SizedBox(height: AppSpacing.sm),
          AppToggleTile(title: 'قائمة الأدوية الحالية', value: _showMedications, onChanged: (v) => setState(() => _showMedications = v)),
          const SizedBox(height: AppSpacing.xl),
          AppButton(label: 'حفظ البطاقة', variant: AppButtonVariant.destructive, onPressed: _save),
        ],
      ),
    );
  }
}

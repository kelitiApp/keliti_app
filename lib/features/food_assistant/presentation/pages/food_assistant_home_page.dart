import 'package:flutter/material.dart';

import '../../../../core/theme/theme.dart';
import '../../../../core/widgets/widgets.dart';
import '../../data/food_item.dart';
import 'food_question_history_page.dart';
import 'food_result_page.dart';

const _faqChips = ['موز', 'بطاطا', 'مكسرات'];

class FoodAssistantHomePage extends StatefulWidget {
  const FoodAssistantHomePage({super.key});

  @override
  State<FoodAssistantHomePage> createState() => _FoodAssistantHomePageState();
}

class _FoodAssistantHomePageState extends State<FoodAssistantHomePage> {
  final _searchController = TextEditingController();

  void _search(String query) {
    if (query.trim().isEmpty) return;
    Navigator.of(context).push(MaterialPageRoute(builder: (_) => FoodResultPage(item: FoodItem.lookup(query))));
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          AppPageHeader(
            title: 'مساعد الغذاء',
            trailing: AppCircleIconButton(
              icon: Icons.history_rounded,
              filled: false,
              onPressed: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => const FoodQuestionHistoryPage())),
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          Center(
            child: Container(
              width: 96,
              height: 96,
              decoration: const BoxDecoration(color: AppColors.primaryLight, shape: BoxShape.circle),
              child: const Icon(Icons.restaurant_menu_rounded, color: AppColors.primary, size: 40),
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          Text('اسأليني عن أي أكلة', textAlign: TextAlign.center, style: AppTextStyles.titleLarge),
          const SizedBox(height: 4),
          Text(
            'بربطلك الإجابة بآخر نتائج فحوصاتك (البوتاسيوم، الفوسفور، الصوديوم)',
            textAlign: TextAlign.center,
            style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textSecondary),
          ),
          const SizedBox(height: AppSpacing.lg),
          AppTextField(
            hint: 'اكتبي اسم الطعام...',
            controller: _searchController,
            prefixIcon: Icons.search,
            textAlign: TextAlign.right,
            onChanged: (_) => setState(() {}),
          ),
          const SizedBox(height: AppSpacing.sm),
          AppButton(
            label: 'أو صوّري الطبق',
            variant: AppButtonVariant.outlined,
            icon: Icons.camera_alt_outlined,
            onPressed: () => _search('دجاج مشوي'),
          ),
          const SizedBox(height: AppSpacing.lg),
          Text('أسئلة شائعة', style: AppTextStyles.titleSmall, textAlign: TextAlign.right),
          const SizedBox(height: AppSpacing.sm),
          Wrap(
            alignment: WrapAlignment.end,
            spacing: AppSpacing.xs,
            children: [for (final f in _faqChips) SelectableChip(label: f, selected: false, onTap: () => _search(f))],
          ),
          const SizedBox(height: AppSpacing.md),
          AppButton(label: 'بحث', onPressed: () => _search(_searchController.text)),
        ],
      ),
    );
  }
}

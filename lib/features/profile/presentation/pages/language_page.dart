import 'package:flutter/material.dart';

import '../../../../core/theme/theme.dart';
import '../../../../core/widgets/widgets.dart';

class LanguagePage extends StatefulWidget {
  const LanguagePage({super.key});

  @override
  State<LanguagePage> createState() => _LanguagePageState();
}

class _LanguagePageState extends State<LanguagePage> {
  String _language = 'ar';

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const AppPageHeader(title: 'اللغة'),
          const SizedBox(height: AppSpacing.lg),
          AppCard(
            padding: EdgeInsets.zero,
            child: Column(
              children: [
                RadioListTile<String>(
                  value: 'ar',
                  groupValue: _language,
                  activeColor: AppColors.primary,
                  onChanged: (v) => setState(() => _language = v!),
                  title: const Text('العربية', textAlign: TextAlign.right),
                ),
                const Divider(height: 1),
                RadioListTile<String>(
                  value: 'en',
                  groupValue: _language,
                  activeColor: AppColors.primary,
                  onChanged: (v) => setState(() => _language = v!),
                  title: const Text('English', textAlign: TextAlign.right),
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.xl),
          AppButton(
            label: 'تطبيق',
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: Text(_language == 'ar' ? 'اللغة العربية مفعّلة بالفعل' : 'English support is coming soon'),
              ));
            },
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';

import '../../../../core/theme/theme.dart';
import '../../../../core/widgets/widgets.dart';

const _principles = [
  ('🤝', 'الاحترام أولاً', 'كل تجربة محترمة، حتى لو اختلفنا فيها.'),
  ('🩺', 'هاد مجتمع دعم، مو نصيحة طبية', 'أي قرار علاجي رجعي فيه لطبيبك المتابع.'),
  ('🔒', 'ما تشاركي معلومات تعرّفك', 'اسمك، رقمك، أو مكان سكنك — حافظي عليها لحالك.'),
  ('🚩', 'شايفة إشي مقلق؟ بلّغي', 'فريقنا يراجع كل بلاغ بسرية تامة.'),
];

class CommunityPrinciplesPage extends StatelessWidget {
  const CommunityPrinciplesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const AppPageHeader(title: 'مبادئ المجتمع'),
          const SizedBox(height: AppSpacing.lg),
          for (final p in _principles) ...[
            AppCard(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(p.$2, style: AppTextStyles.titleSmall),
                        const SizedBox(height: 4),
                        Text(p.$3, textAlign: TextAlign.right, style: AppTextStyles.bodySmall),
                      ],
                    ),
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  Text(p.$1, style: const TextStyle(fontSize: 24)),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.sm),
          ],
        ],
      ),
    );
  }
}

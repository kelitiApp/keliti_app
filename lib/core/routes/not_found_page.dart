import 'package:flutter/material.dart';

import '../widgets/widgets.dart';
import 'routes.dart';

/// Shown for any unknown/unregistered route name instead of crashing.
class NotFoundPage extends StatelessWidget {
  const NotFoundPage({super.key, this.routeName});

  final String? routeName;

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        body: AppResultView(
          tone: ResultTone.error,
          icon: Icons.search_off_rounded,
          title: 'الصفحة غير موجودة',
          description: routeName == null
              ? 'تعذر العثور على هذه الصفحة.'
              : 'تعذر العثور على المسار "$routeName".',
          primaryLabel: 'العودة إلى الرئيسية',
          onPrimary: () => Navigator.of(context).pushNamedAndRemoveUntil(
            AppRoutes.mainShell,
            (route) => false,
          ),
        ),
      ),
    );
  }
}

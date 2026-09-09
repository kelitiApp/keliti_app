import 'package:equatable/equatable.dart';

enum FoodVerdict { safe, caution, avoid }

class NutrientValue extends Equatable {
  const NutrientValue({required this.label, required this.value, required this.status});

  final String label;
  final String value;

  /// 'آمن' | 'متوسط' | 'مرتفع'
  final String status;

  @override
  List<Object?> get props => [label, value, status];
}

class FoodItem extends Equatable {
  const FoodItem({
    required this.name,
    required this.verdict,
    required this.headline,
    required this.subline,
    required this.nutrients,
    this.note,
  });

  final String name;
  final FoodVerdict verdict;
  final String headline;
  final String subline;
  final List<NutrientValue> nutrients;
  final String? note;

  @override
  List<Object?> get props => [name, verdict, headline, subline, nutrients, note];

  static const _database = <String, FoodItem>{
    'موز': FoodItem(
      name: 'موز',
      verdict: FoodVerdict.avoid,
      headline: 'يُفضّل تجنبه حالياً',
      subline: 'بناءً على نتيجة فحصك الأخيرة (بوتاسيوم: مرتفع 5.8)',
      nutrients: [
        NutrientValue(label: 'بوتاسيوم', value: '422 ملغ — مرتفع', status: 'مرتفع'),
        NutrientValue(label: 'فوسفور', value: '26 ملغ — آمن', status: 'آمن'),
        NutrientValue(label: 'صوديوم', value: '1 ملغ — آمن', status: 'آمن'),
      ],
    ),
    'دجاج مشوي': FoodItem(
      name: 'دجاج مشوي',
      verdict: FoodVerdict.safe,
      headline: 'آمن — تفضلي',
      subline: 'مناسب لحميتك الغذائية الحالية',
      nutrients: [
        NutrientValue(label: 'بوتاسيوم', value: '256 ملغ — آمن', status: 'آمن'),
        NutrientValue(label: 'فوسفور', value: '210 ملغ — آمن', status: 'آمن'),
        NutrientValue(label: 'صوديوم', value: '74 ملغ — آمن', status: 'آمن'),
      ],
      note: 'مصدر بروتين جيد بدون تحميل زائد على وظائف كليتك',
    ),
    'بطاطا مقلية': FoodItem(
      name: 'بطاطا مقلية',
      verdict: FoodVerdict.caution,
      headline: 'باعتدال — كمية محدودة بس',
      subline: 'مسموحة بس لا تكرريها كل يوم',
      nutrients: [
        NutrientValue(label: 'بوتاسيوم', value: '470 ملغ — متوسط', status: 'متوسط'),
        NutrientValue(label: 'فوسفور', value: '121 ملغ — آمن', status: 'آمن'),
        NutrientValue(label: 'صوديوم', value: '246 ملغ — متوسط', status: 'متوسط'),
      ],
      note: 'كمية قليلة (حصة صغيرة) مرة بالأسبوع تقريباً مقبولة، بس تجنّبيها بيوم الجلسة',
    ),
    'مكسرات': FoodItem(
      name: 'مكسرات',
      verdict: FoodVerdict.avoid,
      headline: 'يُفضّل تجنبه',
      subline: 'مرتفعة بالفوسفور والبوتاسيوم معاً',
      nutrients: [
        NutrientValue(label: 'بوتاسيوم', value: '620 ملغ — مرتفع', status: 'مرتفع'),
        NutrientValue(label: 'فوسفور', value: '390 ملغ — مرتفع', status: 'مرتفع'),
        NutrientValue(label: 'صوديوم', value: '5 ملغ — آمن', status: 'آمن'),
      ],
    ),
  };

  static FoodItem lookup(String query) {
    final match = _database.keys.firstWhere((k) => k.contains(query.trim()), orElse: () => 'دجاج مشوي');
    return _database[match]!;
  }

  static const safeAlternatives = <String, List<(String name, String potassium)>>{
    'موز': [('تفاح', '107 ملغ'), ('توت أزرق', '77 ملغ')],
  };
}

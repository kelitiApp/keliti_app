import 'package:equatable/equatable.dart';

enum MedicationForm { tablets, syrup, injection }

extension MedicationFormX on MedicationForm {
  String get label => switch (this) {
        MedicationForm.tablets => 'أقراص',
        MedicationForm.syrup => 'شراب',
        MedicationForm.injection => 'حقنة',
      };
}

class Medication extends Equatable {
  const Medication({
    required this.id,
    required this.name,
    required this.form,
    required this.doseAmount,
    required this.doseUnit,
    required this.timesPerDay,
    required this.doseTimes,
    this.notes = '',
    this.active = true,
    this.doctorName = 'د. أحمد خليل',
    this.treatmentEndDate = 'حتى 30 أكتوبر',
    this.stoppedOn,
    this.instructions = const [],
  });

  final String id;
  final String name;
  final MedicationForm form;
  final String doseAmount;
  final String doseUnit;
  final int timesPerDay;
  final List<String> doseTimes;
  final String notes;
  final bool active;
  final String doctorName;
  final String treatmentEndDate;
  final String? stoppedOn;
  final List<(String, String)> instructions; // (title, body)

  Medication copyWith({
    String? name,
    MedicationForm? form,
    String? doseAmount,
    String? doseUnit,
    int? timesPerDay,
    List<String>? doseTimes,
    String? notes,
    bool? active,
    String? stoppedOn,
  }) {
    return Medication(
      id: id,
      name: name ?? this.name,
      form: form ?? this.form,
      doseAmount: doseAmount ?? this.doseAmount,
      doseUnit: doseUnit ?? this.doseUnit,
      timesPerDay: timesPerDay ?? this.timesPerDay,
      doseTimes: doseTimes ?? this.doseTimes,
      notes: notes ?? this.notes,
      active: active ?? this.active,
      doctorName: doctorName,
      treatmentEndDate: treatmentEndDate,
      stoppedOn: stoppedOn ?? this.stoppedOn,
      instructions: instructions,
    );
  }

  static List<Medication> seed() => [
        const Medication(
          id: 'm1',
          name: 'كربونات الكالسيوم',
          form: MedicationForm.tablets,
          doseAmount: '500',
          doseUnit: 'ملغ',
          timesPerDay: 3,
          doseTimes: ['08:00 ص', '02:00 م', '08:00 م'],
          instructions: [
            ('مع الوجبات', 'يؤخذ القرص مع بداية الوجبة مباشرة لأنه يرتبط بالفوسفور الموجود بالأكل ويمنع امتصاصه.'),
            (
              'تنبيه هام',
              'لا تؤخذ كربونات الكالسيوم بنفس وقت أدوية الحديد أو المضادات الحيوية من نوع التتراسايكلين، لازم يكون بينهم فاصل ساعتين على الأقل لأنها تقلل من امتصاصهم.'
            ),
          ],
        ),
        const Medication(
          id: 'm2',
          name: 'إريثروبويتين',
          form: MedicationForm.injection,
          doseAmount: '6000',
          doseUnit: 'وحدة',
          timesPerDay: 1,
          doseTimes: ['08:00 م'],
          instructions: [
            (
              'مع الوجبات',
              'تُحفظ الإبرة بالثلاجة (٨-٢ درجة مئوية) ولا تُجمّد. تُعطى تحت الجلد حسب موعد الجرعة المحدد من الطبيب، مع تبديل مكان الحقن في كل مرة (البطن، الفخذ، أو أعلى الذراع) لتجنب تهيج الجلد.'
            ),
            (
              'تنبيه هام',
              'قد ترفع هذه الإبرة ضغط الدم، لذلك يجب مراقبة الضغط بانتظام. أخبر طبيبك فوراً في حال ظهور صداع شديد أو تورم غير معتاد.'
            ),
          ],
        ),
        const Medication(
          id: 'm3',
          name: 'سيفيلامير',
          form: MedicationForm.tablets,
          doseAmount: '800',
          doseUnit: 'ملغ',
          timesPerDay: 3,
          doseTimes: ['08:00 ص', '02:00 م', '08:00 م'],
          active: false,
          stoppedOn: '02/08',
          instructions: [
            ('مع الوجبات', 'يؤخذ القرص أثناء تناول الطعام لزيادة الفعالية.'),
            ('تنبيه هام', 'لا تتجاوز الجرعة الموصوفة دون استشارة الطبيب.'),
          ],
        ),
      ];

  @override
  List<Object?> get props => [
        id,
        name,
        form,
        doseAmount,
        doseUnit,
        timesPerDay,
        doseTimes,
        notes,
        active,
        doctorName,
        treatmentEndDate,
        stoppedOn,
      ];
}

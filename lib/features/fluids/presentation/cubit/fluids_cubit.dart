import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class FluidEntry extends Equatable {
  const FluidEntry({required this.id, required this.label, required this.amountMl, required this.timeLabel});

  final String id;
  final String label;
  final int amountMl;
  final String timeLabel;

  @override
  List<Object?> get props => [id, label, amountMl, timeLabel];
}

class FluidsState extends Equatable {
  const FluidsState({required this.dailyLimitMl, required this.todayEntries, required this.pastDayTotals});

  final int dailyLimitMl;
  final List<FluidEntry> todayEntries;

  /// label -> (consumedMl, limitMl) for the log history screen.
  final Map<String, (int, int)> pastDayTotals;

  int get todayTotalMl => todayEntries.fold(0, (sum, e) => sum + e.amountMl);
  int get remainingMl => (dailyLimitMl - todayTotalMl).clamp(0, dailyLimitMl);
  double get progress => (todayTotalMl / dailyLimitMl).clamp(0, 1);
  bool get isNearLimit => todayTotalMl >= dailyLimitMl * 0.9 && todayTotalMl < dailyLimitMl;
  bool get isOverLimit => todayTotalMl > dailyLimitMl;

  static FluidsState seed() => const FluidsState(
        dailyLimitMl: 1000,
        todayEntries: [
          FluidEntry(id: 'f1', label: 'كوب ماء', amountMl: 200, timeLabel: '09:15 ص'),
          FluidEntry(id: 'f2', label: 'عصير', amountMl: 400, timeLabel: '11:40 ص'),
        ],
        pastDayTotals: {
          'أمس': (920, 1000),
          'الأحد': (1150, 1000),
        },
      );

  FluidsState copyWith({int? dailyLimitMl, List<FluidEntry>? todayEntries}) => FluidsState(
        dailyLimitMl: dailyLimitMl ?? this.dailyLimitMl,
        todayEntries: todayEntries ?? this.todayEntries,
        pastDayTotals: pastDayTotals,
      );

  @override
  List<Object?> get props => [dailyLimitMl, todayEntries, pastDayTotals];
}

class FluidsCubit extends Cubit<FluidsState> {
  FluidsCubit() : super(FluidsState.seed());

  void addEntry({required String label, required int amountMl}) {
    final entry = FluidEntry(
      id: 'e${state.todayEntries.length + 1}',
      label: label,
      amountMl: amountMl,
      timeLabel: 'الآن',
    );
    emit(state.copyWith(todayEntries: [...state.todayEntries, entry]));
  }

  void setDailyLimit(int limitMl) => emit(state.copyWith(dailyLimitMl: limitMl));
}

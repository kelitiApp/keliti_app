import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/food_item.dart';

class FoodHistoryState {
  const FoodHistoryState({required this.entries});

  final List<FoodItem> entries;

  static FoodHistoryState seed() => FoodHistoryState(entries: [
        FoodItem.lookup('موز'),
        FoodItem.lookup('دجاج مشوي'),
        FoodItem.lookup('بطاطا مقلية'),
      ]);
}

class FoodHistoryCubit extends Cubit<FoodHistoryState> {
  FoodHistoryCubit() : super(FoodHistoryState.seed());

  void addQuery(FoodItem item) {
    emit(FoodHistoryState(entries: [item, ...state.entries]));
  }
}

import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../widgets/category_widget_all/category.model.dart';

class SelectedCategory {
  final UserCreatedCategoryModel model;

  SelectedCategory({required this.model});
}

final selectedCategoryProvider = StateProvider<UserCreatedCategoryModel>((ref) {
  return UserCreatedCategoryModel(
      categoryID: '', categoryName: 'No Category', colorHex: '#4C7755');
});

final categoryUpdateRadioProvider =
    StateProvider<UserCreatedCategoryModel>((ref) {
  return UserCreatedCategoryModel(
      categoryID: '', categoryName: 'No Category', colorHex: '#4C7755');
});

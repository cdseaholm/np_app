import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../widgets/category_widget_all/category.model.dart';

class SelectedCategory {
  final UserCreatedCategoryModel model;

  SelectedCategory({required this.model});
}

final categoryNameRadioProvider =
    StateProvider<UserCreatedCategoryModel>((ref) {
  return UserCreatedCategoryModel(
      categoryID: '', categoryName: 'Select Category', colorHex: '');
});

final taskRadioProvider = StateProvider<Map<String, dynamic>?>((ref) {
  return null;
});

final selectedCategoryProvider =
    StateProvider<UserCreatedCategoryModel?>((ref) => null);

final categoryUpdateRadioProvider =
    StateProvider<UserCreatedCategoryModel>((ref) {
  return UserCreatedCategoryModel(
      categoryID: '', categoryName: 'Select Category', colorHex: '');
});

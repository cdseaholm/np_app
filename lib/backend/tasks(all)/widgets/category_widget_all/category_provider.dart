import 'package:flutter/foundation.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'category.model.dart';
import 'category_service.dart';

final categoryProvider =
    StateNotifierProvider<CategoryListNotifier, List<UserCreatedCategoryModel>>(
        (ref) => CategoryListNotifier());

class CategoryListNotifier
    extends StateNotifier<List<UserCreatedCategoryModel>> {
  CategoryListNotifier() : super([]);

  Future<void> updateCategoriesState(
      List<UserCreatedCategoryModel> categories) async {
    state = categories;
  }

  Future<void> removeCategoriesState(UserCreatedCategoryModel category) async {
    state =
        state.where((item) => item.categoryID != category.categoryID).toList();
  }

  Future<void> updateCategoryState(
      UserCreatedCategoryModel updatedCategory) async {
    if (kDebugMode) {
      print('Updating category state...');
    }
    state = state.map((category) {
      if (category.categoryID == updatedCategory.categoryID) {
        return updatedCategory;
      }
      return category;
    }).toList();
  }
}

final categoryServiceProvider = StateProvider<CategoryService>(
  (ref) {
    return CategoryService();
  },
);

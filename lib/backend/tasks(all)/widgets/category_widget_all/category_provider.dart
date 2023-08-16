import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:np_app/backend/tasks(all)/widgets/category_widget_all/category_service.dart';
import 'category.model.dart';

final categoryServiceProvider = StateProvider<CategoryService>(
  (ref) {
    return CategoryService();
  },
);

final categoryModelProvider = StateProvider<UserCreatedCategoryModel>((ref) {
  return UserCreatedCategoryModel(
      categoryID: '', categoryName: '', colorHex: '');
});

Stream<List<UserCreatedCategoryModel?>> loadCategoryData() async* {
  final userID = FirebaseAuth.instance.currentUser?.uid;
  try {
    final QuerySnapshot<Map<String, dynamic>> categoriesQuery =
        await FirebaseFirestore.instance
            .collection('users')
            .doc(userID)
            .collection('Categories')
            .get();
    final categories = categoriesQuery.docs
        .map((category) => UserCreatedCategoryModel.fromSnapshot(category))
        .toList();
    // ignore: avoid_print
    print("...Categories...${categories[0]}");
    yield categories;
  } catch (e) {
    // Handle the error
    yield [];
  }
}

/*final fetchCategories =
    StreamProvider.autoDispose<List<UserCreatedCategoryModel?>>((ref) {
  final userID = ref.watch(authStateProvider).maybeWhen(
        data: (user) => user?.uid,
        orElse: () => null,
      );
  if (userID != null) {
    final categoryCollection = FirebaseFirestore.instance
        .collection('users')
        .doc(userID)
        .collection('Tasks')
        .snapshots()
        .map((event) => event.docs
            .map((snapshot) => UserCreatedCategoryModel.fromSnapshot(snapshot))
            .toList());

    return categoryCollection;
  } else {
    throw Stream.value(null);
  }
});*/

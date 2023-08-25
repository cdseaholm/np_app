import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

final userID = FirebaseAuth.instance.currentUser?.uid;

class UserCreatedCategoryModel {
  late String categoryID;
  final String categoryName;
  final String colorHex;

  UserCreatedCategoryModel({
    this.categoryID = '',
    required this.categoryName,
    required this.colorHex,
  });

  factory UserCreatedCategoryModel.fromSnapshot(
      QueryDocumentSnapshot<Map<String, dynamic>> snapshot) {
    final data = snapshot.data();
    return UserCreatedCategoryModel(
      categoryID: snapshot.id,
      categoryName: data['categoryName'] ?? '',
      colorHex: data['colorHex'] ?? '',
    );
  }
  UserCreatedCategoryModel.fromJson(Map<String, dynamic> json)
      : categoryID = json['categoryID'] as String,
        categoryName = json['categoryName'] as String,
        colorHex = json['colorHex'] as String;

  Map<String, dynamic> toJson() => {
        'categoryID': categoryID,
        'categoryName': categoryName,
        'colorHex': colorHex,
      };
}

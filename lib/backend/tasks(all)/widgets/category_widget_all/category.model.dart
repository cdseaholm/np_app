import 'package:cloud_firestore/cloud_firestore.dart';

class UserCreatedCategoryModel {
  final String categoryID;
  final String categoryName;
  final String colorHex;

  UserCreatedCategoryModel({
    required this.categoryID,
    required this.categoryName,
    required this.colorHex,
  });

  UserCreatedCategoryModel.fromSnapshot(
      QueryDocumentSnapshot<Map<String, dynamic>> snapshot)
      : categoryID = snapshot.id,
        categoryName = snapshot['categoryName'],
        colorHex = snapshot['colorHex'];

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

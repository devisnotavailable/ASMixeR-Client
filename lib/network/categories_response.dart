import 'package:asmixer/data/entities/category.dart';

class CategoriesResponse {
  final List<Category> categoryList;

  CategoriesResponse(this.categoryList);

  factory CategoriesResponse.fromJson(Map<String, dynamic> json) {
    List<Category> categories = [];
    json['cats'].forEach((v) {
      categories.add(Category.fromJson(v));
    });
    return CategoriesResponse(categories);
  }
}

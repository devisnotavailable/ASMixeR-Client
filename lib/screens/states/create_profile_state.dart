import 'package:asmixer/data/entities/category.dart';
import 'package:asmixer/screens/states/base_state.dart';

class CreateProfileState extends BaseState {
  final List<Category> categoryList;
  final List<Category> selectedCategories;

  @override
  List<Object> get props => [categoryList, selectedCategories];

  CreateProfileState(this.categoryList, this.selectedCategories);
}

class ProfileSavedState extends CreateProfileState {
  ProfileSavedState(
    List<Category> categoryList,
    List<Category> selectedCategories,
  ) : super(categoryList, selectedCategories);
}

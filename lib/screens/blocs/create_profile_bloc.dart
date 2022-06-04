import 'package:asmixer/data/entities/category.dart';
import 'package:asmixer/data/entities/profile.dart';
import 'package:asmixer/data/entities/profile_to_category.dart';
import 'package:asmixer/database/dao/category_dao.dart';
import 'package:asmixer/database/dao/profile_dao.dart';
import 'package:asmixer/database/dao/profile_to_category_dao.dart';
import 'package:asmixer/screens/events/create_profile_event.dart';
import 'package:asmixer/screens/states/create_profile_state.dart';
import 'package:bloc/bloc.dart';

class CreateProfileBloc extends Bloc<CreateProfileEvent, CreateProfileState> {
  late final ProfileDao profileDao;
  late final CategoryDao categoryDao;
  late final ProfileToCategoryDao profileToCategoryDao;

  CreateProfileBloc(CreateProfileState initialState, this.profileDao,
      this.categoryDao, this.profileToCategoryDao)
      : super(initialState) {
    on<InitCreateProfileEvent>(_onInitCreateProfile);
    on<SelectedCategoryChangedEvent>(_onSelectedCategoryChangedEvent);
    on<SaveProfileEvent>(_onSaveProfileEvent);
    on<ChangeProfileEvent>(_onSaveChange);
    on<InitCategoryEvent>(_onInitCategory);
  }

  _onInitCreateProfile(InitCreateProfileEvent event, Emitter emit) async {
    await emit.forEach(categoryDao.getAudioCategoriesStream(),
        onData: (List<Category> categoryList) {
      return CreateProfileState(categoryList, state.selectedCategories);
    });
  }

  _onSelectedCategoryChangedEvent(
      SelectedCategoryChangedEvent event, Emitter emit) {
    List<Category> newSelectedCategories = List.from(state.selectedCategories);

    newSelectedCategories.contains(event.category)
        ? newSelectedCategories.remove(event.category)
        : newSelectedCategories.add(event.category);

    emit(CreateProfileState(
      state.categoryList,
      newSelectedCategories,
    ));
  }

  _onSaveProfileEvent(SaveProfileEvent event, Emitter emit) async {
    var newProfileID = await profileDao.insertEntity(Profile(name: event.name));
    _saveProfileCategories(newProfileID, emit);
  }

  _saveProfileCategories(int newProfileID, Emitter emit) {
    for (var mainCategory in state.selectedCategories) {
      profileToCategoryDao.insertEntity(ProfileToCategory(
          profileID: newProfileID, categoryID: mainCategory.id));
    }
    emit(ProfileSavedState(state.categoryList, state.selectedCategories));
  }

  _onSaveChange(ChangeProfileEvent event, Emitter emit) async {
    await profileDao.updateEntity(event.profile);
    var beforeProfileCategories =
        await profileToCategoryDao.getCategoriesIDs(event.profile.id!);
    for (ProfileToCategory entity in beforeProfileCategories!) {
      await profileToCategoryDao.deleteEntity(entity);
    }
    _saveProfileCategories(event.profile.id!, emit);
  }

  _onInitCategory(InitCategoryEvent event, Emitter emitter) async {
    if (event.profile != null) {
      var currentProfileCategories =
          await profileToCategoryDao.getCategoriesIDs(event.profile!.id!);
      List<Category> selectedMainList = [];
      for (Category category in state.categoryList) {
        for (ProfileToCategory el in currentProfileCategories!) {
          if (category.id == el.categoryID) {
            selectedMainList.add(category);
          }
        }
      }
      emitter(CreateProfileState(
        state.categoryList,
        selectedMainList,
      ));
    }
  }
}

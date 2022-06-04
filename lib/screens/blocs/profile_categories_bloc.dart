import 'package:asmixer/data/entities/category.dart';
import 'package:asmixer/data/entities/profile_to_category.dart';
import 'package:asmixer/database/database.dart';
import 'package:asmixer/screens/events/profile_categories_event.dart';
import 'package:asmixer/screens/states/profile_categories_state.dart';
import 'package:bloc/bloc.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';

class ProfileCategoriesBloc
    extends Bloc<ProfileCategoriesEvent, ProfileCategoriesState> {
  AppDatabase appDatabase;

  ProfileCategoriesBloc(ProfileCategoriesState initialState, this.appDatabase)
      : super(initialState) {
    on<LoadCategoriesEvent>(_onLoadCategories, transformer: droppable());
    on<ProfileToCategoriesReadyEvent>(_onProfileToCategoriesReady);
  }

  _onLoadCategories(LoadCategoriesEvent event, Emitter emit) async {
    await emit.onEach(
        appDatabase.profileToCategoryDao
            .getCategoriesIDsStream(event.profileID),
        onData: (List<ProfileToCategory>? profileToCategoryList) {
      add(ProfileToCategoriesReadyEvent(profileToCategoryList ?? []));
    });
  }

  _onProfileToCategoriesReady(
      ProfileToCategoriesReadyEvent event, Emitter emit) async {
    List<Category> categories = [];
    for (var profileToCategory in event.profileToCategoryList) {
      categories.add((await appDatabase.categoryDao
          .getCategoryByID(profileToCategory.categoryID))!);
    }
    emit(ProfileCategoriesState(categories));
  }
}

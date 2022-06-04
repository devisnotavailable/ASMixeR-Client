import 'package:asmixer/data/entities/category.dart';
import 'package:asmixer/database/dao/category_dao.dart';
import 'package:asmixer/network/api_response.dart';
import 'package:asmixer/network/network_exception.dart';
import 'package:asmixer/network/youtube_repository.dart';
import 'package:asmixer/screens/events/discover_event.dart';
import 'package:asmixer/screens/states/discover_state.dart';
import 'package:asmixer/utils/localization_util.dart';
import 'package:asmixer/utils/shared_preferences_utils.dart';
import 'package:bloc/bloc.dart';

class DiscoverBloc extends Bloc<DiscoverEvent, DiscoverState> {
  final YoutubeRepository youtubeRepository;
  final CategoryDao categoryDao;
  final SharedPreferencesUtils sharedPreferencesUtils;
  final LocalizationUtil localizationUtil;

  DiscoverBloc(DiscoverState initialState, this.youtubeRepository,
      this.categoryDao, this.sharedPreferencesUtils, this.localizationUtil)
      : super(initialState) {
    on<DiscoverInitEvent>(_onDiscoverInitEvent);
    on<DiscoverOnMoreVideos>(_onMoreVideosEvent);
    on<DiscoverCategorySelectedEvent>(_onDiscoverCategoryChangedEvent);
    on<ChangeUseLocaleEvent>(_onChangeUseLocaleEvent);
  }

  _onDiscoverInitEvent(DiscoverInitEvent event, Emitter emit) async {
    await emit.forEach(categoryDao.getVideoCategoriesStream(),
        onData: (List<Category> categories) {
      categories.insert(
          0, const Category(id: -1, name: "ASMR", nameRu: "ASMR"));
      return CategoriesReadyState.fromState(
          state.copyWith(categoryList: categories));
    });
  }

  _onMoreVideosEvent(DiscoverOnMoreVideos event, Emitter emit) async {
    if (state.categoryList.isNotEmpty) {
      try {
        var response = await youtubeRepository.searchVideos(
            pageToken: event.nextToken,
            searchQuery: state.categoryList[state.selectedChipIndex]
                .getNameForLocale(event.isRussian),
            locale: state.useSearchLocale ? event.locale : '');
        emit(state.copyWith(
            videoResponse: ApiResponse.completed(response),
            videoList: response.videos));
      } catch (exception) {
        if (exception is NetworkException) {
          emit(state.copyWith(
              videoResponse: ApiResponse.error(
                  exception.toString(), exception.responseCode)));
        }
        emit(state.copyWith(
            videoResponse: ApiResponse.error(exception.toString())));
      }
    }
  }

  _onDiscoverCategoryChangedEvent(
      DiscoverCategorySelectedEvent event, Emitter emit) async {
    emit(CategoryChangedState.fromState(
        state.copyWith(selectedChipIndex: event.categoryIndex)));
  }

  _onChangeUseLocaleEvent(ChangeUseLocaleEvent event, Emitter emit) async {
    sharedPreferencesUtils.setUseSearchLocale(!state.useSearchLocale);
    emit(state.copyWith(useSearchLocale: !state.useSearchLocale));
  }
}

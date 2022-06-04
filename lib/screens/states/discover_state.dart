import 'package:asmixer/data/entities/category.dart';
import 'package:asmixer/data/entities/video.dart';
import 'package:asmixer/network/api_response.dart';

class DiscoverState {
  final List<Video> videoList; //only last page (PagedListView)
  final ApiResponse? videoResponse;
  final List<Category> categoryList;
  final int selectedChipIndex;
  final bool useSearchLocale;

  DiscoverState(
      {this.videoResponse,
      required this.videoList,
      required this.categoryList,
      required this.selectedChipIndex,
      required this.useSearchLocale});

  DiscoverState copyWith(
      {final List<Video>? videoList,
      final ApiResponse? videoResponse,
      final int? playingIndex,
      final List<Category>? categoryList,
      final int? selectedChipIndex,
      final bool? useSearchLocale}) {
    return DiscoverState(
        videoResponse: videoResponse ?? this.videoResponse,
        videoList: videoList ?? this.videoList,
        categoryList: categoryList ?? this.categoryList,
        selectedChipIndex: selectedChipIndex ?? this.selectedChipIndex,
        useSearchLocale: useSearchLocale ?? this.useSearchLocale);
  }
}

class CategoryChangedState extends DiscoverState {
  CategoryChangedState(ApiResponse? videoResponse, List<Category> categoryList,
      int selectedChipIndex, useSearchLocale)
      : super(
            videoResponse: videoResponse,
            videoList: [],
            categoryList: categoryList,
            selectedChipIndex: selectedChipIndex,
            useSearchLocale: useSearchLocale);

  factory CategoryChangedState.fromState(DiscoverState state) {
    return CategoryChangedState(state.videoResponse, state.categoryList,
        state.selectedChipIndex, state.useSearchLocale);
  }
}

class CategoriesReadyState extends DiscoverState {
  CategoriesReadyState(ApiResponse? videoResponse, List<Category> categoryList,
      int selectedChipIndex, useSearchLocale, videoList)
      : super(
      videoResponse: videoResponse,
            videoList: videoList,
            categoryList: categoryList,
            selectedChipIndex: selectedChipIndex,
            useSearchLocale: useSearchLocale);

  factory CategoriesReadyState.fromState(DiscoverState state) {
    return CategoriesReadyState(state.videoResponse, state.categoryList,
        state.selectedChipIndex, state.useSearchLocale, state.videoList);
  }
}

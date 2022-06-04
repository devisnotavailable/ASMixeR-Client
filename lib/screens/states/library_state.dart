import 'package:asmixer/data/entities/category.dart';
import 'package:asmixer/network/api_response.dart';

enum DownloadStatus {
  notDownloading,
  fetchingDownload,
  downloading,
  downloaded,
  error
}

class AudioTabState {
  final List<Category> categoryList;
  final ApiResponse? apiResponse;
  final int downloadingID;
  final DownloadStatus downloadStatus;
  final double? progress;

  AudioTabState({
    this.categoryList = const [],
    this.apiResponse,
    this.downloadingID = -1,
    this.progress,
    this.downloadStatus = DownloadStatus.notDownloading,
  });

  AudioTabState copyWith(
      {categoryList, apiResponse, downloadingID, progress, downloadStatus}) {
    return AudioTabState(
        apiResponse: apiResponse ?? this.apiResponse,
        progress: progress ?? this.progress,
        categoryList: categoryList ?? this.categoryList,
        downloadingID: downloadingID ?? this.downloadingID,
        downloadStatus: downloadStatus ?? this.downloadStatus);
  }
}

class CategoryUpdateFinishedState extends AudioTabState {
  final bool? hasUpdates;

  CategoryUpdateFinishedState(
      ApiResponse? apiResponse,
      List<Category> categoryList,
      int downloadingID,
      double? progress,
      downloadStatus,
      this.hasUpdates)
      : super(
            apiResponse: apiResponse,
            categoryList: categoryList,
      downloadingID: downloadingID,
      progress: progress,
      downloadStatus: downloadStatus);

  factory CategoryUpdateFinishedState.fromState(AudioTabState state,
      {bool? hasUpdates}) {
    return CategoryUpdateFinishedState(state.apiResponse, state.categoryList,
        state.downloadingID, state.progress, state.downloadStatus, hasUpdates);
  }
}

class DownloadFailedState extends AudioTabState {
  DownloadFailedState(ApiResponse? apiResponse, List<Category> categoryList,
      int downloadingID, double? progress, downloadStatus)
      : super(
            apiResponse: apiResponse,
            categoryList: categoryList,
            downloadingID: downloadingID,
            progress: progress,
            downloadStatus: downloadStatus);

  factory DownloadFailedState.fromState(AudioTabState state) {
    return DownloadFailedState(state.apiResponse, state.categoryList,
        state.downloadingID, state.progress, state.downloadStatus);
  }
}

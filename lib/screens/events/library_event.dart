abstract class AudioTabEvent {}

class LoadCategoryEvent extends AudioTabEvent {}

class UpdateCategoriesEvent extends AudioTabEvent {}

class DownloadSamplesEvent extends AudioTabEvent {
  final int categoryID;

  DownloadSamplesEvent(this.categoryID);
}

class CancelDownloadEvent extends AudioTabEvent {}

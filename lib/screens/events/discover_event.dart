abstract class DiscoverEvent {}

class DiscoverInitEvent extends DiscoverEvent {}

class DiscoverCategorySelectedEvent extends DiscoverEvent {
  final int categoryIndex;

  DiscoverCategorySelectedEvent(this.categoryIndex);
}

class DiscoverOnMoreVideos extends DiscoverEvent {
  final String nextToken;
  final String locale;
  final bool isRussian;

  DiscoverOnMoreVideos(this.nextToken, this.locale, this.isRussian);
}

class ChangeUseLocaleEvent extends DiscoverEvent {}

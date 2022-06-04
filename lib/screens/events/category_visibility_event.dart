abstract class CategoryVisibilityEvent {}

class CategoryVisibilityChangedEvent extends CategoryVisibilityEvent {
  final bool topCategory;

  CategoryVisibilityChangedEvent(this.topCategory);
}

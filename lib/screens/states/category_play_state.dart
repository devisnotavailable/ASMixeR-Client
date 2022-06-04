import 'package:asmixer/screens/states/base_state.dart';

class CategoryPlayState extends BaseState {
  final bool playing;
  final int categoryID;

  @override
  List<Object> get props => [playing, categoryID];

  CategoryPlayState(this.playing, this.categoryID);
}

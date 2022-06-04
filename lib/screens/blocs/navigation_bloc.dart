import 'package:asmixer/screens/events/navigation_event.dart';
import 'package:asmixer/screens/states/navigation_state.dart';
import 'package:asmixer/screens/ui/discover_screen.dart';
import 'package:bloc/bloc.dart';

class NavigationBloc extends Bloc<NavigationEvent, NavigationState> {
  final int discoverIndex = 1;

  NavigationBloc(NavigationState initialState) : super(initialState) {
    on<NavigationEvent>(_onNavigationEvent);
  }

  _onNavigationEvent(NavigationEvent event, Emitter emit) {
    if (event.selectedIndex == discoverIndex &&
        state.screens[event.selectedIndex] is! DiscoverScreen) {
      state.screens[event.selectedIndex] =
          const DiscoverScreen(); //hacking around IndexedStack flaws
    }
    emit(NavigationState(event.selectedIndex, state.screens));
  }
}

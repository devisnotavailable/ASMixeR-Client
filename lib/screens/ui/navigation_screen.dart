import 'package:asmixer/screens/blocs/init_bloc.dart';
import 'package:asmixer/screens/blocs/navigation_bloc.dart';
import 'package:asmixer/screens/events/navigation_event.dart';
import 'package:asmixer/screens/states/init_state.dart';
import 'package:asmixer/screens/states/navigation_state.dart';
import 'package:asmixer/service_locator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class NavigationScreen extends StatefulWidget {
  const NavigationScreen({Key? key}) : super(key: key);

  @override
  State<NavigationScreen> createState() => _NavigationScreenState();
}

class _NavigationScreenState extends State<NavigationScreen> {
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
        providers: [BlocProvider.value(value: getIt<NavigationBloc>())],
        child: BlocBuilder<InitBloc, InitBlocState>(
            builder: (BuildContext context, InitBlocState initState) {
          return BlocBuilder<NavigationBloc, NavigationState>(
              builder: (BuildContext context, NavigationState navigationState) {
            return Scaffold(
                body: IndexedStack(
                    index: navigationState.selectedIndex,
                    children: navigationState.screens),
                bottomNavigationBar: AnimatedSlide(
                  duration: const Duration(seconds: 2),
                  curve: Curves.easeOut,
                  offset: initState.initState == InitState.COMPLETED
                      ? const Offset(0.0, 0.0)
                      : const Offset(0.0, 1.0),
                  child: AnimatedOpacity(
                    opacity:
                        initState.initState == InitState.COMPLETED ? 1.0 : 0.0,
                    duration: const Duration(seconds: 2),
                    child: BottomNavigationBar(
                      type: BottomNavigationBarType.fixed,
                      items: _getNavigationItems(),
                      currentIndex: navigationState.selectedIndex,
                      onTap: (index) {
                        context
                            .read<NavigationBloc>()
                            .add(NavigationEvent(index));
                      },
                    ),
                  ),
                ));
          });
        }));
  }

  List<BottomNavigationBarItem> _getNavigationItems() {
    return [
      BottomNavigationBarItem(
          icon: const Icon(Icons.play_arrow),
          label: AppLocalizations.of(context)!.mix),
      BottomNavigationBarItem(
          icon: const Icon(Icons.public),
          label: AppLocalizations.of(context)!.discover),
      BottomNavigationBarItem(
          icon: const Icon(Icons.library_books),
          label: AppLocalizations.of(context)!.library),
      BottomNavigationBarItem(
          icon: const Icon(Icons.settings),
          label: AppLocalizations.of(context)!.settings),
    ];
  }
}

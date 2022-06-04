import 'package:asmixer/screens/events/discover_event.dart';
import 'package:asmixer/screens/states/discover_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../service_locator.dart';
import '../../blocs/discover_bloc.dart';

class UseLocaleSwitch extends StatelessWidget {
  const UseLocaleSwitch({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: getIt<DiscoverBloc>(),
      child: BlocBuilder<DiscoverBloc, DiscoverState>(
          builder: (BuildContext context, DiscoverState discoverState) {
        return Switch(
            value: discoverState.useSearchLocale,
            onChanged: (value) =>
                context.read<DiscoverBloc>().add(ChangeUseLocaleEvent()));
      }),
    );
  }
}

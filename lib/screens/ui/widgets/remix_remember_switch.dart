import 'package:asmixer/screens/blocs/remix_dialog_bloc.dart';
import 'package:asmixer/screens/events/remix_dialog_event.dart';
import 'package:asmixer/screens/states/remix_dialog_state.dart';
import 'package:asmixer/screens/ui/dialogs/remix_bottom_sheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class RemixRememberSwitch extends StatelessWidget {
  const RemixRememberSwitch({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RemixDialogBloc, RemixDialogState>(
        builder: (BuildContext context, RemixDialogState state) {
      return Switch(
          value: state.remixAction != RemixAction.ASK,
          onChanged: (value) => context.read<RemixDialogBloc>().add(
              RemixActionChangedEvent(
                  value ? RemixAction.SKIP : RemixAction.ASK)));
    });
  }
}

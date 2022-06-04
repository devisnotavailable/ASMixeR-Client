import 'package:asmixer/screens/blocs/current_profile_bloc.dart';
import 'package:asmixer/screens/events/current_profile_event.dart';
import 'package:asmixer/screens/states/current_profile_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CurrentProfileWidget extends StatelessWidget {
  const CurrentProfileWidget({Key? key}) : super(key: key);

  ButtonStyle _getProfileButtonStyle() {
    return ButtonStyle(
      foregroundColor: MaterialStateProperty.all<Color>(Colors.blue),
      overlayColor: MaterialStateProperty.resolveWith<Color?>(
        (Set<MaterialState> states) {
          if (states.contains(MaterialState.hovered)) {
            return Colors.blue.withOpacity(0.04);
          }
          if (states.contains(MaterialState.focused) ||
              states.contains(MaterialState.pressed)) {
            return Colors.blue.withOpacity(0.12);
          }
          return null;
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CurrentProfileBloc, CurrentProfileState>(
      builder: (BuildContext context, state) {
        return TextButton(
            style: _getProfileButtonStyle(),
            onPressed: () async {
              await Navigator.pushNamed(context, "/profiles");
              ScaffoldMessenger.of(context).removeCurrentSnackBar();
              context
                  .read<CurrentProfileBloc>()
                  .add(BackFromProfilesScreenEvent());
            },
            child: Text(state.selectedProfile?.name.toUpperCase() ?? ""));
      },
    );
  }
}

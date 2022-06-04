import 'package:asmixer/screens/blocs/audio_player_bloc.dart';
import 'package:asmixer/screens/blocs/audio_transform_bloc.dart';
import 'package:asmixer/screens/events/audio_player_event.dart';
import 'package:asmixer/screens/events/audio_transform_event.dart';
import 'package:asmixer/styles/styles.dart';
import 'package:asmixer/theme/themes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../blocs/current_profile_bloc.dart';
import '../../blocs/remix_dialog_bloc.dart';
import '../../events/remix_dialog_event.dart';
import '../widgets/remix_remember_switch.dart';

enum RemixAction { ASK, SKIP, REMIX }

pushProfileBottomSheet(BuildContext context) {
  showModalBottomSheet(
    context: context,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.only(
          topLeft: Radius.circular(16), topRight: Radius.circular(16)),
    ),
    builder: (BuildContext context) {
      return Wrap(children: [
        Padding(
          padding: const EdgeInsets.all(defaultPadding),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                AppLocalizations.of(context)!.profileChangedReminderTitle,
                style: const TitleTextStyle(),
              ),
              const SizedBox(height: 5),
              Opacity(
                  opacity: 0.5,
                  child: Text(
                    AppLocalizations.of(context)!
                        .profileChangedReminderDescription,
                    style: const ImportantTextStyle(),
                  )),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    AppLocalizations.of(context)!.rememberMyChoice,
                    style: const ImportantTextStyle(),
                  ),
                  const RemixRememberSwitch(),
                ],
              ),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    context.read<AudioPlayerBloc>().add(ResetPlayerEvent());
                    context.read<AudioTransformBloc>().add(CreateNewAudioEvent(
                        context
                            .read<CurrentProfileBloc>()
                            .state
                            .selectedProfile));
                    if (context.read<RemixDialogBloc>().state.remixAction !=
                        RemixAction.ASK) {
                      context
                          .read<RemixDialogBloc>()
                          .add(RemixActionChangedEvent(RemixAction.REMIX));
                    }
                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(defaultBorderRadius),
                      ),
                      elevation: 3),
                  child: Text(
                    AppLocalizations.of(context)!.yes.toUpperCase(),
                    style: const UnimportantTextStyle(),
                  ),
                ),
              ),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                    onPressed: () => Navigator.pop(context),
                    style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.circular(defaultBorderRadius),
                        ),
                        elevation: 3),
                    child: Text(
                      AppLocalizations.of(context)!.no.toUpperCase(),
                      style: const UnimportantTextStyle(),
                    )),
              ),
            ],
          ),
        ),
      ]);
    },
  );
}

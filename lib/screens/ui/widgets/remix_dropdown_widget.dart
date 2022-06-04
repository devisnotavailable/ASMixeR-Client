import 'package:asmixer/screens/blocs/remix_dialog_bloc.dart';
import 'package:asmixer/screens/events/remix_dialog_event.dart';
import 'package:asmixer/screens/states/remix_dialog_state.dart';
import 'package:asmixer/screens/ui/dialogs/remix_bottom_sheet.dart';
import 'package:asmixer/styles/styles.dart';
import 'package:asmixer/theme/themes.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class RemixDropdown extends StatelessWidget {
  const RemixDropdown({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RemixDialogBloc, RemixDialogState>(
        builder: (context, remixState) {
      return Expanded(
        child: DecoratedBox(
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(36)),
          child: DropdownButton<RemixAction>(
            icon: const SizedBox.shrink(),
            underline: const SizedBox.shrink(),
            value: remixState.remixAction,
            dropdownColor: Theme.of(context).backgroundColor,
            isExpanded: true,
            onChanged: (RemixAction? newValue) {
              context
                  .read<RemixDialogBloc>()
                  .add(RemixActionChangedEvent(newValue!));
            },
            items: <DropdownMenuItem<RemixAction>>[
              DropdownMenuItem(
                  child: Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Theme.of(context).primaryColorLight,
                      borderRadius: const BorderRadius.all(
                          Radius.circular(defaultBorderRadius)),
                    ),
                    child: AutoSizeText(
                      AppLocalizations.of(context)!.remixDialogAsk,
                      style: const SettingsTextStyle(),
                      maxLines: 1,
                    ),
                  ),
                  value: RemixAction.ASK),
              DropdownMenuItem(
                  child: Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Theme.of(context).primaryColorLight,
                      borderRadius: const BorderRadius.all(
                          Radius.circular(defaultBorderRadius)),
                    ),
                    child: AutoSizeText(
                      AppLocalizations.of(context)!.remixDialogRemix,
                      style: const SettingsTextStyle(),
                      maxLines: 1,
                    ),
                  ),
                  value: RemixAction.REMIX),
              DropdownMenuItem(
                  child: Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Theme.of(context).primaryColorLight,
                      borderRadius: const BorderRadius.all(
                          Radius.circular(defaultBorderRadius)),
                    ),
                    child: AutoSizeText(
                      AppLocalizations.of(context)!.remixDialogSkip,
                      style: const SettingsTextStyle(),
                      maxLines: 1,
                    ),
                  ),
                  value: RemixAction.SKIP),
            ],
          ),
        ),
      );
    });
  }
}

import 'package:asmixer/styles/styles.dart';
import 'package:asmixer/theme/theme_notifier.dart';
import 'package:asmixer/theme/themes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';

class ThemeDropdownButton extends StatelessWidget {
  const ThemeDropdownButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<ThemeNotifier>(context);
    return Expanded(
      flex: 2,
      child: DecoratedBox(
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(36)),
        child: DropdownButton<ThemeType>(
          underline: const SizedBox.shrink(),
          value: provider.getCurrentTheme(),
          dropdownColor: Theme.of(context).backgroundColor,
          isExpanded: true,
          elevation: 12,
          onChanged: (ThemeType? newValue) {
            provider.setCurrentTheme(newValue!);
          },
          items: <DropdownMenuItem<ThemeType>>[
            DropdownMenuItem(
                child: Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Theme.of(context).primaryColorLight,
                    borderRadius: const BorderRadius.all(
                        Radius.circular(defaultBorderRadius)),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        AppLocalizations.of(context)!.systemTheme,
                        style: const SettingsTextStyle(),
                      )
                    ],
                  ),
                ),
                value: ThemeType.SYSTEM),
            DropdownMenuItem(
                child: Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Theme.of(context).primaryColorLight,
                    borderRadius: const BorderRadius.all(
                        Radius.circular(defaultBorderRadius)),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        AppLocalizations.of(context)!.lightTheme,
                        style: const SettingsTextStyle(),
                      )
                    ],
                  ),
                ),
                value: ThemeType.LIGHT),
            DropdownMenuItem(
                child: Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Theme.of(context).primaryColorLight,
                    borderRadius: const BorderRadius.all(
                        Radius.circular(defaultBorderRadius)),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        AppLocalizations.of(context)!.darkTheme,
                        style: const SettingsTextStyle(),
                      )
                    ],
                  ),
                ),
                value: ThemeType.DARK)
          ],
        ),
      ),
    );
  }
}

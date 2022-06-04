import 'package:asmixer/screens/ui/widgets/remix_dropdown_widget.dart';
import 'package:asmixer/screens/ui/widgets/theme_dropdown_button.dart';
import 'package:asmixer/screens/ui/widgets/use_locale_switch.dart';
import 'package:asmixer/styles/styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../service_locator.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final String aboutAppLink = "https://github.com/devisnotavailable/ASMixeR";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(AppLocalizations.of(context)!.settings)),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    AppLocalizations.of(context)!.theme,
                    style: const SettingsTextStyle(),
                  ),
                ),
                const ThemeDropdownButton(),
              ],
            ),
          ),
          const Divider(),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    AppLocalizations.of(context)!.remixActionSetting,
                    overflow: TextOverflow.visible,
                    style: const SettingsTextStyle(),
                  ),
                ),
                const RemixDropdown(),
              ],
            ),
          ),
          const Divider(),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    AppLocalizations.of(context)!.useLocale,
                    overflow: TextOverflow.visible,
                    style: const SettingsTextStyle(),
                  ),
                ),
                const UseLocaleSwitch(),
              ],
            ),
          ),
          const Divider(),
          InkWell(
            onTap: () => launchUrl(Uri.parse(aboutAppLink)),
            child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: Row(
                  children: [
                    Expanded(
                      child: Center(
                        child: Text(
                          AppLocalizations.of(context)!.aboutApp,
                          style: const SettingsTextStyle(),
                        ),
                      ),
                    ),
                  ],
                )),
          ),
          const Spacer(),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Align(
                alignment: Alignment.bottomRight,
                child: Text(
                    "v. ${getIt<PackageInfo>().version} (build: ${getIt<PackageInfo>().buildNumber})")),
          )
        ],
      ),
    );
  }
}

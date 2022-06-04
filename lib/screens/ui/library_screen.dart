import 'package:asmixer/screens/ui/audio_tab.dart';
import 'package:asmixer/screens/ui/video_tab.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class LibraryScreen extends StatefulWidget {
  const LibraryScreen({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _LibraryScreenState();
}

class _LibraryScreenState extends State<LibraryScreen> {
  @override
  Widget build(BuildContext context) {
    final List<Tab> tabs = [
      Tab(text: AppLocalizations.of(context)!.audioString),
      Tab(text: AppLocalizations.of(context)!.videoString)
    ];
    return DefaultTabController(
      length: tabs.length,
      child: Builder(builder: (BuildContext context) {
        return Scaffold(
          appBar: AppBar(
            elevation: 0,
            backgroundColor: Theme.of(context).primaryColorLight,
            title: TabBar(
              tabs: tabs,
            ),
          ),
          body: const TabBarView(
            children: [
              AudioTab(),
              VideoTab(),
            ],
          ),
        );
      }),
    );
  }
}

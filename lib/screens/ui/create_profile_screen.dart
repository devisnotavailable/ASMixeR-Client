import 'package:asmixer/data/entities/profile.dart';
import 'package:asmixer/screens/blocs/category_play_bloc.dart';
import 'package:asmixer/screens/blocs/create_profile_bloc.dart';
import 'package:asmixer/screens/events/create_profile_event.dart';
import 'package:asmixer/screens/states/create_profile_state.dart';
import 'package:asmixer/screens/ui/widgets/categories_grid_widget.dart';
import 'package:asmixer/styles/styles.dart';
import 'package:asmixer/theme/themes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../service_locator.dart';

class CreateProfileScreen extends StatefulWidget {
  const CreateProfileScreen({Key? key}) : super(key: key);

  @override
  State<CreateProfileScreen> createState() => _CreateProfileScreenState();
}

late TextEditingController _controller;

class _CreateProfileScreenState extends State<CreateProfileScreen> {
  late Profile? _currentProfile;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  Widget _buildCategorySection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(
          height: 10,
        ),
        Text(
          AppLocalizations.of(context)!.mainCategories,
          style: const MediumTextStyle(),
        ),
        const SizedBox(
          height: 10,
        ),
        Text(
          AppLocalizations.of(context)!.mainCategoriesDescription,
          style: const DescriptionTextStyle(),
        ),
        const SizedBox(
          height: 5,
        ),
        const CategoriesGridWidget(),
      ],
    );
  }

  _getProfileListener(CreateProfileState profileState) {
    if (profileState is ProfileSavedState) {
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    _currentProfile = ModalRoute.of(context)!.settings.arguments as Profile?;
    _controller.text =
        _currentProfile?.name ?? AppLocalizations.of(context)!.newProfile;
    return MultiBlocProvider(
        providers: [
          BlocProvider(
              create: (BuildContext context) => getIt<CreateProfileBloc>()
                ..add(InitCreateProfileEvent())
                ..add(InitCategoryEvent(_currentProfile))),
          BlocProvider(
              create: (BuildContext context) => getIt<CategoryPlayBloc>()),
        ],
        child: BlocListener<CreateProfileBloc, CreateProfileState>(
            listener: (context, profileState) =>
                _getProfileListener(profileState),
            child: Builder(
              builder: (BuildContext context) {
                return Scaffold(
                  body: Container(
                    margin: const EdgeInsets.only(left: 15, right: 15),
                    child: SafeArea(
                      child: Column(
                        children: [
                          const SizedBox(
                            height: 5,
                          ),
                          Row(
                            children: [
                              Expanded(
                                child: TextFormField(
                                  controller: _controller,
                                  maxLength: 30,
                                  style: const TitleTextStyle(),
                                  decoration: const InputDecoration(
                                    counter: Offstage(),
                                    border: InputBorder.none,
                                    focusedBorder: OutlineInputBorder(),
                                    suffixIcon: Icon(Icons.edit),
                                  ),
                                ),
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              SaveButton(currentProfile: _currentProfile)
                            ],
                          ),
                          Expanded(
                            child: SingleChildScrollView(
                              child: _buildCategorySection(),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            )));
  }
}

class SaveButton extends StatelessWidget {
  const SaveButton({Key? key, required this.currentProfile}) : super(key: key);

  final Profile? currentProfile;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
        style: ElevatedButton.styleFrom(
            shape: const RoundedRectangleBorder(
                borderRadius:
                    BorderRadius.all(Radius.circular(defaultBorderRadius)))),
        onPressed: () {
          if (context
              .read<CreateProfileBloc>()
              .state
              .selectedCategories
              .isNotEmpty) {
            context.read<CreateProfileBloc>().add(currentProfile != null
                ? ChangeProfileEvent(
                    Profile(name: _controller.text, id: currentProfile!.id))
                : SaveProfileEvent(_controller.text));
          } else {
            _showNoCategorySnackBar(context);
          }
        },
        child: Text(AppLocalizations.of(context)!.saveString));
  }

  _showNoCategorySnackBar(context) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        duration: const Duration(seconds: 3),
        content: Text(AppLocalizations.of(context)!.noCategorySelected),
      ),
    );
  }
}

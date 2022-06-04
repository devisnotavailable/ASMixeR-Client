import 'package:flutter/material.dart';

import '../theme/themes.dart';

class TitleTextStyle extends TextStyle {
  const TitleTextStyle() : super(fontSize: 22, fontWeight: FontWeight.bold);
}

class SettingsTextStyle extends TextStyle {
  const SettingsTextStyle()
      : super(
          fontSize: 20,
          fontStyle: FontStyle.italic,
        );
}

class MediumTextStyle extends TextStyle {
  const MediumTextStyle() : super(fontSize: 18, fontWeight: FontWeight.bold);
}

class MediumTextStyleBlack extends TextStyle {
  const MediumTextStyleBlack()
      : super(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black);
}

class LabelTextStyle extends TextStyle {
  const LabelTextStyle() : super(fontSize: 18);
}

class DescriptionTextStyle extends TextStyle {
  const DescriptionTextStyle() : super(color: Colors.grey);
}

class ImportantTextStyle extends TextStyle {
  const ImportantTextStyle()
      : super(
          fontSize: 20,
        );
}

class UnimportantTextStyle extends TextStyle {
  const UnimportantTextStyle()
      : super(
          fontSize: 18,
        );
}

class DefaultItemDecoration extends ShapeDecoration {
  DefaultItemDecoration(
      {required context,
      bool selected = false,
      double borderWidth = 1,
      Color backgroundColor = Colors.white70})
      : super(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(defaultBorderRadius),
            side: BorderSide(
              color: selected
                  ? Theme.of(context).colorScheme.primary.withOpacity(0.3)
                  : Colors.grey.withOpacity(0.2),
              width: borderWidth,
            ),
          ),
          color: selected
              ? Theme.of(context).colorScheme.primary.withOpacity(0.2)
              : Theme.of(context).primaryColorLight,
        );
}

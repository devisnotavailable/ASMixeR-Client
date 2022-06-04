import 'package:asmixer/screens/ui/dialogs/remix_bottom_sheet.dart';

abstract class RemixDialogEvent {}

class RemixActionChangedEvent extends RemixDialogEvent {
  final RemixAction remixAction;

  RemixActionChangedEvent(this.remixAction);
}

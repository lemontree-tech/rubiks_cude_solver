// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Rubik Solver';

  @override
  String get appDescription =>
      'Solve 3x3 Rubik\'s cubes with step-by-step solutions. Features 2D and 3D cube visualization, manual cube input, and automatic solving algorithms.';

  @override
  String get ready => 'Ready';

  @override
  String get scrambled => 'Scrambled';

  @override
  String get solving => 'Solving...';

  @override
  String movesFound(int count) {
    return '$count moves found';
  }

  @override
  String get alreadySolved => 'Already solved or no solution found';

  @override
  String error(String message) {
    return 'Error: $message';
  }

  @override
  String get solutionComplete => 'Solution complete';

  @override
  String get autoApplyStopped => 'Auto apply stopped';

  @override
  String stepProgress(int current, int total) {
    return 'Step $current / $total';
  }

  @override
  String autoProgress(int current, int total) {
    return 'Auto: $current / $total';
  }

  @override
  String get customCubeLoaded => 'Custom cube loaded';

  @override
  String get scramble => 'Scramble';

  @override
  String get solve => 'Solve';

  @override
  String get reset => 'Reset';

  @override
  String get close => 'Close';

  @override
  String get cancel => 'Cancel';

  @override
  String get saveAndValidate => 'Save & Validate';

  @override
  String get manualControls => 'Manual Controls';

  @override
  String get solution => 'Solution';

  @override
  String get undo => '◀ Undo';

  @override
  String get apply => 'Apply ▶';

  @override
  String get auto => '▶ Auto';

  @override
  String get stop => '⏸ Stop';

  @override
  String get manualCubeInput => 'Manual Cube Input';

  @override
  String get tapToFocus => 'Tap stickers to focus, select color to change';

  @override
  String get selectColor => 'Select Color';

  @override
  String get invalidCube => 'Invalid cube configuration. Please check colors.';

  @override
  String get display2D => '2D';

  @override
  String get display3D => '3D';
}

// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for German (`de`).
class AppLocalizationsDe extends AppLocalizations {
  AppLocalizationsDe([String locale = 'de']) : super(locale);

  @override
  String get appTitle => 'Rubik\'s Cube Löser';

  @override
  String get ready => 'Bereit';

  @override
  String get scrambled => 'Gemischt';

  @override
  String get solving => 'Lösen...';

  @override
  String movesFound(int count) {
    return '$count Züge gefunden';
  }

  @override
  String get alreadySolved => 'Bereits gelöst oder keine Lösung gefunden';

  @override
  String error(String message) {
    return 'Fehler: $message';
  }

  @override
  String get solutionComplete => 'Lösung abgeschlossen';

  @override
  String get autoApplyStopped => 'Automatische Anwendung gestoppt';

  @override
  String stepProgress(int current, int total) {
    return 'Schritt $current / $total';
  }

  @override
  String autoProgress(int current, int total) {
    return 'Auto: $current / $total';
  }

  @override
  String get customCubeLoaded => 'Benutzerdefinierter Würfel geladen';

  @override
  String get scramble => 'Mischen';

  @override
  String get solve => 'Lösen';

  @override
  String get reset => 'Zurücksetzen';

  @override
  String get close => 'Schließen';

  @override
  String get cancel => 'Abbrechen';

  @override
  String get saveAndValidate => 'Speichern und validieren';

  @override
  String get manualControls => 'Manuelle Steuerung';

  @override
  String get solution => 'Lösung';

  @override
  String get undo => '◀ Rückgängig';

  @override
  String get apply => 'Anwenden ▶';

  @override
  String get auto => '▶ Auto';

  @override
  String get stop => '⏸ Stoppen';

  @override
  String get manualCubeInput => 'Manuelle Würfeleingabe';

  @override
  String get tapToFocus =>
      'Tippen Sie auf Aufkleber zum Fokussieren, wählen Sie die Farbe zum Ändern';

  @override
  String get selectColor => 'Farbe auswählen';

  @override
  String get invalidCube =>
      'Ungültige Würfelkonfiguration. Bitte überprüfen Sie die Farben.';

  @override
  String get display2D => '2D';

  @override
  String get display3D => '3D';
}

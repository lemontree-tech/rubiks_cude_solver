// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for French (`fr`).
class AppLocalizationsFr extends AppLocalizations {
  AppLocalizationsFr([String locale = 'fr']) : super(locale);

  @override
  String get appTitle => 'Solveur de Rubik\'s Cube';

  @override
  String get ready => 'Prêt';

  @override
  String get scrambled => 'Mélangé';

  @override
  String get solving => 'Résolution...';

  @override
  String movesFound(int count) {
    return '$count mouvements trouvés';
  }

  @override
  String get alreadySolved => 'Déjà résolu ou aucune solution trouvée';

  @override
  String error(String message) {
    return 'Erreur : $message';
  }

  @override
  String get solutionComplete => 'Solution complète';

  @override
  String get autoApplyStopped => 'Application automatique arrêtée';

  @override
  String stepProgress(int current, int total) {
    return 'Étape $current / $total';
  }

  @override
  String autoProgress(int current, int total) {
    return 'Auto : $current / $total';
  }

  @override
  String get customCubeLoaded => 'Cube personnalisé chargé';

  @override
  String get scramble => 'Mélanger';

  @override
  String get solve => 'Résoudre';

  @override
  String get reset => 'Réinitialiser';

  @override
  String get close => 'Fermer';

  @override
  String get cancel => 'Annuler';

  @override
  String get saveAndValidate => 'Enregistrer et valider';

  @override
  String get manualControls => 'Contrôles manuels';

  @override
  String get solution => 'Solution';

  @override
  String get undo => '◀ Annuler';

  @override
  String get apply => 'Appliquer ▶';

  @override
  String get auto => '▶ Auto';

  @override
  String get stop => '⏸ Arrêter';

  @override
  String get manualCubeInput => 'Saisie manuelle du cube';

  @override
  String get tapToFocus =>
      'Appuyez sur les autocollants pour vous concentrer, sélectionnez la couleur pour changer';

  @override
  String get selectColor => 'Sélectionner la couleur';

  @override
  String get invalidCube =>
      'Configuration de cube invalide. Veuillez vérifier les couleurs.';

  @override
  String get display2D => '2D';

  @override
  String get display3D => '3D';
}

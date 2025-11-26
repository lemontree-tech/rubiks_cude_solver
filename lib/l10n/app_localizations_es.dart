// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Spanish Castilian (`es`).
class AppLocalizationsEs extends AppLocalizations {
  AppLocalizationsEs([String locale = 'es']) : super(locale);

  @override
  String get appTitle => 'Solucionador de Cubo de Rubik';

  @override
  String get appDescription =>
      'Resuelve cubos de Rubik 3x3 con soluciones paso a paso. Incluye visualización 2D y 3D del cubo, entrada manual del cubo y algoritmos de resolución automática.';

  @override
  String get ready => 'Listo';

  @override
  String get scrambled => 'Mezclado';

  @override
  String get solving => 'Resolviendo...';

  @override
  String movesFound(int count) {
    return 'Se encontraron $count movimientos';
  }

  @override
  String get alreadySolved => 'Ya resuelto o no se encontró solución';

  @override
  String error(String message) {
    return 'Error: $message';
  }

  @override
  String get solutionComplete => 'Solución completa';

  @override
  String get autoApplyStopped => 'Aplicación automática detenida';

  @override
  String stepProgress(int current, int total) {
    return 'Paso $current / $total';
  }

  @override
  String autoProgress(int current, int total) {
    return 'Automático: $current / $total';
  }

  @override
  String get customCubeLoaded => 'Cubo personalizado cargado';

  @override
  String get scramble => 'Mezclar';

  @override
  String get solve => 'Resolver';

  @override
  String get reset => 'Restablecer';

  @override
  String get close => 'Cerrar';

  @override
  String get cancel => 'Cancelar';

  @override
  String get saveAndValidate => 'Guardar y validar';

  @override
  String get manualControls => 'Controles manuales';

  @override
  String get solution => 'Solución';

  @override
  String get undo => '◀ Deshacer';

  @override
  String get apply => 'Aplicar ▶';

  @override
  String get auto => '▶ Automático';

  @override
  String get stop => '⏸ Detener';

  @override
  String get manualCubeInput => 'Entrada manual del cubo';

  @override
  String get tapToFocus =>
      'Toca las pegatinas para enfocar, selecciona el color para cambiar';

  @override
  String get selectColor => 'Seleccionar color';

  @override
  String get invalidCube =>
      'Configuración de cubo inválida. Por favor verifica los colores.';

  @override
  String get display2D => '2D';

  @override
  String get display3D => '3D';
}

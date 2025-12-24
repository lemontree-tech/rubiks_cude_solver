// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Portuguese (`pt`).
class AppLocalizationsPt extends AppLocalizations {
  AppLocalizationsPt([String locale = 'pt']) : super(locale);

  @override
  String get appTitle => 'Solucionador de Cubo Mágico';

  @override
  String get appDescription =>
      'Resolva cubos mágicos 3x3 com soluções passo a passo. Inclui visualização 2D e 3D do cubo, entrada manual do cubo e algoritmos de resolução automática.';

  @override
  String get ready => 'Pronto';

  @override
  String get scrambled => 'Embaralhado';

  @override
  String get solving => 'Resolvendo...';

  @override
  String movesFound(int count) {
    return '$count movimentos encontrados';
  }

  @override
  String get alreadySolved => 'Já resolvido ou nenhuma solução encontrada';

  @override
  String error(String message) {
    return 'Erro: $message';
  }

  @override
  String get solutionComplete => 'Solução completa';

  @override
  String get autoApplyStopped => 'Aplicação automática interrompida';

  @override
  String stepProgress(int current, int total) {
    return 'Passo $current / $total';
  }

  @override
  String autoProgress(int current, int total) {
    return 'Automático: $current / $total';
  }

  @override
  String get customCubeLoaded => 'Cubo personalizado carregado';

  @override
  String get scramble => 'Embaralhar';

  @override
  String get solve => 'Resolver';

  @override
  String get reset => 'Redefinir';

  @override
  String get close => 'Fechar';

  @override
  String get cancel => 'Cancelar';

  @override
  String get saveAndValidate => 'Salvar e validar';

  @override
  String get manualControls => 'Controles manuais';

  @override
  String get solution => 'Solução';

  @override
  String get undo => '◀ Desfazer';

  @override
  String get apply => 'Aplicar ▶';

  @override
  String get auto => '▶ Automático';

  @override
  String get stop => '⏸ Parar';

  @override
  String get manualCubeInput => 'Entrada manual do cubo';

  @override
  String get tapToFocus =>
      'Toque nos adesivos para focar, selecione a cor para alterar';

  @override
  String get selectColor => 'Selecionar cor';

  @override
  String get invalidCube =>
      'Configuração de cubo inválida. Por favor, verifique as cores.';

  @override
  String get display2D => '2D';

  @override
  String get display3D => '3D';
}

/// The translations for Portuguese, as used in Brazil (`pt_BR`).
class AppLocalizationsPtBr extends AppLocalizationsPt {
  AppLocalizationsPtBr() : super('pt_BR');

  @override
  String get appTitle => 'Cubo Mágico Solver';

  @override
  String get appDescription =>
      'Resolva cubos mágicos 3x3 com soluções passo a passo. Inclui visualização 2D e 3D do cubo, entrada manual do cubo e algoritmos de resolução automática.';

  @override
  String get ready => 'Pronto';

  @override
  String get scrambled => 'Embaralhado';

  @override
  String get solving => 'Resolvendo...';

  @override
  String movesFound(int count) {
    return '$count movimentos encontrados';
  }

  @override
  String get alreadySolved => 'Já resolvido ou nenhuma solução encontrada';

  @override
  String error(String message) {
    return 'Erro: $message';
  }

  @override
  String get solutionComplete => 'Solução completa';

  @override
  String get autoApplyStopped => 'Aplicação automática interrompida';

  @override
  String stepProgress(int current, int total) {
    return 'Passo $current / $total';
  }

  @override
  String autoProgress(int current, int total) {
    return 'Automático: $current / $total';
  }

  @override
  String get customCubeLoaded => 'Cubo personalizado carregado';

  @override
  String get scramble => 'Embaralhar';

  @override
  String get solve => 'Resolver';

  @override
  String get reset => 'Redefinir';

  @override
  String get close => 'Fechar';

  @override
  String get cancel => 'Cancelar';

  @override
  String get saveAndValidate => 'Salvar e validar';

  @override
  String get manualControls => 'Controles manuais';

  @override
  String get solution => 'Solução';

  @override
  String get undo => '◀ Desfazer';

  @override
  String get apply => 'Aplicar ▶';

  @override
  String get auto => '▶ Automático';

  @override
  String get stop => '⏸ Parar';

  @override
  String get manualCubeInput => 'Entrada manual do cubo';

  @override
  String get tapToFocus =>
      'Toque nos adesivos para focar, selecione a cor para alterar';

  @override
  String get selectColor => 'Selecionar cor';

  @override
  String get invalidCube =>
      'Configuração de cubo inválida. Por favor, verifique as cores.';

  @override
  String get display2D => '2D';

  @override
  String get display3D => '3D';
}

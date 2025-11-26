// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Japanese (`ja`).
class AppLocalizationsJa extends AppLocalizations {
  AppLocalizationsJa([String locale = 'ja']) : super(locale);

  @override
  String get appTitle => 'ルービックキューブソルバー';

  @override
  String get ready => '準備完了';

  @override
  String get scrambled => 'スクランブル済み';

  @override
  String get solving => '解決中...';

  @override
  String movesFound(int count) {
    return '$count 手の解法が見つかりました';
  }

  @override
  String get alreadySolved => '既に解決済みまたは解法が見つかりませんでした';

  @override
  String error(String message) {
    return 'エラー：$message';
  }

  @override
  String get solutionComplete => '解法完了';

  @override
  String get autoApplyStopped => '自動適用が停止しました';

  @override
  String stepProgress(int current, int total) {
    return 'ステップ $current / $total';
  }

  @override
  String autoProgress(int current, int total) {
    return '自動：$current / $total';
  }

  @override
  String get customCubeLoaded => 'カスタムキューブを読み込みました';

  @override
  String get scramble => 'スクランブル';

  @override
  String get solve => '解決';

  @override
  String get reset => 'リセット';

  @override
  String get close => '閉じる';

  @override
  String get cancel => 'キャンセル';

  @override
  String get saveAndValidate => '保存して検証';

  @override
  String get manualControls => '手動制御';

  @override
  String get solution => '解法';

  @override
  String get undo => '◀ 元に戻す';

  @override
  String get apply => '適用 ▶';

  @override
  String get auto => '▶ 自動';

  @override
  String get stop => '⏸ 停止';

  @override
  String get manualCubeInput => '手動キューブ入力';

  @override
  String get tapToFocus => 'ステッカーをタップしてフォーカス、色を選択して変更';

  @override
  String get selectColor => '色を選択';

  @override
  String get invalidCube => '無効なキューブ構成です。色を確認してください。';

  @override
  String get display2D => '2D';

  @override
  String get display3D => '3D';
}

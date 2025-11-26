// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Chinese (`zh`).
class AppLocalizationsZh extends AppLocalizations {
  AppLocalizationsZh([String locale = 'zh']) : super(locale);

  @override
  String get appTitle => '魔方求解器';

  @override
  String get ready => '就绪';

  @override
  String get scrambled => '已打乱';

  @override
  String get solving => '求解中...';

  @override
  String movesFound(int count) {
    return '找到 $count 步解法';
  }

  @override
  String get alreadySolved => '已解决或未找到解法';

  @override
  String error(String message) {
    return '错误：$message';
  }

  @override
  String get solutionComplete => '解法完成';

  @override
  String get autoApplyStopped => '自动应用已停止';

  @override
  String stepProgress(int current, int total) {
    return '步骤 $current / $total';
  }

  @override
  String autoProgress(int current, int total) {
    return '自动：$current / $total';
  }

  @override
  String get customCubeLoaded => '自定义魔方已加载';

  @override
  String get scramble => '打乱';

  @override
  String get solve => '求解';

  @override
  String get reset => '重置';

  @override
  String get close => '关闭';

  @override
  String get cancel => '取消';

  @override
  String get saveAndValidate => '保存并验证';

  @override
  String get manualControls => '手动控制';

  @override
  String get solution => '解法';

  @override
  String get undo => '◀ 撤销';

  @override
  String get apply => '应用 ▶';

  @override
  String get auto => '▶ 自动';

  @override
  String get stop => '⏸ 停止';

  @override
  String get manualCubeInput => '手动输入魔方';

  @override
  String get tapToFocus => '点击贴纸聚焦，选择颜色更改';

  @override
  String get selectColor => '选择颜色';

  @override
  String get invalidCube => '无效的魔方配置，请检查颜色。';

  @override
  String get display2D => '2D';

  @override
  String get display3D => '3D';
}

/// The translations for Chinese, as used in China (`zh_CN`).
class AppLocalizationsZhCn extends AppLocalizationsZh {
  AppLocalizationsZhCn() : super('zh_CN');

  @override
  String get appTitle => '魔方求解器';

  @override
  String get ready => '就绪';

  @override
  String get scrambled => '已打乱';

  @override
  String get solving => '求解中...';

  @override
  String movesFound(int count) {
    return '找到 $count 步解法';
  }

  @override
  String get alreadySolved => '已解决或未找到解法';

  @override
  String error(String message) {
    return '错误：$message';
  }

  @override
  String get solutionComplete => '解法完成';

  @override
  String get autoApplyStopped => '自动应用已停止';

  @override
  String stepProgress(int current, int total) {
    return '步骤 $current / $total';
  }

  @override
  String autoProgress(int current, int total) {
    return '自动：$current / $total';
  }

  @override
  String get customCubeLoaded => '自定义魔方已加载';

  @override
  String get scramble => '打乱';

  @override
  String get solve => '求解';

  @override
  String get reset => '重置';

  @override
  String get close => '关闭';

  @override
  String get cancel => '取消';

  @override
  String get saveAndValidate => '保存并验证';

  @override
  String get manualControls => '手动控制';

  @override
  String get solution => '解法';

  @override
  String get undo => '◀ 撤销';

  @override
  String get apply => '应用 ▶';

  @override
  String get auto => '▶ 自动';

  @override
  String get stop => '⏸ 停止';

  @override
  String get manualCubeInput => '手动输入魔方';

  @override
  String get tapToFocus => '点击贴纸聚焦，选择颜色更改';

  @override
  String get selectColor => '选择颜色';

  @override
  String get invalidCube => '无效的魔方配置，请检查颜色。';

  @override
  String get display2D => '2D';

  @override
  String get display3D => '3D';
}

/// The translations for Chinese, as used in Hong Kong (`zh_HK`).
class AppLocalizationsZhHk extends AppLocalizationsZh {
  AppLocalizationsZhHk() : super('zh_HK');

  @override
  String get appTitle => '扭計骰 Solver';

  @override
  String get ready => 'Ready';

  @override
  String get scrambled => '已打亂';

  @override
  String get solving => 'Solving 緊...';

  @override
  String movesFound(int count) {
    return '搵到 $count 步 solution';
  }

  @override
  String get alreadySolved => '已經 solved 或者搵唔到 solution';

  @override
  String error(String message) {
    return 'Error：$message';
  }

  @override
  String get solutionComplete => 'Solution 完成';

  @override
  String get autoApplyStopped => 'Auto apply 已停止';

  @override
  String stepProgress(int current, int total) {
    return 'Step $current / $total';
  }

  @override
  String autoProgress(int current, int total) {
    return 'Auto：$current / $total';
  }

  @override
  String get customCubeLoaded => '自訂扭計骰已 load';

  @override
  String get scramble => '打亂';

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
  String get manualCubeInput => '手動輸入扭計骰';

  @override
  String get tapToFocus => '點擊 sticker 聚焦，選擇顏色更改';

  @override
  String get selectColor => '選擇顏色';

  @override
  String get invalidCube => '無效嘅扭計骰配置，請檢查顏色。';

  @override
  String get display2D => '2D';

  @override
  String get display3D => '3D';
}

/// The translations for Chinese, as used in Taiwan (`zh_TW`).
class AppLocalizationsZhTw extends AppLocalizationsZh {
  AppLocalizationsZhTw() : super('zh_TW');

  @override
  String get appTitle => '魔方求解器';

  @override
  String get ready => '就緒';

  @override
  String get scrambled => '已打亂';

  @override
  String get solving => '求解中...';

  @override
  String movesFound(int count) {
    return '找到 $count 步解法';
  }

  @override
  String get alreadySolved => '已解決或未找到解法';

  @override
  String error(String message) {
    return '錯誤：$message';
  }

  @override
  String get solutionComplete => '解法完成';

  @override
  String get autoApplyStopped => '自動應用已停止';

  @override
  String stepProgress(int current, int total) {
    return '步驟 $current / $total';
  }

  @override
  String autoProgress(int current, int total) {
    return '自動：$current / $total';
  }

  @override
  String get customCubeLoaded => '自訂魔方已載入';

  @override
  String get scramble => '打亂';

  @override
  String get solve => '求解';

  @override
  String get reset => '重置';

  @override
  String get close => '關閉';

  @override
  String get cancel => '取消';

  @override
  String get saveAndValidate => '儲存並驗證';

  @override
  String get manualControls => '手動控制';

  @override
  String get solution => '解法';

  @override
  String get undo => '◀ 撤銷';

  @override
  String get apply => '應用 ▶';

  @override
  String get auto => '▶ 自動';

  @override
  String get stop => '⏸ 停止';

  @override
  String get manualCubeInput => '手動輸入魔方';

  @override
  String get tapToFocus => '點擊貼紙聚焦，選擇顏色更改';

  @override
  String get selectColor => '選擇顏色';

  @override
  String get invalidCube => '無效的魔方配置，請檢查顏色。';

  @override
  String get display2D => '2D';

  @override
  String get display3D => '3D';
}

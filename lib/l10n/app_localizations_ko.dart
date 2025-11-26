// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Korean (`ko`).
class AppLocalizationsKo extends AppLocalizations {
  AppLocalizationsKo([String locale = 'ko']) : super(locale);

  @override
  String get appTitle => '루빅스 큐브 솔버';

  @override
  String get ready => '준비됨';

  @override
  String get scrambled => '섞임';

  @override
  String get solving => '해결 중...';

  @override
  String movesFound(int count) {
    return '$count 단계 해법을 찾았습니다';
  }

  @override
  String get alreadySolved => '이미 해결되었거나 해법을 찾을 수 없습니다';

  @override
  String error(String message) {
    return '오류：$message';
  }

  @override
  String get solutionComplete => '해법 완료';

  @override
  String get autoApplyStopped => '자동 적용이 중지되었습니다';

  @override
  String stepProgress(int current, int total) {
    return '단계 $current / $total';
  }

  @override
  String autoProgress(int current, int total) {
    return '자동：$current / $total';
  }

  @override
  String get customCubeLoaded => '사용자 정의 큐브가 로드되었습니다';

  @override
  String get scramble => '섞기';

  @override
  String get solve => '해결';

  @override
  String get reset => '재설정';

  @override
  String get close => '닫기';

  @override
  String get cancel => '취소';

  @override
  String get saveAndValidate => '저장 및 검증';

  @override
  String get manualControls => '수동 제어';

  @override
  String get solution => '해법';

  @override
  String get undo => '◀ 실행 취소';

  @override
  String get apply => '적용 ▶';

  @override
  String get auto => '▶ 자동';

  @override
  String get stop => '⏸ 중지';

  @override
  String get manualCubeInput => '수동 큐브 입력';

  @override
  String get tapToFocus => '스티커를 탭하여 포커스하고 색상을 선택하여 변경';

  @override
  String get selectColor => '색상 선택';

  @override
  String get invalidCube => '잘못된 큐브 구성입니다. 색상을 확인하세요.';

  @override
  String get display2D => '2D';

  @override
  String get display3D => '3D';
}

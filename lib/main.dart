import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:rubiks_cube_solver/l10n/app_localizations.dart';
import 'models/cube.dart';
import 'services/solver.dart';
import 'widgets/cube_display_2d.dart';
import 'widgets/cube_display_3d.dart';
import 'widgets/game_controls.dart';
import 'widgets/solution_panel.dart';
import 'widgets/manual_input_panel.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize Firebase (with error handling)
  try {
    await Firebase.initializeApp();
    
    // Always enable analytics collection (for production tracking)
    // Analytics is enabled by default, but explicitly enabling ensures it works in all builds
    await FirebaseAnalytics.instance.setAnalyticsCollectionEnabled(true);
  } catch (e) {
    // If Firebase fails to initialize, log but don't block app
    debugPrint('Firebase initialization error: $e');
  }
  
  runApp(const RubiksCubeSolverApp());
}

class RubiksCubeSolverApp extends StatelessWidget {
  const RubiksCubeSolverApp({super.key});

  // Allow locale override via environment variable for testing
  static Locale? _getLocaleOverride() {
    const localeOverride = String.fromEnvironment('FLUTTER_LOCALE');
    if (localeOverride.isNotEmpty) {
      // Parse locale string like "zh_HK" or "zh-HK" or "zh"
      final parts = localeOverride.replaceAll('-', '_').split('_');
      if (parts.length == 2) {
        final locale = Locale(parts[0], parts[1]);
        debugPrint('Locale override: ${locale.languageCode}_${locale.countryCode}');
        return locale;
      } else if (parts.length == 1) {
        final locale = Locale(parts[0]);
        debugPrint('Locale override: ${locale.languageCode}');
        return locale;
      }
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final localeOverride = _getLocaleOverride();
    
    // Debug: Print what locale will be used
    if (localeOverride != null) {
      debugPrint('Using locale override: ${localeOverride.languageCode}_${localeOverride.countryCode ?? "null"}');
    } else {
      debugPrint('No locale override, using device locale');
    }
    
    return MaterialApp(
      title: 'Rubik Solver',
      theme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF121212),
        useMaterial3: true,
      ),
      // Override locale if specified via --dart-define
      locale: localeOverride,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('en'), // English (default fallback)
        Locale('zh', 'CN'), // Chinese Simplified
        Locale('zh', 'HK'), // Chinese Traditional Hong Kong
        Locale('zh', 'TW'), // Chinese Traditional Taiwan
        Locale('ja'), // Japanese
        Locale('ko'), // Korean
        Locale('es'), // Spanish
        Locale('fr'), // French
        Locale('de'), // German
        Locale('pt', 'BR'), // Portuguese Brazil
      ],
      // Fallback to English if device locale is not supported
      localeResolutionCallback: localeOverride != null
          ? null // Disable resolution callback when locale is overridden
          : (locale, supportedLocales) {
              // If device locale is null, use English
              if (locale == null) {
                return const Locale('en');
              }
              
              // Check for exact match (language + country)
              for (final supportedLocale in supportedLocales) {
                if (supportedLocale.languageCode == locale.languageCode &&
                    supportedLocale.countryCode == locale.countryCode) {
                  return supportedLocale;
                }
              }
              
              // Check for language code match (e.g., zh without country)
              // For Chinese, prefer Hong Kong (zh_HK) as default
              if (locale.languageCode == 'zh') {
                return const Locale('zh', 'HK');
              }
              
              for (final supportedLocale in supportedLocales) {
                if (supportedLocale.languageCode == locale.languageCode) {
                  return supportedLocale;
                }
              }
              
              // Fallback to English (first in the list)
              return const Locale('en');
            },
      home: const CubeSolverPage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class CubeSolverPage extends StatefulWidget {
  const CubeSolverPage({super.key});

  @override
  State<CubeSolverPage> createState() => _CubeSolverPageState();
}

class _CubeSolverPageState extends State<CubeSolverPage> {
  late RubiksCube cube;
  List<String> solution = [];
  int appliedMovesCount = 0;
  bool isSolving = false;
  bool isAutoApplying = false;
  String statusMessage = 'Ready';
  bool showManualControls = false;
  bool is3DMode = false;
  bool showManualInput = false;
  
  // Firebase Analytics - nullable in case initialization failed
  FirebaseAnalytics? get _analytics {
    try {
      return FirebaseAnalytics.instance;
    } catch (e) {
      return null; // Firebase not initialized
    }
  }

  @override
  void initState() {
    super.initState();
    cube = RubiksCube();
    _logScreenView('main_screen');
  }
  
  void _logScreenView(String screenName) {
    _analytics?.logScreenView(screenName: screenName);
  }
  
  void _logEvent(String eventName, {Map<String, Object>? parameters}) {
    _analytics?.logEvent(name: eventName, parameters: parameters);
  }

  void _scrambleCube() {
    final l10n = AppLocalizations.of(context)!;
    _logEvent('scramble_cube');
    setState(() {
      cube = RubiksCube();
      cube.scramble(25);
      solution = [];
      appliedMovesCount = 0;
      isAutoApplying = false;
      statusMessage = l10n.scrambled;
    });
  }

  void _solveCube() async {
    if (isSolving) return;
    final l10n = AppLocalizations.of(context)!;
    
    // Log solve button click
    _logEvent('solve_button_clicked');

    setState(() {
      isSolving = true;
      statusMessage = l10n.solving;
      solution = [];
      appliedMovesCount = 0;
      isAutoApplying = false;
    });

    try {
      final solver = CubeSolver();
      final moves = await solver.solve(cube);

      setState(() {
        solution = moves;
        appliedMovesCount = 0;
        if (solution.isEmpty) {
          statusMessage = l10n.alreadySolved;
        } else {
          statusMessage = l10n.movesFound(solution.length);
        }
        isSolving = false;
      });
      
      // Log solve completion
      _logEvent('solve_completed', parameters: {
        'solution_length': solution.length,
        'was_already_solved': solution.isEmpty ? 1 : 0, // Convert bool to int
      });
    } catch (e, stackTrace) {
      print('Solve error: $e');
      print('Stack: $stackTrace');
      setState(() {
        statusMessage = l10n.error(e.toString());
        isSolving = false;
      });
    }
  }

  void _closeSolution() {
    final l10n = AppLocalizations.of(context)!;
    setState(() {
      solution = [];
      appliedMovesCount = 0;
      isAutoApplying = false;
      statusMessage = l10n.ready;
    });
  }

  void _startAutoApply() async {
    if (isAutoApplying || solution.isEmpty) return;
    final l10n = AppLocalizations.of(context)!;
    
    _logEvent('auto_apply_started', parameters: {
      'solution_length': solution.length,
    });

    setState(() {
      isAutoApplying = true;
      statusMessage = l10n.solving;
    });

    while (appliedMovesCount < solution.length && isAutoApplying) {
      await Future.delayed(const Duration(milliseconds: 750));
      
      if (!isAutoApplying) break; // Check if stopped
      
      setState(() {
        cube.applyMove(solution[appliedMovesCount]);
        appliedMovesCount++;
        statusMessage = l10n.autoProgress(appliedMovesCount, solution.length);
      });
    }

    setState(() {
      isAutoApplying = false;
      if (appliedMovesCount >= solution.length) {
        statusMessage = l10n.solutionComplete;
      } else {
        statusMessage = l10n.autoApplyStopped;
      }
    });
  }

  void _stopAutoApply() {
    final l10n = AppLocalizations.of(context)!;
    
    // Log auto apply stop
    _logEvent('auto_apply_stopped', parameters: {
      'moves_applied': appliedMovesCount,
      'total_moves': solution.length,
    });
    
    setState(() {
      isAutoApplying = false;
      if (appliedMovesCount > 0) {
        statusMessage = l10n.stepProgress(appliedMovesCount, solution.length);
      } else {
        statusMessage = l10n.movesFound(solution.length);
      }
    });
  }

  void _applyNextStep() {
    if (appliedMovesCount < solution.length && !isAutoApplying) {
      final l10n = AppLocalizations.of(context)!;
      setState(() {
        cube.applyMove(solution[appliedMovesCount]);
        appliedMovesCount++;
        statusMessage = l10n.stepProgress(appliedMovesCount, solution.length);
      });
    }
  }

  void _undoLastStep() {
    if (appliedMovesCount > 0 && !isAutoApplying) {
      final l10n = AppLocalizations.of(context)!;
      setState(() {
        appliedMovesCount--;
        // Apply inverse move to undo
        final move = solution[appliedMovesCount];
        final inverseMove = _getInverseMove(move);
        cube.applyMove(inverseMove);
        if (appliedMovesCount > 0) {
          statusMessage = l10n.stepProgress(appliedMovesCount, solution.length);
        } else {
          statusMessage = l10n.movesFound(solution.length);
        }
      });
    }
  }

  String _getInverseMove(String move) {
    // Handle double turns (F2, R2, etc.) - they are their own inverse
    if (move.endsWith('2')) {
      return move;
    }
    // Handle prime moves (F', R', etc.)
    if (move.endsWith('\'')) {
      return move.substring(0, move.length - 1);
    }
    // Handle regular moves (F, R, etc.)
    return '$move\'';
  }

  void _resetCube() {
    final l10n = AppLocalizations.of(context)!;
    setState(() {
      cube = RubiksCube();
      solution = [];
      appliedMovesCount = 0;
      isAutoApplying = false;
      statusMessage = l10n.ready;
    });
  }

  void _applyMove(String move) {
    setState(() {
      cube.applyMove(move);
    });
  }

  void _toggleManualInput() {
    _logEvent('manual_input_toggled', parameters: {
      'opened': (!showManualInput) ? 1 : 0, // Convert bool to int
    });
    setState(() {
      showManualInput = !showManualInput;
    });
  }

  void _onManualCubeInput(RubiksCube newCube) {
    final l10n = AppLocalizations.of(context)!;
    
    // Log manual input completion
    _logEvent('manual_input_completed');
    
    setState(() {
      cube = newCube;
      solution = [];
      appliedMovesCount = 0;
      isAutoApplying = false;
      statusMessage = l10n.customCubeLoaded;
      showManualInput = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    // Initialize status message if it's still the default
    if (statusMessage == 'Ready') {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          setState(() {
            statusMessage = l10n.ready;
          });
        }
      });
    }
    
    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      body: Stack(
        children: [
          SafeArea(
            child: Column(
          children: [
            // Simple header
            Padding(
              padding: const EdgeInsets.all(20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    l10n.appTitle,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w300,
                      color: Colors.white,
                    ),
                  ),
                  Flexible(
                    child: Text(
                      statusMessage,
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.white70,
                      ),
                      textAlign: TextAlign.right,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),

            // Display mode toggle
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildModeButton(l10n.display2D, !is3DMode, () {
                    _logEvent('view_mode_changed', parameters: {'mode': '2d'});
                    setState(() {
                      is3DMode = false;
                    });
                  }),
                  const SizedBox(width: 12),
                  _buildModeButton(l10n.display3D, is3DMode, () {
                    _logEvent('view_mode_changed', parameters: {'mode': '3d'});
                    setState(() {
                      is3DMode = true;
                    });
                  }),
                ],
              ),
            ),

            // Cube display
            Expanded(
              child: Center(
                child: is3DMode
                    ? CubeDisplay3D(cube: cube)
                    : SingleChildScrollView(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: CubeDisplay2D(cube: cube),
                        ),
                      ),
              ),
            ),

            // Solution display
            AnimatedSize(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut,
              child: solution.isNotEmpty
                  ? SolutionPanel(
                      solution: solution,
                      appliedMovesCount: appliedMovesCount,
                      isAutoApplying: isAutoApplying,
                      onUndo: appliedMovesCount > 0 && !isAutoApplying ? _undoLastStep : null,
                      onApplyNext: appliedMovesCount < solution.length && !isAutoApplying ? _applyNextStep : null,
                      onAutoApply: isAutoApplying ? _stopAutoApply : _startAutoApply,
                    )
                  : const SizedBox.shrink(),
            ),

            const SizedBox(height: 10),

            // Controls
            GameControls(
              onScramble: _scrambleCube,
              onSolve: _solveCube,
              onCloseSolution: solution.isNotEmpty ? _closeSolution : null,
              onReset: _resetCube,
              onMove: _applyMove,
              isSolving: isSolving,
              showManualControls: showManualControls,
              onToggleManualControls: () {
                setState(() {
                  showManualControls = !showManualControls;
                });
              },
              onEdit: _toggleManualInput,
            ),

            const SizedBox(height: 20),
          ],
        ),
      ),
          
          // Manual input overlay
          if (showManualInput)
            ManualInputPanel(
              initialCube: cube,
              onFinish: _onManualCubeInput,
              onCancel: _toggleManualInput,
            ),
        ],
      ),
    );
  }

  Widget _buildModeButton(String label, bool isSelected, VoidCallback onTap) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: isSelected
                ? Colors.white.withOpacity(0.2)
                : Colors.white.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
            border: isSelected
                ? Border.all(color: Colors.white.withOpacity(0.3), width: 1)
                : null,
          ),
          child: Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: isSelected ? Colors.white : Colors.white70,
              fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
            ),
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'models/cube.dart';
import 'services/solver.dart';
import 'widgets/cube_display.dart';
import 'widgets/game_controls.dart';

void main() {
  runApp(const RubiksCubeSolverApp());
}

class RubiksCubeSolverApp extends StatelessWidget {
  const RubiksCubeSolverApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Rubik Solver',
      theme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF121212),
        useMaterial3: true,
      ),
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
  String statusMessage = 'Ready';
  bool showManualControls = false;

  @override
  void initState() {
    super.initState();
    cube = RubiksCube();
  }

  void _scrambleCube() {
    setState(() {
      cube = RubiksCube();
      cube.scramble(25);
      solution = [];
      appliedMovesCount = 0;
      statusMessage = 'Scrambled';
    });
  }

  void _solveCube() async {
    if (isSolving) return;

    setState(() {
      isSolving = true;
      statusMessage = 'Solving...';
      solution = [];
      appliedMovesCount = 0;
    });

    try {
      final solver = CubeSolver();
      final moves = await solver.solve(cube);

      setState(() {
        solution = moves;
        appliedMovesCount = 0;
        if (solution.isEmpty) {
          statusMessage = 'Already solved or no solution found';
        } else {
          statusMessage = '${solution.length} moves found';
        }
        isSolving = false;
      });
    } catch (e, stackTrace) {
      print('Solve error: $e');
      print('Stack: $stackTrace');
      setState(() {
        statusMessage = 'Error: ${e.toString()}';
        isSolving = false;
      });
    }
  }

  void _applySolution() {
    if (solution.isEmpty) return;

    setState(() {
      for (var move in solution) {
        cube.applyMove(move);
      }
      statusMessage = 'Applied';
      solution = [];
      appliedMovesCount = 0;
    });
  }

  void _applyNextStep() {
    if (appliedMovesCount < solution.length) {
      setState(() {
        cube.applyMove(solution[appliedMovesCount]);
        appliedMovesCount++;
        statusMessage = 'Step $appliedMovesCount / ${solution.length}';
      });
    }
  }

  void _undoLastStep() {
    if (appliedMovesCount > 0) {
      setState(() {
        appliedMovesCount--;
        // Apply inverse move to undo
        final move = solution[appliedMovesCount];
        final inverseMove = _getInverseMove(move);
        cube.applyMove(inverseMove);
        if (appliedMovesCount > 0) {
          statusMessage = 'Step $appliedMovesCount / ${solution.length}';
        } else {
          statusMessage = '${solution.length} moves found';
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
    setState(() {
      cube = RubiksCube();
      solution = [];
      appliedMovesCount = 0;
      statusMessage = 'Ready';
    });
  }

  void _applyMove(String move) {
    setState(() {
      cube.applyMove(move);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      body: SafeArea(
        child: Column(
          children: [
            // Simple header
            Padding(
              padding: const EdgeInsets.all(20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Rubik Solver',
                    style: TextStyle(
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

            // Cube display
            Expanded(
              child: Center(
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: CubeDisplay(cube: cube),
                  ),
                ),
              ),
            ),

            // Solution display
            if (solution.isNotEmpty)
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.05),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Solution',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.white54,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Text(
                          '$appliedMovesCount / ${solution.length}',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.white54,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Wrap(
                      spacing: 6,
                      runSpacing: 6,
                      children: solution.asMap().entries.map((entry) {
                        final index = entry.key;
                        final move = entry.value;
                        final isApplied = index < appliedMovesCount;
                        return Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: isApplied
                                ? const Color(0xFF06D6A0).withOpacity(0.3)
                                : Colors.white.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            move,
                            style: TextStyle(
                              fontSize: 12,
                              color: isApplied ? Colors.white : Colors.white70,
                              fontWeight: isApplied ? FontWeight.w600 : FontWeight.normal,
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: _buildStepButton(
                            '◀ Undo',
                            Icons.undo,
                            appliedMovesCount > 0 ? _undoLastStep : null,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: _buildStepButton(
                            'Apply ▶',
                            Icons.redo,
                            appliedMovesCount < solution.length ? _applyNextStep : null,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

            const SizedBox(height: 10),

            // Controls
            GameControls(
              onScramble: _scrambleCube,
              onSolve: _solveCube,
              onApplySolution: solution.isNotEmpty ? _applySolution : null,
              onReset: _resetCube,
              onMove: _applyMove,
              isSolving: isSolving,
              showManualControls: showManualControls,
              onToggleManualControls: () {
                setState(() {
                  showManualControls = !showManualControls;
                });
              },
            ),

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildStepButton(String label, IconData icon, VoidCallback? onPressed) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(6),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: onPressed != null
                ? Colors.white.withOpacity(0.1)
                : Colors.white.withOpacity(0.05),
            borderRadius: BorderRadius.circular(6),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: 16,
                color: onPressed != null ? Colors.white70 : Colors.white30,
              ),
              const SizedBox(width: 6),
              Text(
                label,
                style: TextStyle(
                  fontSize: 12,
                  color: onPressed != null ? Colors.white70 : Colors.white30,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

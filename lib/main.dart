import 'package:flutter/material.dart';
import 'models/cube.dart';
import 'services/solver.dart';
import 'widgets/cube_display_2d.dart';
import 'widgets/cube_display_3d.dart';
import 'widgets/game_controls.dart';
import 'widgets/solution_panel.dart';
import 'widgets/manual_input_panel.dart';

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
  bool isAutoApplying = false;
  String statusMessage = 'Ready';
  bool showManualControls = false;
  bool is3DMode = false;
  bool showManualInput = false;

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
      isAutoApplying = false;
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
      isAutoApplying = false;
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

  void _closeSolution() {
    setState(() {
      solution = [];
      appliedMovesCount = 0;
      isAutoApplying = false;
      statusMessage = 'Ready';
    });
  }

  void _startAutoApply() async {
    if (isAutoApplying || solution.isEmpty) return;

    setState(() {
      isAutoApplying = true;
      statusMessage = 'Auto applying...';
    });

    while (appliedMovesCount < solution.length && isAutoApplying) {
      await Future.delayed(const Duration(milliseconds: 750));
      
      if (!isAutoApplying) break; // Check if stopped
      
      setState(() {
        cube.applyMove(solution[appliedMovesCount]);
        appliedMovesCount++;
        statusMessage = 'Auto: $appliedMovesCount / ${solution.length}';
      });
    }

    setState(() {
      isAutoApplying = false;
      if (appliedMovesCount >= solution.length) {
        statusMessage = 'Solution complete';
      } else {
        statusMessage = 'Auto apply stopped';
      }
    });
  }

  void _stopAutoApply() {
    setState(() {
      isAutoApplying = false;
      if (appliedMovesCount > 0) {
        statusMessage = 'Step $appliedMovesCount / ${solution.length}';
      } else {
        statusMessage = '${solution.length} moves found';
      }
    });
  }

  void _applyNextStep() {
    if (appliedMovesCount < solution.length && !isAutoApplying) {
      setState(() {
        cube.applyMove(solution[appliedMovesCount]);
        appliedMovesCount++;
        statusMessage = 'Step $appliedMovesCount / ${solution.length}';
      });
    }
  }

  void _undoLastStep() {
    if (appliedMovesCount > 0 && !isAutoApplying) {
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
      isAutoApplying = false;
      statusMessage = 'Ready';
    });
  }

  void _applyMove(String move) {
    setState(() {
      cube.applyMove(move);
    });
  }

  void _toggleManualInput() {
    setState(() {
      showManualInput = !showManualInput;
    });
  }

  void _onManualCubeInput(RubiksCube newCube) {
    setState(() {
      cube = newCube;
      solution = [];
      appliedMovesCount = 0;
      isAutoApplying = false;
      statusMessage = 'Custom cube loaded';
      showManualInput = false;
    });
  }

  @override
  Widget build(BuildContext context) {
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
                  Row(
                    children: [
                      const Text(
                        'Rubik Solver',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.w300,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(width: 12),
                      IconButton(
                        icon: const Icon(Icons.edit, size: 20),
                        onPressed: _toggleManualInput,
                        color: Colors.white70,
                        tooltip: 'Manual Input',
                      ),
                    ],
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
                  _buildModeButton('2D', !is3DMode, () {
                    setState(() {
                      is3DMode = false;
                    });
                  }),
                  const SizedBox(width: 12),
                  _buildModeButton('3D', is3DMode, () {
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

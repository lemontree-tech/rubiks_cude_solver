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
      statusMessage = 'Scrambled';
    });
  }

  void _solveCube() async {
    if (isSolving) return;

    setState(() {
      isSolving = true;
      statusMessage = 'Solving...';
      solution = [];
    });

    try {
      final solver = CubeSolver();
      final moves = await solver.solve(cube);

      setState(() {
        solution = moves;
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
    });
  }

  void _resetCube() {
    setState(() {
      cube = RubiksCube();
      solution = [];
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
                children: [
                  const Text(
                    'Rubik Solver',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w300,
                      color: Colors.white,
                    ),
                  ),
                  Text(
                    statusMessage,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.white70,
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
                    Text(
                      'Solution',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.white54,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Wrap(
                      spacing: 6,
                      runSpacing: 6,
                      children: solution.map((move) {
                        return Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            move,
                            style: const TextStyle(
                              fontSize: 12,
                              color: Colors.white,
                            ),
                          ),
                        );
                      }).toList(),
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
}

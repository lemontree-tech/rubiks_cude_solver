import 'dart:async';
import 'package:cuber/cuber.dart';
import '../models/cube.dart';

class CubeSolver {
  // Uses cuber package - Kociemba's two-phase algorithm
  
  Future<List<String>> solve(RubiksCube cube) async {
    if (cube.isSolved) {
      return [];
    }

    try {
      // Use cuber's cube directly - no conversion needed!
      final cuberCube = cube.cube;
      
      // Check if cube is valid
      if (!cuberCube.isOk) {
        print('Cube is not valid: ${cuberCube.verify()}');
        return [];
      }
      
      print('Starting solver...');
      
      // Solve using Kociemba's algorithm with timeout
      const solver = KociembaSolver();
      final solution = await Future(() => solver.solve(
        cuberCube,
        timeout: const Duration(seconds: 30),
      )).timeout(
        const Duration(seconds: 35),
        onTimeout: () {
          print('Solver timeout');
          return null;
        },
      );
      
      if (solution == null) {
        print('Solver returned null');
        return [];
      }
      
      if (solution.isEmpty) {
        print('Solution is empty');
        return [];
      }
      
      // Convert cuber's algorithm to our move format
      final moves = _convertFromCuberAlgorithm(solution.algorithm);
      print('Solution found: ${moves.length} moves: ${moves.join(" ")}');
      return moves;
    } catch (e, stackTrace) {
      // Log the error for debugging
      print('Solver error: $e');
      print('Stack trace: $stackTrace');
      return [];
    }
  }

  List<String> _convertFromCuberAlgorithm(Algorithm algorithm) {
    // cuber's Algorithm.toString() returns moves in standard notation
    // e.g., "R U R' U'"
    final movesString = algorithm.toString();
    print('Algorithm string: $movesString');
    final moves = movesString.trim().split(RegExp(r'\s+'));
    return moves.where((move) => move.isNotEmpty).toList();
  }
}

import 'package:cuber/cuber.dart';

// Wrapper around cuber's Cube to maintain compatibility with existing code
class RubiksCube {
  Cube _cube;

  RubiksCube() : _cube = Cube.solved;

  RubiksCube.copy(RubiksCube other) : _cube = other._cube;

  // Get the internal cube
  Cube get cube => _cube;

  // Delegate to cuber's cube
  bool get isSolved => _cube.isSolved;

  void scramble(int moves) {
    _cube = Algorithm.scramble(n: moves).apply(Cube.solved);
  }

  void applyMove(String move) {
    _cube = _cube.move(Move.parse(move));
  }

  // Convert cuber's cube to our face representation for display
  List<List<List<FaceColor>>> get faces {
    final definition = _cube.definition;
    // definition is 54 characters: U (9) R (9) F (9) D (9) L (9) B (9)
    
    final faces = List.generate(6, (_) => List.generate(3, (_) => List.filled(3, FaceColor.white)));
    
    // Parse each face
    int index = 0;
    
    // Up face (0) - first 9 characters
    for (int i = 0; i < 3; i++) {
      for (int j = 0; j < 3; j++) {
        faces[0][i][j] = _charToFaceColor(definition[index++]);
      }
    }
    
    // Right face (4) - next 9 characters
    for (int i = 0; i < 3; i++) {
      for (int j = 0; j < 3; j++) {
        faces[4][i][j] = _charToFaceColor(definition[index++]);
      }
    }
    
    // Front face (2) - next 9 characters
    for (int i = 0; i < 3; i++) {
      for (int j = 0; j < 3; j++) {
        faces[2][i][j] = _charToFaceColor(definition[index++]);
      }
    }
    
    // Down face (1) - next 9 characters
    for (int i = 0; i < 3; i++) {
      for (int j = 0; j < 3; j++) {
        faces[1][i][j] = _charToFaceColor(definition[index++]);
      }
    }
    
    // Left face (5) - next 9 characters
    for (int i = 0; i < 3; i++) {
      for (int j = 0; j < 3; j++) {
        faces[5][i][j] = _charToFaceColor(definition[index++]);
      }
    }
    
    // Back face (3) - last 9 characters
    for (int i = 0; i < 3; i++) {
      for (int j = 0; j < 3; j++) {
        faces[3][i][j] = _charToFaceColor(definition[index++]);
      }
    }
    
    return faces;
  }

  FaceColor _charToFaceColor(String char) {
    switch (char) {
      case 'U':
        return FaceColor.white;
      case 'D':
        return FaceColor.yellow;
      case 'F':
        return FaceColor.red;
      case 'B':
        return FaceColor.orange;
      case 'R':
        return FaceColor.green;
      case 'L':
        return FaceColor.blue;
      default:
        return FaceColor.white;
    }
  }

  RubiksCube copy() {
    return RubiksCube.copy(this);
  }
}

enum FaceColor {
  white,   // Up
  yellow,  // Down
  red,     // Front
  orange,  // Back
  green,   // Right
  blue,    // Left
}

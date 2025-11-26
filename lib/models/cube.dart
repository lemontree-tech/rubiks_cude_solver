import 'package:cuber/cuber.dart';

// Wrapper around cuber's Cube to maintain compatibility with existing code
class RubiksCube {
  Cube _cube;

  RubiksCube() : _cube = Cube.solved;

  RubiksCube.copy(RubiksCube other) : _cube = other._cube;

  // Private constructor for factory
  RubiksCube._fromCube(this._cube);

  // Factory to create from facelet string
  factory RubiksCube.fromFacelets(String facelets) {
    try {
      final cuberCube = Cube.from(facelets);
      return RubiksCube._fromCube(cuberCube);
    } catch (e) {
      throw ArgumentError('Invalid facelet string: $e');
    }
  }

  // Get the internal cube
  Cube get cube => _cube;

  // Delegate to cuber's cube
  bool get isSolved => _cube.isSolved;

  // Get cube definition for state comparison
  String get definition => _cube.definition;

  // Check if cube is valid and solvable
  bool get isValid {
    try {
      return _cube.isOk;
    } catch (e) {
      return false;
    }
  }

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

  // Convert face representation to facelet string for cuber library
  // Order: U (0) R (4) F (2) D (1) L (5) B (3)
  String toFaceletString(List<List<List<FaceColor>>> customFaces) {
    String result = '';
    final faceOrder = [0, 4, 2, 1, 5, 3]; // U, R, F, D, L, B
    
    for (final faceIndex in faceOrder) {
      for (int i = 0; i < 3; i++) {
        for (int j = 0; j < 3; j++) {
          result += _faceColorToChar(customFaces[faceIndex][i][j]);
        }
      }
    }
    
    return result;
  }

  String _faceColorToChar(FaceColor color) {
    switch (color) {
      case FaceColor.white:
        return 'U';
      case FaceColor.yellow:
        return 'D';
      case FaceColor.red:
        return 'F';
      case FaceColor.orange:
        return 'B';
      case FaceColor.green:
        return 'R';
      case FaceColor.blue:
        return 'L';
    }
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

import 'dart:math';

enum FaceColor {
  white,   // Up
  yellow,  // Down
  red,     // Front
  orange,  // Back
  green,   // Right
  blue,    // Left
}

class RubiksCube {
  // 6 faces, each is a 3x3 grid
  // Face indices: 0=Up(White), 1=Down(Yellow), 2=Front(Red), 3=Back(Orange), 4=Right(Green), 5=Left(Blue)
  List<List<List<FaceColor>>> faces;

  RubiksCube() : faces = List.generate(6, (_) => List.generate(3, (_) => List.filled(3, FaceColor.white))) {
    _initializeSolvedState();
  }

  RubiksCube.copy(RubiksCube other) 
      : faces = other.faces.map((face) => 
          face.map((row) => List<FaceColor>.from(row)).toList()
        ).toList();

  void _initializeSolvedState() {
    faces[0] = List.generate(3, (_) => List.filled(3, FaceColor.white));   // Up
    faces[1] = List.generate(3, (_) => List.filled(3, FaceColor.yellow));  // Down
    faces[2] = List.generate(3, (_) => List.filled(3, FaceColor.red));    // Front
    faces[3] = List.generate(3, (_) => List.filled(3, FaceColor.orange));  // Back
    faces[4] = List.generate(3, (_) => List.filled(3, FaceColor.green));   // Right
    faces[5] = List.generate(3, (_) => List.filled(3, FaceColor.blue));   // Left
  }

  bool get isSolved {
    for (int face = 0; face < 6; face++) {
      final color = faces[face][0][0];
      for (int i = 0; i < 3; i++) {
        for (int j = 0; j < 3; j++) {
          if (faces[face][i][j] != color) return false;
        }
      }
    }
    return true;
  }

  void scramble(int moves) {
    final random = Random();
    final moveNotation = ['U', 'U\'', 'D', 'D\'', 'F', 'F\'', 'B', 'B\'', 'R', 'R\'', 'L', 'L\''];
    
    for (int i = 0; i < moves; i++) {
      final move = moveNotation[random.nextInt(moveNotation.length)];
      applyMove(move);
    }
  }

  void applyMove(String move) {
    switch (move) {
      case 'U':
        rotateFaceClockwise(0);
        break;
      case 'U\'':
        rotateFaceCounterClockwise(0);
        break;
      case 'D':
        rotateFaceClockwise(1);
        break;
      case 'D\'':
        rotateFaceCounterClockwise(1);
        break;
      case 'F':
        rotateFaceClockwise(2);
        break;
      case 'F\'':
        rotateFaceCounterClockwise(2);
        break;
      case 'B':
        rotateFaceClockwise(3);
        break;
      case 'B\'':
        rotateFaceCounterClockwise(3);
        break;
      case 'R':
        rotateFaceClockwise(4);
        break;
      case 'R\'':
        rotateFaceCounterClockwise(4);
        break;
      case 'L':
        rotateFaceClockwise(5);
        break;
      case 'L\'':
        rotateFaceCounterClockwise(5);
        break;
    }
  }

  void rotateFaceClockwise(int faceIndex) {
    // Rotate the face itself
    final face = faces[faceIndex];
    final rotated = List.generate(3, (i) => List.generate(3, (j) => face[2 - j][i]));
    faces[faceIndex] = rotated;

    // Rotate adjacent edges
    switch (faceIndex) {
      case 0: // Up (White)
        _rotateUpEdges();
        break;
      case 1: // Down (Yellow)
        _rotateDownEdges();
        break;
      case 2: // Front (Red)
        _rotateFrontEdges();
        break;
      case 3: // Back (Orange)
        _rotateBackEdges();
        break;
      case 4: // Right (Green)
        _rotateRightEdges();
        break;
      case 5: // Left (Blue)
        _rotateLeftEdges();
        break;
    }
  }

  void rotateFaceCounterClockwise(int faceIndex) {
    // Three clockwise rotations = one counter-clockwise
    rotateFaceClockwise(faceIndex);
    rotateFaceClockwise(faceIndex);
    rotateFaceClockwise(faceIndex);
  }

  void _rotateUpEdges() {
    // Up face rotation affects: Front, Right, Back, Left top rows
    final temp = List<FaceColor>.from(faces[2][0]);
    faces[2][0] = List<FaceColor>.from(faces[4][0]);
    faces[4][0] = List<FaceColor>.from(faces[3][0]);
    faces[3][0] = List<FaceColor>.from(faces[5][0]);
    faces[5][0] = temp;
  }

  void _rotateDownEdges() {
    // Down face rotation affects: Front, Left, Back, Right bottom rows
    final temp = List<FaceColor>.from(faces[2][2]);
    faces[2][2] = List<FaceColor>.from(faces[5][2]);
    faces[5][2] = List<FaceColor>.from(faces[3][2]);
    faces[3][2] = List<FaceColor>.from(faces[4][2]);
    faces[4][2] = temp;
  }

  void _rotateFrontEdges() {
    // Front face rotation affects: Up bottom row, Right left column, Down top row, Left right column
    final temp = [
      faces[0][2][0],
      faces[0][2][1],
      faces[0][2][2],
    ];
    
    // Up bottom row <- Left right column (reversed)
    faces[0][2][0] = faces[5][2][2];
    faces[0][2][1] = faces[5][1][2];
    faces[0][2][2] = faces[5][0][2];
    
    // Left right column <- Down top row (reversed)
    faces[5][0][2] = faces[1][0][2];
    faces[5][1][2] = faces[1][0][1];
    faces[5][2][2] = faces[1][0][0];
    
    // Down top row <- Right left column
    faces[1][0][0] = faces[4][2][0];
    faces[1][0][1] = faces[4][1][0];
    faces[1][0][2] = faces[4][0][0];
    
    // Right left column <- Up bottom row
    faces[4][0][0] = temp[2];
    faces[4][1][0] = temp[1];
    faces[4][2][0] = temp[0];
  }

  void _rotateBackEdges() {
    // Back face rotation affects: Up top row, Left left column, Down bottom row, Right right column
    final temp = [
      faces[0][0][0],
      faces[0][0][1],
      faces[0][0][2],
    ];
    
    // Up top row <- Right right column
    faces[0][0][0] = faces[4][0][2];
    faces[0][0][1] = faces[4][1][2];
    faces[0][0][2] = faces[4][2][2];
    
    // Right right column <- Down bottom row (reversed)
    faces[4][0][2] = faces[1][2][2];
    faces[4][1][2] = faces[1][2][1];
    faces[4][2][2] = faces[1][2][0];
    
    // Down bottom row <- Left left column
    faces[1][2][0] = faces[5][2][0];
    faces[1][2][1] = faces[5][1][0];
    faces[1][2][2] = faces[5][0][0];
    
    // Left left column <- Up top row (reversed)
    faces[5][0][0] = temp[2];
    faces[5][1][0] = temp[1];
    faces[5][2][0] = temp[0];
  }

  void _rotateRightEdges() {
    // Right face rotation affects: Up right column, Back left column, Down right column, Front right column
    final temp = [
      faces[0][0][2],
      faces[0][1][2],
      faces[0][2][2],
    ];
    
    // Up right column <- Front right column
    faces[0][0][2] = faces[2][0][2];
    faces[0][1][2] = faces[2][1][2];
    faces[0][2][2] = faces[2][2][2];
    
    // Front right column <- Down right column
    faces[2][0][2] = faces[1][0][2];
    faces[2][1][2] = faces[1][1][2];
    faces[2][2][2] = faces[1][2][2];
    
    // Down right column <- Back left column (reversed)
    faces[1][0][2] = faces[3][2][0];
    faces[1][1][2] = faces[3][1][0];
    faces[1][2][2] = faces[3][0][0];
    
    // Back left column <- Up right column (reversed)
    faces[3][0][0] = temp[2];
    faces[3][1][0] = temp[1];
    faces[3][2][0] = temp[0];
  }

  void _rotateLeftEdges() {
    // Left face rotation affects: Up left column, Front left column, Down left column, Back right column
    final temp = [
      faces[0][0][0],
      faces[0][1][0],
      faces[0][2][0],
    ];
    
    // Up left column <- Back right column (reversed)
    faces[0][0][0] = faces[3][2][2];
    faces[0][1][0] = faces[3][1][2];
    faces[0][2][0] = faces[3][0][2];
    
    // Back right column <- Down left column (reversed)
    faces[3][0][2] = faces[1][2][0];
    faces[3][1][2] = faces[1][1][0];
    faces[3][2][2] = faces[1][0][0];
    
    // Down left column <- Front left column
    faces[1][0][0] = faces[2][0][0];
    faces[1][1][0] = faces[2][1][0];
    faces[1][2][0] = faces[2][2][0];
    
    // Front left column <- Up left column
    faces[2][0][0] = temp[0];
    faces[2][1][0] = temp[1];
    faces[2][2][0] = temp[2];
  }

  RubiksCube copy() {
    return RubiksCube.copy(this);
  }
}


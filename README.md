# Rubik's Cube Solver - Flutter Mini App

A Flutter application for solving 3x3 Rubik's cubes. This mini-app provides an interactive interface to visualize, scramble, and solve Rubik's cubes.

## Features

- **3D Cube Visualization**: View the cube in an unfolded net format showing all 6 faces
- **Scramble Function**: Randomly scramble the cube with 25 random moves
- **Solver Algorithm**: Automatically solve the cube using a depth-first search algorithm
- **Manual Controls**: Apply individual face rotations manually
- **Solution Display**: View the sequence of moves needed to solve the cube
- **Apply Solution**: Automatically apply the solution moves to solve the cube

## Project Structure

```
lib/
├── main.dart              # Main app entry point
├── models/
│   └── cube.dart         # Rubik's cube data model and rotation logic
├── services/
│   └── solver.dart       # Cube solving algorithm
└── widgets/
    ├── cube_display.dart # Cube visualization widget
    └── controls.dart     # UI controls widget
```

## Getting Started

### Prerequisites

- Flutter SDK (>=3.0.0)
- Dart SDK

### Installation

1. Navigate to the project directory:
```bash
cd rubiks_cube_solver
```

2. Get Flutter dependencies:
```bash
flutter pub get
```

3. Run the app:
```bash
flutter run
```

## Usage

1. **Scramble**: Tap the "Scramble" button to randomly scramble the cube
2. **Solve**: Tap the "Solve" button to find a solution (may take a few seconds)
3. **Apply Solution**: Once a solution is found, tap "Apply Solution" to automatically solve the cube
4. **Manual Control**: Use the manual controls to rotate individual faces
5. **Reset**: Tap "Reset to Solved" to return the cube to its solved state

## Cube Notation

The app uses standard Rubik's cube notation:
- **U**: Rotate Up face clockwise
- **U'**: Rotate Up face counter-clockwise
- **D**: Rotate Down face clockwise
- **D'**: Rotate Down face counter-clockwise
- **F**: Rotate Front face clockwise
- **F'**: Rotate Front face counter-clockwise
- **B**: Rotate Back face clockwise
- **B'**: Rotate Back face counter-clockwise
- **R**: Rotate Right face clockwise
- **R'**: Rotate Right face counter-clockwise
- **L**: Rotate Left face clockwise
- **L'**: Rotate Left face counter-clockwise

## Technical Details

- The cube is represented as a 3D array (6 faces × 3×3 grid)
- Face rotations include both the face itself and adjacent edge pieces
- The solver uses iterative deepening depth-first search
- The visualization shows the cube in an unfolded net format

## Future Improvements

- 3D cube visualization with rotation
- Faster solving algorithm (Kociemba's algorithm)
- Solution step-by-step animation
- Save/load cube states
- Timer for solving speed


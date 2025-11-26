import 'package:flutter/material.dart';
import '../models/cube.dart';

class ManualInputPanel extends StatefulWidget {
  final RubiksCube initialCube;
  final Function(RubiksCube) onFinish;
  final VoidCallback onCancel;

  const ManualInputPanel({
    super.key,
    required this.initialCube,
    required this.onFinish,
    required this.onCancel,
  });

  @override
  State<ManualInputPanel> createState() => _ManualInputPanelState();
}

class _ManualInputPanelState extends State<ManualInputPanel> {
  late List<List<List<FaceColor>>> _currentFaces;
  String _validationMessage = '';

  @override
  void initState() {
    super.initState();
    _currentFaces = _deepCopyFaces(widget.initialCube.faces);
  }

  List<List<List<FaceColor>>> _deepCopyFaces(List<List<List<FaceColor>>> original) {
    return original.map((face) =>
        face.map((row) => List<FaceColor>.from(row)).toList()
    ).toList();
  }

  void _toggleColor(int faceIndex, int row, int col) {
    setState(() {
      final currentColor = _currentFaces[faceIndex][row][col];
      _currentFaces[faceIndex][row][col] = FaceColor.values[(currentColor.index + 1) % FaceColor.values.length];
      _validationMessage = ''; // Clear message on color change
    });
  }

  void _validateAndSave() {
    try {
      // Convert current faces to facelet string
      final faceletString = widget.initialCube.toFaceletString(_currentFaces);
      
      // Try to create a cube from this
      final newCube = RubiksCube.fromFacelets(faceletString);
      
      // Check if valid
      if (newCube.isValid) {
        widget.onFinish(newCube);
      } else {
        setState(() {
          _validationMessage = 'Invalid cube configuration. Please check colors.';
        });
      }
    } catch (e) {
      setState(() {
        _validationMessage = 'Error: ${e.toString()}';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black.withOpacity(0.85),
      child: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'Manual Cube Input',
                  style: TextStyle(fontSize: 24, color: Colors.white, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
                const Text(
                  'Tap stickers to change colors',
                  style: TextStyle(fontSize: 14, color: Colors.white70),
                ),
                const SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: _buildCubeInputGrid(),
                ),
                const SizedBox(height: 20),
                if (_validationMessage.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: Text(
                      _validationMessage,
                      style: const TextStyle(color: Colors.redAccent, fontSize: 14),
                      textAlign: TextAlign.center,
                    ),
                  ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _buildButton('Cancel', widget.onCancel, Colors.grey[700]!),
                    const SizedBox(width: 20),
                    _buildButton('Save & Validate', _validateAndSave, Colors.green[700]!),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCubeInputGrid() {
    return LayoutBuilder(
      builder: (context, constraints) {
        // Calculate responsive sticker size similar to CubeDisplay2D
        final availableWidth = constraints.maxWidth;
        final spacing = 24.0;
        final borderWidth = 4.0;
        final stickerMargins = 9.0;
        final buffer = 8.0;
        final maxFaceWidth = (availableWidth - spacing - (borderWidth * 4) - stickerMargins - buffer) / 4;
        final stickerSize = (maxFaceWidth / 3.3).clamp(18.0, 28.0);

        // Build an invisible spacer face with same dimensions
        final spacerFace = Opacity(
          opacity: 0.0,
          child: _buildFace(_currentFaces[5], stickerSize, 5),
        );

        return Column(
          children: [
            // Top face - aligned with front face
            _buildFaceRow([
              spacerFace,
              _buildFace(_currentFaces[0], stickerSize, 0), // Up face
              spacerFace,
              spacerFace,
            ]),
            const SizedBox(height: 8),
            // Middle row
            _buildFaceRow([
              _buildFace(_currentFaces[5], stickerSize, 5), // Left face
              _buildFace(_currentFaces[2], stickerSize, 2), // Front face
              _buildFace(_currentFaces[4], stickerSize, 4), // Right face
              _buildFace(_currentFaces[3], stickerSize, 3), // Back face
            ]),
            const SizedBox(height: 8),
            // Bottom face - aligned with front face
            _buildFaceRow([
              spacerFace,
              _buildFace(_currentFaces[1], stickerSize, 1), // Down face
              spacerFace,
              spacerFace,
            ]),
          ],
        );
      },
    );
  }

  Widget _buildFaceRow(List<Widget> faces) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: faces.map((face) {
        return Flexible(
          fit: FlexFit.loose,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 3),
            child: face,
          ),
        );
      }).toList(),
    );
  }

  Widget _buildFace(List<List<FaceColor>> face, double stickerSize, int faceIndex) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(
          color: Colors.white.withOpacity(0.2),
          width: 1,
        ),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: List.generate(3, (i) {
          return Row(
            mainAxisSize: MainAxisSize.min,
            children: List.generate(3, (j) {
              return GestureDetector(
                onTap: () => _toggleColor(faceIndex, i, j),
                child: _buildSticker(face[i][j], stickerSize),
              );
            }),
          );
        }),
      ),
    );
  }

  Widget _buildSticker(FaceColor faceColor, double size) {
    Color displayColor;
    switch (faceColor) {
      case FaceColor.white:
        displayColor = Colors.white;
        break;
      case FaceColor.yellow:
        displayColor = const Color(0xFFFFEB3B);
        break;
      case FaceColor.red:
        displayColor = const Color(0xFFE53935);
        break;
      case FaceColor.orange:
        displayColor = const Color(0xFFFF6F00);
        break;
      case FaceColor.green:
        displayColor = const Color(0xFF4CAF50);
        break;
      case FaceColor.blue:
        displayColor = const Color(0xFF2196F3);
        break;
    }

    return Container(
      width: size,
      height: size,
      margin: const EdgeInsets.all(1),
      decoration: BoxDecoration(
        color: displayColor,
        border: Border.all(
          color: Colors.black.withOpacity(0.2),
          width: 0.5,
        ),
        borderRadius: BorderRadius.circular(2),
      ),
    );
  }

  Widget _buildButton(String text, VoidCallback onPressed, Color bgColor) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: bgColor,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      child: Text(text),
    );
  }
}


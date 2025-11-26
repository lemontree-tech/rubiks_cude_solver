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
  int? _focusedFaceIndex;
  int? _focusedRow;
  int? _focusedCol;

  @override
  void initState() {
    super.initState();
    _currentFaces = _deepCopyFaces(widget.initialCube.faces);
    // Auto-focus the first non-center sticker (top-left of first face)
    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {
        _focusedFaceIndex = 0; // Up face
        _focusedRow = 0;
        _focusedCol = 0; // Top-left sticker
      });
    });
  }

  List<List<List<FaceColor>>> _deepCopyFaces(List<List<List<FaceColor>>> original) {
    return original.map((face) =>
        face.map((row) => List<FaceColor>.from(row)).toList()
    ).toList();
  }

  void _onStickerTap(int faceIndex, int row, int col) {
    // Center stickers are unfocusable and unchangeable
    if (row == 1 && col == 1) {
      return;
    }
    
    setState(() {
      _focusedFaceIndex = faceIndex;
      _focusedRow = row;
      _focusedCol = col;
      _validationMessage = ''; // Clear message on focus change
    });
  }

  void _moveToNextSticker() {
    if (_focusedFaceIndex == null || _focusedRow == null || _focusedCol == null) {
      return;
    }
    
    int nextRow = _focusedRow!;
    int nextCol = _focusedCol! + 1;
    int nextFaceIndex = _focusedFaceIndex!;
    
    if (nextCol >= 3) {
      nextCol = 0;
      nextRow++;
      if (nextRow >= 3) {
        nextRow = 0;
        // Move to next face
        nextFaceIndex = _getNextFaceIndex(nextFaceIndex);
      }
    }
    
    // Skip center stickers
    while (nextRow == 1 && nextCol == 1) {
      nextCol++;
      if (nextCol >= 3) {
        nextCol = 0;
        nextRow++;
        if (nextRow >= 3) {
          nextRow = 0;
          nextFaceIndex = _getNextFaceIndex(nextFaceIndex);
        }
      }
    }
    
    setState(() {
      _focusedFaceIndex = nextFaceIndex;
      _focusedRow = nextRow;
      _focusedCol = nextCol;
    });
  }

  int _getNextFaceIndex(int currentFaceIndex) {
    // Face order: 0=Up, 1=Down, 2=Front, 3=Back, 4=Right, 5=Left
    // Navigate in order: Up -> Left -> Front -> Right -> Back -> Down -> Up
    final faceOrder = [0, 5, 2, 4, 3, 1]; // Top, Left, Front, Right, Back, Bottom
    final currentIndex = faceOrder.indexOf(currentFaceIndex);
    final nextIndex = (currentIndex + 1) % faceOrder.length;
    return faceOrder[nextIndex];
  }

  void _setColor(FaceColor color) {
    if (_focusedFaceIndex == null || _focusedRow == null || _focusedCol == null) {
      return;
    }
    
    // Center stickers are unchangeable
    if (_focusedRow == 1 && _focusedCol == 1) {
      return;
    }
    
    setState(() {
      _currentFaces[_focusedFaceIndex!][_focusedRow!][_focusedCol!] = color;
      _validationMessage = ''; // Clear message on color change
    });
    
    // Auto-focus next sticker after setting color
    _moveToNextSticker();
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
                  'Tap stickers to focus, select color to change',
                  style: TextStyle(fontSize: 14, color: Colors.white70),
                ),
                const SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: _buildCubeInputGrid(),
                ),
                const SizedBox(height: 20),
                // Color picker - show when a face is focused
                if (_focusedFaceIndex != null)
                  _buildColorPicker(),
                if (_focusedFaceIndex != null)
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
    final isFocused = _focusedFaceIndex == faceIndex;
    
    return Container(
      decoration: BoxDecoration(
        border: Border.all(
          color: isFocused 
              ? Colors.blue.withOpacity(0.8)
              : Colors.white.withOpacity(0.2),
          width: isFocused ? 2 : 1,
        ),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: List.generate(3, (i) {
          return Row(
            mainAxisSize: MainAxisSize.min,
            children: List.generate(3, (j) {
              final isStickerFocused = isFocused && _focusedRow == i && _focusedCol == j;
              final isCenter = i == 1 && j == 1;
              
              return GestureDetector(
                onTap: () => _onStickerTap(faceIndex, i, j),
                child: _buildSticker(face[i][j], stickerSize, isStickerFocused, isCenter),
              );
            }),
          );
        }),
      ),
    );
  }

  Widget _buildSticker(FaceColor faceColor, double size, bool isFocused, bool isCenter) {
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
          color: isFocused
              ? Colors.blue
              : isCenter
                  ? Colors.grey.withOpacity(0.5)
                  : Colors.black.withOpacity(0.2),
          width: isFocused ? 2 : (isCenter ? 1 : 0.5),
        ),
        borderRadius: BorderRadius.circular(2),
        boxShadow: isFocused
            ? [
                BoxShadow(
                  color: Colors.blue.withOpacity(0.5),
                  blurRadius: 4,
                  spreadRadius: 1,
                ),
              ]
            : null,
      ),
      child: isCenter
          ? Center(
              child: Icon(
                Icons.lock,
                size: size * 0.4,
                color: Colors.grey.withOpacity(0.7),
              ),
            )
          : null,
    );
  }

  Widget _buildColorPicker() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          const Text(
            'Select Color',
            style: TextStyle(
              fontSize: 14,
              color: Colors.white70,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: FaceColor.values.map((color) {
              return GestureDetector(
                onTap: () => _setColor(color),
                child: Container(
                  width: 40,
                  height: 40,
                  margin: const EdgeInsets.symmetric(horizontal: 6),
                  decoration: BoxDecoration(
                    color: _getColorForFaceColor(color),
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: Colors.white.withOpacity(0.3),
                      width: 2,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.3),
                        blurRadius: 4,
                        spreadRadius: 1,
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Color _getColorForFaceColor(FaceColor faceColor) {
    switch (faceColor) {
      case FaceColor.white:
        return Colors.white;
      case FaceColor.yellow:
        return const Color(0xFFFFEB3B);
      case FaceColor.red:
        return const Color(0xFFE53935);
      case FaceColor.orange:
        return const Color(0xFFFF6F00);
      case FaceColor.green:
        return const Color(0xFF4CAF50);
      case FaceColor.blue:
        return const Color(0xFF2196F3);
    }
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


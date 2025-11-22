import 'package:flutter/material.dart';
import '../models/cube.dart';

class CubeDisplay extends StatelessWidget {
  final RubiksCube cube;

  const CubeDisplay({super.key, required this.cube});

  @override
  Widget build(BuildContext context) {
    // Calculate responsive sticker size
    final screenWidth = MediaQuery.of(context).size.width;
    final padding = 40.0;
    final availableWidth = screenWidth - padding;
    final spacing = 24.0;
    final borderWidth = 4.0;
    final stickerMargins = 9.0;
    final buffer = 8.0;
    final maxFaceWidth = (availableWidth - spacing - (borderWidth * 4) - stickerMargins - buffer) / 4;
    final stickerSize = (maxFaceWidth / 3.3).clamp(18.0, 28.0);

    return Container(
      padding: const EdgeInsets.all(24),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final actualWidth = constraints.maxWidth;
          final maxFaceWidth = (actualWidth - spacing - (borderWidth * 4) - stickerMargins - buffer) / 4;
          final actualStickerSize = (maxFaceWidth / 3.3).clamp(18.0, 28.0);

          return Column(
            children: [
              // Top face
              _buildFaceRow([
                null,
                _buildFace(cube.faces[0], actualStickerSize),
                null,
              ]),
              const SizedBox(height: 8),
              // Middle row
              _buildFaceRow([
                _buildFace(cube.faces[5], actualStickerSize),
                _buildFace(cube.faces[2], actualStickerSize),
                _buildFace(cube.faces[4], actualStickerSize),
                _buildFace(cube.faces[3], actualStickerSize),
              ]),
              const SizedBox(height: 8),
              // Bottom face
              _buildFaceRow([
                null,
                _buildFace(cube.faces[1], actualStickerSize),
                null,
              ]),
            ],
          );
        },
      ),
    );
  }

  Widget _buildFaceRow(List<Widget?> faces) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: faces.map((face) {
        if (face == null) {
          return const SizedBox.shrink();
        }
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

  Widget _buildFace(List<List<FaceColor>> face, double stickerSize) {
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
              return _buildSticker(face[i][j], stickerSize);
            }),
          );
        }),
      ),
    );
  }

  Widget _buildSticker(FaceColor color, double size) {
    Color stickerColor;
    switch (color) {
      case FaceColor.white:
        stickerColor = Colors.white;
        break;
      case FaceColor.yellow:
        stickerColor = const Color(0xFFFFEB3B);
        break;
      case FaceColor.red:
        stickerColor = const Color(0xFFE53935);
        break;
      case FaceColor.orange:
        stickerColor = const Color(0xFFFF6F00);
        break;
      case FaceColor.green:
        stickerColor = const Color(0xFF4CAF50);
        break;
      case FaceColor.blue:
        stickerColor = const Color(0xFF2196F3);
        break;
    }

    return Container(
      width: size,
      height: size,
      margin: const EdgeInsets.all(1),
      decoration: BoxDecoration(
        color: stickerColor,
        border: Border.all(
          color: Colors.black.withOpacity(0.2),
          width: 0.5,
        ),
        borderRadius: BorderRadius.circular(2),
      ),
    );
  }
}

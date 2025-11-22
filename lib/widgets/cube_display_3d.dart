import 'package:flutter/material.dart';
import 'dart:math' as math;
import '../models/cube.dart';

class CubeDisplay3D extends StatefulWidget {
  final RubiksCube cube;

  const CubeDisplay3D({super.key, required this.cube});

  @override
  State<CubeDisplay3D> createState() => _CubeDisplay3DState();
}

class _CubeDisplay3DState extends State<CubeDisplay3D> {
  double _rotationX = -0.5;
  double _rotationY = 0.5;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final cubeSize = math.min(size.width, size.height) * 0.4;
    final stickerSize = cubeSize / 3;

    return GestureDetector(
      onPanUpdate: (details) {
        setState(() {
          _rotationY += details.delta.dx * 0.01;
          _rotationX -= details.delta.dy * 0.01;
          _rotationX = _rotationX.clamp(-math.pi / 2, math.pi / 2);
        });
      },
      child: Center(
        child: Transform(
          alignment: Alignment.center,
          transform: Matrix4.identity()
            ..setEntry(3, 2, 0.001) // Perspective
            ..rotateX(_rotationX)
            ..rotateY(_rotationY),
          child: SizedBox(
            width: cubeSize,
            height: cubeSize,
            child: Stack(
              children: [
                // Back face (furthest)
                _buildFace3D(
                  widget.cube.faces[3],
                  stickerSize,
                  Matrix4.identity()
                    ..translate(0.0, 0.0, -cubeSize / 2),
                ),
                // Left face
                _buildFace3D(
                  widget.cube.faces[5],
                  stickerSize,
                  Matrix4.identity()
                    ..rotateY(-math.pi / 2)
                    ..translate(-cubeSize / 2, 0.0, 0.0),
                ),
                // Right face
                _buildFace3D(
                  widget.cube.faces[4],
                  stickerSize,
                  Matrix4.identity()
                    ..rotateY(math.pi / 2)
                    ..translate(cubeSize / 2, 0.0, 0.0),
                ),
                // Bottom face
                _buildFace3D(
                  widget.cube.faces[1],
                  stickerSize,
                  Matrix4.identity()
                    ..rotateX(math.pi / 2)
                    ..translate(0.0, cubeSize / 2, 0.0),
                ),
                // Top face
                _buildFace3D(
                  widget.cube.faces[0],
                  stickerSize,
                  Matrix4.identity()
                    ..rotateX(-math.pi / 2)
                    ..translate(0.0, -cubeSize / 2, 0.0),
                ),
                // Front face (closest)
                _buildFace3D(
                  widget.cube.faces[2],
                  stickerSize,
                  Matrix4.identity()
                    ..translate(0.0, 0.0, cubeSize / 2),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFace3D(
    List<List<FaceColor>> face,
    double stickerSize,
    Matrix4 transform,
  ) {
    return Transform(
      alignment: Alignment.center,
      transform: transform,
      child: Container(
        width: stickerSize * 3,
        height: stickerSize * 3,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: List.generate(3, (i) {
            return Row(
              mainAxisSize: MainAxisSize.min,
              children: List.generate(3, (j) {
                return _buildSticker3D(face[i][j], stickerSize);
              }),
            );
          }),
        ),
      ),
    );
  }

  Widget _buildSticker3D(FaceColor color, double size) {
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
      margin: const EdgeInsets.all(0.5),
      decoration: BoxDecoration(
        color: stickerColor,
        border: Border.all(
          color: Colors.black.withOpacity(0.3),
          width: 0.5,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 2,
            offset: const Offset(1, 1),
          ),
        ],
      ),
    );
  }
}


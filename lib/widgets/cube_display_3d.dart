import 'package:flutter/material.dart';
import 'dart:math' as math;
import 'package:flutter_scene/scene.dart';
import 'package:vector_math/vector_math.dart' as vm;
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
  late Scene scene;

  @override
  void initState() {
    super.initState();
    scene = Scene();
    _buildRubiksCube();
  }

  void _buildRubiksCube() {
    scene.removeAll();
    
    const cubeSize = 2.0;
    const gap = 0.02;
    const stickerSize = (cubeSize - gap * 2) / 3;
    const halfSize = cubeSize / 2;
    const stickerDepth = 0.01;

    final faceConfigs = [
      {'pos': vm.Vector3(0, halfSize + stickerDepth/2, 0), 'rot': vm.Vector3(-math.pi / 2, 0, 0), 'idx': 0}, // Top
      {'pos': vm.Vector3(0, -halfSize - stickerDepth/2, 0), 'rot': vm.Vector3(math.pi / 2, 0, 0), 'idx': 1}, // Bottom
      {'pos': vm.Vector3(0, 0, halfSize + stickerDepth/2), 'rot': vm.Vector3(0, 0, 0), 'idx': 2}, // Front
      {'pos': vm.Vector3(0, 0, -halfSize - stickerDepth/2), 'rot': vm.Vector3(0, math.pi, 0), 'idx': 3}, // Back
      {'pos': vm.Vector3(halfSize + stickerDepth/2, 0, 0), 'rot': vm.Vector3(0, math.pi / 2, 0), 'idx': 4}, // Right
      {'pos': vm.Vector3(-halfSize - stickerDepth/2, 0, 0), 'rot': vm.Vector3(0, -math.pi / 2, 0), 'idx': 5}, // Left
    ];

    for (final config in faceConfigs) {
      final faceIndex = config['idx'] as int;
      final faceData = widget.cube.faces[faceIndex];
      final faceRot = config['rot'] as vm.Vector3;
      final facePos = config['pos'] as vm.Vector3;
      
      // Create rotation matrix for the face
      final faceRotation = vm.Matrix4.identity();
      faceRotation.rotateX(faceRot.x);
      faceRotation.rotateY(faceRot.y);
      faceRotation.rotateZ(faceRot.z);
      
      for (int i = 0; i < 3; i++) {
        for (int j = 0; j < 3; j++) {
          final color = _getColor(faceData[i][j]);
          final material = UnlitMaterial();
          // Use RGB values directly (0-1 range)
          material.baseColorFactor = vm.Vector4(
            color.red / 255.0,
            color.green / 255.0,
            color.blue / 255.0,
            1.0,
          );
          // Ensure vertex color weight is 0 to use only base color
          material.vertexColorWeight = 0.0;
          
          final geometry = CuboidGeometry(vm.Vector3(stickerSize, stickerSize, stickerDepth));
          final mesh = Mesh(geometry, material);
          
          // Calculate sticker position in face-local coordinates
          final offsetX = (stickerSize + gap) * (j - 1);
          final offsetY = (stickerSize + gap) * (1 - i);
          
          // Sticker offset in face-local space (before rotation)
          vm.Vector3 localOffset;
          if (faceIndex == 0 || faceIndex == 1) {
            // Top/Bottom: offset in XZ plane
            localOffset = vm.Vector3(offsetX, 0, offsetY);
          } else if (faceIndex == 2 || faceIndex == 3) {
            // Front/Back: offset in XY plane
            localOffset = vm.Vector3(offsetX, offsetY, 0);
          } else {
            // Right/Left: offset in YZ plane
            localOffset = vm.Vector3(0, offsetY, offsetX);
          }
          
          // Build transform: translate to face position, then apply rotation, then apply sticker offset
          // Order: T(facePos) * R(faceRot) * T(localOffset)
          final transform = vm.Matrix4.identity();
          
          // First, translate to face position
          transform.setTranslation(facePos);
          
          // Then apply face rotation
          final rotMatrix = vm.Matrix4.identity();
          rotMatrix.rotateX(faceRot.x);
          rotMatrix.rotateY(faceRot.y);
          rotMatrix.rotateZ(faceRot.z);
          transform.multiply(rotMatrix);
          
          // Finally, apply sticker offset in the rotated coordinate system
          final offsetMatrix = vm.Matrix4.translation(localOffset);
          transform.multiply(offsetMatrix);
          
          final node = Node(localTransform: transform, mesh: mesh);
          scene.add(node);
        }
      }
    }
  }

  Color _getColor(FaceColor color) {
    switch (color) {
      case FaceColor.white:
        return const Color(0xFFFFFFFF); // Pure white
      case FaceColor.yellow:
        return const Color(0xFFFFEB3B); // Bright yellow (matches 2D)
      case FaceColor.red:
        return const Color(0xFFE53935); // Red (matches 2D)
      case FaceColor.orange:
        return const Color(0xFFFF6F00); // Orange (matches 2D)
      case FaceColor.green:
        return const Color(0xFF4CAF50); // Green (matches 2D)
      case FaceColor.blue:
        return const Color(0xFF2196F3); // Blue (matches 2D)
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final cubeSize = math.min(size.width, size.height) * 0.5;

    return GestureDetector(
      onPanUpdate: (details) {
        setState(() {
          _rotationY += details.delta.dx * 0.01;
          _rotationX -= details.delta.dy * 0.01;
          _rotationX = _rotationX.clamp(-math.pi / 2, math.pi / 2);
        });
      },
      child: SizedBox(
        width: cubeSize,
        height: cubeSize,
        child: CustomPaint(
          painter: _ScenePainter(scene, _rotationX, _rotationY),
        ),
      ),
    );
  }

  @override
  void didUpdateWidget(CubeDisplay3D oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.cube != widget.cube) {
      _buildRubiksCube();
    }
  }
}

class _ScenePainter extends CustomPainter {
  _ScenePainter(this.scene, this.rotationX, this.rotationY);
  final Scene scene;
  final double rotationX;
  final double rotationY;

  @override
  void paint(Canvas canvas, Size size) {
    // Calculate camera position based on rotation
    final distance = 5.0;
    final cameraX = math.sin(rotationY) * math.cos(rotationX) * distance;
    final cameraY = -math.sin(rotationX) * distance;
    final cameraZ = math.cos(rotationY) * math.cos(rotationX) * distance;
    
    final camera = PerspectiveCamera(
      position: vm.Vector3(cameraX, cameraY, cameraZ),
      target: vm.Vector3(0, 0, 0),
    );

    scene.render(camera, canvas, viewport: Offset.zero & size);
  }

  @override
  bool shouldRepaint(covariant _ScenePainter oldDelegate) {
    return oldDelegate.rotationX != rotationX || oldDelegate.rotationY != rotationY;
  }
}

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
  Scene? _cachedScene;
  String? _cachedCubeDefinition;

  Scene get _currentScene {
    final currentDefinition = widget.cube.definition;
    if (_cachedScene == null || _cachedCubeDefinition != currentDefinition) {
      _cachedCubeDefinition = currentDefinition;
      _cachedScene = Scene();
      _buildRubiksCube(_cachedScene!);
    }
    return _cachedScene!;
  }

  @override
  void initState() {
    super.initState();
    _cachedCubeDefinition = widget.cube.definition;
    _cachedScene = Scene();
    _buildRubiksCube(_cachedScene!);
  }

  void _buildRubiksCube(Scene scene) {
    scene.removeAll();
    
    const cubeSize = 2.0;
    const gap = 0.01;
    const stickerSize = (cubeSize - gap * 2) / 3;
    const halfSize = cubeSize / 2;
    const stickerDepth = 0.02;

    // Face configurations: each face has a normal direction and position
    // The stickers are positioned in a plane perpendicular to the normal
    final faceConfigs = [
      // Top face (0) - white, at y = +halfSize, normal pointing up (+Y)
      {'normal': vm.Vector3(0, 1, 0), 'pos': vm.Vector3(0, halfSize + stickerDepth/2, 0), 'idx': 0},
      // Bottom face (1) - yellow, at y = -halfSize, normal pointing down (-Y)
      {'normal': vm.Vector3(0, -1, 0), 'pos': vm.Vector3(0, -halfSize - stickerDepth/2, 0), 'idx': 1},
      // Front face (2) - red, at z = +halfSize, normal pointing forward (+Z)
      {'normal': vm.Vector3(0, 0, 1), 'pos': vm.Vector3(0, 0, halfSize + stickerDepth/2), 'idx': 2},
      // Back face (3) - orange, at z = -halfSize, normal pointing backward (-Z)
      {'normal': vm.Vector3(0, 0, -1), 'pos': vm.Vector3(0, 0, -halfSize - stickerDepth/2), 'idx': 3},
      // Right face (4) - green, at x = +halfSize, normal pointing right (+X)
      {'normal': vm.Vector3(1, 0, 0), 'pos': vm.Vector3(halfSize + stickerDepth/2, 0, 0), 'idx': 4},
      // Left face (5) - blue, at x = -halfSize, normal pointing left (-X)
      {'normal': vm.Vector3(-1, 0, 0), 'pos': vm.Vector3(-halfSize - stickerDepth/2, 0, 0), 'idx': 5},
    ];

    for (final config in faceConfigs) {
      final faceIndex = config['idx'] as int;
      final faceData = widget.cube.faces[faceIndex];
      final faceNormal = config['normal'] as vm.Vector3;
      final faceCenter = config['pos'] as vm.Vector3;
      
      // Build rotation matrix to align face normal with +Z (for sticker positioning)
      // Then we'll translate to face center
      final rotation = _rotationToAlignNormal(faceNormal);
      
      for (int row = 0; row < 3; row++) {
        for (int col = 0; col < 3; col++) {
          final color = _getColor(faceData[row][col]);
          final material = UnlitMaterial();
          material.baseColorFactor = vm.Vector4(
            color.red / 255.0,
            color.green / 255.0,
            color.blue / 255.0,
            1.0,
          );
          material.vertexColorWeight = 0.0;
          
          // Sticker geometry: width x height x depth
          // Default orientation: extends along +X, +Y, +Z from center
          final geometry = CuboidGeometry(vm.Vector3(stickerSize, stickerSize, stickerDepth));
          final mesh = Mesh(geometry, material);
          
          // Calculate sticker position in face-local coordinates
          // Row 0 is top, row 2 is bottom; Col 0 is left, col 2 is right
          final offsetX = (stickerSize + gap) * (col - 1);
          final offsetY = (stickerSize + gap) * (1 - row); // Invert Y so row 0 is top
          
          // Position sticker in XY plane (Z will be the depth/offset from face)
          // After rotation, this will align with the face normal
          final stickerLocalPos = vm.Vector3(offsetX, offsetY, stickerDepth / 2);
          
          // Build transform: rotate to align with face, then translate to face center
          // Order: T(faceCenter) * R(rotation) * T(stickerLocalPos)
          final stickerOffset = vm.Matrix4.translation(stickerLocalPos);
          final rotated = rotation * stickerOffset;
          final transform = vm.Matrix4.translation(faceCenter) * rotated;
          
          final node = Node(localTransform: transform, mesh: mesh);
          scene.add(node);
        }
      }
    }
  }

  // Build rotation matrix to align +Z axis with the given normal
  vm.Matrix4 _rotationToAlignNormal(vm.Vector3 normal) {
    // Default normal is +Z (0, 0, 1)
    if (normal.x == 0 && normal.y == 0 && normal.z == 1) {
      // Front face - no rotation needed
      return vm.Matrix4.identity();
    } else if (normal.x == 0 && normal.y == 0 && normal.z == -1) {
      // Back face - rotate 180 degrees around Y
      return vm.Matrix4.rotationY(math.pi);
    } else if (normal.x == 0 && normal.y == 1 && normal.z == 0) {
      // Top face - rotate -90 degrees around X
      return vm.Matrix4.rotationX(-math.pi / 2);
    } else if (normal.x == 0 && normal.y == -1 && normal.z == 0) {
      // Bottom face - rotate 90 degrees around X
      return vm.Matrix4.rotationX(math.pi / 2);
    } else if (normal.x == 1 && normal.y == 0 && normal.z == 0) {
      // Right face - rotate 90 degrees around Y
      return vm.Matrix4.rotationY(math.pi / 2);
    } else if (normal.x == -1 && normal.y == 0 && normal.z == 0) {
      // Left face - rotate -90 degrees around Y
      return vm.Matrix4.rotationY(-math.pi / 2);
    }
    return vm.Matrix4.identity();
  }

  Color _getColor(FaceColor color) {
    switch (color) {
      case FaceColor.white:
        return const Color(0xFFFFFFFF);
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

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final cubeSize = math.min(size.width, size.height) * 0.5;
    
    // Get current scene (will rebuild if cube changed)
    final scene = _currentScene;

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
          key: ValueKey(widget.cube.definition),
          painter: _ScenePainter(scene, _rotationX, _rotationY, widget.cube.definition),
        ),
      ),
    );
  }

  @override
  void didUpdateWidget(CubeDisplay3D oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Invalidate cache if cube changed, so getter will rebuild
    if (oldWidget.cube.definition != widget.cube.definition) {
      _cachedScene = null;
    }
  }
}

class _ScenePainter extends CustomPainter {
  _ScenePainter(this.scene, this.rotationX, this.rotationY, this.cubeDefinition);
  final Scene scene;
  final double rotationX;
  final double rotationY;
  final String cubeDefinition; // Track cube state for repaint detection

  @override
  void paint(Canvas canvas, Size size) {
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
    // Repaint if rotation OR cube state changes
    return oldDelegate.rotationX != rotationX || 
           oldDelegate.rotationY != rotationY ||
           oldDelegate.cubeDefinition != cubeDefinition;
  }
}

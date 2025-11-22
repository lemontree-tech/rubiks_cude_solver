import 'package:flutter/material.dart';

class GameControls extends StatelessWidget {
  final VoidCallback onScramble;
  final VoidCallback onSolve;
  final VoidCallback? onApplySolution;
  final VoidCallback onReset;
  final Function(String) onMove;
  final bool isSolving;

  const GameControls({
    super.key,
    required this.onScramble,
    required this.onSolve,
    this.onApplySolution,
    required this.onReset,
    required this.onMove,
    required this.isSolving,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Main buttons
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            children: [
              Expanded(
                child: _buildButton(
                  icon: Icons.shuffle,
                  label: 'Scramble',
                  onPressed: isSolving ? null : onScramble,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildButton(
                  icon: Icons.auto_fix_high,
                  label: 'Solve',
                  onPressed: isSolving ? null : onSolve,
                  isLoading: isSolving,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: onApplySolution != null
                    ? _buildButton(
                        icon: Icons.play_arrow,
                        label: 'Apply',
                        onPressed: onApplySolution,
                      )
                    : _buildButton(
                        icon: Icons.refresh,
                        label: 'Reset',
                        onPressed: onReset,
                      ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 20),

        // Manual controls
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Manual',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.white54,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 12),
              _buildManualControls(),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildButton({
    required IconData icon,
    required String label,
    required VoidCallback? onPressed,
    bool isLoading = false,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(8),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 16),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(onPressed == null ? 0.05 : 0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              isLoading
                  ? SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(
                          Colors.white70,
                        ),
                      ),
                    )
                  : Icon(
                      icon,
                      color: Colors.white70,
                      size: 24,
                    ),
              const SizedBox(height: 8),
              Text(
                label,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.white70,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildManualControls() {
    final controls = [
      ['U', 'U\'', 'D', 'D\''],
      ['F', 'F\'', 'B', 'B\''],
      ['R', 'R\'', 'L', 'L\''],
    ];

    return Column(
      children: controls.map((row) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 8),
          child: Row(
            children: row.map((move) {
              return Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  child: _buildMoveButton(move),
                ),
              );
            }).toList(),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildMoveButton(String move) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () => onMove(move),
        borderRadius: BorderRadius.circular(6),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.05),
            borderRadius: BorderRadius.circular(6),
          ),
          child: Center(
            child: Text(
              move,
              style: const TextStyle(
                fontSize: 14,
                color: Colors.white,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

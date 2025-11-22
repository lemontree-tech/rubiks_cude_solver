import 'package:flutter/material.dart';

class SolutionPanel extends StatelessWidget {
  final List<String> solution;
  final int appliedMovesCount;
  final bool isAutoApplying;
  final VoidCallback? onUndo;
  final VoidCallback? onApplyNext;
  final VoidCallback onAutoApply;

  const SolutionPanel({
    super.key,
    required this.solution,
    required this.appliedMovesCount,
    required this.isAutoApplying,
    this.onUndo,
    this.onApplyNext,
    required this.onAutoApply,
  });

  @override
  Widget build(BuildContext context) {
    if (solution.isEmpty) {
      return const SizedBox.shrink();
    }

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Solution',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.white54,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Text(
                '$appliedMovesCount / ${solution.length}',
                style: const TextStyle(
                  fontSize: 12,
                  color: Colors.white54,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 6,
            runSpacing: 6,
            children: solution.asMap().entries.map((entry) {
              final index = entry.key;
              final move = entry.value;
              final isApplied = index < appliedMovesCount;
              return Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: isApplied
                      ? const Color(0xFF06D6A0).withOpacity(0.3)
                      : Colors.white.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  move,
                  style: TextStyle(
                    fontSize: 12,
                    color: isApplied ? Colors.white : Colors.white70,
                    fontWeight: isApplied ? FontWeight.w600 : FontWeight.normal,
                  ),
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _buildStepButton(
                  '◀ Undo',
                  Icons.undo,
                  onUndo,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _buildStepButton(
                  'Apply ▶',
                  Icons.redo,
                  onApplyNext,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _buildStepButton(
                  isAutoApplying ? '⏸ Stop' : '▶ Auto',
                  isAutoApplying ? Icons.pause : Icons.play_arrow,
                  onAutoApply,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStepButton(String label, IconData icon, VoidCallback? onPressed) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(6),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: onPressed != null
                ? Colors.white.withOpacity(0.1)
                : Colors.white.withOpacity(0.05),
            borderRadius: BorderRadius.circular(6),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: 16,
                color: onPressed != null ? Colors.white70 : Colors.white30,
              ),
              const SizedBox(width: 6),
              Text(
                label,
                style: TextStyle(
                  fontSize: 12,
                  color: onPressed != null ? Colors.white70 : Colors.white30,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}


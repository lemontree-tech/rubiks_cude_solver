import 'package:flutter/material.dart';
import 'package:rubiks_cube_solver/l10n/app_localizations.dart';

class GameControls extends StatelessWidget {
  final VoidCallback onScramble;
  final VoidCallback onSolve;
  final VoidCallback? onCloseSolution;
  final VoidCallback onReset;
  final Function(String) onMove;
  final bool isSolving;
  final bool showManualControls;
  final VoidCallback onToggleManualControls;
  final VoidCallback? onEdit;

  const GameControls({
    super.key,
    required this.onScramble,
    required this.onSolve,
    this.onCloseSolution,
    required this.onReset,
    required this.onMove,
    required this.isSolving,
    required this.showManualControls,
    required this.onToggleManualControls,
    this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
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
                  label: l10n.scramble,
                  onPressed: isSolving ? null : onScramble,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildButton(
                  icon: Icons.auto_fix_high,
                  label: l10n.solve,
                  onPressed: isSolving ? null : onSolve,
                  isLoading: isSolving,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: onCloseSolution != null
                    ? _buildButton(
                        icon: Icons.close,
                        label: l10n.close,
                        onPressed: onCloseSolution,
                      )
                    : _buildButton(
                        icon: Icons.refresh,
                        label: l10n.reset,
                        onPressed: onReset,
                      ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 12),

        // Manual controls toggle with edit button
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            children: [
              Expanded(
                child: InkWell(
                  onTap: onToggleManualControls,
                  borderRadius: BorderRadius.circular(8),
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.05),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          l10n.manualControls,
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.white70,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(width: 8),
                        AnimatedRotation(
                          turns: showManualControls ? 0.5 : 0,
                          duration: const Duration(milliseconds: 200),
                          child: Icon(
                            Icons.keyboard_arrow_down,
                            color: Colors.white70,
                            size: 20,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              if (onEdit != null) ...[
                const SizedBox(width: 12),
                Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: onEdit,
                    borderRadius: BorderRadius.circular(22),
                    child: Container(
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.1),
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: Colors.white.withOpacity(0.2),
                          width: 1,
                        ),
                      ),
                      child: const Icon(
                        Icons.edit,
                        size: 20,
                        color: Colors.white70,
                      ),
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),

        // Manual controls (collapsible with animation)
        AnimatedSize(
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeInOut,
          child: showManualControls
              ? Padding(
                  padding: const EdgeInsets.only(top: 12, left: 20, right: 20),
                  child: _buildManualControls(),
                )
              : const SizedBox.shrink(),
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

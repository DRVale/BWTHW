import 'package:flutter/material.dart';

class XPProgressBar extends StatelessWidget {
  final double currentXP;
  final int maxXP;
  final List<Checkpoint> checkpoints;

  const XPProgressBar({
    super.key,
    required this.currentXP,
    required this.maxXP,
    required this.checkpoints,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final progress = currentXP / maxXP;
        final barWidth = constraints.maxWidth;

        return Stack(
          children: [
            // Background bar
            Container(
              height: 20,
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            // Progress fill
            Container(
              height: 20,
              width: barWidth * progress.clamp(0.0, 1.0),
              decoration: BoxDecoration(
                color: Colors.green,
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            // Checkpoint icons
            ...checkpoints.map((cp) {
              final left = (cp.xpRequired / maxXP) * barWidth;
              final isReached = currentXP >= cp.xpRequired;

              return Positioned(
                left: left - 12, // center icon
                top: -25,
                child: Column(
                  children: [
                    Icon(cp.icon, size: 24, color: isReached ? Colors.amber : Colors.grey),
                    Text(cp.label, style: TextStyle(fontSize: 10)),
                  ],
                ),
              );
            }).toList(),
          ],
        );
      },
    );
  }
}


class Checkpoint {
  final int xpRequired;
  final IconData icon;
  final String label;

  Checkpoint({required this.xpRequired, required this.icon, required this.label});
}
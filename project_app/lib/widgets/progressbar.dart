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
        double progressWidth = barWidth * progress.clamp(0.0, 1.0);

        return SizedBox(
          height: 100,
          child: Stack(
            clipBehavior: Clip.none,
            children: [

              // Checkpoint icons
              ...checkpoints.map((cp) {
                final left = ((cp.xpRequired -50)/ maxXP) * barWidth - 10;
                final isReached = currentXP >= cp.xpRequired;
          
                return Positioned(
                  left: left, // center icon
                  top: 0,
                  child: Column(
                    children: [
                      Icon(cp.icon, size: 24, color: isReached ? Colors.amber : Colors.grey),
                      Text(cp.label, style: TextStyle(fontSize: 10)),
                    ],
                  ),
                );
              }).toList(),

              // Background bar
              Positioned(
                top: 40,
                child: Container(
                  height: 20,
                  width: barWidth,
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(255, 231, 231, 231),
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),

              // Progress fill
              Positioned(
                top: 40,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Container(
                    height: 20,
                    width: progressWidth,
                    decoration: BoxDecoration(
                      color: Colors.green,
                      gradient: LinearGradient(
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                        colors: [
                          Colors.yellow,
                          Colors.orange,
                          Colors.red
                          ],
                      ),
                    ),
                    
                )),
              ),

              if (progressWidth > 30) // evita che si tagli o sovrapponga a sinistra
                Positioned(
                  left: progressWidth - 12, // centro l’icona in punta
                  top: 35, // leggermente sopra la barra
                  child: const Icon(Icons.rocket_launch, size: 24, color: Color.fromARGB(255, 0, 0, 0)),
                ),
            ],
          ),
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
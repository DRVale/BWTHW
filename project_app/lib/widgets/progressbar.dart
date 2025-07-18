import 'package:flutter/material.dart';
import 'dart:math';

class XPProgressBar extends StatelessWidget {
  final int currentXP;
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
    final progress = currentXP / maxXP;
    final angle = pi * progress.clamp(0.0, 1.0);
    
    return LayoutBuilder(
      builder: (context,constraints) {
        final width = constraints.maxWidth; 
        return SizedBox(
          height: width * 0.7, 
          width: width,
          child: Stack(
            alignment: Alignment.center,
            children: [
              // Background arc
              Positioned(
                bottom: -100,
                  child: CustomPaint(
                  size: const Size(300, 300),
                  painter: ArcPainter(
                    sweepAngle: pi,
                    radius: width/3,
                    color: const Color.fromARGB(255, 231, 231, 231),
                  ),
                )
              ),
        
              // Progress arc
              Positioned(
                bottom: -100,
                child: CustomPaint(
                  size: const Size(300, 300),
                  painter: ArcPainter(
                    sweepAngle: angle,
                    radius: width/3,
                    gradient: const LinearGradient(
                      colors: [Color.fromARGB(255, 235, 255, 59), Color.fromARGB(255, 146, 236, 44), Color.fromARGB(255, 31, 206, 19)],
                    ),
                  ),
                )
              ),
        
              Positioned(
                bottom: 20,
                child: Transform.rotate(
                  angle: angle - pi / 2,
                  child: Transform.translate(
                    offset: const Offset(0, -50),
                    child: Container(
                      width: 4,
                      height: width/4,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade400,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  )
                ),
              ),
        
              // Central XP label
              Positioned(
                bottom: 5,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      '${currentXP.toInt()} XP',
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.black54,
                      ),
                    ),
                    Text(
                      'out of $maxXP',
                      style: const TextStyle(fontSize: 16, color: Colors.black54),
                    ),
                  ],
                ),
              ),
        
              // Checkpoints
              ...checkpoints.map((cp) {
                final cpAngle = pi * (cp.xpRequired / maxXP).clamp(0.0, 0.95);
                final radius = width/3 + 40;
                final dx = radius * cos(cpAngle - pi);
                final dy = radius * sin(cpAngle - pi) + 75;
                final isReached = currentXP >= cp.xpRequired;
        
                return Transform.translate(
                  offset: Offset(dx, dy),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(cp.label, style: const TextStyle(fontSize: 10, color: Colors.black54)),
                      Icon(cp.icon, size: width/10, color: isReached ? Colors.amber : Colors.grey),
                    ],
                  ),
                );
              }).toList(),
              
            ],
          ),
        );
      }
    );
  }
}

class ArcPainter extends CustomPainter {
  final double sweepAngle;
  final Color? color;
  final Gradient? gradient;
  final double radius;
  

  ArcPainter({required this.sweepAngle, required this.radius,this.color, this.gradient});

  @override
  void paint(Canvas canvas, Size size) {
    
    final rect = Rect.fromCircle(center: size.center(Offset.zero), radius: radius);
    final startAngle = pi;
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 25
      ..strokeCap = StrokeCap.round;

    if (gradient != null) {
      paint.shader = gradient!.createShader(rect);
    } else {
      paint.color = color ?? Colors.grey;
    }

    canvas.drawArc(rect, startAngle, sweepAngle, false, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}


class Checkpoint {
  final int xpRequired;
  final IconData icon;
  final String label;

  Checkpoint({required this.xpRequired, required this.icon, required this.label});
}
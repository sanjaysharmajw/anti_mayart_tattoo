import 'package:flutter/material.dart';
import 'dart:math' as math;
import '../theme.dart';

class SmokeParticles extends StatefulWidget {
  final int count;
  final Color color;
  const SmokeParticles({super.key, this.count = 50, this.color = Colors.white});

  @override
  State<SmokeParticles> createState() => _SmokeParticlesState();
}

class _SmokeParticlesState extends State<SmokeParticles> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late List<_Particle> particles;
  final math.Random random = math.Random();

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: const Duration(seconds: 15))..repeat();
    particles = List.generate(widget.count, (index) => _generateParticle());
    _controller.addListener(() {
      for (var p in particles) {
        p.update();
        if (p.isDead) {
          p.reset(random);
        }
      }
    });
  }

  _Particle _generateParticle() {
    return _Particle(
      x: random.nextDouble(),
      y: random.nextDouble(),
      size: random.nextDouble() * 60 + 20,
      opacity: random.nextDouble() * 0.15 + 0.05,
      speed: random.nextDouble() * 0.001 + 0.0005,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return CustomPaint(
          painter: _SmokePainter(particles: particles, color: widget.color),
          size: Size.infinite,
        );
      },
    );
  }
}

class _Particle {
  double x, y;
  double size;
  double opacity;
  double speed;

  _Particle({required this.x, required this.y, required this.size, required this.opacity, required this.speed});

  void update() {
    y -= speed;
    x += (math.Random().nextDouble() - 0.5) * 0.002; // slight horizontal drift
  }

  bool get isDead => y < -0.1;

  void reset(math.Random random) {
    y = 1.1; // reset slightly below bottom
    x = random.nextDouble();
    opacity = random.nextDouble() * 0.15 + 0.05;
  }
}

class _SmokePainter extends CustomPainter {
  final List<_Particle> particles;
  final Color color;

  _SmokePainter({required this.particles, required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    for (var p in particles) {
      final paint = Paint()
        ..color = color.withOpacity(p.opacity)
        ..maskFilter = MaskFilter.blur(BlurStyle.normal, p.size * 0.8);
      canvas.drawCircle(Offset(p.x * size.width, p.y * size.height), p.size, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

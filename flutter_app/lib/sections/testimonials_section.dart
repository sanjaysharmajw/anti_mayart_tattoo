import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme.dart';
import '../widgets/smoke_particles.dart';
import 'dart:math' as math;

class TestimonialsSection extends StatelessWidget {
  const TestimonialsSection({super.key});

  @override
  Widget build(BuildContext context) {
    bool isMobile = MediaQuery.of(context).size.width < 768;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: isMobile ? 20 : 50, vertical: isMobile ? 100 : 150),
      color: AppTheme.bgDark,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Subtle texture pattern via CustomPaint or Opacity
          Positioned.fill(
            child: Opacity(
              opacity: 0.05,
              child: CustomPaint(
                painter: _PatternPainter(),
              ),
            ),
          ),
          
          // Added Smoke Particles here
          const Positioned.fill(
            child: SmokeParticles(count: 40, color: AppTheme.accentColor),
          ),

          // Main Content
          Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'READY TO INK YOUR STORY?',
                textAlign: TextAlign.center,
                style: GoogleFonts.outfit(
                  fontSize: isMobile ? 36 : 64,
                  fontWeight: FontWeight.w900,
                  color: Colors.white,
                  letterSpacing: isMobile ? 2 : 4,
                  shadows: [
                    BoxShadow(
                      color: AppTheme.accentColor.withOpacity(0.3),
                      blurRadius: 40,
                    )
                  ]
                ),
              ),
              const SizedBox(height: 20),
              Text(
                'Transform your ideas into a lifelong masterpiece.',
                style: GoogleFonts.inter(
                  fontSize: 20,
                  color: AppTheme.textSecondary,
                  fontWeight: FontWeight.w300,
                  letterSpacing: 1.5,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 60),
              
              _ContactForm(),
            ],
          ),
        ],
      ),
    );
  }
}

class _PatternPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white
      ..strokeWidth = 1
      ..style = PaintingStyle.fill;
    
    // Draw a subtle dot grid texture
    for (double i = 0; i < size.width; i += 30) {
      for (double j = 0; j < size.height; j += 30) {
        if (math.Random().nextDouble() > 0.6) {
           canvas.drawCircle(Offset(i, j), 1.5, paint);
        }
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _ContactForm extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    bool isMobile = MediaQuery.of(context).size.width < 768;
    
    return Container(
      width: isMobile ? double.infinity : 600,
      padding: const EdgeInsets.all(30),
      decoration: BoxDecoration(
        color: AppTheme.bgDark.withOpacity(0.8),
        borderRadius: BorderRadius.circular(2),
        border: Border.all(color: AppTheme.accentColor.withOpacity(0.3), width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.5),
            blurRadius: 20,
          )
        ],
      ),
      child: Column(
        children: [
          _buildTextField('FULL NAME', Icons.person_outline),
          const SizedBox(height: 20),
          _buildTextField('EMAIL ADDRESS', Icons.email_outlined),
          const SizedBox(height: 20),
          _buildTextField('PHONE NUMBER', Icons.phone_outlined),
          const SizedBox(height: 20),
          _buildTextField('YOUR MESSAGE / TATTOO IDEA', Icons.message_outlined, maxLines: 4),
          const SizedBox(height: 30),
          _SubmitButton(),
        ],
      ),
    );
  }

  Widget _buildTextField(String hint, IconData icon, {int maxLines = 1}) {
    return TextFormField(
      maxLines: maxLines,
      style: GoogleFonts.inter(color: Colors.white),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: GoogleFonts.inter(color: AppTheme.textSecondary, fontSize: 14),
        prefixIcon: maxLines == 1 ? Icon(icon, color: AppTheme.accentColor, size: 20) : null,
        filled: true,
        fillColor: Colors.white.withOpacity(0.05),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(2),
          borderSide: BorderSide(color: Colors.white.withOpacity(0.1)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(2),
          borderSide: const BorderSide(color: AppTheme.accentColor),
        ),
      ),
    );
  }
}

class _SubmitButton extends StatefulWidget {
  @override
  State<_SubmitButton> createState() => _SubmitButtonState();
}

class _SubmitButtonState extends State<_SubmitButton> {
  bool _isHovering = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovering = true),
      onExit: (_) => setState(() => _isHovering = false),
      cursor: SystemMouseCursors.click,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 18),
        decoration: BoxDecoration(
          color: _isHovering ? Colors.transparent : AppTheme.accentColor,
          borderRadius: BorderRadius.circular(2),
          border: Border.all(color: AppTheme.accentColor, width: 2),
          boxShadow: _isHovering
              ? [
                  BoxShadow(
                    color: AppTheme.accentColor.withOpacity(0.4),
                    blurRadius: 20,
                    spreadRadius: 2,
                  )
                ]
              : [],
        ),
        child: Center(
          child: Text(
            'SEND MESSAGE',
            style: GoogleFonts.outfit(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.bold,
              letterSpacing: 2,
            ),
          ),
        ),
      ),
    );
  }
}

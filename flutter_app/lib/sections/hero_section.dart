import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme.dart';
import '../widgets/smoke_particles.dart';
import 'dart:math' as math;

class HeroSection extends StatefulWidget {
  final VoidCallback? onContactTap;

  const HeroSection({super.key, this.onContactTap});

  @override
  State<HeroSection> createState() => _HeroSectionState();
}

class _HeroSectionState extends State<HeroSection> with SingleTickerProviderStateMixin {
  late AnimationController _smokeCtrl;
  Offset _mousePos = Offset.zero;

  @override
  void initState() {
    super.initState();
    _smokeCtrl = AnimationController(
       vsync: this, 
       duration: const Duration(seconds: 15)
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _smokeCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    bool isMobile = size.width < 768;
    
    return SizedBox(
      height: size.height,
      width: size.width,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Background Image
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/tattoo_hero_bg_1772521342551.png'),
                fit: BoxFit.cover,
              ),
            ),
          ),
            
            // Smoke Particles Overlay
            const Positioned.fill(
              child: SmokeParticles(count: 60, color: AppTheme.accentColor),
            ),
          
          // 70% opacity black gradient overlay
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.black.withOpacity(0.5),
                  Colors.black.withOpacity(0.7),
                  AppTheme.bgDeep,
                ],
              ),
            ),
          ),
          
          // Content
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 100),
              
              Padding(
                padding: EdgeInsets.symmetric(horizontal: isMobile ? 30 : 100),
                child: Text(
                  'YOUR TATTOO JOURNEY INTO AN\nUNFORGETTABLE EXPERIENCE',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.outfit(
                    fontSize: isMobile ? 36 : 64,
                    fontWeight: FontWeight.w900,
                    color: Colors.white,
                    height: 1.1,
                    letterSpacing: -1,
                    shadows: [
                      const Shadow(
                        color: Colors.black54,
                        blurRadius: 20,
                        offset: Offset(0, 5),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),
              
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 40),
                child: Text(
                  'Transforming art into skin with comfort and precision.',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.inter(
                    fontSize: isMobile ? 18 : 24,
                    color: AppTheme.textSecondary,
                    fontWeight: FontWeight.w300,
                  ),
                ),
              ),
              const SizedBox(height: 40),
              
              Text(
                'MON - SAT  |  10:00 - 20:00',
                style: GoogleFonts.inter(
                  fontSize: 14,
                  letterSpacing: 3,
                  color: AppTheme.accentColor.withOpacity(0.8),
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 40),
              _CtaButton(onTap: widget.onContactTap),
            ],
          ),
        ],
      ),
    );
  }
}

class _SocialIcon extends StatefulWidget {
  final IconData icon;
  const _SocialIcon({required this.icon});

  @override
  State<_SocialIcon> createState() => _SocialIconState();
}

class _SocialIconState extends State<_SocialIcon> {
  bool _isHovering = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovering = true),
      onExit: (_) => setState(() => _isHovering = false),
      cursor: SystemMouseCursors.click,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: _isHovering ? AppTheme.accentColor.withOpacity(0.2) : Colors.transparent,
          border: Border.all(
            color: _isHovering ? AppTheme.accentColor : Colors.white24,
          ),
          boxShadow: _isHovering
              ? [BoxShadow(color: AppTheme.accentColor.withOpacity(0.4), blurRadius: 15)]
              : [],
        ),
        child: Icon(
          widget.icon,
          color: _isHovering ? AppTheme.accentColor : Colors.white,
          size: 20,
        ),
      ),
    );
  }
}

class _CtaButton extends StatefulWidget {
  final VoidCallback? onTap;

  const _CtaButton({this.onTap});

  @override
  State<_CtaButton> createState() => _CtaButtonState();
}

class _CtaButtonState extends State<_CtaButton> {
  bool _isHovering = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovering = true),
      onExit: (_) => setState(() => _isHovering = false),
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          decoration: BoxDecoration(
            color: AppTheme.accentColor,
            borderRadius: BorderRadius.circular(2),
          ),
          transform: _isHovering ? (Matrix4.identity()..translate(0.0, -3.0)) : Matrix4.identity(),
          child: Text(
            'CONTACT US',
            style: GoogleFonts.outfit(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
              letterSpacing: 2,
            ),
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme.dart';

class FooterSection extends StatelessWidget {
  const FooterSection({super.key});

  @override
  Widget build(BuildContext context) {
    bool isMobile = MediaQuery.of(context).size.width < 768;
    return Container(
      color: AppTheme.bgDeep,
      padding: EdgeInsets.only(top: isMobile ? 60 : 80, bottom: 40),
      child: Column(
        children: [
          RichText(
            text: TextSpan(
              style: GoogleFonts.outfit(
                fontSize: 32,
                fontWeight: FontWeight.w900,
                letterSpacing: 4,
                color: Colors.white,
              ),
              children: const [
                TextSpan(text: 'MAYART'),
                TextSpan(
                  text: '/INK',
                  style: TextStyle(color: AppTheme.accentColor),
                ),
              ],
            ),
          ),
          const SizedBox(height: 30),
          
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _FooterIcon(icon: Icons.camera_alt),
              const SizedBox(width: 20),
              _FooterIcon(icon: Icons.facebook),
              const SizedBox(width: 20),
              _FooterIcon(icon: Icons.chat),
            ],
          ),
          const SizedBox(height: 40),
          
          // Thin glowing divider line
          Container(
            height: 1,
            width: double.infinity,
            margin: EdgeInsets.symmetric(horizontal: isMobile ? 20 : 100),
            decoration: BoxDecoration(
              color: AppTheme.accentColor.withOpacity(0.3),
              boxShadow: [
                BoxShadow(
                  color: AppTheme.accentColor.withOpacity(0.5),
                  blurRadius: 10,
                )
              ],
            ),
          ),
          const SizedBox(height: 40),
          
          Text(
            '© 2026 Mayart Ink. All rights reserved.',
            style: GoogleFonts.inter(
              fontSize: 14,
              color: AppTheme.textSecondary,
              letterSpacing: 1,
            ),
          ),
        ],
      ),
    );
  }
}

class _FooterIcon extends StatefulWidget {
  final IconData icon;
  const _FooterIcon({required this.icon});

  @override
  State<_FooterIcon> createState() => _FooterIconState();
}

class _FooterIconState extends State<_FooterIcon> {
  bool _isHovering = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovering = true),
      onExit: (_) => setState(() => _isHovering = false),
      cursor: SystemMouseCursors.click,
      child: AnimatedOpacity(
        opacity: _isHovering ? 1.0 : 0.6,
        duration: const Duration(milliseconds: 300),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: _isHovering ? AppTheme.bgDark : Colors.transparent,
            border: Border.all(
              color: _isHovering ? AppTheme.accentColor : Colors.white24,
            ),
            boxShadow: _isHovering
                ? [BoxShadow(color: AppTheme.accentColor.withOpacity(0.2), blurRadius: 10)]
                : [],
          ),
          transform: _isHovering ? (Matrix4.identity()..translate(0.0, -3.0)) : Matrix4.identity(),
          child: Icon(
            widget.icon,
            color: Colors.white,
            size: 20,
          ),
        ),
      ),
    );
  }
}

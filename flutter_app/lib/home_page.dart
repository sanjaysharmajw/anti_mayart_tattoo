import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'theme.dart';
import 'sections/hero_section.dart';
import 'sections/portfolio_section.dart';
import 'sections/artist_section.dart';
import 'sections/services_section.dart';
import 'sections/testimonials_section.dart';
import 'sections/footer_section.dart';
import 'dart:math' as math; // Add math

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final ScrollController _scrollController = ScrollController();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final GlobalKey _contactKey = GlobalKey();
  bool _isScrolled = false;

  void _scrollToContact() {
    if (_contactKey.currentContext != null) {
      Scrollable.ensureVisible(
        _contactKey.currentContext!, 
        duration: const Duration(milliseconds: 800), 
        curve: Curves.easeInOut
      );
    }
  }

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(() {
      if (_scrollController.offset > 50 && !_isScrolled) {
        setState(() => _isScrolled = true);
      } else if (_scrollController.offset <= 50 && _isScrolled) {
        setState(() => _isScrolled = false);
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      extendBodyBehindAppBar: true,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(80),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          color: _isScrolled ? AppTheme.bgDark.withOpacity(0.9) : Colors.transparent,
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  RichText(
                    text: TextSpan(
                      style: GoogleFonts.outfit(
                        fontSize: 24,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 2,
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
                  if (MediaQuery.of(context).size.width > 768)
                    Row(
                      children: [
                        _NavBarItem(title: 'Portfolio'),
                        const SizedBox(width: 24),
                        _NavBarItem(title: 'Artist'),
                        const SizedBox(width: 24),
                        _NavBarItem(title: 'Services'),
                        const SizedBox(width: 24),
                        _NavBarItem(title: 'Reviews'),
                        const SizedBox(width: 24),
                        OutlinedButton(
                          onPressed: () {},
                          style: OutlinedButton.styleFrom(
                            side: const BorderSide(color: AppTheme.accentColor),
                            foregroundColor: AppTheme.accentColor,
                            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                            textStyle: GoogleFonts.outfit(
                              fontWeight: FontWeight.bold,
                              letterSpacing: 1,
                            ),
                          ),
                          child: const Text("LET'S TALK"),
                        ),
                      ],
                    )
                  else
                    IconButton(
                      icon: const Icon(Icons.menu, color: Colors.white, size: 28),
                      onPressed: () {
                        _scaffoldKey.currentState?.openEndDrawer();
                      },
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        controller: _scrollController,
        child: Column(
          children: [
            HeroSection(onContactTap: _scrollToContact),
            const ArtistSection(),
            const PortfolioSection(),
            const ServicesSection(),
            TestimonialsSection(key: _contactKey),
            const FooterSection(),
          ],
        ),
      ),
      endDrawer: Drawer(
        backgroundColor: AppTheme.bgDark.withOpacity(0.95),
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                border: Border(bottom: BorderSide(color: AppTheme.accentColor.withOpacity(0.5), width: 1)),
              ),
              child: Center(
                child: RichText(
                  text: TextSpan(
                    style: GoogleFonts.outfit(
                      fontSize: 24,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 2,
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
              ),
            ),
            ListTile(
              contentPadding: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
              title: Text('PORTFOLIO', style: GoogleFonts.inter(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold, letterSpacing: 1)),
              onTap: () { Navigator.pop(context); },
            ),
            ListTile(
              contentPadding: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
              title: Text('ARTIST', style: GoogleFonts.inter(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold, letterSpacing: 1)),
              onTap: () { Navigator.pop(context); },
            ),
            ListTile(
              contentPadding: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
              title: Text('SERVICES', style: GoogleFonts.inter(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold, letterSpacing: 1)),
              onTap: () { Navigator.pop(context); },
            ),
            ListTile(
              contentPadding: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
              title: Text('REVIEWS', style: GoogleFonts.inter(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold, letterSpacing: 1)),
              onTap: () { Navigator.pop(context); },
            ),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: OutlinedButton(
                onPressed: () { Navigator.pop(context); },
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: AppTheme.accentColor),
                  foregroundColor: AppTheme.accentColor,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  textStyle: GoogleFonts.outfit(
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1,
                  ),
                ),
                child: const Text("LET'S TALK"),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: const _WhatsAppButton(),
    );
  }
}

class _WhatsAppButton extends StatefulWidget {
  const _WhatsAppButton();

  @override
  State<_WhatsAppButton> createState() => _WhatsAppButtonState();
}

class _WhatsAppButtonState extends State<_WhatsAppButton> with SingleTickerProviderStateMixin {
  late AnimationController _pulseCtrl;

  @override
  void initState() {
    super.initState();
    _pulseCtrl = AnimationController(
       vsync: this, 
       duration: const Duration(milliseconds: 1500)
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _pulseCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _pulseCtrl,
      builder: (context, child) {
        return Transform.scale(
          scale: 1.0 + (_pulseCtrl.value * 0.05),
          child: Container(
            margin: const EdgeInsets.only(bottom: 20, right: 20),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.greenAccent.withOpacity(0.4 + (_pulseCtrl.value * 0.2)),
                  blurRadius: 20 + (_pulseCtrl.value * 10),
                  spreadRadius: _pulseCtrl.value * 5,
                )
              ]
            ),
            child: FloatingActionButton(
               onPressed: () {},
               backgroundColor: const Color(0xFF25D366), // WhatsApp Green
               child: const Icon(Icons.chat, color: Colors.white, size: 30),
            ),
          ),
        );
      }
    );
  }
}

class _NavBarItem extends StatefulWidget {
  final String title;
  const _NavBarItem({required this.title});

  @override
  State<_NavBarItem> createState() => _NavBarItemState();
}

class _NavBarItemState extends State<_NavBarItem> {
  bool _isHovering = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovering = true),
      onExit: (_) => setState(() => _isHovering = false),
      cursor: SystemMouseCursors.click,
      child: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Text(
              widget.title.toUpperCase(),
              style: GoogleFonts.inter(
                fontWeight: FontWeight.w600,
                color: _isHovering ? AppTheme.accentColor : Colors.white,
                letterSpacing: 1,
              ),
            ),
          ),
          AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            height: 2,
            width: _isHovering ? 40 : 0,
            color: AppTheme.accentColor,
            margin: const EdgeInsets.only(top: 4),
          ),
        ],
      ),
    );
  }
}

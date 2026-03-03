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
import 'dart:ui';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final ScrollController _scrollController = ScrollController();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final GlobalKey _contactKey = GlobalKey();
  final GlobalKey _portfolioKey = GlobalKey();
  final GlobalKey _aboutKey = GlobalKey();
  final GlobalKey _latestTattoosKey = GlobalKey();
  bool _isScrolled = false;

  void _scrollToSection(GlobalKey key) {
    if (key.currentContext != null) {
      Scrollable.ensureVisible(
        key.currentContext!, 
        duration: const Duration(milliseconds: 800), 
        curve: Curves.easeInOut
      );
    }
  }

  void _scrollToContact() {
    _scrollToSection(_contactKey);
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
        child: ClipRect(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 8.0, sigmaY: 8.0),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              color: _isScrolled ? AppTheme.bgDark.withOpacity(0.85) : Colors.transparent,
              child: SafeArea(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Image.asset('assets/images/logo.png', height: 40),
                          const SizedBox(width: 12),
                          Text('MaayArt', style: GoogleFonts.outfit(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold)),
                        ],
                      ),
                      if (MediaQuery.of(context).size.width > 768)
                        Row(
                          children: [
                            GestureDetector(onTap: () => _scrollToSection(_portfolioKey), child: const _NavBarItem(title: 'Portfolio')),
                            const SizedBox(width: 24),
                            GestureDetector(onTap: () => _scrollToSection(_aboutKey), child: const _NavBarItem(title: 'About')),
                            const SizedBox(width: 24),
                            GestureDetector(onTap: () => _scrollToSection(_latestTattoosKey), child: const _NavBarItem(title: 'Latest Tattoos')),
                            const SizedBox(width: 24),
                            GestureDetector(onTap: _scrollToContact, child: const _NavBarItem(title: 'Contact Us')),
                            const SizedBox(width: 24),
                            OutlinedButton(
                              onPressed: () {_scrollToContact();},
                              style: OutlinedButton.styleFrom(
                                side: const BorderSide(color: AppTheme.accentColor),
                                foregroundColor: AppTheme.accentColor,
                                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                                textStyle: GoogleFonts.outfit(
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 1,
                                ),
                              ),
                              child: const Text("Contact Us"),
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
        ),
      ),
      body: SingleChildScrollView(
        controller: _scrollController,
        child: Column(
          children: [
            HeroSection(onContactTap: _scrollToContact),
            ArtistSection(key: _aboutKey),
            PortfolioSection(key: _portfolioKey),
            ServicesSection(key: _latestTattoosKey),
            TestimonialsSection(key: _contactKey),
            const FooterSection(),
          ],
        ),
      ),
      endDrawer: Drawer(
        backgroundColor: Colors.transparent,
        elevation: 0,
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                const Color(0xFF0A0A0A).withOpacity(0.98),
                const Color(0xFF151515).withOpacity(0.98),
                AppTheme.accentColor.withOpacity(0.05),
              ],
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.5),
                blurRadius: 20,
              )
            ],
            border: Border(
              left: BorderSide(
                color: AppTheme.accentColor.withOpacity(0.2),
                width: 1,
              ),
            ),
          ),
          child: SafeArea(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                DrawerHeader(
                  decoration: BoxDecoration(
                    border: Border(bottom: BorderSide(color: AppTheme.accentColor.withOpacity(0.2), width: 1)),
                  ),
                  child: Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset('assets/images/logo.png', height: 40),
                        const SizedBox(width: 12),
                        Text('MaayArt', style: GoogleFonts.outfit(color: Colors.white, fontSize: 28, fontWeight: FontWeight.bold, letterSpacing: 2)),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                _DrawerItem(
                  title: 'PORTFOLIO',
                  icon: Icons.grid_view_rounded,
                  onTap: () { Navigator.pop(context); _scrollToSection(_portfolioKey); },
                ),
                _DrawerItem(
                  title: 'ABOUT',
                  icon: Icons.person_outline_rounded,
                  onTap: () { Navigator.pop(context); _scrollToSection(_aboutKey); },
                ),
                _DrawerItem(
                  title: 'LATEST TATTOOS',
                  icon: Icons.local_fire_department_outlined,
                  onTap: () { Navigator.pop(context); _scrollToSection(_latestTattoosKey); },
                ),
                _DrawerItem(
                  title: 'CONTACT US',
                  icon: Icons.mail_outline_rounded,
                  onTap: () { Navigator.pop(context); _scrollToContact(); },
                ),
              ],
            ),
          ),
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
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
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

class _DrawerItem extends StatefulWidget {
  final String title;
  final IconData icon;
  final VoidCallback onTap;

  const _DrawerItem({required this.title, required this.icon, required this.onTap});

  @override
  State<_DrawerItem> createState() => _DrawerItemState();
}

class _DrawerItemState extends State<_DrawerItem> {
  bool _isHovering = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovering = true),
      onExit: (_) => setState(() => _isHovering = false),
      cursor: SystemMouseCursors.click,
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 40, vertical: 12),
        leading: Icon(widget.icon, color: _isHovering ? AppTheme.accentColor : Colors.white70, size: 24),
        title: Text(
          widget.title, 
          style: GoogleFonts.outfit(
            color: _isHovering ? AppTheme.accentColor : Colors.white, 
            fontSize: 16, 
            fontWeight: FontWeight.w600, 
            letterSpacing: 2
          )
        ),
        onTap: widget.onTap,
        tileColor: _isHovering ? AppTheme.accentColor.withOpacity(0.05) : Colors.transparent,
      ),
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

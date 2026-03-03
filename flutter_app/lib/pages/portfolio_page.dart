import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme.dart';
import '../widgets/smoke_particles.dart';

class PortfolioPage extends StatelessWidget {
  const PortfolioPage({super.key});

  @override
  Widget build(BuildContext context) {
    bool isMobile = MediaQuery.of(context).size.width < 768;
    bool isTablet = MediaQuery.of(context).size.width >= 768 && MediaQuery.of(context).size.width < 1200;
    int columns = isMobile ? 2 : (isTablet ? 3 : 4);

    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: AppTheme.bgDark,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'FULL PORTFOLIO',
          style: GoogleFonts.outfit(
            color: Colors.white,
            fontWeight: FontWeight.w800,
            letterSpacing: 2,
          ),
        ),
        centerTitle: true,
      ),
      body: Stack(
        children: [
          // Background Smoke
          const Positioned.fill(
            child: SmokeParticles(count: 30, color: AppTheme.accentColor),
          ),
          
          SafeArea(
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: isMobile ? 20 : 50, vertical: 40),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    'OUR MASTERPIECES',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.outfit(
                      fontSize: isMobile ? 40 : 64,
                      fontWeight: FontWeight.w900,
                      color: Colors.white,
                      letterSpacing: 3,
                      shadows: [
                        BoxShadow(
                          color: AppTheme.accentColor.withOpacity(0.4),
                          blurRadius: 30,
                        )
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    'Explore our complete collection of timeless artworks marked on skin. From dark realism to geometric precision.',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.inter(
                      fontSize: 18,
                      color: AppTheme.textSecondary,
                      letterSpacing: 1,
                    ),
                  ),
                  const SizedBox(height: 60),
                  
                  // Masonry Grid
                  _FullPortfolioGrid(columns: columns),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _FullPortfolioGrid extends StatelessWidget {
  final int columns;
  const _FullPortfolioGrid({required this.columns});

  @override
  Widget build(BuildContext context) {
    // List of standard items
    final items = [
      _PortfolioItemData('assets/images/tattoo_portfolio_1_1772521412592.png', 'DARK REALISM', 1.0),
      _PortfolioItemData('assets/images/tattoo_portfolio_2_1772521428566.png', 'FINE LINE', 1.3),
      _PortfolioItemData('assets/images/geom_tattoo_1772516290886.png', 'GEOMETRIC', 1.0),
      _PortfolioItemData('assets/images/realistic_tattoo_1772516370103.png', 'PORTRAIT', 1.2),
      _PortfolioItemData('assets/images/tribal_tattoo_1772516307052.png', 'BLACKWORK', 1.1),
      _PortfolioItemData('assets/images/tattoo_about_1_1772521378042.png', 'SLEEVE', 1.0),
      _PortfolioItemData('assets/images/tattoo_about_2_1772521394095.png', 'CHEST PIECE', 1.1),
      _PortfolioItemData('assets/images/hero_tattoo_bg_1772516268163.png', 'COVER UP', 1.0),
    ];

    List<List<_PortfolioItemData>> columnItems = List.generate(columns, (_) => []);
    
    for (int i = 0; i < items.length; i++) {
        columnItems[i % columns].add(items[i]);
    }

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: List.generate(columns, (i) {
        return Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Column(
              children: columnItems[i].map((e) => Padding(
                padding: const EdgeInsets.only(bottom: 20),
                child: _PortfolioCard(item: e),
              )).toList(),
            ),
          ),
        );
      }),
    );
  }
}

class _PortfolioItemData {
  final String image;
  final String category;
  final double ratio;
  _PortfolioItemData(this.image, this.category, this.ratio);
}

class _PortfolioCard extends StatefulWidget {
  final _PortfolioItemData item;

  const _PortfolioCard({required this.item});

  @override
  State<_PortfolioCard> createState() => _PortfolioCardState();
}

class _PortfolioCardState extends State<_PortfolioCard> {
  bool _isHovering = false;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return MouseRegion(
          onEnter: (_) => setState(() => _isHovering = true),
          onExit: (_) => setState(() => _isHovering = false),
          cursor: SystemMouseCursors.click,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            height: constraints.maxWidth * widget.item.ratio,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: _isHovering ? AppTheme.accentColor : Colors.white.withOpacity(0.05),
                width: 2,
              ),
              boxShadow: _isHovering
                  ? [
                      BoxShadow(
                        color: AppTheme.accentColor.withOpacity(0.3),
                        blurRadius: 25,
                        spreadRadius: 2,
                      )
                    ]
                  : [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.5),
                        blurRadius: 15,
                        offset: const Offset(0, 10),
                      )
                    ],
            ),
            clipBehavior: Clip.antiAlias,
            child: Stack(
              fit: StackFit.expand,
              children: [
                AnimatedScale(
                  duration: const Duration(milliseconds: 600),
                  scale: _isHovering ? 1.08 : 1.0,
                  curve: Curves.easeOutCubic,
                  child: Image.asset(
                    widget.item.image,
                    fit: BoxFit.cover,
                  ),
                ),
                
                // Gradient Overlay
                AnimatedOpacity(
                  opacity: _isHovering ? 1.0 : 0.4,
                  duration: const Duration(milliseconds: 300),
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.bottomCenter,
                        end: Alignment.topCenter,
                        colors: [
                          Colors.black.withOpacity(0.95),
                          Colors.black.withOpacity(_isHovering ? 0.2 : 0.0),
                        ],
                      ),
                    ),
                  ),
                ),
                
                // Category Tag
                Positioned(
                  bottom: 25,
                  left: 25,
                  child: AnimatedSlide(
                    offset: _isHovering ? Offset.zero : const Offset(0, 0.4),
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeOutBack,
                    child: AnimatedOpacity(
                      opacity: _isHovering ? 1.0 : 0.0,
                      duration: const Duration(milliseconds: 300),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                            decoration: BoxDecoration(
                              color: AppTheme.accentColor,
                              borderRadius: BorderRadius.circular(30),
                            ),
                            child: Text(
                              widget.item.category.toUpperCase(),
                              style: GoogleFonts.outfit(
                                color: Colors.white,
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 1.5,
                              ),
                            ),
                          ),
                          const SizedBox(height: 10),
                          Row(
                            children: [
                              Text(
                                'VIEW PROJECT',
                                style: GoogleFonts.outfit(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  letterSpacing: 2,
                                ),
                              ),
                              const SizedBox(width: 8),
                              const Icon(Icons.arrow_forward_rounded, color: Colors.white, size: 18),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        );
      }
    );
  }
}

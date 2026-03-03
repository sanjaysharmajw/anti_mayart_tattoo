import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme.dart';
import '../pages/portfolio_page.dart';

class PortfolioSection extends StatelessWidget {
  const PortfolioSection({super.key});

  @override
  Widget build(BuildContext context) {
    bool isMobile = MediaQuery.of(context).size.width < 768;
    bool isTablet = MediaQuery.of(context).size.width >= 768 && MediaQuery.of(context).size.width < 1200;
    
    int columns = isMobile ? 3 : (isTablet ? 4 : 5);
    
    return Container(
      color: AppTheme.bgDark, // Slight dark grey (#121212)
      padding: EdgeInsets.symmetric(horizontal: isMobile ? 20 : 50, vertical: isMobile ? 80 : 120),
      child: Column(
        children: [
          Text(
            'PORTFOLIO',
            style: GoogleFonts.outfit(
              fontSize: isMobile ? 32 : 48,
              fontWeight: FontWeight.w900,
              color: Colors.white,
              letterSpacing: 4,
              shadows: [
                BoxShadow(
                  color: AppTheme.accentColor.withOpacity(0.5),
                  blurRadius: 15,
                )
              ]
            ),
          ),
          const SizedBox(height: 15),
          Text(
            'Timeless artworks marked on the skin, exploring contrasts and realism.',
            textAlign: TextAlign.center,
            style: GoogleFonts.inter(
              fontSize: isMobile ? 14 : 18,
              color: AppTheme.textSecondary,
              letterSpacing: 1,
            ),
          ),
          const SizedBox(height: 10),
          Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 1200),
              child: GridView.count(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisCount: columns,
                mainAxisSpacing: 20,
                crossAxisSpacing: 20,
                childAspectRatio: 0.8,
                children: const [
                  _GridItem(
                    image: 'assets/images/tattoo_portfolio_1_1772521412592.png',
                    category: 'DARK REALISM',
                  ),
                  _GridItem(
                    image: 'assets/images/tattoo_portfolio_2_1772521428566.png',
                    category: 'FINE LINE',
                  ),
                  _GridItem(
                    image: 'assets/images/geom_tattoo_1772516290886.png',
                    category: 'GEOMETRIC',
                  ),
                  _GridItem(
                    image: 'assets/images/realistic_tattoo_1772516370103.png',
                    category: 'PORTRAIT',
                  ),
                  _GridItem(
                    image: 'assets/images/tribal_tattoo_1772516307052.png',
                    category: 'BLACKWORK',
                  ),
                  _GridItem(
                    image: 'assets/images/tattoo_about_1_1772521378042.png',
                    category: 'SLEEVE',
                  ),
                  _GridItem(
                    image: 'assets/images/tattoo_about_2_1772521394095.png',
                    category: 'CHEST PIECE',
                  ),
                  _GridItem(
                    image: 'assets/images/hero_tattoo_bg_1772516268163.png',
                    category: 'COVER UP',
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 60),
          _VerMaisButton(),
        ],
      ),
    );
  }
}

class _VerMaisButton extends StatefulWidget {
  @override
  State<_VerMaisButton> createState() => _VerMaisButtonState();
}

class _VerMaisButtonState extends State<_VerMaisButton> {
  bool _isHovering = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovering = true),
      onExit: (_) => setState(() => _isHovering = false),
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const PortfolioPage()),
          );
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
          decoration: BoxDecoration(
            color: Colors.transparent,
            borderRadius: BorderRadius.circular(2),
            border: Border.all(
              color: _isHovering ? AppTheme.accentColor : Colors.white24,
              width: 2,
            ),
            boxShadow: _isHovering
                ? [
                    BoxShadow(
                      color: AppTheme.accentColor.withOpacity(0.3),
                      blurRadius: 15,
                    )
                  ]
                : [],
          ),
          child: Text(
            'VIEW FULL PORTFOLIO',
            style: GoogleFonts.outfit(
              color: _isHovering ? AppTheme.accentColor : Colors.white,
              fontSize: 14,
              fontWeight: FontWeight.bold,
              letterSpacing: 2,
            ),
          ),
        ),
      ),
    );
  }
}

class _GridItem extends StatefulWidget {
  final String image;
  final String category;

  const _GridItem({
    required this.image,
    required this.category,
  });

  @override
  State<_GridItem> createState() => _GridItemState();
}

class _GridItemState extends State<_GridItem> {
  bool _isHovering = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovering = true),
      onExit: (_) => setState(() => _isHovering = false),
      cursor: SystemMouseCursors.click,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(2),
          border: Border.all(
            color: _isHovering ? AppTheme.accentColor : Colors.transparent,
            width: 2,
          ),
          boxShadow: _isHovering
              ? [
                  BoxShadow(
                    color: AppTheme.accentColor.withOpacity(0.4),
                    blurRadius: 20,
                  )
                ]
              : [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.5),
                    blurRadius: 10,
                  )
                ],
        ),
        clipBehavior: Clip.antiAlias,
        child: Stack(
          fit: StackFit.expand,
          children: [
            AnimatedScale(
              duration: const Duration(milliseconds: 600),
              scale: _isHovering ? 1.05 : 1.0,
              curve: Curves.easeOutCubic,
              child: Image.asset(
                widget.image,
                fit: BoxFit.cover,
              ),
            ),
            
            // Dark Overlay Gradient Fade On Hover
            AnimatedOpacity(
              opacity: _isHovering ? 1.0 : 0.6,
              duration: const Duration(milliseconds: 300),
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                    colors: [
                      Colors.black.withOpacity(0.9),
                      Colors.black.withOpacity(_isHovering ? 0.2 : 0.4),
                    ],
                  ),
                ),
              ),
            ),
            
            // Category Text Bottom Left
            Positioned(
              bottom: 20,
              left: 20,
              child: AnimatedSlide(
                offset: _isHovering ? Offset.zero : const Offset(0, 0.2),
                duration: const Duration(milliseconds: 300),
                child: Text(
                  widget.category,
                  style: GoogleFonts.outfit(
                    color: Colors.white,
                    fontSize: MediaQuery.of(context).size.width < 768 ? 10 : 16,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.5,
                    shadows: const [
                      Shadow(
                        color: Colors.black87,
                        blurRadius: 4,
                      )
                    ]
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme.dart';
import '../pages/portfolio_page.dart';

class ServicesSection extends StatelessWidget {
  const ServicesSection({super.key});

  @override
  Widget build(BuildContext context) {
    bool isMobile = MediaQuery.of(context).size.width < 768;

    return Container(
      padding: EdgeInsets.symmetric(vertical: isMobile ? 80 : 120),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: isMobile ? 20 : 50),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'LATEST TATTOOS',
                      style: GoogleFonts.outfit(
                        fontSize: isMobile ? 32 : 40,
                        fontWeight: FontWeight.w900,
                        color: Colors.white,
                        letterSpacing: 2,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      'Explore our latest projects.',
                      style: GoogleFonts.inter(
                        fontSize: isMobile ? 14 : 18,
                        color: AppTheme.textSecondary,
                        letterSpacing: 1,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),

          // Horizontal Carousel
          SizedBox(
            height: isMobile ? 250 : 350,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              physics: const PageScrollPhysics(), // Snap scroll feel
              padding: const EdgeInsets.symmetric(horizontal: 30),
              itemCount: 8,
              itemBuilder: (context, index) {
                final images = [
                  'assets/images/tattoo_portfolio_1_1772521412592.png',
                  'assets/images/tattoo_portfolio_2_1772521428566.png',
                  'assets/images/realistic_tattoo_1772516370103.png',
                  'assets/images/geom_tattoo_1772516290886.png',
                  'assets/images/tattoo_about_1_1772521378042.png',
                  'assets/images/tattoo_about_2_1772521394095.png',
                  'assets/images/tribal_tattoo_1772516307052.png',
                  'assets/images/hero_tattoo_bg_1772516268163.png',
                ];
                final labels = [
                  'Skull Realism',
                  'Fine Line Details',
                  'Shadowed Portrait',
                  'Geometric Flows',
                  'Full Sleeve Blackwork',
                  'Chest Artwork',
                  'Tribal Patterns',
                  'Cover Up Designs',
                ];
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  child: _CarouselItem(
                    image: images[index],
                    label: labels[index],
                  ),
                );
              },
            ),
          ),
          
          Padding(
            padding: const EdgeInsets.only(top: 40, left: 20, right: 20),
            child: Center(child: _VerMaisButton()),
          ),
        ],
      ),
    );
  }
}

class _CarouselItem extends StatefulWidget {
  final String image;
  final String label;

  const _CarouselItem({required this.image, required this.label});

  @override
  State<_CarouselItem> createState() => _CarouselItemState();
}

class _CarouselItemState extends State<_CarouselItem> {
  bool _isHovering = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovering = true),
      onExit: (_) => setState(() => _isHovering = false),
      cursor: SystemMouseCursors.click,
      child: Container(
        width: MediaQuery.of(context).size.width < 768 ? 160 : 220,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(2),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(2),
                child: AnimatedScale(
                  duration: const Duration(milliseconds: 600),
                  scale: _isHovering ? 1.05 : 1.0,
                  curve: Curves.easeOutCubic,
                  child: Image.asset(
                    widget.image,
                    fit: BoxFit.cover,
                    width: double.infinity,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Text(
               widget.label,
               style: GoogleFonts.outfit(
                 color: _isHovering ? AppTheme.accentColor : Colors.white,
                 fontSize: MediaQuery.of(context).size.width < 768 ? 14 : 18,
                 fontWeight: FontWeight.w600,
                 letterSpacing: 1,
               ),
            ),
            AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              height: 2,
              width: _isHovering ? 60 : 0,
              color: AppTheme.accentColor,
              margin: const EdgeInsets.only(top: 8),
            ),
          ],
        ),
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
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        decoration: BoxDecoration(
          color: AppTheme.accentColor,
          borderRadius: BorderRadius.circular(2),
        ),
        transform: _isHovering ? (Matrix4.identity()..translate(0.0, -3.0)) : Matrix4.identity(),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'VIEW MORE',
              style: GoogleFonts.outfit(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold,
                letterSpacing: 2,
              ),
            ),
            const SizedBox(width: 8),
            const Icon(Icons.arrow_forward, color: Colors.white, size: 18),
          ],
        ),
      ),
      ),
    );
  }
}

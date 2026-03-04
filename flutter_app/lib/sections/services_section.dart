import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme.dart';
import '../pages/portfolio_page.dart';
import 'package:provider/provider.dart';
import '../providers/tattoo_provider.dart';

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
            child: Consumer<TattooProvider>(
              builder: (context, provider, child) {
                if (provider.isLoading && provider.tattoos.isEmpty) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (provider.errorMessage.isNotEmpty && provider.tattoos.isEmpty) {
                  return Center(
                    child: Text('Error: ${provider.errorMessage}', style: const TextStyle(color: Colors.red)),
                  );
                }
                if (provider.tattoos.isEmpty) {
                  return const Center(
                    child: Text('No tattoos available yet.', style: TextStyle(color: Colors.white70)),
                  );
                }

                return ListView.builder(
                  scrollDirection: Axis.horizontal,
                  physics: const PageScrollPhysics(), // Snap scroll feel
                  padding: const EdgeInsets.symmetric(horizontal: 30),
                  itemCount: provider.tattoos.length,
                  itemBuilder: (context, index) {
                    final tattoo = provider.tattoos[index];
                    final imageUrl = tattoo.image.startsWith('http') 
                        ? tattoo.image 
                        : 'https://anti-mayart-tattoo.onrender.com${tattoo.image.startsWith('/') ? tattoo.image : '/${tattoo.image}'}';

                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15),
                      child: _CarouselItem(
                        image: imageUrl,
                        label: tattoo.title,
                        isNetwork: true,
                      ),
                    );
                  },
                );
              }
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
  final bool isNetwork;

  const _CarouselItem({required this.image, required this.label, this.isNetwork = false});

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
                  child: widget.isNetwork 
                      ? Image.network(
                          widget.image,
                          fit: BoxFit.cover,
                          width: double.infinity,
                          errorBuilder: (context, error, stackTrace) => Container(color: Colors.grey[900], child: const Icon(Icons.broken_image, color: Colors.white54)),
                        )
                      : Image.asset(
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

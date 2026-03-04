import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme.dart';
import 'package:provider/provider.dart';
import '../providers/about_provider.dart';

class ArtistSection extends StatefulWidget {
  const ArtistSection({super.key});

  @override
  State<ArtistSection> createState() => _ArtistSectionState();
}

class _ArtistSectionState extends State<ArtistSection> with SingleTickerProviderStateMixin {
  bool _isVisible = false;

  @override
  Widget build(BuildContext context) {
    bool isMobile = MediaQuery.of(context).size.width < 768;

    return Container(
      padding: EdgeInsets.symmetric(horizontal: isMobile ? 20 : 50, vertical: isMobile ? 80 : 120),
      child: Focus( // Simple visibility trigger simulation on hover or wrap in another detector
        onFocusChange: (hasFocus) => setState(() => _isVisible = true),
        child: MouseRegion(
          onEnter: (_) => setState(() => _isVisible = true),
          child: AnimatedOpacity(
            opacity: _isVisible ? 1.0 : 0.4,
            duration: const Duration(milliseconds: 1000),
            curve: Curves.easeIn,
            child: Flex(
              direction: isMobile ? Axis.vertical : Axis.horizontal,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Left Side: 3 Overlapping Images
                SizedBox(
                  width: isMobile ? 320 : 500,
                  height: isMobile ? 320 : 500,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Positioned(
                        top: 20, left: 0,
                        child: _ImageLayer(
                          image: 'assets/images/tattoo_about_1_1772521378042.png',
                          width: isMobile ? 180 : 280,
                          height: isMobile ? 220 : 350,
                          rotation: -0.05,
                        ),
                      ),
                      Positioned(
                        bottom: 0, right: 30,
                        child: _ImageLayer(
                          image: 'assets/images/tattoo_about_2_1772521394095.png',
                          width: isMobile ? 150 : 260,
                          height: isMobile ? 180 : 320,
                          rotation: 0.04,
                        ),
                      ),
                      Positioned(
                        top: 60, right: 0,
                        child: _ImageLayer(
                          image: 'assets/images/tattoo_about_1_1772521378042.png', // reusing
                          width: isMobile ? 120 : 200,
                          height: isMobile ? 160 : 250,
                          rotation: 0.1,
                          opacity: 0.8,
                        ),
                      ),
                    ],
                  ),
                ),
                
                SizedBox(width: isMobile ? 0 : 80, height: isMobile ? 60 : 0),
                
                // Right Side: Text & Info
                Builder(
                  builder: (context) {
                    final textContent = Consumer<AboutProvider>(
                      builder: (context, provider, child) {
                        if (provider.isLoading) {
                          return const Center(child: CircularProgressIndicator());
                        }
                        
                        // If we have data, show the first item, else show default
                        final title = provider.abouts.isNotEmpty ? provider.abouts.first.title.toUpperCase() : 'ABOUT';
                        final desc = provider.abouts.isNotEmpty ? provider.abouts.first.description : 'With over a decade of experience...';

                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              title,
                              style: GoogleFonts.outfit(
                                fontSize: isMobile ? 32 : 48,
                                fontWeight: FontWeight.w900,
                                color: Colors.white,
                                letterSpacing: 4,
                                shadows: [
                                  BoxShadow(
                                    color: AppTheme.accentColor.withOpacity(0.4),
                                    blurRadius: 20,
                                  )
                                ]
                              ),
                            ),
                            const SizedBox(height: 20),
                            
                            // Divider line with subtle glow
                            Container(
                              height: 3,
                              width: 100,
                              decoration: BoxDecoration(
                                color: AppTheme.accentColor,
                                boxShadow: [
                                  BoxShadow(
                                    color: AppTheme.accentColor.withOpacity(0.8),
                                    blurRadius: 15,
                                  )
                                ],
                                borderRadius: BorderRadius.circular(2),
                              ),
                            ),
                            const SizedBox(height: 40),
                            
                            Text(
                              desc,
                              style: GoogleFonts.inter(
                                fontSize: isMobile ? 14 : 16,
                                color: Colors.white,
                                height: 1.8,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ],
                        );
                      }
                    );
                    return isMobile ? textContent : Expanded(child: textContent);
                  }
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _ImageLayer extends StatelessWidget {
  final String image;
  final double width;
  final double height;
  final double rotation;
  final double opacity;

  const _ImageLayer({
    required this.image,
    required this.width,
    required this.height,
    required this.rotation,
    this.opacity = 1.0,
  });

  @override
  Widget build(BuildContext context) {
    return Transform.rotate(
      angle: rotation,
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(2),
          border: Border.all(
            color: AppTheme.accentColor.withOpacity(0.3),
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: AppTheme.accentColor.withOpacity(0.15),
              blurRadius: 20,
              spreadRadius: 2,
            ),
            BoxShadow(
              color: Colors.black.withOpacity(0.6),
              blurRadius: 30,
              offset: const Offset(10, 15),
            )
          ],
          image: DecorationImage(
            image: AssetImage(image),
            fit: BoxFit.cover,
            colorFilter: ColorFilter.mode(
              Colors.black.withOpacity(1 - opacity),
              BlendMode.darken,
            ),
          ),
        ),
      ),
    );
  }
}

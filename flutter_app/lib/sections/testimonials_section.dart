import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme.dart';
import 'package:provider/provider.dart';
import '../providers/contact_provider.dart';

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

class _ContactForm extends StatefulWidget {
  @override
  State<_ContactForm> createState() => _ContactFormState();
}

class _ContactFormState extends State<_ContactForm> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _messageController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _messageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    bool isMobile = MediaQuery.of(context).size.width < 768;
    final provider = Provider.of<ContactProvider>(context);
    
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
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            _buildTextField('FULL NAME', Icons.person_outline, _nameController),
            const SizedBox(height: 20),
            _buildTextField('EMAIL ADDRESS', Icons.email_outlined, _emailController),
            const SizedBox(height: 20),
            _buildTextField('PHONE NUMBER', Icons.phone_outlined, _phoneController),
            const SizedBox(height: 20),
            _buildTextField('YOUR MESSAGE / TATTOO IDEA', Icons.message_outlined, _messageController, maxLines: 4),
            const SizedBox(height: 30),
            if (provider.isLoading)
              const CircularProgressIndicator(color: AppTheme.accentColor)
            else
              _SubmitButton(onTap: () async {
                if (_formKey.currentState!.validate()) {
                  final result = await provider.createContact(
                    _nameController.text,
                    _emailController.text,
                    _phoneController.text,
                    _messageController.text,
                  );
                  if (result && mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Message sent successfully!'), backgroundColor: Colors.green),
                    );
                    _nameController.clear();
                    _emailController.clear();
                    _phoneController.clear();
                    _messageController.clear();
                  } else if (mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                       SnackBar(content: Text(provider.errorMessage), backgroundColor: Colors.red),
                    );
                  }
                }
              }),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(String hint, IconData icon, TextEditingController controller, {int maxLines = 1}) {
    return TextFormField(
      controller: controller,
      maxLines: maxLines,
      style: GoogleFonts.inter(color: Colors.white),
      validator: (value) => value == null || value.isEmpty ? 'Required field' : null,
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
  final VoidCallback onTap;
  const _SubmitButton({required this.onTap});

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
      child: GestureDetector(
        onTap: widget.onTap,
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
      ),
    );
  }
}

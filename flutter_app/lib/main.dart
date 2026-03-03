import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'theme.dart';
import 'home_page.dart';

void main() {
  runApp(const AntiMayartTattooApp());
}

class AntiMayartTattooApp extends StatelessWidget {
  const AntiMayartTattooApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Anti Mayart Tattoo',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.darkTheme.copyWith(
        textTheme: GoogleFonts.interTextTheme(Theme.of(context).textTheme).apply(
          bodyColor: AppTheme.textPrimary,
          displayColor: AppTheme.textPrimary,
        ),
      ),
      home: const HomePage(),
    );
  }
}

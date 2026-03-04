import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'theme.dart';
import 'home_page.dart';
import 'providers/about_provider.dart';
import 'providers/contact_provider.dart';
import 'providers/portfolio_provider.dart';
import 'providers/tattoo_provider.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AboutProvider()),
        ChangeNotifierProvider(create: (_) => ContactProvider()),
        ChangeNotifierProvider(create: (_) => PortfolioProvider()),
        ChangeNotifierProvider(create: (_) => TattooProvider()),
      ],
      child: const AntiMayartTattooApp(),
    ),
  );
}

class AntiMayartTattooApp extends StatelessWidget {
  const AntiMayartTattooApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Anti Mayart Tattoo',
      debugShowCheckedModeBanner: false,
      scrollBehavior: AppScrollBehavior(),
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

class AppScrollBehavior extends MaterialScrollBehavior {
  @override
  Set<PointerDeviceKind> get dragDevices => {
        PointerDeviceKind.touch,
        PointerDeviceKind.mouse,
        PointerDeviceKind.trackpad,
      };
}

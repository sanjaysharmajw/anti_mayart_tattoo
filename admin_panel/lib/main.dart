import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/about_provider.dart';
import 'providers/portfolio_provider.dart';
import 'providers/tattoo_provider.dart';
import 'providers/contact_provider.dart';
import 'screens/dashboard_screen.dart';
import 'screens/about_screen.dart';
import 'screens/portfolio_screen.dart';
import 'screens/tattoo_screen.dart';
import 'screens/contact_screen.dart';
import 'screens/main_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AboutProvider()),
        ChangeNotifierProvider(create: (_) => PortfolioProvider()),
        ChangeNotifierProvider(create: (_) => TattooProvider()),
        ChangeNotifierProvider(create: (_) => ContactProvider()),
      ],
      child: MaterialApp(
        title: 'Admin Panel',
        debugShowCheckedModeBanner: false,
        theme: ThemeData.dark(useMaterial3: true).copyWith(
          scaffoldBackgroundColor: const Color(0xFF161616),
          primaryColor: const Color(0xFF72D565),
          colorScheme: const ColorScheme.dark(
            primary: Color(0xFF72D565),
            secondary: Color(0xFF72D565),
            surface: Color(0xFF1E1E1E),
            background: Color(0xFF161616),
            error: Color(0xFFEF4444),
          ),
          cardTheme: const CardThemeData(
            color: Color(0xFF1E1E1E),
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(20)),
              side: BorderSide(color: Color(0xFF2E2E2E), width: 1),
            ),
            margin: EdgeInsets.all(0),
          ),
          appBarTheme: const AppBarTheme(
            backgroundColor: Color(0xFF161616),
            elevation: 0,
            centerTitle: false,
            titleTextStyle: TextStyle(fontSize: 22, fontWeight: FontWeight.w600, color: Colors.white, letterSpacing: -0.5),
            iconTheme: IconThemeData(color: Colors.white),
          ),
          drawerTheme: const DrawerThemeData(
            backgroundColor: Color(0xFF1A1A1A),
            elevation: 0,
            shape: RoundedRectangleBorder(
              side: BorderSide(color: Color(0xFF2A2A2A), width: 1),
            ),
          ),
          inputDecorationTheme: InputDecorationTheme(
            filled: true,
            fillColor: const Color(0xFF121212),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Color(0xFF2A2A2A))),
            enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Color(0xFF2A2A2A))),
            focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Color(0xFF72D565), width: 1.5)),
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            labelStyle: const TextStyle(color: Color(0xFF888888)),
            hintStyle: const TextStyle(color: Color(0xFF888888)),
          ),
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF72D565),
              foregroundColor: Colors.black,
              elevation: 0,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              textStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
            ),
          ),
          outlinedButtonTheme: OutlinedButtonThemeData(
            style: OutlinedButton.styleFrom(
              foregroundColor: Colors.white,
              side: const BorderSide(color: Color(0xFF2A2A2A)),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            ),
          ),
          floatingActionButtonTheme: const FloatingActionButtonThemeData(
            backgroundColor: Color(0xFF72D565),
            foregroundColor: Colors.black,
            elevation: 0,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(12))),
          ),
          dialogTheme: DialogThemeData(
            backgroundColor: const Color(0xFF1A1A1A),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
              side: const BorderSide(color: Color(0xFF2A2A2A)),
            ),
            titleTextStyle: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
          ),
          dividerColor: const Color(0xFF2E2E2E),
        ),
        home: const MainScreen(),
      ),
    );
  }
}

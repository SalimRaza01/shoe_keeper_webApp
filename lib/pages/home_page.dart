// screens/home_page.dart
import 'package:flutter/material.dart';
import '../widgets/responsive_header.dart';
import '../widgets/mobile_drawer.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 800;

    return Scaffold(
      appBar: const ResponsiveHeader(),
      endDrawer: isMobile ? const MobileDrawer() : null,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Text(
            "Welcome to Home Page 🌐",
            style: TextStyle(
              fontSize: isMobile ? 24 : 36,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}

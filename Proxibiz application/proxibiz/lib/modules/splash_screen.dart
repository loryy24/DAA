import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'location_page.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  final List<IconData> icons = [
    Icons.location_on,
    Icons.search,
    Icons.store,
    Icons.route,
    Icons.business,
    Icons.map,
    Icons.pin_drop,
    Icons.place,
    Icons.navigation,
    Icons.zoom_in_map,
  ];

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );

    _scaleAnimation = Tween<double>(begin: 0.2, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOutExpo),
    );

    _controller.forward();

    Timer(const Duration(seconds: 5), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const LocationPage()),
      );
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  /// Génère des icônes dispersées aléatoirement
  List<Widget> _buildScatteredIcons(Size size) {
    final random = Random();
    final colors = [
      Colors.deepPurple.shade300,
      Colors.blue.shade300,
      Colors.green.shade300,
      Colors.purple.shade200,
      Colors.indigo.shade300,
      Colors.teal.shade300,
      Colors.pink.shade200,
    ];

    return List.generate(30, (index) {
      final icon = icons[random.nextInt(icons.length)];
      final top = random.nextDouble() * size.height;
      final left = random.nextDouble() * size.width;
      final color = colors[random.nextInt(colors.length)];

      return Positioned(
        top: top,
        left: left,
        child: Icon(
          icon,
          color: color.withOpacity(0.5), // Visibles mais pas trop flashy
          size: 30 + random.nextDouble() * 10,
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      body: Stack(
        children: [
          // Dégradé violet léger
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFFFFFFFF), Color(0xFF9B97A3)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ),

          // Icônes décoratives éparpillées
          ..._buildScatteredIcons(size),

          // Contenu centré
          Center(
            child: ScaleTransition(
              scale: _scaleAnimation,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Image.asset(
                    'assets/logo.png', // Mets le bon chemin
                    height: 200,
                    width: 200,
                  ),
                  const SizedBox(height: 28),
                  const Text(
                    'Bienvenue dans Proxibiz',
                    style: TextStyle(
                      fontSize: 20,
                      color: Color(0xFF6A1B9A), // Violet profond
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 160),
                  const CircularProgressIndicator(color: Color(0xFF6A1B9A)),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

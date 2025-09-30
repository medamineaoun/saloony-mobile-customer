import 'dart:async';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:saloony/core/constants/app_routes.dart';

class SaloonySplashPage extends StatefulWidget {
  const SaloonySplashPage({Key? key}) : super(key: key);

  @override
  State<SaloonySplashPage> createState() => _SaloonySplashPageState();
}

class _SaloonySplashPageState extends State<SaloonySplashPage>
    with TickerProviderStateMixin {
  late AnimationController _mainController;
  late AnimationController _scissorsController;
  late AnimationController _sparkleController;
  
  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scissorsRotation;
  late Animation<double> _underlineWidth;
  
  final List<Animation<double>> _letterAnimations = [];
  final List<Animation<double>> _sparkleAnimations = [];

  @override
  void initState() {
    super.initState();
    _setupAnimations();
    _startAnimations();
    
    // Redirection après 4 secondes - avec vérification mounted
    Timer(const Duration(seconds: 4), () {
      if (mounted) {
      Navigator.pushReplacementNamed(context, AppRoutes.signIn);
      }
    });
  }

  void _setupAnimations() {
    // Animation principale
    _mainController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    );

    // Animation des ciseaux
    _scissorsController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 3000),
    );

    // Animation des étincelles
    _sparkleController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    );

    _scaleAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _mainController,
      curve: Curves.elasticOut,
    ));

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _mainController,
      curve: const Interval(0.0, 0.6, curve: Curves.easeInOut),
    ));

    _scissorsRotation = Tween<double>(
      begin: 0.0,
      end: 2 * math.pi,
    ).animate(CurvedAnimation(
      parent: _scissorsController,
      curve: Curves.easeInOut,
    ));

    _underlineWidth = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _mainController,
      curve: const Interval(0.7, 1.0, curve: Curves.easeOut),
    ));

    // Animations des lettres
    const String logoText = "Saloony";
    for (int i = 0; i < logoText.length; i++) {
      final double start = 0.2 + (i * 0.1);
      final double end = (0.6 + (i * 0.1)).clamp(0.0, 1.0);

      _letterAnimations.add(
        Tween<double>(begin: 0.0, end: 1.0).animate(
          CurvedAnimation(
            parent: _mainController,
            curve: Interval(start, end, curve: Curves.elasticOut),
          ),
        ),
      );
    }

    // Animations des étincelles
    for (int i = 0; i < 6; i++) {
      final double start = i * 0.1;
      final double end = (0.5 + (i * 0.1)).clamp(0.0, 1.0);

      _sparkleAnimations.add(
        Tween<double>(begin: 0.0, end: 1.0).animate(
          CurvedAnimation(
            parent: _sparkleController,
            curve: Interval(start, end, curve: Curves.easeInOut),
          ),
        ),
      );
    }
  }

  void _startAnimations() {
    _mainController.forward();
    
    Timer(const Duration(milliseconds: 500), () {
      if (mounted) {
        _scissorsController.repeat();
      }
    });
    
    Timer(const Duration(milliseconds: 1000), () {
      if (mounted) {
        _sparkleController.repeat(reverse: true);
      }
    });
  }

  @override
  void dispose() {
    _mainController.dispose();
    _scissorsController.dispose();
    _sparkleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF1A365D),
              Color(0xFF2D5282),
              Color(0xFF3182CE),
            ],
          ),
        ),
        child: SafeArea(
          child: Center(
            child: AnimatedBuilder(
              animation: _mainController,
              builder: (context, child) {
                return FadeTransition(
                  opacity: _fadeAnimation,
                  child: ScaleTransition(
                    scale: _scaleAnimation,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Logo principal avec ciseaux
                        SizedBox(
                          width: 300,
                          height: 100,
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              // Ciseaux animés
                              Positioned(
                                left: 20,
                                top: 10,
                                child: AnimatedBuilder(
                                  animation: _scissorsController,
                                  builder: (context, child) {
                                    return Transform.rotate(
                                      angle: _scissorsRotation.value * 0.1,
                                      child: const Icon(
                                        Icons.content_cut,
                                        size: 35,
                                        color: Color(0xFFFFD700),
                                      ),
                                    );
                                  },
                                ),
                              ),
                              
                              // Texte du logo
                              _buildAnimatedText(),
                            ],
                          ),
                        ),
                        
                        const SizedBox(height: 20),
                        
                        // Sous-titre
                        AnimatedBuilder(
                          animation: _mainController,
                          builder: (context, child) {
                            return Opacity(
                              opacity: _fadeAnimation.value,
                              child: const Text(
                                "",
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.white70,
                                  letterSpacing: 1.2,
                                ),
                              ),
                            );
                          },
                        ),
                        
                        const SizedBox(height: 40),
                        
                        // Indicateur de chargement
                        AnimatedBuilder(
                          animation: _sparkleController,
                          builder: (context, child) {
                            return Opacity(
                              opacity: _fadeAnimation.value,
                              child: const SizedBox(
                                width: 30,
                                height: 30,
                                child: CircularProgressIndicator(
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                    Color(0xFFFFD700),
                                  ),
                                  strokeWidth: 2,
                                ),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAnimatedText() {
    const String logoText = "Saloony";
    
    return Stack(
      alignment: Alignment.center,
      children: [
        // Texte principal
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: logoText.split('').asMap().entries.map((entry) {
            int index = entry.key;
            String letter = entry.value;
            
            return AnimatedBuilder(
              animation: _letterAnimations.length > index 
                ? _letterAnimations[index] 
                : _mainController,
              builder: (context, child) {
                double animValue = _letterAnimations.length > index 
                  ? _letterAnimations[index].value 
                  : _fadeAnimation.value;
                
                return Transform.translate(
                  offset: Offset(0, (1 - animValue) * 30),
                  child: Opacity(
                    opacity: animValue,
                    child: Text(
                      letter,
                      style: TextStyle(
                        fontSize: 48,
                        fontWeight: FontWeight.w600,
                        color: index == 0 ? const Color(0xFFFFD700) : Colors.white,
                        letterSpacing: -1,
                        shadows: const [
                          Shadow(
                            offset: Offset(0, 4),
                            blurRadius: 8,
                            color: Colors.black38,
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            );
          }).toList(),
        ),
        
        // Ligne de soulignement animée
        Positioned(
          bottom: -8,
          child: AnimatedBuilder(
            animation: _underlineWidth,
            builder: (context, child) {
              return Container(
                width: 200 * _underlineWidth.value,
                height: 3,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFFFFD700), Color(0xFFFFED4E)],
                  ),
                  borderRadius: BorderRadius.circular(2),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

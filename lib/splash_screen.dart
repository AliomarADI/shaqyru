import 'package:flutter/material.dart';
import 'package:shaqyru/welcome_screen.dart';

class WeddingSplashScreen extends StatefulWidget {
  final VoidCallback onAnimationComplete;

  const WeddingSplashScreen({Key? key, required this.onAnimationComplete})
    : super(key: key);

  @override
  State<WeddingSplashScreen> createState() => _WeddingSplashScreenState();
}

class _WeddingSplashScreenState extends State<WeddingSplashScreen>
    with TickerProviderStateMixin {
  late AnimationController _fadeController;
  late AnimationController _scaleController;
  late AnimationController _rotateController;

  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;
  late Animation<double> _rotateAnimation;

  @override
  void initState() {
    super.initState();

    // Анимация прозрачности
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );

    // Анимация масштаба
    _scaleController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    // Анимация поворота
    _rotateController = AnimationController(
      duration: const Duration(milliseconds: 3000),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _fadeController, curve: Curves.easeInOut),
    );

    _scaleAnimation = Tween<double>(begin: 0.5, end: 1.0).animate(
      CurvedAnimation(parent: _scaleController, curve: Curves.elasticOut),
    );

    _rotateAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _rotateController, curve: Curves.easeInOut),
    );

    // Запуск анимаций появления
    _startEntranceAnimations();

    // Автоматическое исчезновение через 4 секунды
    Future.delayed(const Duration(seconds: 4), () {
      _startExitAnimations();
    });
  }

  void _startEntranceAnimations() {
    _fadeController.forward();
    _scaleController.forward();
    _rotateController.repeat();
  }

  void _startExitAnimations() {
    // Анимация исчезновения
    _fadeController.reverse().then((_) {
      widget.onAnimationComplete();
    });

    // Уменьшение масштаба при исчезновении
    _scaleController.animateTo(0.8);
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _scaleController.dispose();
    _rotateController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F4F0),
      body: AnimatedBuilder(
        animation: Listenable.merge([
          _fadeAnimation,
          _scaleAnimation,
          _rotateAnimation,
        ]),
        builder: (context, child) {
          return FadeTransition(
            opacity: _fadeAnimation,
            child: Transform.scale(
              scale: _scaleAnimation.value,
              child: Container(
                width: double.infinity,
                height: double.infinity,
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [Color(0xFFF8F4F0), Color(0xFFE8DDD4)],
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Stack(
                      alignment: Alignment.center,
                      children: [
                        Transform.rotate(
                          angle: _rotateAnimation.value * 2 * 3.14159,
                          child: Container(
                            width: 120,
                            height: 120,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: const Color(0xFFD4AF37),
                                width: 3,
                              ),
                            ),
                          ),
                        ),
                        Transform.rotate(
                          angle: -_rotateAnimation.value * 2 * 3.14159,
                          child: Container(
                            width: 80,
                            height: 80,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: const Color(0xFFD4AF37),
                                width: 2,
                              ),
                            ),
                          ),
                        ),

                        const Icon(
                          Icons.favorite,
                          size: 40,
                          color: Color(0xFFD4AF37),
                        ),
                      ],
                    ),
                    const SizedBox(height: 40),
                    const Text(
                      'Тойға шақыру',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.w300,
                        color: Color(0xFF8B4513),
                        height: 1.2,
                      ),
                    ),
                    const SizedBox(height: 20),
                    Container(
                      width: 120,
                      height: 2,
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [
                            Color(0xFFD4AF37),
                            Color(0xFFF4E4BC),
                            Color(0xFFD4AF37),
                          ],
                        ),
                        borderRadius: BorderRadius.circular(1),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      'Асыға күтеміз',
                      style: TextStyle(
                        fontSize: 16,
                        fontStyle: FontStyle.italic,
                        color: Color(0xFF8B4513).withOpacity(0.8),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

// Пример использования в main.dart
class WeddingApp extends StatefulWidget {
  @override
  State<WeddingApp> createState() => _WeddingAppState();
}

class _WeddingAppState extends State<WeddingApp> {
  bool _showSplash = true;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Wedding Invitation',
      home:
          _showSplash
              ? WeddingSplashScreen(
                onAnimationComplete: () {
                  setState(() {
                    _showSplash = false;
                  });
                },
              )
              : WelcomeScreen(),
    );
  }
}

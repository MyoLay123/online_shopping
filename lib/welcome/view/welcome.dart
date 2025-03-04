import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:online_shop/l10n/l10n.dart';
import 'package:online_shop/route_path.dart';

class WelcomePage extends StatelessWidget {
  const WelcomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final welcomeL10n = context.welcomeL10n;

    return Scaffold(
      body: Stack(
        children: [
          // Background Image (Replace with your image asset)
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage(
                  'assets/images/start_shoe.jpg',
                ), // Replace with your image path
                fit: BoxFit.cover,
              ),
            ),
          ).animate().fadeIn(duration: 1000.ms),
          // Gradient Overlay (Optional, for the wavy effect)
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.bottomCenter,
                end: Alignment.topCenter,
                colors: [
                  Colors.black.withValues(
                    alpha: 0.7,
                  ),
                  Colors.transparent,
                ],
              ),
            ),
          ),

          // Content Overlay
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(
                24,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    welcomeL10n.line1,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 36,
                      fontWeight: FontWeight.bold,
                      height: 1.2,
                    ),
                  ).animate().slideY(
                        begin: 0.5,
                        end: 0,
                        duration: 500.ms,
                        curve: Curves.easeInOut,
                      ),
                  Text(
                    welcomeL10n.line2,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 36,
                      fontWeight: FontWeight.bold,
                      height: 1.2,
                    ),
                  ).animate().slideY(
                        begin: 0.5,
                        end: 0,
                        delay: 100.ms,
                        duration: 500.ms,
                        curve: Curves.easeInOut,
                      ),
                  const SizedBox(height: 12).animate().fade(duration: 300.ms),
                  Text(
                    welcomeL10n.slogan,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                    ),
                  ).animate().fadeIn(
                        delay: 200.ms,
                        duration: 500.ms,
                        curve: Curves.easeInOut,
                      ),
                  const SizedBox(height: 55).animate().fade(duration: 300.ms),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pushNamed(
                          context,
                          RoutePath.product,
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Theme.of(context).colorScheme.primary,
                        foregroundColor:
                            Theme.of(context).colorScheme.onPrimary,
                        padding: const EdgeInsets.symmetric(
                          vertical: 20,
                        ),
                        textStyle: const TextStyle(fontSize: 18),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Text(
                        welcomeL10n.start,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  )
                      .animate()
                      .scaleY(
                        begin: 0,
                        end: 1,
                        duration: 400.ms,
                        curve: Curves.easeInOutBack,
                      )
                      .fadeIn(duration: 500.ms),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

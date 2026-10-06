import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/theme/neo_colors.dart';
import '../../core/theme/neo_shadows.dart';
import '../../core/theme/neo_typography.dart';
import '../../core/widgets/neo_bandaid_alarm_logo.dart';
import '../../core/widgets/neo_button.dart';
import '../../core/widgets/neo_card.dart';
import 'home_shell_screen.dart';

final hasSeenOnboardingProvider = StateProvider<bool>((ref) => false);

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<_OnboardingSlide> _slides = const [
    _OnboardingSlide(
      tag: 'PHILOSOPHY',
      title: 'PLAN LESS.\nLIVE MORE.',
      description:
          'Remember Me learns the difference between what you planned and what actually happened, creating adaptive schedules without guilt or micromanagement.',
      icon: Icons.auto_awesome,
      color: Color(0xFFF0C020),
    ),
    _OnboardingSlide(
      tag: 'ADAPTIVE COCKPIT',
      title: 'DYNAMIC\nCAPACITY',
      description:
          'Know what to do right now, what comes next, and your true available focus capacity with auto-adjusting recovery buffers.',
      icon: Icons.speed_rounded,
      color: Color(0xFF1040C0),
    ),
    _OnboardingSlide(
      tag: 'REAL-WORLD GNSS',
      title: 'LOCAL-FIRST\nJOURNEY ENGINE',
      description:
          'Track walking, running, and cycling with genuine street maps and jitter filtering. 100% on-device and privacy-first.',
      icon: Icons.map_rounded,
      color: Color(0xFFD02020),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final colors = context.neo;

    return Scaffold(
      backgroundColor: colors.canvas,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Column(
            children: [
              // Top Bar: Logo + Skip Button
              Row(
                children: [
                  NeoBandaidAlarmLogo(
                    size: 36,
                    alarmColor: colors.accentYellow,
                    bandaidColor: colors.accentRed,
                    borderColor: colors.border,
                  ),
                  const Spacer(),
                  GestureDetector(
                    onTap: _finishOnboarding,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                      decoration: BoxDecoration(
                        color: colors.surface,
                        border: Border.all(color: colors.border, width: 2),
                      ),
                      child: Text(
                        'SKIP',
                        style: NeoTypography.label(
                          color: colors.textSecondary,
                          fontSize: 11,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // Page Slider
              Expanded(
                child: PageView.builder(
                  controller: _pageController,
                  onPageChanged: (idx) => setState(() => _currentPage = idx),
                  itemCount: _slides.length,
                  itemBuilder: (context, index) {
                    final slide = _slides[index];
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Animated Hero Visual Card
                        NeoCard(
                          backgroundColor: slide.color,
                          borderColor: colors.border,
                          borderWidth: 3.5,
                          shadowOffset: const Offset(6, 6),
                          padding: const EdgeInsets.all(28),
                          child: Icon(
                            slide.icon,
                            size: 64,
                            color: slide.color == const Color(0xFFF0C020)
                                ? Colors.black
                                : Colors.white,
                          ),
                        ),
                        const SizedBox(height: 32),

                        // Tag
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          color: colors.accentRed,
                          child: Text(
                            slide.tag,
                            style: NeoTypography.label(
                              color: Colors.white,
                              fontSize: 10,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                        ),
                        const SizedBox(height: 14),

                        // Title
                        Text(
                          slide.title,
                          style: NeoTypography.display(
                            color: colors.textPrimary,
                            fontSize: 26,
                            fontWeight: FontWeight.w900,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 14),

                        // Description
                        Text(
                          slide.description,
                          style: NeoTypography.body(
                            color: colors.textSecondary,
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    );
                  },
                ),
              ),

              // Indicators & Action Button
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  _slides.length,
                  (i) => Container(
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    width: _currentPage == i ? 24 : 8,
                    height: 8,
                    decoration: BoxDecoration(
                      color: _currentPage == i ? colors.accentRed : colors.border,
                      border: Border.all(color: colors.border, width: 1.5),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 24),

              NeoButton(
                text: _currentPage == _slides.length - 1 ? 'GET STARTED →' : 'CONTINUE →',
                variant: NeoButtonVariant.accentYellow,
                isFullWidth: true,
                padding: const EdgeInsets.symmetric(vertical: 16),
                fontSize: 14,
                onPressed: () {
                  if (_currentPage < _slides.length - 1) {
                    _pageController.nextPage(
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeInOut,
                    );
                  } else {
                    _finishOnboarding();
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _finishOnboarding() {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (_) => const HomeShellScreen()),
    );
  }
}

class _OnboardingSlide {
  const _OnboardingSlide({
    required this.tag,
    required this.title,
    required this.description,
    required this.icon,
    required this.color,
  });

  final String tag;
  final String title;
  final String description;
  final IconData icon;
  final Color color;
}

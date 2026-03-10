import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';

/// Blue petal-shaped confetti overlay that fires when triggered.
class FocusConfettiOverlay extends StatefulWidget {
  const FocusConfettiOverlay({
    super.key,
    required this.trigger,
    required this.child,
    this.shouldPlay = true,
  });

  /// Increment this value to fire confetti again.
  final int trigger;

  /// Whether confetti should actually play when trigger changes.
  final bool shouldPlay;
  final Widget child;

  @override
  State<FocusConfettiOverlay> createState() => _FocusConfettiOverlayState();
}

class _FocusConfettiOverlayState extends State<FocusConfettiOverlay> {
  late final ConfettiController _confettiController;

  @override
  void initState() {
    super.initState();
    _confettiController = ConfettiController(
      duration: const Duration(seconds: 3),
    );
  }

  @override
  void didUpdateWidget(covariant FocusConfettiOverlay oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.trigger > oldWidget.trigger &&
        widget.trigger > 0 &&
        widget.shouldPlay) {
      _confettiController.play();
    }
  }

  @override
  void dispose() {
    _confettiController.dispose();
    super.dispose();
  }

  /// Custom petal-shaped path for confetti particles.
  Path _petalPath(Size size) {
    final path = Path();
    final w = size.width;
    final h = size.height;
    path.moveTo(w / 2, 0);
    path.quadraticBezierTo(w, h * 0.3, w / 2, h);
    path.quadraticBezierTo(0, h * 0.3, w / 2, 0);
    path.close();
    return path;
  }

  static const _blueShades = <Color>[
    Color(0xFF3DA8AF),
    Color(0xFF2F4158),
    Color(0xFF5BC0C8),
    Color(0xFF7DD3D8),
    Color(0xFFC7CED7),
  ];

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        widget.child,
        Align(
          alignment: Alignment.topCenter,
          child: ConfettiWidget(
            confettiController: _confettiController,
            blastDirectionality: BlastDirectionality.explosive,
            numberOfParticles: 30,
            minBlastForce: 8,
            gravity: 0.15,
            emissionFrequency: 0.05,
            createParticlePath: _petalPath,
            colors: _blueShades,
          ),
        ),
      ],
    );
  }
}

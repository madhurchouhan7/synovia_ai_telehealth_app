import 'package:flutter/material.dart';

/// A widget that animates its child into view with a slide and fade effect.
class AnimatedEntrance extends StatefulWidget {
  /// The widget to be animated.
  final Widget child;

  /// The total duration of the slide and fade animation.
  final Duration animationDuration;

  /// The delay before the animation starts. Useful for staggering effects.
  final Duration delay;

  /// The starting offset for the slide animation.
  /// E.g., Offset(0, 0.5) to slide up from 50% below.
  /// E.g., Offset(-0.5, 0) to slide right from 50% to the left.
  final Offset slideBegin;

  /// The curve for the slide animation.
  final Curve slideCurve;

  /// The curve for the fade animation.
  final Curve fadeCurve;

  const AnimatedEntrance({
    super.key,
    required this.child,
    this.animationDuration = const Duration(milliseconds: 700), // Default animation duration
    this.delay = Duration.zero, // Default no delay
    this.slideBegin = const Offset(0, 0.5), // Default: slide up from 50% below
    this.slideCurve = Curves.easeOutCubic, // Default slide curve
    this.fadeCurve = Curves.easeIn, // Default fade curve
  });

  @override
  State<AnimatedEntrance> createState() => _AnimatedEntranceState();
}

class _AnimatedEntranceState extends State<AnimatedEntrance> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: widget.animationDuration,
    );

    _slideAnimation = Tween<Offset>(
      begin: widget.slideBegin,
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: widget.slideCurve,
    ));

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: widget.fadeCurve,
      ),
    );

    // Apply the delay before starting the animation
    Future.delayed(widget.delay, () {
      if (mounted) { // Ensure the widget is still in the tree before starting animation
        _animationController.forward();
      }
    });
  }

  @override
  void dispose() {
    _animationController.dispose(); // Dispose the controller to prevent memory leaks
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _fadeAnimation,
      child: SlideTransition(
        position: _slideAnimation,
        child: widget.child,
      ),
    );
  }
}
import 'package:flutter/material.dart';

/// Fades and lifts [child] into place during its slice of [animation].
///
/// Several of these share one controller, each with a later [start], so a
/// screen settles in piece by piece.
class StaggeredEntrance extends StatelessWidget {
  const StaggeredEntrance({
    required this.animation,
    required this.start,
    required this.child,
    this.end = 1,
    super.key,
  });

  final Animation<double> animation;

  /// Where in [animation] (0 to 1) this child begins and finishes moving.
  final double start;
  final double end;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final curved = CurvedAnimation(
      parent: animation,
      curve: Interval(start, end, curve: Curves.easeOutCubic),
    );
    return FadeTransition(
      opacity: curved,
      child: SlideTransition(
        position: Tween(
          begin: const Offset(0, 0.15),
          end: Offset.zero,
        ).animate(curved),
        child: child,
      ),
    );
  }
}

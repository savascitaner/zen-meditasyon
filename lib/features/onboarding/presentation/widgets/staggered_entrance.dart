import 'package:flutter/material.dart';

/// Fades and lifts [child] into place during its slice of [animation].
///
/// Several of these share one controller, each with a later [start], so a
/// screen settles in piece by piece.
class StaggeredEntrance extends StatefulWidget {
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
  State<StaggeredEntrance> createState() => _StaggeredEntranceState();
}

class _StaggeredEntranceState extends State<StaggeredEntrance> {
  // A CurvedAnimation listens to its parent, so it is created once here and
  // disposed with this state rather than rebuilt on every build.
  late CurvedAnimation _curved;
  late Animation<Offset> _slide;

  @override
  void initState() {
    super.initState();
    _createCurve();
  }

  @override
  void didUpdateWidget(StaggeredEntrance oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.animation != widget.animation ||
        oldWidget.start != widget.start ||
        oldWidget.end != widget.end) {
      _curved.dispose();
      _createCurve();
    }
  }

  void _createCurve() {
    _curved = CurvedAnimation(
      parent: widget.animation,
      curve: Interval(widget.start, widget.end, curve: Curves.easeOutCubic),
    );
    _slide = Tween(
      begin: const Offset(0, 0.15),
      end: Offset.zero,
    ).animate(_curved);
  }

  @override
  void dispose() {
    _curved.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _curved,
      child: SlideTransition(position: _slide, child: widget.child),
    );
  }
}

/// Adds up how long the user really listened.
///
/// Position updates that jump (seeking, the 15 second skips) are ignored, so
/// skipping ahead cannot complete a session.
class ListenTracker {
  /// Larger jumps between two position updates are treated as a seek.
  static const maxStep = Duration(seconds: 5);

  Duration _listened = Duration.zero;
  Duration _last = Duration.zero;

  Duration get listened => _listened;

  void onPosition(Duration position, {required bool playing}) {
    final step = position - _last;
    _last = position;
    if (!playing) return;
    if (step > Duration.zero && step <= maxStep) _listened += step;
  }

  void reset() {
    _listened = Duration.zero;
    _last = Duration.zero;
  }
}

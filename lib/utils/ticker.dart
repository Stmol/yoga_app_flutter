import 'dart:async';

class Ticker {
  Ticker() {
    _stopwatch = Stopwatch();
  }

  Stopwatch _stopwatch;
  Timer _timer;

  StreamController<Duration> _currentDuration = StreamController<Duration>.broadcast(sync: true);

  Stream<Duration> get currentDuration => _currentDuration.stream.asBroadcastStream();

  bool get isRunning => _timer != null;

  void _onTick(Timer timer) {
    _currentDuration.add(_stopwatch.elapsed);
  }

  void start() {
    if (_timer != null) return;

    _timer = Timer.periodic(Duration(seconds: 1), _onTick);
    _stopwatch.start();
  }

  void stop() {
    _timer?.cancel();
    _timer = null;
    _stopwatch.stop();
  }

  void reset() {
    stop();
    _stopwatch.reset();
  }

  void dispose() {
    _currentDuration.close();
    _timer?.cancel();
  }
}

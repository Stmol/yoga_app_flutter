import 'dart:math';

String asanasCount(final int count) {
  //final words = ['асана', 'асаны', 'асан'];
  final words = ['asana', 'asanas', 'asanas'];

  final index = count % 100 > 4 && count % 100 < 20
      ? 2
      : [2, 0, 1, 1, 1, 2][min(count % 10, 5)];

  return '$count ${words[index]}';
}

String classroomTimeRounded(final Duration duration) {
  if (duration.inHours > 0) {
    return '${duration.inHours} h.';
  }

  final seconds = duration.inSeconds;

  if (duration.inMinutes <= 0) {
    return '$seconds sec.';
  }

  return '${(seconds / 60).round()} min.';
}

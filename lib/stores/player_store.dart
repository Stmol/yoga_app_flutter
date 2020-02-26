import 'dart:async';

import 'package:audioplayers/audio_cache.dart';
import 'package:flutter/foundation.dart';
import 'package:mobx/mobx.dart';
import 'package:my_yoga_fl/models/classroom_model.dart';
import 'package:my_yoga_fl/utils/ticker.dart';
import 'package:wakelock/wakelock.dart';

part 'player_store.g.dart';

class PlayerStore = PlayerStoreBase with _$PlayerStore;

abstract class PlayerStoreBase with Store {
  static const BEGIN_DURATION = Duration(seconds: 3);

  PlayerStoreBase(ClassroomModel classroom)
      : assert(classroom != null),
        assert(classroom.classroomRoutines.isNotEmpty),
        _classroom = classroom {
    _updatePlayerSubscription = _ticker.currentDuration.listen((d) => _tickCurrentTimer(d));
    _updateTotalTimerSubscription = _ticker.currentDuration.listen((d) => _tickTotalTimer(d));

    _isPlayingReaction = reaction((_) => isPlaying, (isPlaying) {
      _switchWakelockMode(isPlaying);

      if (playerPhase == PlayerPhase.finish) {
        _ticker.reset();

        return;
      }

      isPlaying == false ? _ticker.stop() : _ticker.start();
    });

    // Reaction to changes item in queue
    _queueItemShiftReaction = reaction((_) => _currentQueueItemIndex, (_) {
//      if (currentQueueItem.hasAsana) { FIXME: Better approach to switch current asana
//        currentAsanaUName = currentQueueItem.asanaUniqueName;
//      }

      _playTimerSound();

      if (playerPhase == PlayerPhase.finish) {
        isPlaying = false; // FIXME: Are you sure?
      }

      _updateCurrentTimerDuration();
    });

    _queue = _initQueue();
    totalTimer = _getTotalLeftDuration(_queue, _currentQueueItemIndex);

    // TODO: Insert here your own sound file
//    _audioCache.load('Notification.m4a').then((_) {
//      _isSoundsLoaded = true;
//    }).catchError((error) {
//      _isSoundsLoaded = false;
//      Log.error(error);
//    });

    //isPlaying = true; //TODO: Auto start?
  }

  final ClassroomModel _classroom;
  final AudioCache _audioCache = AudioCache(prefix: 'audio/');

  @observable
  bool isPlaying = false;

  @observable
  Duration totalTimer;

  @observable
  int _currentQueueItemIndex = 0;

  ///
  /// Duration to display in the text widget of timer
  ///
  @observable
  Duration currentTimerDuration = BEGIN_DURATION;

  bool _isSoundsLoaded = false;

  Ticker _ticker = Ticker();
  List<PlayerQueueItem> _queue;

  ReactionDisposer _isPlayingReaction;
  ReactionDisposer _queueItemShiftReaction;
  StreamSubscription _updatePlayerSubscription;
  StreamSubscription _updateTotalTimerSubscription;

  PlayerQueueItem get currentQueueItem =>
      _currentQueueItemIndex > _queue.length - 1 ? null : _queue[_currentQueueItemIndex];

  List<String> get asanasUniqueNamesInQueue => _queue
      .where((item) => item.hasAsana)
      .map((item) => item.asanaUniqueName)
      .toList(growable: false);

  PlayerQueueItem get nextQueueItemWithAsana {
    return _queue.skip(_currentQueueItemIndex).firstWhere((item) => item.hasAsana);
  }

  @computed
  bool get isFinished => playerPhase == PlayerPhase.finish && isPlaying == false;

  @computed
  bool get isSkipEnabled => ![PlayerPhase.finish].contains(playerPhase);

  @computed
  bool get isRewindEnabled => ![PlayerPhase.begin, PlayerPhase.finish].contains(playerPhase);

  @computed
  PlayerPhase get playerPhase {
    if (_currentQueueItemIndex < 0 || _currentQueueItemIndex >= _queue.length) {
      return PlayerPhase.finish;
    }

    return _queue[_currentQueueItemIndex].phase;
  }

  @computed
  int get currentAsanaBlockIndex {
    if (currentQueueItem.hasAsana == false) {
      return null;
    }

    return _queue.take(_currentQueueItemIndex).fold(0, (prevIndex, el) {
      return el.hasAsana ? prevIndex + 1 : prevIndex;
    });
  }

  @computed
  String get currentAsanaUniqueName {
    if (currentQueueItem.hasAsana) {
      return currentQueueItem.asanaUniqueName;
    }

    // If player finished it have to show last asana
    if (currentQueueItem.isFinished) {
      return _queue.lastWhere((item) => item.hasAsana).asanaUniqueName;
    }

    return null;
  }

  // FIXME: Use this memoized field instead [currentAsanaUniqueName] when pause blocks will be added to screen
  //@observable
  //String currentAsanaUName;

  @action
  void pausePlayer() {
    if (_ticker.isRunning == true && isPlaying == true && playerPhase != PlayerPhase.finish) {
      isPlaying = false;
    }
  }

  @action
  void startPlayer() {
    if (_ticker.isRunning == false && isPlaying == false && playerPhase != PlayerPhase.finish) {
      isPlaying = true;
    }
  }

  @action
  void _tickTotalTimer(Duration duration) {
    // Don't tick if we are at start or at end
    if ([PlayerPhase.begin, PlayerPhase.finish].contains(playerPhase)) {
      return;
    }

    final newTime = totalTimer - Duration(seconds: 1);
    if (newTime.isNegative == false) {
      totalTimer = newTime;
    } else {
      totalTimer = Duration.zero;
    }
  }

  @action
  void _tickCurrentTimer(Duration duration) {
    currentTimerDuration -= Duration(seconds: 1);

    if (currentTimerDuration.isNegative == true) {
      _currentQueueItemIndex++;
    }
  }

  ///
  /// Skip current block (Next button)
  ///
  @action
  void skipCurrentPhase() {
    if (isSkipEnabled == false) {
      return;
    }

    pausePlayer(); // TODO: Action inside another action?

    _currentQueueItemIndex++;
    totalTimer = _getTotalLeftDuration(_queue, _currentQueueItemIndex);
  }

  @action
  void rewindCurrentPhaseOrGoBack() {
    if (isRewindEnabled == false) {
      return;
    }

    pausePlayer(); // TODO: Action inside another action?

    if (currentTimerDuration == currentQueueItem.duration) {
      _currentQueueItemIndex--;
    } else {
      // TODO: This is so declarative :(
      _updateCurrentTimerDuration();
    }

    totalTimer = _getTotalLeftDuration(_queue, _currentQueueItemIndex);
  }

  @action
  void _updateCurrentTimerDuration() {
    if (currentQueueItem == null) {
      currentTimerDuration = Duration.zero;

      return;
    }

    switch (currentQueueItem.phase) {
      case PlayerPhase.begin:
        currentTimerDuration = BEGIN_DURATION;
        break;
      case PlayerPhase.asana:
      case PlayerPhase.chill:
        currentTimerDuration = currentQueueItem.duration;
        break;
      case PlayerPhase.finish:
        currentTimerDuration = Duration.zero;
        break;
    }
  }

  /// Calculate total time of current block list
  ///
  /// Looks like this operation is very expensive, try to avoid using it
  ///
  /// Alert: the next block is switch when timer goes to the negative value
  Duration _getTotalLeftDuration(List<PlayerQueueItem> blocks, int currentBlockIndex) {
    if (currentBlockIndex >= blocks.length - 1 || blocks[currentBlockIndex].isFinished) {
      return Duration.zero;
    }

    final blocksLeftCount = blocks
        .skip(currentBlockIndex)
        .takeWhile(
          (b) => b.isFinished == false,
        )
        .length;

    // This is because we have extra seconds between blocks
    final Duration startDuration = Duration(seconds: blocksLeftCount - 1);

    return blocks.skip(currentBlockIndex).fold(startDuration, (prev, el) {
      return prev + (el.phase == PlayerPhase.begin ? Duration.zero : el.duration);
    });
  }

  List<PlayerQueueItem> _initQueue() {
    List<PlayerQueueItem> blocks = [PlayerQueueItem.begin(duration: BEGIN_DURATION)];

    for (int i = 0; i < _classroom.classroomRoutines.length; i++) {
      if (i > 0 && _classroom.timeBetweenAsanas > 0) {
        blocks.add(PlayerQueueItem(
          phase: PlayerPhase.chill,
          duration: _classroom.durationBetweenAsanas,
        ));
      }

      blocks.add(PlayerQueueItem(
        phase: PlayerPhase.asana,
        duration: _classroom.classroomRoutines[i].asanaDuration,
        asanaUniqueName: _classroom.classroomRoutines[i].asanaUniqueName,
      ));
    }

    blocks.add(PlayerQueueItem.finish());

    return blocks.toList(growable: false);
  }

  /// Turn on/off the device screen's infinite mode
  void _switchWakelockMode(bool isOn) {
    Wakelock.toggle(on: isOn);
  }

  void _playTimerSound() {
    if (_isSoundsLoaded == false) {
      return;
    }

    if (isPlaying == false) {
      return;
    }

    if (currentQueueItem.isFinished == true) {
      return;
    }

    // TODO: Insert here your own audio file
    //_audioCache.play('Notification.m4a');
  }

  void dispose() {
    _audioCache.clearCache();

    _isPlayingReaction();
    _queueItemShiftReaction();

    _updatePlayerSubscription.cancel();
    _updateTotalTimerSubscription.cancel();

    _ticker.dispose();

    Wakelock.disable();
  }
}

enum PlayerPhase { begin, asana, chill, finish }

///
/// Element of queue in player
///
class PlayerQueueItem {
  PlayerQueueItem({
    @required this.phase,
    @required this.duration,
    this.asanaUniqueName,
  })  : assert(phase != null),
        assert(duration != null) {
    if (phase == PlayerPhase.asana) {
      assert(asanaUniqueName != null);
      assert(asanaUniqueName.isNotEmpty);
    }
  }

  const PlayerQueueItem.finish()
      : phase = PlayerPhase.finish,
        duration = Duration.zero,
        asanaUniqueName = null;

  const PlayerQueueItem.begin({@required Duration duration})
      : assert(duration != null),
        phase = PlayerPhase.begin,
        duration = duration,
        asanaUniqueName = null;

  final Duration duration;
  final PlayerPhase phase;
  final String asanaUniqueName;

  bool get hasAsana => phase == PlayerPhase.asana && asanaUniqueName != null;

  bool get isChilling => phase == PlayerPhase.chill;

  bool get isFinished => phase == PlayerPhase.finish;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PlayerQueueItem &&
          runtimeType == other.runtimeType &&
          duration == other.duration &&
          phase == other.phase &&
          asanaUniqueName == other.asanaUniqueName;

  @override
  int get hashCode => duration.hashCode ^ phase.hashCode ^ asanaUniqueName.hashCode;
}

import 'dart:async';

import 'package:built_collection/built_collection.dart';
import 'package:flutter/foundation.dart';
import 'package:mobx/mobx.dart';
import 'package:my_yoga_fl/models/asana_model.dart';
import 'package:my_yoga_fl/utils/ticker.dart';
import 'package:wakelock/wakelock.dart';
import '../extensions/duration_extensions.dart';

part 'player_store.g.dart';

class PlayerStore = PlayerStoreBase with _$PlayerStore;

abstract class PlayerStoreBase with Store {
  static const ASANA_DURATION = Duration(seconds: 3);
  static const BEGIN_DURATION = Duration(seconds: 2);
  static const CHILL_DURATION = Duration(seconds: 2);

  PlayerStoreBase(List<AsanaModel> asanasInClassroom)
      : assert(asanasInClassroom.isNotEmpty),
        this.asanasInClassroom = BuiltList<AsanaModel>.from(asanasInClassroom) {
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

    _queueItemShiftReaction = reaction((_) => _currentQueueItemIndex, (_) {
      if (playerPhase == PlayerPhase.finish) {
        isPlaying = false; // FIXME: Are you sure?
      }

      _updateCurrentTimerDuration();
    });

    _queue = _initQueue();
    totalTimer = _getTotalLeftDuration(_queue, _currentQueueItemIndex);

    //isPlaying = true; //TODO: Auto start?
  }

  BuiltList<AsanaModel> asanasInClassroom;

  @observable
  bool isPlaying = false;

  @observable
  Duration totalTimer;

  @observable
  int _currentQueueItemIndex = 0;

  ///
  /// Duration to display in text widget of timer
  ///
  @observable
  Duration currentTimerDuration = BEGIN_DURATION;

  Ticker _ticker = Ticker();
  List<PlayerQueueItem> _queue;

  ReactionDisposer _isPlayingReaction;
  ReactionDisposer _queueItemShiftReaction;
  StreamSubscription _updatePlayerSubscription;
  StreamSubscription _updateTotalTimerSubscription;

  PlayerQueueItem get currentQueueItem =>
      _currentQueueItemIndex > _queue.length - 1 ? null : _queue[_currentQueueItemIndex];

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
  AsanaModel get currentAsana {
    // Skip() is here because we have to change [current asana] when chill phase appear
    final block = _queue.skip(_currentQueueItemIndex).firstWhere(
          (b) => b.hasAsana,
          orElse: () => _queue.lastWhere((b) => b.hasAsana),
        );

    return block?.asana; // FIXME: Null pointer exception possible
  }

//  @computed
//  double get currentTimeInPercent {
//    final total = _calculateTotalTimerDuration();
//
//    return ((total - totalTimer).inSeconds / total.inSeconds);
//  }

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
      // TODO Is it possible to set total timer to negative value? :-/
      totalTimer = newTime;
    } else {
      totalTimer = Duration.zero;
    }
  }

  @action
  void _tickCurrentTimer(Duration duration) {
    currentTimerDuration -= Duration(seconds: 1);
    //print("Current duration: ${currentTimerDuration.printAsTimer()}");

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
        currentTimerDuration = ASANA_DURATION;
        break;
      case PlayerPhase.chill:
        currentTimerDuration = CHILL_DURATION;
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
    final beginBlock = PlayerQueueItem.begin(duration: BEGIN_DURATION);
    List<PlayerQueueItem> blocks = [beginBlock];

    for (int i = 0; i < asanasInClassroom.length; i++) {
      if (i > 0) {
        blocks.add(PlayerQueueItem(phase: PlayerPhase.chill, duration: CHILL_DURATION));
      }

      blocks.add(PlayerQueueItem(
        phase: PlayerPhase.asana,
        duration: ASANA_DURATION,
        asana: asanasInClassroom[i],
      ));
    }

    blocks.add(PlayerQueueItem.finish());

    return blocks.toList(growable: false);
  }

  /// Turn on/off the device screen's infinite mode
  void _switchWakelockMode(bool isOn) {
    Wakelock.toggle(on: isOn);
  }

  void dispose() {
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
    this.asana,
  })  : assert(phase != null),
        assert(duration != null) {
    if (phase == PlayerPhase.asana) {
      assert(asana != null);
    }
  }

  const PlayerQueueItem.finish()
      : phase = PlayerPhase.finish,
        duration = Duration.zero,
        asana = null;

  const PlayerQueueItem.begin({@required Duration duration})
      : assert(duration != null),
        phase = PlayerPhase.begin,
        duration = duration,
        asana = null;

  final Duration duration;
  final PlayerPhase phase;
  final AsanaModel asana;

  bool get hasAsana => phase == PlayerPhase.asana && asana != null;

  bool get isChilling => phase == PlayerPhase.chill;

  bool get isFinished => phase == PlayerPhase.finish;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PlayerQueueItem &&
          runtimeType == other.runtimeType &&
          duration == other.duration &&
          phase == other.phase &&
          asana == other.asana;

  @override
  int get hashCode => duration.hashCode ^ phase.hashCode ^ asana.hashCode;
}

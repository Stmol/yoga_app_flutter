// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'player_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$PlayerStore on PlayerStoreBase, Store {
  Computed<bool> _$isFinishedComputed;

  @override
  bool get isFinished =>
      (_$isFinishedComputed ??= Computed<bool>(() => super.isFinished)).value;
  Computed<bool> _$isSkipEnabledComputed;

  @override
  bool get isSkipEnabled =>
      (_$isSkipEnabledComputed ??= Computed<bool>(() => super.isSkipEnabled))
          .value;
  Computed<bool> _$isRewindEnabledComputed;

  @override
  bool get isRewindEnabled => (_$isRewindEnabledComputed ??=
          Computed<bool>(() => super.isRewindEnabled))
      .value;
  Computed<PlayerPhase> _$playerPhaseComputed;

  @override
  PlayerPhase get playerPhase =>
      (_$playerPhaseComputed ??= Computed<PlayerPhase>(() => super.playerPhase))
          .value;
  Computed<int> _$currentAsanaBlockIndexComputed;

  @override
  int get currentAsanaBlockIndex => (_$currentAsanaBlockIndexComputed ??=
          Computed<int>(() => super.currentAsanaBlockIndex))
      .value;
  Computed<String> _$currentAsanaUniqueNameComputed;

  @override
  String get currentAsanaUniqueName => (_$currentAsanaUniqueNameComputed ??=
          Computed<String>(() => super.currentAsanaUniqueName))
      .value;

  final _$isPlayingAtom = Atom(name: 'PlayerStoreBase.isPlaying');

  @override
  bool get isPlaying {
    _$isPlayingAtom.context.enforceReadPolicy(_$isPlayingAtom);
    _$isPlayingAtom.reportObserved();
    return super.isPlaying;
  }

  @override
  set isPlaying(bool value) {
    _$isPlayingAtom.context.conditionallyRunInAction(() {
      super.isPlaying = value;
      _$isPlayingAtom.reportChanged();
    }, _$isPlayingAtom, name: '${_$isPlayingAtom.name}_set');
  }

  final _$totalTimerAtom = Atom(name: 'PlayerStoreBase.totalTimer');

  @override
  Duration get totalTimer {
    _$totalTimerAtom.context.enforceReadPolicy(_$totalTimerAtom);
    _$totalTimerAtom.reportObserved();
    return super.totalTimer;
  }

  @override
  set totalTimer(Duration value) {
    _$totalTimerAtom.context.conditionallyRunInAction(() {
      super.totalTimer = value;
      _$totalTimerAtom.reportChanged();
    }, _$totalTimerAtom, name: '${_$totalTimerAtom.name}_set');
  }

  final _$_currentQueueItemIndexAtom =
      Atom(name: 'PlayerStoreBase._currentQueueItemIndex');

  @override
  int get _currentQueueItemIndex {
    _$_currentQueueItemIndexAtom.context
        .enforceReadPolicy(_$_currentQueueItemIndexAtom);
    _$_currentQueueItemIndexAtom.reportObserved();
    return super._currentQueueItemIndex;
  }

  @override
  set _currentQueueItemIndex(int value) {
    _$_currentQueueItemIndexAtom.context.conditionallyRunInAction(() {
      super._currentQueueItemIndex = value;
      _$_currentQueueItemIndexAtom.reportChanged();
    }, _$_currentQueueItemIndexAtom,
        name: '${_$_currentQueueItemIndexAtom.name}_set');
  }

  final _$currentTimerDurationAtom =
      Atom(name: 'PlayerStoreBase.currentTimerDuration');

  @override
  Duration get currentTimerDuration {
    _$currentTimerDurationAtom.context
        .enforceReadPolicy(_$currentTimerDurationAtom);
    _$currentTimerDurationAtom.reportObserved();
    return super.currentTimerDuration;
  }

  @override
  set currentTimerDuration(Duration value) {
    _$currentTimerDurationAtom.context.conditionallyRunInAction(() {
      super.currentTimerDuration = value;
      _$currentTimerDurationAtom.reportChanged();
    }, _$currentTimerDurationAtom,
        name: '${_$currentTimerDurationAtom.name}_set');
  }

  final _$PlayerStoreBaseActionController =
      ActionController(name: 'PlayerStoreBase');

  @override
  void pausePlayer() {
    final _$actionInfo = _$PlayerStoreBaseActionController.startAction();
    try {
      return super.pausePlayer();
    } finally {
      _$PlayerStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void startPlayer() {
    final _$actionInfo = _$PlayerStoreBaseActionController.startAction();
    try {
      return super.startPlayer();
    } finally {
      _$PlayerStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void _tickTotalTimer(Duration duration) {
    final _$actionInfo = _$PlayerStoreBaseActionController.startAction();
    try {
      return super._tickTotalTimer(duration);
    } finally {
      _$PlayerStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void _tickCurrentTimer(Duration duration) {
    final _$actionInfo = _$PlayerStoreBaseActionController.startAction();
    try {
      return super._tickCurrentTimer(duration);
    } finally {
      _$PlayerStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void skipCurrentPhase() {
    final _$actionInfo = _$PlayerStoreBaseActionController.startAction();
    try {
      return super.skipCurrentPhase();
    } finally {
      _$PlayerStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void rewindCurrentPhaseOrGoBack() {
    final _$actionInfo = _$PlayerStoreBaseActionController.startAction();
    try {
      return super.rewindCurrentPhaseOrGoBack();
    } finally {
      _$PlayerStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void _updateCurrentTimerDuration() {
    final _$actionInfo = _$PlayerStoreBaseActionController.startAction();
    try {
      return super._updateCurrentTimerDuration();
    } finally {
      _$PlayerStoreBaseActionController.endAction(_$actionInfo);
    }
  }
}

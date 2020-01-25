import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mobx/mobx.dart';
import 'package:my_yoga_fl/extensions/duration_extensions.dart';
import 'package:my_yoga_fl/models/asana_model.dart';
import 'package:my_yoga_fl/models/classroom_model.dart';
import 'package:my_yoga_fl/stores/player_store.dart';

Color kAccentGrey = Colors.grey.shade700;
Color kShadedGrey = Colors.grey.shade300;

const Color kControlsIconColor = Color(0xFF3C3C59);
const Color kControlsLightGrey = Color(0xFFF1F1F4);

const Color kTimerActive = Color(0xFF405DC3);
const Color kTimerPause = Color(0xFFA52A22);

class PlayerMainScreen extends StatelessWidget {
  final ClassroomModel classroom;
  final PlayerStore playerStore;

  const PlayerMainScreen({
    Key key,
    @required this.classroom,
    @required this.playerStore,
  }) : super(key: key);

  Widget _totalTimer() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(50),
        color: kAccentGrey,
      ),
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 3),
      child: Observer(
        builder: (_) => Text(
          playerStore.totalTimer.printAsTimer(),
          style: GoogleFonts.montserrat(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            letterSpacing: 2.0,
          ),
        ),
      ),
    );
  }

  Widget _exitAppBarButton(BuildContext context) {
    return IconButton(
      padding: EdgeInsets.all(0),
      alignment: Alignment.centerLeft,
      iconSize: 32,
      onPressed: () {
        Navigator.of(context).pop();
      },
      icon: Icon(Icons.clear, color: Colors.red[400]),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        titleSpacing: 20,
        centerTitle: false,
        backgroundColor: Colors.white,
        elevation: 0.0,
        automaticallyImplyLeading: false,
        brightness: Brightness.light,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _exitAppBarButton(context),
            Row(
              children: [
                IconButton(
                  icon: Icon(
                    Icons.tune,
                    color: Colors.grey[700],
                  ),
                  onPressed: () {
//                    TODO: showModalBottomSheet(
//                      context: context,
//                      isScrollControlled: true,
//                      builder: (_) {

//                    return FractionallySizedBox(
//                      heightFactor: 0.8,
//                      child: BigListViewWidget(),
//                    );

//                        return Container(
//                          height: MediaQuery.of(context).size.height,
//                          child: Column(
//                            children: [
//                              ListTile(
//                                title: Text("Save"),
//                                leading: Icon(Icons.save_alt),
//                              )
//                            ],
//                          ),
//                        );
//                      },
//                      backgroundColor: Colors.white,
//                    );
                  },
                ),
                _totalTimer(),
              ],
            ),
          ],
        ),
      ),
      body: SafeArea(child: _PlayerMainScreenContent(playerStore: playerStore)),
    );
  }
}

class _PlayerMainScreenContent extends StatefulWidget {
  final PlayerStore playerStore;

  _PlayerMainScreenContent({
    Key key,
    @required this.playerStore,
  }) : super(key: key);

  @override
  _PlayerMainScreenContentState createState() => _PlayerMainScreenContentState();
}

class _PlayerMainScreenContentState extends State<_PlayerMainScreenContent> {
  final asanasProgressScrollController = ScrollController();

  // TODO: GlobalKey?
  final Map<String, GlobalKey> asanasKeysInQueueBar = {};

  final double playerButtonAspectRatio = 20 / 7.5;
  final double playerButtonIconSize = 38;
  final BorderRadius playerButtonBorderRadius = BorderRadius.circular(15);

  ReactionDisposer _asanasInQueueBarAutoScrollReaction;

  PlayerStore get store => widget.playerStore;

  @override
  void initState() {
    super.initState();

    // Auto scroll to current asana inside asanas queue
    _asanasInQueueBarAutoScrollReaction = reaction(
      (_) => store.currentAsana,
      (asana) {
        final index = store.asanasInClassroom.indexOf(asana);
        if (index == -1) {
          return;
        }

        final hash = _getHashForAsanaInQueueBar(asana, index);
        if (asanasKeysInQueueBar.containsKey(hash) == false) {
          return;
        }

        final globalKey = asanasKeysInQueueBar[hash];
        // FIXME: Have to do [ensureVisible] only for invisible items
        Scrollable.ensureVisible(
          globalKey.currentContext,
          duration: Duration(milliseconds: 500),
          curve: Curves.fastOutSlowIn,
          alignment: 1,
        );
      },
    );
  }

  Widget _queueAsanasBarItem(AsanaModel asana, int index, bool isLast) {
    final hash = _getHashForAsanaInQueueBar(asana, index);
    asanasKeysInQueueBar[hash] = GlobalKey(); // TODO: Fill the map in initial method?

    return Observer(
      builder: (BuildContext context) {
        return Row(children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: Container(
              key: asanasKeysInQueueBar[hash],
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    width: 3,
                    color: asana == store.currentAsana ? kAccentGrey : kShadedGrey,
                  ),
                ),
              ),
              child: Image.asset(
                'assets/images/asana_screen.png',
                //fit: BoxFit.fill,
                color: Colors.grey,
                colorBlendMode: asana == store.currentAsana ? BlendMode.dst : BlendMode.saturation,
              ),
            ),
          ),
          SizedBox(width: isLast ? 0 : 10),
        ]);
      },
    );
  }

  Widget _queueAsanasBar(BuildContext context) {
    if (store.asanasInClassroom.isEmpty) {
      return Container(height: 50); // TODO: Empty list
    }

    return ListView.builder(
      controller: asanasProgressScrollController,
      itemCount: store.asanasInClassroom.length,
      scrollDirection: Axis.horizontal,
      itemBuilder: (context, index) {
        final asana = store.asanasInClassroom[index];
        final isLast = (store.asanasInClassroom.length - 1) == index;

        return _queueAsanasBarItem(asana, index, isLast);
      },
    );
  }

  Widget _currentAsana() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.only(top: 4),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey[50], width: 1),
        boxShadow: [
          BoxShadow(
            color: Color.fromRGBO(101, 101, 101, 0.2),
            offset: Offset(0, 2),
            blurRadius: 2,
          )
        ],
      ),
      child: Column(
        children: [
          Expanded(
            child: Image.asset('assets/images/asana_screen.png'),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 10, right: 10, bottom: 5),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Observer(
                  builder: (_) => Expanded(
                    child: Wrap(
                      spacing: 5,
                      crossAxisAlignment: WrapCrossAlignment.center,
                      children: [
                        FittedBox(
                          child: Text(
                            store.currentAsana.title,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: GoogleFonts.pTSans(
                              fontWeight: FontWeight.w700,
                              fontSize: 22,
                            ),
                          ),
                        ),
                        Text(
                          store.currentAsana.hindiTitle ?? '',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: GoogleFonts.pTSans(
                            fontWeight: FontWeight.w500,
                            fontSize: 16,
                            color: Colors.grey[400],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Icon(Icons.info_outline, color: kAccentGrey),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _timer() {
    return Observer(
      builder: (_) => Container(
        padding: EdgeInsets.symmetric(horizontal: 20),
        child: FittedBox(
          child: Text(
            store.currentTimerDuration.printAsTimer(),
            textAlign: TextAlign.center,
            style: GoogleFonts.montserrat(
              letterSpacing: 3,
              color: store.playerPhase == PlayerPhase.asana ? kTimerActive : kTimerPause,
              fontSize: 64,
              fontWeight: FontWeight.w800,
            ),
          ),
        ),
      ),
    );
  }

  Widget _playButton() {
    return Observer(
      builder: (_) {
        return PlayerPlayButton(
          icon: store.isPlaying ? Icons.pause : Icons.play_arrow,
          isEnabled: store.isFinished == false,
          onTap: () {
            store.isPlaying == true ? store.pausePlayer() : store.startPlayer();
          },
        );
      },
    );
  }

  Widget _rewindButton() {
    return Observer(builder: (_) {
      final onTap = store.isRewindEnabled ? () => store.rewindCurrentPhaseOrGoBack() : null;

      return PlayerButton(
        borderRadius: playerButtonBorderRadius,
        onTap: onTap,
        child: AspectRatio(
          aspectRatio: playerButtonAspectRatio,
          child: Container(
            padding: EdgeInsets.fromLTRB(0, 0, 45, 0),
            decoration: BoxDecoration(
              border: Border.all(color: kControlsLightGrey, width: 6),
              borderRadius: playerButtonBorderRadius,
            ),
            child: Icon(
              Icons.refresh,
              color: kControlsIconColor,
              size: playerButtonIconSize,
            ),
          ),
        ),
      );
    });
  }

  Widget _skipButton() {
    return Observer(builder: (_) {
      final onTap = store.isSkipEnabled ? () => store.skipCurrentPhase() : null;

      return PlayerButton(
        borderRadius: playerButtonBorderRadius,
        onTap: onTap,
        child: AspectRatio(
          aspectRatio: playerButtonAspectRatio,
          child: Container(
            padding: EdgeInsets.fromLTRB(45, 0, 0, 0),
            decoration: BoxDecoration(
              border: Border.all(color: kControlsLightGrey, width: 6),
              borderRadius: playerButtonBorderRadius,
            ),
            child: Icon(
              Icons.fast_forward,
              color: kControlsIconColor,
              size: playerButtonIconSize,
            ),
          ),
        ),
      );
    });
  }

  Widget _controls() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Expanded(child: _rewindButton()),
                      Expanded(child: _skipButton()),
                    ],
                  ),
                  _playButton(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _getHashForAsanaInQueueBar(AsanaModel asana, int indexInQueue) {
    return '${asana.uniqueName}-$indexInQueue';
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 0, bottom: 5),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Flexible(
            flex: 7,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: _queueAsanasBar(context),
            ),
          ),
          Flexible(
            flex: 46,
            child: Padding(
              padding: const EdgeInsets.only(top: 7, left: 20, right: 20),
              child: _currentAsana(),
            ),
          ),
          Expanded(
            flex: 14,
            child: _timer(),
          ),
          Flexible(
            flex: 14,
            child: _controls(),
          )
        ],
      ),
    );
  }

  @override
  void dispose() {
    asanasKeysInQueueBar.clear();

    store.dispose();
    _asanasInQueueBarAutoScrollReaction();

    super.dispose();
  }

//  Widget _progressBar(double width, double progress) {
//    final progressBarHeight = 6.0;
//
//    return Stack(
//      children: [
//        Container(
//          height: progressBarHeight,
//          width: width,
//          decoration: BoxDecoration(
//            color: kShadedGrey,
//            borderRadius: BorderRadius.circular(50),
//          ),
//        ),
//        Container(
//          height: progressBarHeight,
//          width: width * progress,
//          decoration: BoxDecoration(
//            color: kAccentGrey,
//            borderRadius: BorderRadius.circular(50),
//          ),
//        )
//      ],
//    );
//  }
}

class PlayerPlayButton extends StatefulWidget {
  final Function onTap;
  final bool isEnabled;
  final IconData icon;

  const PlayerPlayButton({
    Key key,
    @required this.onTap,
    @required this.icon,
    this.isEnabled = true,
  }) : super(key: key);

  @override
  _PlayerPlayButtonState createState() => _PlayerPlayButtonState();
}

class _PlayerPlayButtonState extends State<PlayerPlayButton> with SingleTickerProviderStateMixin {
  final Color _bgColor = Color(0xFFF1F1F4);
  final Color _bgTappedColor = Color(0xFFBEBEC1);

  final Color _iconColor = Color(0xFF3C3C59);
  final Color _iconTappedColor = Color(0xFF141630);

  AnimationController _animationController;
  Animation<double> _animation;
  TickerFuture _pushAnimationTicker;

  Color _currentBgColor;
  Color _currentIconColor;

  final animationDuration = const Duration(milliseconds: 85);
  final zoomOutLevel = 0.94;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(duration: animationDuration, vsync: this);
    _animation = Tween<double>(begin: 1.0, end: zoomOutLevel).animate(_animationController);

    _currentBgColor = _bgColor;
    _currentIconColor = _iconColor;
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) {
        if (widget.isEnabled == false) {
          return;
        }

        setState(() {
          _currentBgColor = _bgTappedColor;
          _currentIconColor = _iconTappedColor;
        });

        _pushAnimationTicker = _animationController.forward();
      },
      onTapUp: (_) {
        if (widget.isEnabled == false) {
          return;
        }

        widget.onTap();

        Timer(const Duration(milliseconds: 8), () {
          setState(() {
            _currentBgColor = _bgColor;
            _currentIconColor = _iconColor;
          });
        });

        _pushAnimationTicker.whenCompleteOrCancel(() => _animationController.reverse());
      },
      onTapCancel: () {
        if (widget.isEnabled == false) {
          return;
        }

        setState(() {
          _currentBgColor = _bgColor;
          _currentIconColor = _iconColor;
        });

        _animationController.reverse();
      },
      child: AnimatedBuilder(
        animation: _animation,
        child: Container(
          padding: EdgeInsets.all(4),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(100),
          ),
          child: Opacity(
            opacity: widget.isEnabled ? 1 : 0.4,
            child: FittedBox(
              child: CircleAvatar(
                backgroundColor: _currentBgColor,
                minRadius: 40,
                maxRadius: 50,
                child: Icon(
                  widget.icon,
                  color: _currentIconColor,
                  size: 65,
                ),
              ),
            ),
          ),
        ),
        builder: (_, child) => Transform.scale(scale: _animation.value, child: child),
      ),
    );
  }
}

class PlayerButton extends StatefulWidget {
  const PlayerButton({
    Key key,
    @required this.child,
    this.onTap,
    this.borderRadius,
  }) : super(key: key);

  final Widget child;
  final VoidCallback onTap;
  final BorderRadius borderRadius;

  @override
  _PlayerButtonState createState() => _PlayerButtonState();
}

class _PlayerButtonState extends State<PlayerButton> with SingleTickerProviderStateMixin {
  AnimationController _animationController;
  Animation<double> _animation;
  TickerFuture _scaleOutAnimationTicker;

  final animationDuration = Duration(milliseconds: 95);
  final zoomOutLevel = 0.96;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(duration: animationDuration, vsync: this);
    _animation = Tween<double>(begin: 1.0, end: zoomOutLevel).animate(_animationController);
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  bool get isEnabled => widget.onTap != null;

  VoidCallback get _onTap {
    if (widget.onTap == null) {
      return null;
    }

    return () {
      _scaleOutAnimationTicker.whenCompleteOrCancel(() => _animationController.reverse());
      widget.onTap();
    };
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (_, child) {
        return Transform.scale(
          scale: _animation.value,
          child: child,
        );
      },
      child: InkWell(
        onTap: _onTap,
        onTapDown: (_) {
          _scaleOutAnimationTicker = _animationController.forward();
        },
        onTapCancel: () {
          _animationController.reverse();
        },
        borderRadius: widget.borderRadius,
        child: Opacity(
          opacity: isEnabled ? 1.0 : 0.4,
          child: widget.child,
        ),
      ),
    );
  }
}

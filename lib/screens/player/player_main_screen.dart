import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mobx/mobx.dart';
import 'package:my_yoga_fl/assets.dart';
import 'package:my_yoga_fl/extensions/duration_extensions.dart';
import 'package:my_yoga_fl/models/asana_model.dart';
import 'package:my_yoga_fl/models/classroom_model.dart';
import 'package:my_yoga_fl/stores/asanas_store.dart';
import 'package:my_yoga_fl/stores/player_store.dart';
import 'package:my_yoga_fl/styles.dart';
import 'package:my_yoga_fl/utils/log.dart';
import 'package:provider/provider.dart';

import 'player_button.dart';
import 'player_play_button.dart';

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
        color: Styles.accentGreyColor,
      ),
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 3),
      child: Observer(
        builder: (_) => Text(
          playerStore.totalTimer.toTimeString(),
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

    store.asanasUniqueNamesInQueue.asMap().forEach((index, asanaUniqueName) {
      final hash = _getHashForAsanaInQueueBar(asanaUniqueName, index);
      asanasKeysInQueueBar[hash] = GlobalKey();
    });

    // Auto scroll to current asana inside asanas queue
    _asanasInQueueBarAutoScrollReaction = reaction(
      (_) => store.currentAsanaBlockIndex,
      (index) {
        if (store.currentAsanaUniqueName == null) {
          return;
        }

        final hash = _getHashForAsanaInQueueBar(store.currentAsanaUniqueName, index);
        if (asanasKeysInQueueBar.containsKey(hash) == false) {
          return;
        }

        final globalKey = asanasKeysInQueueBar[hash];
        // FIXME: Have to do autoscroll only for invisible items
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
    final isActive = store.currentAsanaBlockIndex == index;
    final hash = _getHashForAsanaInQueueBar(asana.uniqueName, index);

    return Row(children: [
      ClipRRect(
        borderRadius: BorderRadius.circular(4),
        child: Container(
          key: asanasKeysInQueueBar[hash],
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(
                width: 3,
                color: isActive ? Styles.accentGreyColor : Styles.shadedGreyColor,
              ),
            ),
          ),
          child: Opacity(
            opacity: isActive ? 1.0 : 0.7,
            child: Image.asset(
              ImageAssets.asanaCoverImage,
              fit: BoxFit.cover,
              color: Colors.grey,
              colorBlendMode: isActive ? BlendMode.dst : BlendMode.saturation,
            ),
          ),
        ),
      ),
      SizedBox(width: isLast ? 0 : 10),
    ]);
  }

  Widget _queueAsanasBar(BuildContext context) {
    final asanasStore = Provider.of<AsanasStore>(context, listen: false);

    return ListView.builder(
      controller: asanasProgressScrollController,
      itemCount: store.asanasUniqueNamesInQueue.length,
      scrollDirection: Axis.horizontal,
      itemBuilder: (context, index) {
        return Observer(builder: (_) {
          final asanaUniqueName = store.asanasUniqueNamesInQueue[index];
          final asana = asanasStore.asanas[asanaUniqueName];
          final isLast = (store.asanasUniqueNamesInQueue.length - 1) == index;

          if (asana == null) {
            Log.warn('Somehow you\'ve got empty asana queue item.');
            return SizedBox.shrink();
          }

          return _queueAsanasBarItem(asana, index, isLast);
        });
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
      child: Consumer<AsanasStore>(builder: (_, asanasStore, __) {
        return Observer(builder: (_) {
          if (store.currentAsanaUniqueName == null || store.currentAsanaUniqueName.isEmpty) {
            return SizedBox.shrink();
          }

          final asana = asanasStore.asanas[store.currentAsanaUniqueName];
          if (asana == null) {
            return SizedBox.shrink();
          }

          return Column(
            children: [
              Expanded(
                child: Image.asset(ImageAssets.asanaArtImage),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 10, right: 10, bottom: 5),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Expanded(
                      child: Wrap(
                        spacing: 5,
                        crossAxisAlignment: WrapCrossAlignment.center,
                        children: [
                          FittedBox(
                            child: Text(
                              asana.title,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: GoogleFonts.pTSans(
                                fontWeight: FontWeight.w700,
                                fontSize: 22,
                              ),
                            ),
                          ),
                          Text(
                            asana.hindiTitle ?? '',
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
                    Icon(Icons.info_outline, color: Styles.accentGreyColor),
                  ],
                ),
              )
            ],
          );
        });
      }),
    );
  }

  Widget _currentNonAsanaBlock(
    String text, {
    AsanaModel nextAsana,
    Duration nextAsanaDuration,
  }) {
    assert(text != null);

    final nextAsanaWidget = nextAsana == null
        ? SizedBox.shrink()
        : Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: <Widget>[
                Row(
                  children: <Widget>[
                    ClipRRect(
                      borderRadius: BorderRadius.circular(4),
                      child: Container(
                        width: 60,
                        height: 60,
                        child: Image.asset(ImageAssets.asanaCoverImage),
                      ),
                    ),
                    SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text('Next:', style: TextStyle(fontSize: 18, color: Colors.grey)),
                          Text(
                            nextAsana.title,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: GoogleFonts.pTSans(
                              fontWeight: FontWeight.w700,
                              fontSize: 22,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Text(
                      nextAsanaDuration?.toTimeString() ?? '',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                    ),
                  ],
                ),
              ],
            ),
          );

    return Container(
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Expanded(
            child: Center(
              child: FittedBox(
                child: Text(
                  text,
                  maxLines: 2,
                  style: GoogleFonts.pTSansCaption(
                    fontSize: 72,
                    fontWeight: FontWeight.bold,
                    color: Styles.timerPauseColor,
                  ),
                ),
              ),
            ),
          ),
          nextAsanaWidget,
        ],
      ),
    );
  }

  Widget _currentPlayerItem(BuildContext context) {
    if (store.currentQueueItem.phase == PlayerPhase.begin) {
      return _currentNonAsanaBlock('Prepare');
    }

    if (store.currentQueueItem.isChilling) {
      AsanaModel nextAsana;
      Duration nextAsanaDuration;

      if (store.nextQueueItemWithAsana != null) {
        final asanasStore = Provider.of<AsanasStore>(context, listen: false);
        nextAsana = asanasStore.asanas[store.nextQueueItemWithAsana.asanaUniqueName];
        nextAsanaDuration = store.nextQueueItemWithAsana.duration;
      }

      return _currentNonAsanaBlock(
        'Break',
        nextAsana: nextAsana,
        nextAsanaDuration: nextAsanaDuration,
      );
    }

    if (store.currentQueueItem.isFinished) {
      return _currentNonAsanaBlock('Done 🎉');
    }

    return _currentAsana();
  }

  Widget _timer() {
    return Observer(
      builder: (_) => Container(
        padding: EdgeInsets.symmetric(horizontal: 20),
        child: FittedBox(
          child: Text(
            store.currentTimerDuration.toPlayerTimer(),
            textAlign: TextAlign.center,
            style: GoogleFonts.montserrat(
              letterSpacing: 3,
              color: Styles.timerPauseColor,
//              color: [PlayerPhase.asana, PlayerPhase.begin].contains(store.playerPhase)
//                  ? Styles.timerActiveColor
//                  : Styles.timerPauseColor,
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
              border: Border.all(color: Styles.controlsLightGreyColor, width: 6),
              borderRadius: playerButtonBorderRadius,
            ),
            child: Icon(
              Icons.refresh,
              color: Styles.controlsIconColor,
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
              border: Border.all(color: Styles.controlsLightGreyColor, width: 6),
              borderRadius: playerButtonBorderRadius,
            ),
            child: Icon(
              Icons.fast_forward,
              color: Styles.controlsIconColor,
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

  String _getHashForAsanaInQueueBar(String asanaUniqueName, int index) {
    return '$asanaUniqueName-$index';
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
              child: Observer(builder: (_) => _currentPlayerItem(context)),
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
}

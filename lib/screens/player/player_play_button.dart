import 'dart:async';

import 'package:flutter/material.dart';

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
  // TODO: Move colors to [Styles]
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

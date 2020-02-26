import 'package:flutter/material.dart';

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

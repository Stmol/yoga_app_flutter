import 'package:flutter/material.dart';

// TODO: Delete
class ScalableButton extends StatefulWidget {
  const ScalableButton({
    Key key,
    @required this.onTapDown,
    @required this.onTapUp,
    @required this.onTapCancel,
    @required this.child,
  }) : super(key: key);

  final Widget child;
  final VoidCallback onTapDown;
  final VoidCallback onTapUp;
  final VoidCallback onTapCancel;

  @override
  _ScalableButtonState createState() => _ScalableButtonState();
}

class _ScalableButtonState extends State<ScalableButton> with SingleTickerProviderStateMixin {
  AnimationController _animationController;
  Animation<double> _animation;
  TickerFuture _scaleOutAnimationTicker;

  @override
  void initState() {
    super.initState();
    _animationController =
        AnimationController(duration: const Duration(milliseconds: 95), vsync: this);
    _animation = Tween<double>(begin: 1.0, end: 0.92).animate(_animationController);
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
        _scaleOutAnimationTicker = _animationController.forward();

        widget.onTapDown();
      },
      onTapUp: (_) {
        _scaleOutAnimationTicker.whenCompleteOrCancel(() => _animationController.reverse());

        widget.onTapUp();
      },
      onTapCancel: () {
        _animationController.reverse();

        widget.onTapCancel();
      },
      child: AnimatedBuilder(
        animation: _animation,
        child: widget.child,
        builder: (_, child) {
          return Transform.scale(scale: _animation.value, child: child);
        },
      ),
    );
  }
}

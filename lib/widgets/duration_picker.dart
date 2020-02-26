import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class DurationPicker extends StatefulWidget {
  final String title;
  final Duration initialDuration;
  final Function(Duration newDuration) onSave;
  final bool isZeroDurationAvailable;

  const DurationPicker({
    Key key,
    this.title,
    this.isZeroDurationAvailable = true,
    @required this.initialDuration,
    @required this.onSave,
  })  : assert(initialDuration != null),
        assert(onSave != null),
        super(key: key);

  @override
  _DurationPickerState createState() => _DurationPickerState();
}

class _DurationPickerState extends State<DurationPicker> {
  Duration _currentDuration;

  bool get isSaveButtonEnabled {
    if (widget.isZeroDurationAvailable == false) {
      return _currentDuration != Duration.zero;
    }

    return true;
  }

  @override
  void initState() {
    super.initState();

    _currentDuration = widget.initialDuration;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(child: SizedBox(width: double.infinity)),
        Expanded(
          child: Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(horizontal: 20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topRight: Radius.circular(10),
                topLeft: Radius.circular(10),
              ),
            ),
            child: SafeArea(
              top: false,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  widget.title == null || widget.title.isEmpty
                      ? SizedBox.shrink()
                      : Flexible(
                          flex: 1,
                          child: FittedBox(
                            child: Text(
                              widget.title,
                              style: Theme.of(context).textTheme.caption,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ),
                  Flexible(
                    flex: 3,
                    child: CupertinoTimerPicker(
                      mode: CupertinoTimerPickerMode.ms,
                      backgroundColor: Colors.white,
                      initialTimerDuration: widget.initialDuration,
                      onTimerDurationChanged: (duration) {
                        setState(() => _currentDuration = duration);
                      },
                    ),
                  ),
                  Flexible(
                    flex: 1,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: FlatButton(
                            child: Text('Cancel'),
                            onPressed: () => Navigator.of(context).pop(),
                          ),
                        ),
                        SizedBox(width: 10),
                        Expanded(
                          child: OutlineButton(
                            child: Text('Save'),
                            onPressed: isSaveButtonEnabled == false
                                ? null
                                : () {
                                    Navigator.of(context).pop();
                                    widget.onSave(_currentDuration);
                                  },
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

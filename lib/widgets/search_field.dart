import 'package:flutter/material.dart';
import 'package:my_yoga_fl/stores/asanas_search_store.dart';

class SearchField extends StatefulWidget {
  final String hintText;
  final Widget trailing;
  final int maxLength;

  final Function(bool) onFocusChanged;

  final AsanasSearchStore asanasSearchStore;

  SearchField({
    Key key,
    this.hintText = 'Поиск',
    this.maxLength = 50,
    this.trailing,
    this.asanasSearchStore,
    this.onFocusChanged,
  }) : super(key: key);

  @override
  _SearchFieldState createState() => _SearchFieldState();
}

class _SearchFieldState extends State<SearchField> {
  final textController = TextEditingController();
  final focusNode = FocusNode();

  /// Determines that the search was started by tapping on the text field
  ///
  /// The search is considered canceled if the cancel button was pressed or
  /// widget was disposed
  bool _isCancelButtonShow = false;

  IconButton _textFieldClearIconButton;

  @override
  void initState() {
    super.initState();

    focusNode.addListener(_onFocusChanged);
    textController.addListener(_onTextChangedListener);
  }

  @override
  void dispose() {
    textController.dispose();
    focusNode.dispose();

    super.dispose();
  }

  void _onFocusChanged() {
    if (focusNode.hasFocus && _isCancelButtonShow == false) {
      setState(() => _isCancelButtonShow = true);
    }

    widget.asanasSearchStore?.onTextFieldWidgetFocusChanged(focusNode.hasFocus);
    if (widget.onFocusChanged is Function) {
      widget.onFocusChanged(focusNode.hasFocus);
    }
  }

  void _cancel() {
    textController.clear();
    focusNode.unfocus();

    setState(() => _isCancelButtonShow = false);
    widget.asanasSearchStore?.onTextFieldWidgetCancelTap();
  }

  void _onTextChangedListener() {
    if (textController.text.isNotEmpty) {
      setState(() => _textFieldClearIconButton = _getClearIconButton());
    } else {
      setState(() => _textFieldClearIconButton = null);
    }

    widget.asanasSearchStore?.onTextFieldWidgetTextChanged(textController.text);
  }

  InputDecoration _getInputDecoration() {
    return InputDecoration(
      hintText: widget.hintText,
      filled: true,
      fillColor: Colors.grey[200],
      isDense: true,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(50),
        borderSide: BorderSide.none,
      ),
      // TODO: Hardcoded padding values...
      contentPadding: EdgeInsets.only(left: 15, top: 10, bottom: 6),
      counterText: '',
      suffixIcon: _textFieldClearIconButton,
    );
  }

  Widget _getClearIconButton() {
    return IconButton(
      splashColor: Colors.transparent,
      iconSize: 18, // TODO: Hardcode size value
      color: Colors.grey[600],
      icon: Icon(Icons.cancel),
      onPressed: () {
        // TODO: addPostFrameCallback
        WidgetsBinding.instance.addPostFrameCallback((_) => textController.clear());
      },
    );
  }

  Widget _getCancelButton() {
    return GestureDetector(
      // TODO: Add tap effect (changing opacity)
      onTap: _cancel,
      child: Text('Отмена', style: TextStyle(color: Colors.blue)),
    );
  }

  Widget _getTrailingWidget([double spaceBefore = 8.0]) {
    final compiledTrailing = widget.trailing == null
        ? SizedBox.shrink()
        : Row(
            children: [
              SizedBox(width: spaceBefore),
              widget.trailing,
            ],
          );

    return AnimatedCrossFade(
      alignment: Alignment.center,
      duration: Duration(milliseconds: 200),
      crossFadeState: _isCancelButtonShow ? CrossFadeState.showSecond : CrossFadeState.showFirst,
      firstChild: compiledTrailing,
      secondChild: Row(children: [
        SizedBox(width: spaceBefore),
        _getCancelButton(),
      ]),
      layoutBuilder: (topChild, topKey, bottomChild, bottomKey) {
        return Stack(
          overflow: Overflow.visible,
          alignment: Alignment.center,
          children: [
            Positioned(
              key: bottomKey,
              top: 100, // TODO: Hack :)
              child: bottomChild,
            ),
            Positioned(
              key: topKey,
              child: topChild,
            )
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Expanded(
          child: Container(
            height: 35,
            child: TextField(
              cursorColor: Colors.grey,
              decoration: _getInputDecoration(),
              controller: textController,
              focusNode: focusNode,
              maxLength: widget.maxLength,
            ),
          ),
        ),
        _getTrailingWidget(),
      ],
    );
  }
}

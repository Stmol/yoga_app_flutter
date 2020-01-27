import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:my_yoga_fl/stores/new_classroom_store.dart';
import 'package:my_yoga_fl/widgets/button.dart';
import 'package:my_yoga_fl/widgets/duration_picker.dart';
import '../../extensions/duration_extensions.dart';

class NewClassroomStep2Screen extends StatelessWidget {
  final NewClassroomStore newClassroomStore;

  const NewClassroomStep2Screen({
    Key key,
    @required this.newClassroomStore,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        titleSpacing: 0,
        centerTitle: false,
        backgroundColor: Colors.white,
        elevation: 0.0,
        automaticallyImplyLeading: false,
        brightness: Brightness.light,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          color: Colors.grey,
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          'Новый класс',
          style: Theme.of(context).textTheme.title,
        ),
      ),
      body: _NewClassroomStep2Content(newClassroomStore: newClassroomStore),
    );
  }
}

class _NewClassroomStep2Content extends StatelessWidget {
  final NewClassroomStore newClassroomStore;

  const _NewClassroomStep2Content({
    Key key,
    @required this.newClassroomStore,
  }) : super(key: key);

  ///
  /// Handler Classroom saving action
  ///
  void _onSubmit(BuildContext context) {
    // TODO Check this method to pop out from modal
    // Navigator.popUntil(context, ModalRoute.withName(ClassroomsScreen.routeName));
    int count = 0;
    Navigator.popUntil(context, (_) => count++ >= 2);
  }

  Widget _classroomForm(BuildContext context) {
    return NewClassroomForm(
      onSubmit: () => _onSubmit(context),
      store: newClassroomStore,
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: EdgeInsets.all(20),
      children: <Widget>[
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5),
            color: Colors.grey[100],
          ),
          width: double.infinity,
          height: 150,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Icon(
                Icons.image,
                color: Colors.grey,
                size: 32,
              ),
              Text('Добавить изображение'),
            ],
          ),
        ),
        SizedBox(height: 15),
        _classroomForm(context),
      ],
    );
  }
}

class NewClassroomForm extends StatefulWidget {
  final Function onSubmit;
  final NewClassroomStore store;

  NewClassroomForm({
    Key key,
    @required this.onSubmit,
    @required this.store,
  }) : super(key: key);

  @override
  _NewClassroomFormState createState() => _NewClassroomFormState();
}

class _NewClassroomFormState extends State<NewClassroomForm> {
  final titleController = TextEditingController();
  final descriptionController = TextEditingController();
  final timeIntervalController = TextEditingController();

  NewClassroomStore get store => widget.store;

  @override
  void initState() {
    super.initState();

    titleController.addListener(() {
      store.formTitle = titleController.text;
    });

    descriptionController.addListener(() {
      store.formDescription = descriptionController.text;
    });

    titleController.text = store.formTitle;
    descriptionController.text = store.formDescription;
    timeIntervalController.text = store.formIntervalDuration.toTimeString();
  }

  @override
  void dispose() {
    titleController.dispose();
    descriptionController.dispose();
    timeIntervalController.dispose();

    super.dispose();
  }

  void _submitForm() {
    FocusScope.of(context).unfocus();

    store.saveForm();
    widget.onSubmit();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        TextFormField(
          controller: titleController,
          maxLines: 1,
          maxLength: 50,
          decoration: const InputDecoration(
            labelText: 'Название',
            border: const OutlineInputBorder(),
            counter: const Offstage(),
          ),
        ),
        SizedBox(height: 15),
        TextFormField(
          controller: descriptionController,
          maxLines: 2,
          minLines: 1,
          maxLength: 150,
          decoration: const InputDecoration(
            labelText: 'Описание',
            border: const OutlineInputBorder(),
            counter: const Offstage(),
          ),
        ),
        SizedBox(height: 15),
        TextFormField(
          controller: timeIntervalController,
          readOnly: true,
          decoration: const InputDecoration(
            labelText: 'Пауза между позами',
            border: const OutlineInputBorder(),
            counter: const Offstage(),
          ),
          inputFormatters: [
            WhitelistingTextInputFormatter.digitsOnly,
          ],
          onTap: () {
            showCupertinoModalPopup(context: context, builder: (_) {
              return DurationPicker(
                title: 'Пауза между позами',
                initialDuration: store.formIntervalDuration,
                onSave: (duration) {
                  timeIntervalController.text = duration.toTimeString();
                  store.formIntervalDuration = duration;
                },
              );
            });
          },
        ),
        SizedBox(height: 15),
//        Text(
//          'Напоминания',
//          style: Theme.of(context).textTheme.caption,
//        ),
//        SizedBox(height: 15),
        SizedBox(
          width: double.infinity,
          child: Button(
            title: 'Сохранить',
            onPressed: _submitForm,
          ),
        ),
      ],
    );
  }
}

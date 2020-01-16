import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:my_yoga_fl/models/classroom_model.dart';
import 'package:my_yoga_fl/screens/classrooms_screen.dart';
import 'package:my_yoga_fl/stores/classrooms_store.dart';
import 'package:my_yoga_fl/stores/new_classroom_store.dart';
import 'package:my_yoga_fl/widgets/button.dart';
import 'package:provider/provider.dart';

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
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          color: Colors.grey,
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          "Новый класс",
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
              Text("Добавить изображение"),
            ],
          ),
        ),
        SizedBox(height: 15),
        Consumer<ClassroomsStore>(
          builder: (_, store, __) {
            return NewClassroomForm(onSave: (ClassroomModel classroom) {
              newClassroomStore.addSelectedAsanasToClassroom(classroom);
              store.addClassroom(classroom);

              // TODO Check this method to pop out from modal
              Navigator.popUntil(context, ModalRoute.withName(ClassroomsScreen.routeName));
              //int count = 0; Navigator.popUntil(context, (_) => count++ >= 2);
            });
          },
        ),
      ],
    );
  }
}

class NewClassroomForm extends StatefulWidget {
  final Function(ClassroomModel model) onSave;

  const NewClassroomForm({
    Key key,
    @required this.onSave,
  }) : super(key: key);

  @override
  _NewClassroomFormState createState() => _NewClassroomFormState();
}

class _NewClassroomFormState extends State<NewClassroomForm> {
  final titleController = TextEditingController();
  final descriptionController = TextEditingController();
  final timeIntervalController = TextEditingController();

  @override
  void initState() {
    super.initState();

    timeIntervalController.text = "0:30";
  }

  @override
  void dispose() {
    titleController.dispose();
    descriptionController.dispose();
    timeIntervalController.dispose();

    super.dispose();
  }

  int _formatTimeIntervalToSeconds(String text) {
    final List<String> parts = text.split(":"); // FIXME Out of a range
    final duration = Duration(minutes: int.parse(parts[0]), seconds: int.parse(parts[1]));

    return duration.inSeconds;
  }

  void _submitForm() {
    FocusScope.of(context).unfocus();

    final title = titleController.text;
    final description = descriptionController.text;
    final timeInterval = timeIntervalController.text;

    final classroom = ClassroomModel(
      title: title,
      description: description,
      timeBetweenAsanas: _formatTimeIntervalToSeconds(timeInterval),
    );

    widget.onSave(classroom);
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
            labelText: "Название",
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
            labelText: "Описание",
            border: const OutlineInputBorder(),
            counter: const Offstage(),
          ),
        ),
        SizedBox(height: 15),
        TextFormField(
          controller: timeIntervalController,
          keyboardType: TextInputType.number,
          enabled: false,
          decoration: const InputDecoration(
            labelText: "Пауза между позами",
            border: const OutlineInputBorder(),
            counter: const Offstage(),
          ),
          inputFormatters: [
            WhitelistingTextInputFormatter.digitsOnly,
          ],
        ),
        SizedBox(height: 15),
//        Text(
//          "Напоминания",
//          style: Theme.of(context).textTheme.caption,
//        ),
//        SizedBox(height: 15),
        SizedBox(
          width: double.infinity,
          child: Button(
            title: "Сохранить",
            onPressed: _submitForm,
          ),
        ),
      ],
    );
  }
}

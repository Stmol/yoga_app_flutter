import 'package:flutter/material.dart';
import 'package:my_yoga_fl/widgets/button.dart';

class NewClassroomScreen extends StatelessWidget {
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
      body: _NewClassroomScreen(),
    );
  }
}

class _NewClassroomScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
      child: ListView(
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
          TextField(
            maxLines: 1,
            cursorColor: Colors.grey,
            decoration: const InputDecoration(
              border: const OutlineInputBorder(),
              labelText: "Название",
            ),
          ),
          SizedBox(height: 15),
          TextField(
            maxLines: 4,
            minLines: 2,
            cursorColor: Colors.grey,
            decoration: const InputDecoration(
              border: const OutlineInputBorder(),
              labelText: "Описание",
            ),
          ),
          SizedBox(height: 15),
          TextField(
            // TODO: Add number picker (slider)
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
              border: const OutlineInputBorder(),
              labelText: "Пауза между позами",
            ),
          ),
          SizedBox(height: 15),
          Text(
            "Напоминания",
            style: Theme.of(context).textTheme.caption,
          ),
          SizedBox(height: 15),
          SizedBox(
            width: double.infinity,
            child: Button(
              title: "Сохранить",
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ),
        ],
      ),
    );
  }
}

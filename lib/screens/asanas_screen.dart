import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:my_yoga_fl/stores/asanas_store.dart';
import 'package:my_yoga_fl/widgets/asanas_list.dart';
import 'package:my_yoga_fl/widgets/search_field.dart';
import 'package:provider/provider.dart';

class AsanasScreen extends StatelessWidget {
  static const routeName = '/asanas';

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
          "Асаны и позы",
          style: Theme.of(context).textTheme.title,
        ),
      ),
      body: _AsanasScreen(),
    );
  }
}

class _AsanasScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: <Widget>[
          SearchField(),
          SizedBox(height: 15),
          Consumer<AsanasStore>(builder: (_, store, __) {
            return Observer(builder: (_) {
              // FIXME: toBuiltList()
              return AsanasList(asanas: store.asanas.toList(growable: false));
            });
          }),
        ],
      ),
    );
  }
}

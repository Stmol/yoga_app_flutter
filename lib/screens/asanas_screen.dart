import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:my_yoga_fl/stores/asanas_search_store.dart';
import 'package:my_yoga_fl/stores/asanas_store.dart';
import 'package:my_yoga_fl/widgets/asanas_list.dart';
import 'package:my_yoga_fl/widgets/search_field.dart';
import 'package:provider/provider.dart';

import 'asana_screen.dart';

class AsanasScreen extends StatelessWidget {
  static const routeName = '/asanas';

  @override
  Widget build(BuildContext context) {
    final store = Provider.of<AsanasStore>(context, listen: false);
    final asanasSearchStore = AsanasSearchStore(initialAsanasList: store.sortedAsanasList);

    return Scaffold(
      backgroundColor: Colors.white,
      body: _AsanasScreenContent(asanasSearchStore: asanasSearchStore),
    );
  }
}

class _AsanasScreenContent extends StatefulWidget {
  final AsanasSearchStore asanasSearchStore;

  const _AsanasScreenContent({
    Key key,
    @required this.asanasSearchStore,
  })  : assert(asanasSearchStore != null),
        super(key: key);

  @override
  _AsanasScreenContentState createState() => _AsanasScreenContentState();
}

class _AsanasScreenContentState extends State<_AsanasScreenContent> {
  final scrollController = ScrollController();
  FocusScopeNode _currentFocus;

  AsanasSearchStore get searchStore => widget.asanasSearchStore;

  @override
  void initState() {
    super.initState();

    // Hide keyboard when user start scrolling UP in "Search mode"
    scrollController.addListener(() {
      if (scrollController.position.userScrollDirection == ScrollDirection.reverse &&
          _currentFocus?.hasPrimaryFocus == false) {
        _currentFocus.unfocus();
      }
    });
  }

  @override
  void dispose() {
    searchStore.dispose();
    super.dispose();
  }

  Widget _getSearchField() {
    return SearchField(
      trailing: Icon(Icons.filter_list),
      asanasSearchStore: searchStore,
      onFocusChanged: (hasFocus) {
        if (hasFocus) {
          scrollController.jumpTo(0);
        }
      },
    );
  }

  Widget _getAsanasSliverList(BuildContext context) {
    return Observer(builder: (_) {
      if (searchStore.asanas.isEmpty) {
        return SliverList(delegate: SliverChildListDelegate.fixed([]));
      }

      return SliverList(
        delegate: SliverChildBuilderDelegate((_, index) {
          final asana = searchStore.asanas[index];
          final isLast = (searchStore.asanas.length - 1) == index;

          return Padding(
            padding: EdgeInsets.fromLTRB(20, 10, 20, isLast ? 20 : 10),
            child: AsanaListItem(
              title: asana.title,
              hindiTitle: asana.hindiTitle,
              level: asana.level,
              imageUrl: asana.imageUrl,
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                  fullscreenDialog: true,
                  builder: (context) => AsanaScreen(asana),
                ),
              ),
            ),
          );
        }, childCount: searchStore.asanas.length),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    _currentFocus = FocusScope.of(context);

    return CustomScrollView(
      controller: scrollController,
      physics: BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
      slivers: <Widget>[
        SliverAppBar(
          title: Text('Асаны', style: Theme.of(context).textTheme.title),
          titleSpacing: 0,
          centerTitle: false,
          backgroundColor: Colors.white,
          brightness: Brightness.light,
          automaticallyImplyLeading: false,
          floating: true,
          pinned: true,
          expandedHeight: 95,
          elevation: 0.8,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            color: Colors.grey,
            onPressed: () => Navigator.of(context).pop(),
          ),
          bottom: PreferredSize(
            preferredSize: Size(double.infinity, 45),
            child: Container(
              width: double.infinity,
              height: 45,
              padding: EdgeInsets.symmetric(horizontal: 20),
              color: Colors.white,
              child: _getSearchField(),
            ),
          ),
        ),
        _getAsanasSliverList(context)
      ],
    );
  }
}

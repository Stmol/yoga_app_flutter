import 'package:flushbar/flushbar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:my_yoga_fl/assets.dart';
import 'package:my_yoga_fl/repository/classroom_repository.dart';
import 'package:my_yoga_fl/screens/asanas_screen.dart';
import 'package:my_yoga_fl/screens/changelog_screen.dart';
import 'package:my_yoga_fl/screens/classrooms_screen.dart';
import 'package:my_yoga_fl/stores/asanas_store.dart';
import 'package:my_yoga_fl/stores/classrooms_store.dart';
import 'package:my_yoga_fl/styles.dart';
import 'package:my_yoga_fl/utils/log.dart';
import 'package:my_yoga_fl/widgets/button.dart';
import 'package:package_info/package_info.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized(); // TODO: What the heck?

  // TODO: Find to best place for init SP
  PackageInfo packageInfo = await PackageInfo.fromPlatform();
  SharedPreferences prefs = await SharedPreferences.getInstance();
  Log.init();

  runApp(MyApp(
    sharedPreferences: prefs,
    appVersion: packageInfo.version,
  ));
}

const kClassroomKeyValueRepositoryKeyName = 'classrooms';

class MyApp extends StatelessWidget {
  final SharedPreferences sharedPreferences;
  final String appVersion;

  MyApp({
    Key key,
    @required this.sharedPreferences,
    @required this.appVersion,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<AsanasStore>(
          create: (_) => AsanasStore()..init(),
          lazy: false,
        ),
        Provider<ClassroomsStore>(
          create: (_) {
            final repository =
                ClassroomKeyValueRepository(kClassroomKeyValueRepositoryKeyName, sharedPreferences);

            return ClassroomsStore(repository)..init();
          },
          dispose: (_, store) => store.dispose(),
          lazy: false,
        )
      ],
      child: MaterialApp(
        title: 'Yoga App',
        debugShowCheckedModeBanner: false,
        initialRoute: MyHomePage.routeName,
        routes: {
          MyHomePage.routeName: (context) => MyHomePage(
                title: 'Yoga',
                appVersion: appVersion,
              ),
          ClassroomsScreen.routeName: (context) => ClassroomsScreen(),
          AsanasScreen.routeName: (context) => AsanasScreen(),
        },
        theme: theme,
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  static const routeName = '/home';

  MyHomePage({
    Key key,
    @required this.title,
    @required this.appVersion,
  }) : super(key: key);

  final String title;
  final String appVersion;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  bool _isCleaning = false;

  void _clearAndRefresh(BuildContext context) async {
    setState(() => _isCleaning = true);

    try {
      final asanasStore = Provider.of<AsanasStore>(context, listen: false);
      final classroomsStore = Provider.of<ClassroomsStore>(context, listen: false);

      await asanasStore.refreshData();
      await classroomsStore.refreshData();

      _showNotification(context);
    } catch (_) {
      _showNotification(context, isError: true);
    } finally {
      setState(() => _isCleaning = false);
    }
  }

  void _showNotification(BuildContext context, {bool isError = false}) {
    Flushbar(
      // TODO: Move to separate widget
      message: isError ? 'Произошла ошибка' : 'Данные приложения сброшены',
      icon: Icon(
        isError ? Icons.error_outline : Icons.done,
        color: isError ? Colors.red : Colors.lightGreenAccent,
      ),
      shouldIconPulse: false,
      margin: EdgeInsets.all(8),
      borderRadius: 8.0,
      duration: Duration(milliseconds: 1350),
      animationDuration: Duration(milliseconds: 350),
      flushbarPosition: FlushbarPosition.TOP,
      barBlur: 1,
      backgroundColor: Color(0xCC000000),
    )..show(context);
  }

  void _onClearButtonTap(BuildContext context) {
    // TODO: Pick up to separate widget with platform selecting logic
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) {
        return AlertDialog(
          content: Text('Удалить пользовательские данные?'),
          actions: [
            FlatButton(
                child: Text('Отмена'),
                textColor: Colors.black,
                onPressed: () {
                  Navigator.of(context).pop();
                }),
            FlatButton(
                child: Text('Удалить'),
                textColor: Colors.red[400],
                onPressed: () {
                  Navigator.of(context).pop();
                  _clearAndRefresh(context);
                }),
          ],
        );
      },
    );
  }

  Widget _getMenu() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SizedBox(height: 30),
        Row(
          children: [
            Expanded(
              child: Button(
                'Асаны',
                onTap: () {
                  Navigator.pushNamed(context, AsanasScreen.routeName);
                },
              ),
            ),
            SizedBox(width: 10),
            Expanded(
              child: Button(
                'Классы',
                onTap: () {
                  Navigator.pushNamed(context, ClassroomsScreen.routeName);
                },
              ),
            ),
          ],
        ),
        SizedBox(height: 10),
        Button('Быстрая тренировка', onTap: null),
        SizedBox(height: 30),
        Button(
          'Очистить и обновить данные',
          style: ButtonStyle.warning,
          onTap: _isCleaning ? null : () => _onClearButtonTap(context),
        ),
      ],
    );
  }

  Widget _getChangelogBar() {
    // TODO: Take away styles constants
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(20),
      margin: EdgeInsets.only(top: 20),
      decoration: BoxDecoration(
        color: Color(0xFFEEF6FC),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text(
            'Версия ${widget.appVersion}',
            style: TextStyle(color: Color(0xFF1D72AA), fontSize: 18),
          ),
          LimitedBox(
            maxWidth: 120,
            child: OutlineButton(
              child: FittedBox(
                child: Text(
                  'Что нового?',
                  style: TextStyle(color: Color(0xFF1D72AA)),
                ),
              ),
              highlightColor: Colors.blue[50],
              highlightedBorderColor: Color(0xFF1D72AA),
              splashColor: Colors.transparent,
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => ChangelogScreen(), fullscreenDialog: true),
                );
              },
            ),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.white,
        child: CustomScrollView(
          slivers: [
            SliverAppBar(
              snap: false,
              expandedHeight: 200,
              backgroundColor: Colors.white,
              flexibleSpace: FlexibleSpaceBar(
                background: Image.asset(ImageAssets.yogaBgImage, fit: BoxFit.cover),
              ),
            ),
            SliverList(
              delegate: SliverChildListDelegate([
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    children: <Widget>[
                      _getChangelogBar(),
                      _getMenu(),
                    ],
                  ),
                ),
              ]),
            )
          ],
        ),
      ),
    );
  }
}

// TODO: Remove to separate file
final theme = ThemeData(
  primarySwatch: Colors.deepPurple,
  textTheme: TextTheme(
    title: GoogleFonts.pTSansCaption(
      textStyle: TextStyle(
        color: Colors.black,
        fontWeight: FontWeight.bold,
        fontSize: 36,
      ),
    ),
    button: TextStyle(color: Styles.primaryBrandColor, fontSize: 18),
    caption: GoogleFonts.pTSansCaption(
      textStyle: TextStyle(
        color: Colors.black,
        fontWeight: FontWeight.bold,
        fontSize: 20,
      ),
    ),
    body2: GoogleFonts.pTSansNarrow(
      textStyle: TextStyle(
        color: Colors.black,
        fontSize: 18,
      ),
    ),
  ),
);

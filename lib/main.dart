import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:my_yoga_fl/assets.dart';
import 'package:my_yoga_fl/repository/classroom_repository.dart';
import 'package:my_yoga_fl/screens/asanas_screen.dart';
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
          MyHomePage.routeName: (context) => MyHomePage(title: 'Yoga $appVersion'),
          ClassroomsScreen.routeName: (context) => ClassroomsScreen(),
          AsanasScreen.routeName: (context) => AsanasScreen(),
        },
        theme: ThemeData(
          primarySwatch: Colors.purple,
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
        ),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  static const routeName = '/home';

  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  void _clearAndRefresh(BuildContext context) async {
    final asanasStore = Provider.of<AsanasStore>(context, listen: false);
    final classroomsStore = Provider.of<ClassroomsStore>(context, listen: false);

    await asanasStore.refreshData();
    await classroomsStore.refreshData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.title,
          style: Theme.of(context).textTheme.title,
        ),
        centerTitle: false,
        backgroundColor: Colors.transparent,
        brightness: Brightness.light,
        elevation: 0.0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(18.0),
        child: ListView(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(5.0),
              child: Image.asset(ImageAssets.yogaBgImage),
            ),
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
              onTap: () => _clearAndRefresh(context),
            ),
          ],
        ),
      ),
    );
  }
}

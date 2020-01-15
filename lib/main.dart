import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:my_yoga_fl/screens/asanas_screen.dart';
import 'package:my_yoga_fl/screens/classrooms_screen.dart';
import 'package:my_yoga_fl/stores/asanas_store.dart';
import 'package:my_yoga_fl/stores/classrooms_store.dart';
import 'package:my_yoga_fl/widgets/button.dart';
import 'package:provider/provider.dart';

 void main() => runApp(MyApp());

 const kBrandColor = Color.fromRGBO(107, 117, 255, 1);
const kBrandColorButtonBG = Color.fromRGBO(107, 117, 255, 0.16);

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<AsanasStore>(
          create: (_) => AsanasStore()..initAsanas(),
          lazy: false,
        ),
        Provider<ClassroomsStore>(
          create: (_) => ClassroomsStore()..initClassrooms(),
          lazy: false,
        )
      ],
      child: MaterialApp(
        title: 'My Yoga App',
        debugShowCheckedModeBanner: false,
        initialRoute: MyHomePage.routeName,
        routes: {
          MyHomePage.routeName: (context) => MyHomePage(title: 'My Yoga'),
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
            button: TextStyle(color: kBrandColor, fontSize: 18),
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
  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.title,
          style: Theme.of(context).textTheme.title,
        ),
        centerTitle: false,
        backgroundColor: Colors.transparent,
        elevation: 0.0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(18.0),
        child: ListView(
          children: <Widget>[
            ClipRRect(
              borderRadius: BorderRadius.circular(5.0),
              child: Image.asset('assets/images/yoga-bg-1.jpeg'),
            ),
            SizedBox(height: 30),
            Row(
              children: <Widget>[
                Expanded(
                  child: Button(
                      title: "Асаны",
                      onPressed: () {
                        Navigator.pushNamed(context, AsanasScreen.routeName);
                      }),
                ),
                SizedBox(width: 10),
                Expanded(
                  child: Button(
                    title: "Классы",
                    onPressed: () {
                      Navigator.pushNamed(context, ClassroomsScreen.routeName);
                    },
                  ),
                ),
              ],
            ),
            SizedBox(height: 10),
            Row(
              children: <Widget>[
                Expanded(
                  child: Button(title: "Быстрая тренировка", onPressed: () => {}),
                ),
              ],
            )
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: null,
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ),
    );
  }
}

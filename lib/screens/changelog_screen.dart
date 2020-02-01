import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:my_yoga_fl/assets.dart';
import 'package:my_yoga_fl/widgets/widgets.dart';

class ChangelogScreen extends StatefulWidget {
  @override
  _ChangelogScreenState createState() => _ChangelogScreenState();
}

class _ChangelogScreenState extends State<ChangelogScreen> {
  String _data;

  @override
  void initState() {
    super.initState();

    rootBundle.loadString(OtherAssets.changelogMarkdown).then((data) {
      setState(() => _data = data);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Container(
          width: double.infinity,
          color: Colors.white,
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              if (_data == null)
                ActivityIndicator()
              else
                Expanded(
                  child: Stack(
                    alignment: Alignment.bottomCenter,
                    children: [
                      Markdown(
                        data: _data,
                        selectable: true,
                      ),
                      Container(
                        height: 25,
                        decoration: const BoxDecoration(
                          gradient: const LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              const Color(0x1AFFFFFF),
                              const Color(0xFFFFFFFF),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              Container(
                width: double.infinity,
                margin: const EdgeInsets.only(top: 5),
                child: Button(
                  'ОК, понятно',
                  style: ButtonStyle.success,
                  onTap: () => Navigator.of(context).pop(),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

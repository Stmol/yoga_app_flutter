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
          padding: EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              if (_data == null)
                ActivityIndicator()
              else
                Expanded(
                  child: Markdown(
                    data: _data,
                    selectable: true,
                  ),
                ),
              Container(
                width: double.infinity,
                margin: EdgeInsets.only(top: 10),
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

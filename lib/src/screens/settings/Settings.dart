import 'package:flutter/material.dart';
import 'MacronutrientSettings.dart';
import 'package:tuple/tuple.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../main.dart';

class Settings extends StatefulWidget {
  @override
  _SettingsState createState() => new _SettingsState();
}

class _SettingsState extends State<Settings> {

  @override
  Widget build(BuildContext context) {

    return new Scaffold(
      appBar: AppBar(
        iconTheme: new IconThemeData(
          color: Colors.black26,
        ),
        title: const Text(
          'Settings',
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: Colors.white,
        elevation: 2.0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Colors.black
          ),
          onPressed: () {
            Navigator.pop(context);
            Navigator.pop(context);
            Navigator.of(context).push(MaterialPageRoute(
              builder: (BuildContext context) => MacroHome(),
            ));

          },
        ),
      ),
      body: Column(
        children: [
          ListView(
            shrinkWrap: true,
            children: _makeSettings(),
          ),
          Expanded(
            child: Align(
              alignment: FractionalOffset.bottomCenter,
              child: Padding(
                padding: EdgeInsets.all(32.0),
                child: Text('Macro $versionNumber'),
              ),
            ),
          ),
        ],
      ),
      
    );
  }

  List<Widget> _makeSettings() {
    return [      
      Padding(
        padding: EdgeInsets.only(top: 4.0, bottom: 4.0),
        child: Material(
          elevation: 2.0,
          child: InkWell(
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(
                builder: (BuildContext context) => MacronutrientSettings(),
              ));
            },
            child: ListTile(
              leading: Icon(Icons.assignment),
              title: Text('Macronutrients'),
              subtitle: Text('Customize daily macronutrient limits.'),
            ),
          ),
        ),
      ),
      Padding(
        padding: EdgeInsets.only(top: 4.0, bottom: 4.0),
        child: Material(
          elevation: 2.0,
          child: InkWell(
            onTap: () => {},
            child: ListTile(
              leading: Icon(Icons.alarm),
              title: Text('Alerts'),
              subtitle: Text('Customize and create alerts for meals and activity.'),
            ),
          ),
        ),
      ),      
    ];
  }

}
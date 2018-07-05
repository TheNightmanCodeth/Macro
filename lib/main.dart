import 'dart:async';

import 'package:flutter/material.dart';
import 'package:tuple/tuple.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'src/widgets/GraphDetailsList.dart';
import 'src/screens/settings/Settings.dart';
import 'src/widgets/CircleGraphWidget.dart';
import 'src/screens/login/login_dialog.dart';

final FirebaseAuth _auth = FirebaseAuth.instance;
final GoogleSignIn _googleSignIn = GoogleSignIn();
const String versionNumber = "0.0-alpha_3";
  final ThemeData appTheme = ThemeData(
    accentColor: Colors.amberAccent,
    primaryColor: Colors.amber,
  );

void main() async {
  final FirebaseApp app = await FirebaseApp.configure(
    name: 'db',
    options: const FirebaseOptions(
      gcmSenderID: '828362099397',
      googleAppID: '1:828362099397:ios:1f7995ab659763a8',          
      apiKey: 'AIzaSyCbPMHSleOGc8CREfpVsKz3BXWOUeaaCtI',
      projectID: 'macro-3a898',
    )
  );
  final Firestore firestore = Firestore(app: app);
  

  runApp(MaterialApp(
    title: 'Macro',
    theme: appTheme,
    home: MacroHome(
      firestore: firestore,
    )
  ));
}

class MacroHome extends StatefulWidget {
  MacroHome({Key key, this.firestore}) : super(key: key);
  final Firestore firestore;
  CollectionReference get userdata => firestore.collection('users');

  @override
  _MacroHomePageState createState() => _MacroHomePageState();
}

class _MacroHomePageState extends State<MacroHome> {
  List<Tuple2<Tuple2<String, Color>, Tuple2<int, int>>> _macros =
      List<Tuple2<Tuple2<String, Color>, Tuple2<int, int>>>();

  Future<bool> _onWillPop() {
    return showDialog(
          context: context,
          builder: (BuildContext context) => AlertDialog(
                title: new Text('Are you sure?'),
                content: new Text('Do you want to exit Macro?'),
                actions: <Widget>[
                  new FlatButton(
                    onPressed: () => Navigator.of(context).pop(false),
                    child: new Text('No'),
                  ),
                  new FlatButton(
                    onPressed: () => Navigator.of(context).pop(true),
                    child: new Text('Yes'),
                  ),
                ],
              ),
        ) ??
        false;
  }

  Future<bool> _getLoginStatus() async {
    final FirebaseUser currentUser = await _auth.currentUser();
    if (currentUser == null) {
        bool status = await Navigator.of(context).push(MaterialPageRoute(
        builder: (BuildContext context) => LoginDialog(),
        fullscreenDialog: true,
      ));
      return (status != null && status == true);
    }
  }

  @override
  void initState() {
    super.initState();
    loadMacrosFromSharedPrefs();
  }

  @override
  Widget build(BuildContext context) {
    final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

    return WillPopScope(
        onWillPop: _onWillPop,
        child: Scaffold(
          key: _scaffoldKey,
          drawer: Drawer(
            child: Column(
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                ListView(
                  shrinkWrap: true,
                  children: <Widget>[
                    DrawerHeader(
                      child: Text(
                        'Macro',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18.0,
                        ),
                      ),
                      decoration: BoxDecoration(
                        shape: BoxShape.rectangle,
                        color: Colors.blueAccent,
                      ),
                    ),
                    ListTile(
                      leading: Icon(Icons.fitness_center),
                      title: Text('Activity'),
                    ),
                  ],
                ),
                Expanded(
                  child: Align(
                    alignment: FractionalOffset.bottomCenter,
                    // onTap
                    child: Material(
                      elevation: 15.0,
                      child: InkWell(
                        onTap: () {
                          /* Gotta pop the drawer or else the context will think 
                          it's still open when we come back from a different  
                          page and throw an exception.                        */
                          Navigator.pop(context);
                          Navigator.of(context).push(MaterialPageRoute(
                                builder: (BuildContext context) => Settings(),
                              ));
                        },
                        child: ListTile(
                          leading: Icon(Icons.settings),
                          title: Text('Settings'),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          appBar: AppBar(
            // Here we take the value from the MyHomePage object that was created by
            // the App.build method, and use it to set our appbar title.
            iconTheme: IconThemeData(
              color: Colors.black,
            ),
            title: const Text(
              'Macro',
              style: TextStyle(color: Colors.black),
            ),
            backgroundColor: Colors.white10,
            elevation: 0.0,
            leading: IconButton(
              icon: Icon(Icons.menu),
              onPressed: () => _scaffoldKey.currentState.openDrawer(),
            ),
          ),
          body: Center(
            // Center is a layout widget. It takes a single child and positions it
            // in the middle of the parent.
            child: Column(
              children: <Widget>[
                Align(
                  alignment: Alignment.center,
                  child: Padding(
                    padding: EdgeInsets.only(top: 25.0),
                    child: CustomPaint(
                      painter: CircleGraphWidget(macros: _macros),
                      //Apparently this needs to be here?
                      child: null,
                    ),
                  ),
                ),
                Expanded(
                  child: Align(
                    alignment: FractionalOffset.bottomCenter,
                    child: GraphDetailsList(items: _macros),
                  ),
                ),
              ],
            ),
          ), // This trailing comma makes auto-formatting nicer for build methods.
        ));
  }
   // build

  loadMacrosFromSharedPrefs() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> macroNames = prefs.getStringList('prefs_macroNames');
    List<String> macroValue = prefs.getStringList('prefs_macroValue');
    List<String> macroMax = prefs.getStringList('prefs_macroMax');
    List<String> macroColor = prefs.getStringList('prefs_macroColor');

    if (macroNames != null) {
      setState(() {
        List<Tuple2<Tuple2<String, Color>, Tuple2<int, int>>> list =
            List<Tuple2<Tuple2<String, Color>, Tuple2<int, int>>>();
        for (var i = 0; i < macroNames.length; i++) {
          Tuple2<Tuple2<String, Color>, Tuple2<int, int>> value =
              Tuple2<Tuple2<String, Color>, Tuple2<int, int>>(
                  Tuple2<String, Color>(macroNames[i].toString(),
                      Color(int.parse(macroColor[i]))),
                  Tuple2<int, int>(
                      int.parse(macroMax[i]), int.parse(macroValue[i])));
          list.add(value);
        }
        _macros = list;
      });
    }
  }
}

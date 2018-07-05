import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../screens/settings/MacronutrientSettings.dart';

class AddMacroDialog extends StatefulWidget {
  @override
  _AddMacroDialogState createState() => _AddMacroDialogState();
}

class _AddMacroDialogState extends State<AddMacroDialog> {

  final GlobalKey<FormState> _formKey = new GlobalKey<FormState>();
  Macro _data = Macro();
  final List<Color> colors = <Color> [
    Colors.amber,
    Colors.green,
    Colors.blue,
    Colors.red,
    Colors.lightGreen,
    Colors.deepOrange,
    Colors.deepPurple,
    Colors.indigo
  ];

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text('New Macro'),
        actions: <Widget>[
          Builder(
            builder: (BuildContext context) {
              return FlatButton(
                onPressed: () {              
                  _formKey.currentState.save();
                  _verifyNewMacro(_data, (bool t) {
                    if (t) {
                      Navigator
                      .of(context)
                      .pop(_data);
                    } else {
                      // todo: Provide feedback
                      Scaffold.of(context).showSnackBar(SnackBar(
                        content: Text("That percentage is too big!!!"),
                      ));
                    }
                  });              
                },
                child: Text('SAVE',
                  style: Theme.of(context)
                  .textTheme
                  .subhead
                ),
              );
            },
          ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Form(
            key: _formKey,
            child: ListView(
              shrinkWrap: true,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 4.0),
                  child: Material(
                    elevation: 5.0,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Padding(
                          padding: EdgeInsets.only(top: 16.0, left: 16.0, right: 16.0),
                          child: Text(
                            'Macro Name',
                            style: TextStyle(
                              color: Theme.of(context).accentColor,
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(left: 16.0, right: 16.0, bottom:16.0),
                          child: TextFormField(
                            keyboardType: TextInputType.text,
                            decoration: new InputDecoration(
                              hintText: 'Fiber',
                            ),
                            onSaved: (String val) {
                              _data.name = val;
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 4.0),
                  child: Material(
                    elevation: 5.0,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Padding(
                          padding: EdgeInsets.only(top: 16.0, left: 16.0, right: 16.0),
                          child: Text(
                            'Daily Percentage',
                            style: TextStyle(
                              color: Theme.of(context).accentColor,
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(left: 16.0, right: 16.0, bottom:16.0),
                          child: TextFormField(
                            keyboardType: TextInputType.number,
                            decoration: new InputDecoration(
                              hintText: '30',
                            ),
                            onSaved: (String val) {
                              _data.max = int.parse(val);
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),

          Padding(
            padding: EdgeInsets.symmetric(vertical: 4.0),
            child: Material(
              elevation: 5.0,
              child: Column(
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.only(top: 16.0, left: 16.0, right: 16.0),
                    child: Text(
                      'Color',
                      style: TextStyle(
                        color: Theme.of(context).accentColor,
                      ),
                    ),
                  ),
                
                  Padding(
                    padding: EdgeInsets.only(top: 0.0, left: 16.0, right: 16.0),
                    child: Container(
                      height: 100.0,
                      width: double.infinity,
                      child: ListView(
                        scrollDirection: Axis.horizontal,
                        shrinkWrap: true,
                        children: List<Widget>.generate(colors.length, (int index) {
                          return InkWell(
                            splashColor: colors[index],
                            onTap: () {
                              _data.color = colors[index];
                            },
                            child: Icon(
                              Icons.brightness_1,
                              size: 64.0,
                              color: colors[index],
                            ),
                          );
                        }),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ]),
    );
  }

  _verifyNewMacro(Macro m, Function c) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> macroNames = prefs.getStringList('prefs_macroNames');
    List<String> macroValue = prefs.getStringList('prefs_macroValue');
    List<String> macroMax   = prefs.getStringList('prefs_macroMax');
    List<String> macroColor = prefs.getStringList('prefs_macroColor');

    if (macroNames == null) {
      c(true);
    }

    int sum = 0;
    for (var val in macroMax) {
      sum += int.parse(val);
    }
    if (sum + m.max <= 100) {
      c(true);
    } else {
      c(false);
    }
  }

}
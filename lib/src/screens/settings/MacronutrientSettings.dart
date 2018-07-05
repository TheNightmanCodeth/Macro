import 'package:flutter/material.dart';
import 'package:tuple/tuple.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async';
import '../../../main.dart';
import '../../widgets/MacroDialog.dart';

class MacronutrientSettings extends StatefulWidget {
  MacronutrientSettings({Key key}): super(key: key);

  @override
  _MacronutrientSettingsState createState() => _MacronutrientSettingsState();
}

class Macro {
  String name;
  Color color;
  int max;
  int val = 0;
}

class _MacronutrientSettingsState extends State<MacronutrientSettings> {

  List<Tuple2<Tuple2<String, Color>, Tuple2<int,int>>> _macros 
  = List<Tuple2<Tuple2<String, Color>, Tuple2<int,int>>>();

  @override
  void initState() {
    super.initState();
    loadMacrosFromSharedPrefs();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(
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
          },
        ),
      ),
      body: ListView(
        shrinkWrap: true,
        children: _makeMacroSettings(),
      )
    );
  }

  List<Widget> _makeMacroSettings() {
    return <Widget> [
      Material(
        elevation: 2.0,
        child: ListView(
          shrinkWrap: true,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(top: 16.0, left: 16.0, right: 16.0),
              child: Text(
                'Macros',
                style: TextStyle(
                  color: Colors.amber,
                ),
              ),
            ),
            ListView(
              shrinkWrap: true,
              children: List<Widget>.generate(_macros.length, _buildMacroItem),
            ),
            ListTile(
              leading: Icon(Icons.add),
              title: Text(' Macro'),
              onTap: () {
                _openAddMacroDialog();
              },
            ),
          ],
        ),
      ),
    ];
  }

  Future _openAddMacroDialog() async {
    Macro result = await Navigator.of(context).push(MaterialPageRoute(
      builder: (BuildContext context) => AddMacroDialog(),
      fullscreenDialog: true,
    ));
    if (result != null) {
      await _addMacroToSharedPrefs(result.name, result.val.toString(), result.max.toString(), result.color.value.toString());
      setState(() {
        loadMacrosFromSharedPrefs();        
      });
    }
  }

  _addMacroToSharedPrefs(String name, String val, String max, String color) async {
    // Get all the lists from shared_prefs
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> macroNames = prefs.getStringList('prefs_macroNames');
    List<String> macroValue = prefs.getStringList('prefs_macroValue');
    List<String> macroMax   = prefs.getStringList('prefs_macroMax');
    List<String> macroColor = prefs.getStringList('prefs_macroColor');

    //The lists should either all be null, or all not-null. Just to be sure we check them all
    if (macroNames == null || macroValue == null || macroMax == null || macroColor == null) {
      macroNames = List<String>();
      macroValue = List<String>();
      macroMax   = List<String>();
      macroColor = List<String>();
    }

    // Add the values to the lists we got from prefs
    macroNames.add(name);
    macroValue.add(val);
    macroMax.add(max);
    macroColor.add(color);

    // Set the values in the prefs
    await prefs.setStringList('prefs_macroNames', macroNames);
    await prefs.setStringList('prefs_macroValue', macroValue);
    await prefs.setStringList('prefs_macroMax', macroMax);
    await prefs.setStringList('prefs_macroColor', macroColor);
  }

  Widget _buildMacroItem(int index) {
    return ListTile(
      leading: Icon(Icons.label, color: _macros[index].item1.item2),
      title: Text(_macros[index].item1.item1),
      onTap: () {
        showDialog(
          context: context,
          barrierDismissible: true,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Edit ${_macros[index].item1.item1}?'),
              actions: <Widget>[
                FlatButton(
                  child: Text('Edit'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          },
        );
      },
      onLongPress: () {
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext context) {
            return  AlertDialog(
              title: Text('Remove \'${_macros[index].item1.item1}\' macro?'),
              content: SingleChildScrollView(
                child: ListBody(
                  children: <Widget>[
                    Text('This cannot be undone.'),
                    Text('Are you sure you want to remove it?'),
                  ],
                ),
              ),
              actions: <Widget>[
                FlatButton(
                  child: Text('Cancel'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
                FlatButton(
                  child: Text('Remove'),
                  onPressed: () {
                    removeMacroFromSharedPrefs(index);
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          },
        );
      },
    );
  }

  removeMacroFromSharedPrefs(int index) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> names = prefs.getStringList('prefs_macroNames');
    List<String> vals = prefs.getStringList('prefs_macroValue');
    List<String> max = prefs.getStringList('prefs_macroMax');
    List<String> color = prefs.getStringList('prefs_macroColor');
    names.removeAt(index);
    vals.removeAt(index);
    max.removeAt(index);
    color.removeAt(index);
    setState(() {
      _macros.removeAt(index);
      prefs.setStringList('prefs_macroNames', names);
      prefs.setStringList('prefs_macroValue', vals);
      prefs.setStringList('prefs_macroMax', max);
      prefs.setStringList('prefs_macroColor', color);
    });
  }

  loadMacrosFromSharedPrefs() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> macroNames = prefs.getStringList('prefs_macroNames');
    List<String> macroValue = prefs.getStringList('prefs_macroValue');
    List<String> macroMax   = prefs.getStringList('prefs_macroMax');
    List<String> macroColor = prefs.getStringList('prefs_macroColor');
      
    if (macroNames != null){
      setState(() {
        List<Tuple2<Tuple2<String,Color>,Tuple2<int,int>>> list = 
        List<Tuple2<Tuple2<String, Color>, Tuple2<int,int>>>();
        for (var i = 0; i < macroNames.length; i++) {
          Tuple2<Tuple2<String, Color>, Tuple2<int,int>> value = 
          Tuple2<Tuple2<String, Color>, Tuple2<int,int>>(
            Tuple2<String, Color>(macroNames[i].toString(), Color(int.parse(macroColor[i]))),
            Tuple2<int, int>(int.parse(macroMax[i]), int.parse(macroValue[i]))
          );
          list.add(value);
        }
        _macros = list;
      });
    }
  }
}
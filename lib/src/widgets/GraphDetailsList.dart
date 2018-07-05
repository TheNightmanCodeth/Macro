import 'package:flutter/material.dart';
import 'package:tuple/tuple.dart';
import '../../main.dart';
import '../screens/settings/MacronutrientSettings.dart';

class GraphDetailsList extends StatelessWidget {
  GraphDetailsList({Key key, this.items}) : super(key: key);
  final List<Tuple2<Tuple2<String, Color>, Tuple2<int, int>>> items;

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return ListView(
      shrinkWrap: true,
      padding: EdgeInsets.only(left: 16.0, right: 16.0, bottom: 16.0),
      children: _makeItems(context),
    );
  }

  List<Widget> _makeItems(BuildContext ctx) {
    if (items.isNotEmpty) {
      List<Widget> widgets = List<Widget>();
      for (var item in items) {
        widgets.add(
          ListTile(
            leading: Icon(Icons.label, color: item.item1.item2),
            title: Text(item.item1.item1),
            trailing: Text(item.item2.item2.toString()),
          ),
        );
      }
      return widgets;
    } else return null;
  }
}

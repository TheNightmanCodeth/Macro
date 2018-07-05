import 'package:flutter/material.dart';

class FoodDialog extends StatefulWidget {
  @override
    State<StatefulWidget> createState() => _FoodDialogState();
}

class _FoodDialogState extends State<FoodDialog> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Create Food'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.save),
            onPressed: (){},
          ),
        ],
      ),
      body: Column(
        children: <Widget>[
          Flexible(
            flex: 0,
            child: Center(
              child: Form(
                child: Flex(
                  direction: Axis.vertical,
                  children: <Widget>[
                    ListTile(
                      leading: Icon(Icons.book),
                      title: TextFormField(
                        decoration: InputDecoration(
                          hintText: 'Food name...',
                        ),
                      ),
                    ),
                    ListTile(
                      leading: ,
                    ),
                  ],
                )
              )
            )
          ),
        ],
      ),
    );
  }
}
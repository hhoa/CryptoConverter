import 'package:flutter/material.dart';

class ListItemScreen extends StatelessWidget {
  final Map<String, List<String>> listCurrency;
  final List<String> listSymbol;

  ListItemScreen(this.listSymbol, this.listCurrency);

  @override
  Widget build(BuildContext context1) {
    // TODO: implement build
    return new MaterialApp(
      title: 'Second screen',
      home: new Scaffold(
        appBar: new AppBar(
          title: new Text('List Cryptocurrency'),
        ),
        body: new ListView.builder(
            itemCount: listCurrency.length,
            itemBuilder: (context, pos) {
              return new Column(
                children: <Widget>[
                  new ListTile(
                    title: new Text(
                      listCurrency[listSymbol[pos]][0],
                      style: new TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: new Text('1\$ = ${listCurrency[listSymbol[pos]][1]}\$'),
                    leading: new Text(listSymbol[pos]),
                    onTap: () => Navigator.pop(context1, listSymbol[pos]),
                  ),
                  new Padding(padding: new EdgeInsets.all(5.0)),
                  new Divider(
                    height: 7.0,
                  ),
                  new Padding(padding: new EdgeInsets.all(5.0))
                ],
              );
            }),
      ),
    );
  }
}

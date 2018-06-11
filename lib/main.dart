import 'package:flutter/material.dart';
import 'dart:convert';
import 'dart:async';
import 'package:http/http.dart' as http;
import './ListItemScreen.dart';

Map<String, List<String>> listCurrency = new Map();
List<String> listSymbol = new List();

void main() async {
  Map mCurrency = await getListCurrency();
  mCurrency['data'].forEach((k, v) {
    listCurrency.putIfAbsent(
        v['symbol'], () => [v['name'], v['quotes']['USD']['price'].toString()]);
    listSymbol.add(v['symbol']);
  });
  runApp(new MyApp());
}

Future<Map> getListCurrency() async {
  String url = 'https://api.coinmarketcap.com/v2/ticker/?limit=10';
  http.Response response = await http.get(url);

  return json.decode(response.body);
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Flutter Demo',
      theme: new ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or press Run > Flutter Hot Reload in IntelliJ). Notice that the
        // counter didn't reset back to zero; the application is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: new MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => new _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String _fromCurrency = 'BTC';
  String _toCurrency = 'ETH';
  String _fromMoney = '0';
  String _toMoney = '0';

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text('Currency Converter'),
        backgroundColor: Colors.brown,
      ),
      backgroundColor: Colors.blueGrey,
      body: new Container(
        child: new Column(
          children: <Widget>[
            _cardInfo('from', _fromCurrency, 1),
            new Container(
              height: 60.0,
              color: Colors.black54,
              child: new Center(
                  child: new CircleAvatar(
                      child: new IconButton(
                          icon: new Icon(Icons.repeat),
                          onPressed: () => _swap()), backgroundColor: Colors.black38,
                  )),
            ),
            _cardInfo('to', _toCurrency, 2),
            new Expanded(
              child: _calc(),
            )
          ],
        ),
      ),
    );
  }

  _swap() {
    debugPrint('voa dya');
    setState(() {
      String tmp = _fromCurrency;
      _fromCurrency = _toCurrency;
      _toCurrency = tmp;

      tmp = _fromMoney;
      _fromMoney = _toMoney;
      _toMoney = tmp;
    });
  }

  Widget _cardInfo(String fromTo, String name, int type) {
    return new Container(
      padding: new EdgeInsets.all(15.0),
      height: 120.0,
      width: MediaQuery.of(context).size.width,
      color: Colors.black54,
      child: new Container(
        alignment: Alignment.centerLeft,
        child: new Row(
          children: <Widget>[
            new CircleAvatar(
              child: new Text(name),
              backgroundColor: Colors.black26,
            ),
            new Expanded(
              child: new FlatButton(
                onPressed: () => _listItemScreen(context, type),
                child: new Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    new Text(
                      fromTo,
                      style: new TextStyle(
                          fontStyle: FontStyle.italic,
                          color: Colors.white70,
                          fontSize: 20.0),
                    ),
                    new Text(
                      listCurrency[name][0],
                      style: new TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.white70,
                          fontSize: 24.0),
                    )
                  ],
                ),
              ),
            ),
            new Text(type == 1 ? _fromMoney : _toMoney, style: new TextStyle(fontSize: 20.0, color: Colors.white70),)
          ],
        ),
      ),
    );
  }

  Widget _calc() {
    return new Container(
      alignment: Alignment.center,
      child: new Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          _numberCalc('7', '8', '9', 'AC'),
          _numberCalc('4', '5', '6', 'x'),
          _numberCalc('1', '2', '3', ''),
          _numberCalc('0', '00', '.', '='),
        ],
      ),
    );
  }

  Widget _numberCalc(String s1, String s2, String s3, String s4) {
    double h = 60.0;

    return new Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        new FlatButton(
            onPressed: () => _tapNumber(s1),
            child: new Container(
              alignment: Alignment.center,
              color: Colors.white70,
              width: h,
              height: h,
              child: new Text(s1),
            )),
        new FlatButton(
            onPressed: () => _tapNumber(s2),
            child: new Container(
              alignment: Alignment.center,
              color: Colors.white70,
              width: h,
              height: h,
              child: new Text(s2),
            )),
        new FlatButton(
            onPressed: () => _tapNumber(s3),
            child: new Container(
              alignment: Alignment.center,
              color: Colors.white70,
              width: h,
              height: h,
              child: new Text(s3),
            )),
        new FlatButton(
            onPressed: () => _tapNumber(s4),
            child: new Container(
              alignment: Alignment.center,
              color: Colors.white70,
              width: h,
              height: h,
              child: new Text(s4),
            )),
      ],
    );
  }

  _tapNumber(String character) {
    print(character);
    setState(() {
      int len = _fromMoney.length;
      switch (character) {
        case 'AC':
          _fromMoney = '0';
          break;
        case 'x':
          if (len > 1) {
            _fromMoney = _fromMoney.substring(0, len - 1);
          } else {
            _fromMoney = '0';
          }
          break;
        case '.':
          if (_fromMoney[len - 1] == '.') return;
          _fromMoney += '.';
          break;
        case '0':
          if (len == 1 && _fromMoney[0] == '0') return;
          _fromMoney += '0';
          break;
        case '00':
          if (len == 1 && _fromMoney[0] == '0') return;
          _fromMoney += '00';
          break;
        case '=':
          break;
        default:
          if (len == 1 && _fromMoney[0] == '0')
            _fromMoney = character;
          else
            _fromMoney += character;
      }

      _toMoney = ((double.parse(_fromMoney) *
                  double.parse(listCurrency[_fromCurrency][1])) /
              double.parse(listCurrency[_toCurrency][1]))
          .toStringAsFixed(3);
    });
  }

  _listItemScreen(BuildContext context, int type) async {
    if (listCurrency.isEmpty) return;
    final result = await Navigator.push(
        context,
        new MaterialPageRoute(
            builder: (context) =>
                new ListItemScreen(listSymbol, listCurrency)));

    print(result);
    if (result == null)
      return;
    String sym = result.toString();
    setState(() {
      switch (type) {
        case 1:
          _fromCurrency = sym;
          break;
        case 2:
          _toCurrency = sym;
          break;
      }
      _fromMoney = '0';
      _toMoney = '0';
    });
  }
}

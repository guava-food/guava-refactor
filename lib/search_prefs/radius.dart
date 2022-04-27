import 'package:flutter/material.dart';
import 'package:guava_refactor/data_files/gua_globals.dart';

class SearchRadiusPage extends StatefulWidget {
  const SearchRadiusPage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<SearchRadiusPage> createState() => _SearchRadiusPageState();
}

class _SearchRadiusPageState extends State<SearchRadiusPage> {
  @override
  Widget build(BuildContext context) {
    double _distvalue = 0;
    return MaterialApp(
      home: Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.green,
            title: Text("Distance Preference"),
          ),
          body: Center(
            child: Slider(
              value: _distvalue,
              min: 0,
              max: 25,
              divisions: 25,
              onChanged: (double value) {
                setState(() {
                  _distvalue = value;
                });
              },
            ),
          )),
    );
  }
}

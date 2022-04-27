import 'package:flutter/material.dart';
import 'package:guava_refactor/data_files/gua_globals.dart';

class SearchRadiusPage extends StatefulWidget {
  const SearchRadiusPage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<SearchRadiusPage> createState() => _SearchRadiusPageState();
}

class _SearchRadiusPageState extends State<SearchRadiusPage> {
  String _returnDistance() {
    if (_distvalue == 0) {
      return "No preference";
    } else {
      return _distvalue.round().toString() + " miles";
    }
  }

  @override
  double _distvalue = 0;
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Search radius"),
          centerTitle: true,
        ),
        body: Center(
          child: Slider(
            value: _distvalue,
            min: 0,
            max: 25,
            divisions: 25,
            label: (_returnDistance()),
            onChanged: (double value) {
              setState(() {
                _distvalue = value;
                value = searchRadius;
              });
            },
          ),
        ));
  }
}

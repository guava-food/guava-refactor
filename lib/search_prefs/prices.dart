import 'package:flutter/material.dart';
import 'package:guava_refactor/data_files/gua_globals.dart';

class PricesPage extends StatefulWidget {
  const PricesPage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<PricesPage> createState() => _PricesPageState();
}

class _PricesPageState extends State<PricesPage> {
  final Map<String, bool> _priceList = {
    "\$": false,
    "\$\$": false,
    "\$\$\$": false,
    "\$\$\$\$": false,
  };

  @override
  Widget build(BuildContext context) {
    var keys = _priceList.keys.toList();
    bool _noPref = false;

    void _convertToString() {
      // for nums
      String s = "";

      for (var i = 0; i < _priceList.length; i++) {
        if (_priceList[keys[i]]! == true) {
          s += (i + 1).toString() + ",";
        }
      }

      if (s.isNotEmpty) {
        s = s.substring(0, s.length - 1);
      }

      print(s);
      pricesAllowedNums = s;

      // for syms
      s = "";

      for (var i = 0; i < _priceList.length; i++) {
        if (_priceList[keys[i]]! == true) {
          s += keys[i] + ", ";
        }
      }

      if (s.isNotEmpty) {
        s = s.substring(0, s.length - 2);
      }

      print(s);
      pricesAllowedSyms = s;
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text("Sort by"),
        centerTitle: true,
      ),
      body: Center(
        child: ListView.builder(
          itemBuilder: (BuildContext context, int index) {
            return CheckboxListTile(
              title: Text(keys[index]),
              value: _priceList[keys[index]],
              onChanged: (value) {
                setState(() {
                  _priceList[keys[index]] = value!;
                  _convertToString();
                });
              },
            );
          },
          itemCount: _priceList.length,
        ),
      ),
    );
  }
}

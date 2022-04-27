import 'package:flutter/material.dart';
import 'package:guava_refactor/data_files/gua_globals.dart';

class PricesPage extends StatefulWidget {
  const PricesPage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<PricesPage> createState() => _PricesPageState();
}

class _PricesPageState extends State<PricesPage> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Scaffold(
            appBar: AppBar(
              backgroundColor: Colors.green,
              title: Text("Pricing"),
            ),
            body: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                //OutlinedButton(onPressed: onPressed, child: child)
              ],
            )));
  }
}

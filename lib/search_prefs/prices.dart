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
    return Scaffold(
      appBar: AppBar(
        title: const Text("Price"),
        centerTitle: true,
      ),
      body: Center(child: Text("hello world")),
    );
  }
}

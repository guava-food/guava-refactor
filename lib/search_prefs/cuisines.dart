import 'package:flutter/material.dart';
import 'package:guava_refactor/data_files/gua_globals.dart';

class CusinesPage extends StatefulWidget {
  const CusinesPage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<CusinesPage> createState() => _CusinesPageState();
}

class _CusinesPageState extends State<CusinesPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Cuisine"),
        centerTitle: true,
      ),
      body: Center(child: Text("hello world")),
    );
  }
}

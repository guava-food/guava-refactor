import 'package:flutter/material.dart';
import 'package:guava_refactor/data_files/gua_globals.dart';

class SortByPage extends StatefulWidget {
  const SortByPage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<SortByPage> createState() => _SortByPageState();
}

class _SortByPageState extends State<SortByPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Sort by"),
        centerTitle: true,
      ),
      body: Center(child: Text("hello world")),
    );
  }
}

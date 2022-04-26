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
    return Scaffold(
      appBar: AppBar(
        title: const Text("Search radius"),
        centerTitle: true,
      ),
      body: Center(child: Text("hello world")),
    );
  }
}

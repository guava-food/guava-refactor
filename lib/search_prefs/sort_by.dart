import 'package:flutter/material.dart';
import 'package:guava_refactor/data_files/gua_globals.dart';

class SortByPage extends StatefulWidget {
  const SortByPage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<SortByPage> createState() => _SortByPageState();
}

class _SortByPageState extends State<SortByPage> {
  List<String> sortby = ['Best match', 'Distance', 'Rating', 'Review Count'];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Sort by"),
        centerTitle: true,
      ),
      body: Center(
        child: ListView.builder(
          itemBuilder: (BuildContext context, int index) {
            return RadioListTile(
                title: Text(sortby[index]),
                value: sortby[index],
                groupValue: sortby,
                onChanged: (value) {
                  setState(() {
                    sortBy = sortby[index];
                  });
                });
          },
          itemCount: sortby.length,
        ),
      ),
    );
  }
}

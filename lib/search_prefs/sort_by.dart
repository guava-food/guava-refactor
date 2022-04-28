import "package:flutter/material.dart";
import "package:guava_refactor/data_files/gua_globals.dart";

class SortByPage extends StatefulWidget {
  const SortByPage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<SortByPage> createState() => _SortByPageState();
}

class _SortByPageState extends State<SortByPage> {
  final List<String> _sortByList = [
    "best_match",
    "rating",
    "review_count",
    "distance"
  ];

  final List<String> _sortByNames = [
    "Best Match",
    "Rating",
    "Review Count",
    "Distance"
  ];

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
                title: Text(_sortByNames[index]),
                value: _sortByList[index],
                groupValue: sortBy,
                onChanged: (value) {
                  setState(() {
                    sortBy = _sortByList[index];
                    sortByUI = _sortByNames[index];
                  });
                });
          },
          itemCount: _sortByList.length,
        ),
      ),
    );
  }
}

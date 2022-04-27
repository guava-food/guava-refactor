import 'package:flutter/material.dart';
import 'package:guava_refactor/data_files/gua_globals.dart';

class CuisinesPage extends StatefulWidget {
  CuisinesPage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<CuisinesPage> createState() => _CuisinesPageState();
}

class _CuisinesPageState extends State<CuisinesPage> {
  List<String> cuisines = [
    'No preference',
    'American',
    'Barbecue',
    'Chinese',
    'French',
    'Hamburger',
    'Indian',
    'Italian',
    'Japanese',
    'Mexican',
    'Pizza',
    'Seafood',
    'Steak',
    'Sushi',
    'Thai'
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Search radius"),
        centerTitle: true,
      ),
      body: Center(
        child: ListView.builder(
          itemBuilder: (BuildContext context, int index) {
            return RadioListTile(
                title: Text(cuisines[index]),
                value: cuisines[index],
                groupValue: cuisine,
                onChanged: (value) {
                  setState(() {
                    cuisine = cuisines[index];
                  });
                });
          },
          itemCount: cuisines.length,
        ),
      ),
    );
  }
}

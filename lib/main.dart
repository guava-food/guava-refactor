// ignore_for_file: prefer_const_constructors
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher_string.dart';

import 'dart:async';

import 'search_prefs/cuisines.dart';
import 'search_prefs/prices.dart';
import 'search_prefs/radius.dart';
import 'search_prefs/sort_by.dart';

import 'data_files/gua_globals.dart';
import 'data_files/likes_list.dart';
import 'data_files/rest_list.dart';
import 'package:guava_refactor/navbar_pages/likes_page.dart';
import 'package:guava_refactor/navbar_pages/settings_ui.dart';
import 'package:guava_refactor/navbar_pages/explore_page.dart';

import 'package:geolocator/geolocator.dart';

import 'package:settings_ui/settings_ui.dart';

import 'package:cached_network_image/cached_network_image.dart';

import 'package:flutter_rating_bar/flutter_rating_bar.dart';

import 'package:url_launcher/url_launcher.dart';

import 'dart:convert' as convert;
import 'package:http/http.dart' as http;

Future<Position> _determinePosition() async {
  bool serviceEnabled;
  LocationPermission permission;
  serviceEnabled = await Geolocator.isLocationServiceEnabled();
  if (!serviceEnabled) {
    return Future.error('Location services are disabled.');
  }
  permission = await Geolocator.checkPermission();
  if (permission == LocationPermission.denied) {
    permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied) {
      return Future.error('Location permissions are denied');
    }
  }
  if (permission == LocationPermission.deniedForever) {
    return Future.error(
        'Location permissions are permanently denied, we cannot request permissions.');
  }
  return await Geolocator.getCurrentPosition();
}

class MyAppIcon extends StatelessWidget {
  static const double size = 32;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: SizedBox(
          width: size,
          height: size,
          child: FlutterLogo(),
        ),
      ),
    );
  }
}

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Guava',
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      routes: {
        '/': (context) => MyHomePage(title: "🍉 Guava"),
        '/cuisines': (context) => CuisinesPage(title: "cuisines"),
        '/prices': (context) => PricesPage(title: "prices"),
        '/radius': (context) => SearchRadiusPage(title: "radius"),
        '/sortby': (context) => SortByPage(title: "sortby"),
      },
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _selectedIndex = 1;
  bool _runLoadingIcon = false;

  void _yelpRequest() async {
    Map<String, String> queryParameters = {
      'https://api.yelp.com/v3/businesses/search?term': 'food',
      'limit': '50',
      'latitude': gpsLatitude.toString(),
      'longitude': gpsLongitude.toString(),
      'sort_by': sortBy,
      'price': pricesAllowedNums == "" ? "1,2,3,4" : pricesAllowedNums,
      'open_now': openNow.toString(),
      'categories': cuisine != "No preference" ? "" : cuisine,
      'radius': searchRadius == -1 ||
              searchRadius * 1609 >= 40000 ||
              searchRadius == 0
          ? 40000.toString()
          : (searchRadius * 1609).toString()
    };

    var url = Uri.https("cors.amouxaden.workers.dev", "/", queryParameters);
    var api =
        "CSPBb5_jfbSmHLPjALQ2zoIgKlP2VlSTa6uJJOw3icdkfgnBAbKGypM2X2eatNaohl7EPHDbVD3t0LNXYv1SIvNisq76WkFvTVHGb8LoYuhZaDzjMWoCYMnYBJtMYnYx";

    var response = await http.get(
      url,
      headers: {
        'Authorization': 'Bearer ' + api,
      },
    );
    if (response.statusCode == 200) {
      print(response.statusCode);
      print(queryParameters.toString());

      yelp_json = convert.jsonDecode(response.body) as Map<String, dynamic>;

      _selectedIndex = 1;
      setState(() {});
    } else {
      print(
          'Request failed with status: ${response.statusCode}. \n  ${response.body}');
    }
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  FutureOr _onGoBack(dynamic value) {
    setState(() {});
  }

  void _savePosition() async {
    Position position = await _determinePosition();
    gpsLatitude = position.latitude.toDouble();
    gpsLongitude = position.longitude.toDouble();
    setState(() {});
  }

  Future<void> _savePositionF() async {
    Position position = await _determinePosition();
    gpsLatitude = position.latitude.toDouble();
    gpsLongitude = position.longitude.toDouble();
    _yelpRequest();
    setState(() {});
  }

  Widget _image(String asset) {
    return Image.asset(
      asset,
      height: 30.0,
      width: 30.0,
    );
  }

  String _catList(int index) {
    String s = "";
    int n = yelp_json["businesses"][index]["categories"].length;
    for (var i = 0; i < n - 1; i++) {
      s += yelp_json["businesses"][index]["categories"][i]["title"] + ", ";
    }
    s += yelp_json["businesses"][index]["categories"][n - 1]["title"];
    return s;
  }

  void _launchUrl(Uri _url) async {
    if (!await launchUrl(_url)) throw 'Could not launch $_url';
  }

  final List<String> entries = <String>['A', 'B', 'C'];
  final List<int> colorCodes = <int>[600, 500, 100];

  @override
  Widget build(BuildContext context) {
    var settingsPage = SettingsList(
      sections: [
        SettingsSection(
          title: Text(
            'Location',
            style: TextStyle(color: Colors.pink),
          ),
          tiles: <SettingsTile>[
            SettingsTile.navigation(
              leading: Icon(Icons.language),
              title: Text('Update location'),
              value:
                  Text(gpsLatitude.toString() + ", " + gpsLongitude.toString()),
              onPressed: (context) {
                _savePosition();
              },
            ),
            SettingsTile.navigation(
              leading: Icon(Icons.search),
              title: Text('Custom location'),
              value: Text("Select a custom location"),
              onPressed: (context) {
                _savePosition();
              },
            ),
          ],
        ),
        SettingsSection(
          title: Text(
            'Yelp',
            style: TextStyle(color: Colors.pink),
          ),
          tiles: <SettingsTile>[
            SettingsTile.navigation(
              leading: Icon(Icons.refresh_outlined),
              title: Text('Get new restaurants'),
              value: Text("Refreshes list using new params"),
              onPressed: (context) {
                _yelpRequest();
              },
            ),
          ],
        ),
        SettingsSection(
          title: Text(
            'Search filters',
            style: TextStyle(color: Colors.pink),
          ),
          tiles: <SettingsTile>[
            SettingsTile.switchTile(
              onToggle: (value) {
                setState(() {
                  openNow = value;
                });
              },
              initialValue: openNow,
              leading: Icon(Icons.lock_clock),
              title: Text('Open now'),
              description: openNow == false
                  ? Text("Show all restaurants")
                  : Text("Only show restaurants open now"),
            ),
            SettingsTile.navigation(
                leading: Icon(Icons.sort_rounded),
                title: Text('Sort by'),
                onPressed: (context) {
                  Navigator.pushNamed(context, "/sortby").then(_onGoBack);
                },
                description:
                    sortBy == "-1" ? Text("No preference") : Text(sortByUI)),
            SettingsTile.navigation(
              leading: Icon(Icons.directions_walk),
              title: Text('Search radius'),
              onPressed: (context) {
                Navigator.pushNamed(context, "/radius").then(_onGoBack);
              },
              description: searchRadius == -1 || searchRadius == 0
                  ? Text("No preference")
                  : Text(searchRadius.toString() + ' miles'),
            ),
            SettingsTile.navigation(
              leading: Icon(Icons.restaurant_menu),
              title: Text('Cuisine'),
              onPressed: (context) {
                Navigator.pushNamed(context, "/cuisines").then(_onGoBack);
              },
              description: cuisine == ""
                  ? Text("No preference")
                  : Text(cuisine.toString()),
            ),
            SettingsTile.navigation(
              leading: Icon(Icons.attach_money),
              title: Text('Price'),
              onPressed: (context) {
                Navigator.pushNamed(context, "/prices").then(_onGoBack);
              },
              description: pricesAllowedSyms == ""
                  ? Text("No preference")
                  : Text("Only " + pricesAllowedSyms.toString()),
            ),
          ],
        ),
        SettingsSection(
          title: Text(
            'About',
            style: TextStyle(color: Colors.pink),
          ),
          tiles: <SettingsTile>[
            SettingsTile.navigation(
                leading: Icon(Icons.info),
                title: Text('About'),
                onPressed: (context) {
                  showAboutDialog(
                      context: context,
                      applicationVersion: '0.0.2-alpha',
                      applicationIcon: MyAppIcon(),
                      applicationLegalese:
                          "Restaurant search powered by Yelp Fusion v3.");
                },
                description: Text("More info about Guava")),
          ],
        ),
      ],
    );
    var containerPage = Container(
      constraints: BoxConstraints(minWidth: 100, maxWidth: 600),
      child: ListView.separated(
          scrollDirection: Axis.vertical,
          separatorBuilder: (BuildContext context, int index) => const Divider(
                height: 20,
              ),
          padding: const EdgeInsets.all(8),
          itemCount: yelp_json["businesses"].length,
          itemBuilder: (BuildContext context, int index) {
            return Card(
                elevation: 4.0,
                child: Column(
                  children: [
                    ListTile(
                      title: Row(
                        children: [
                          Text(yelp_json["businesses"][index]["name"]),
                          SizedBox(
                            width: 50,
                          ),
                        ],
                      ),
                      subtitle: Text(_catList(index)),
                      trailing: IconButton(
                        icon: Icon(Icons.favorite_outline),
                        onPressed: () {},
                      ),
                    ),
                    Container(
                      height: 400,
                      child: Stack(children: [
                        yelp_json["businesses"][index]["image_url"] != ""
                            ? Ink.image(
                                image: CachedNetworkImageProvider(
                                    yelp_json["businesses"][index]
                                        ["image_url"]),
                                fit: BoxFit.cover,
                              )
                            : Ink.image(
                                image:
                                    AssetImage('assets/icons/guava_stock.jpg'),
                                fit: BoxFit.cover,
                              ),
                        Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              yelp_json["businesses"][index]["is_closed"]
                                  ? Column(
                                      children: [
                                        Text(
                                          "Now open",
                                          style: TextStyle(
                                              background: Paint()
                                                ..color =
                                                    Color.fromARGB(200, 0, 0, 0)
                                                ..strokeWidth = 14
                                                ..strokeJoin = StrokeJoin.round
                                                ..strokeCap = StrokeCap.round
                                                ..style = PaintingStyle.stroke,
                                              color: Colors.green,
                                              // fontWeight: FontWeight.bold,
                                              fontSize: 12),
                                        ),
                                        SizedBox(
                                          height: 20,
                                        ),
                                      ],
                                    )
                                  : Container(),
                              yelp_json["businesses"][index]["distance"]
                                              .toInt() /
                                          1609 <
                                      .5
                                  ? Text(
                                      (yelp_json["businesses"][index]
                                                          ["distance"]
                                                      .toInt() *
                                                  3.28)
                                              .toStringAsFixed(0) +
                                          " ft",
                                      style: TextStyle(
                                          background: Paint()
                                            ..color =
                                                Color.fromARGB(200, 0, 0, 0)
                                            ..strokeWidth = 14
                                            ..strokeJoin = StrokeJoin.round
                                            ..strokeCap = StrokeCap.round
                                            ..style = PaintingStyle.stroke,
                                          color: Colors.white,
                                          // fontWeight: FontWeight.bold,
                                          fontSize: 12),
                                    )
                                  : Text(
                                      (yelp_json["businesses"][index]
                                                          ["distance"]
                                                      .toInt() /
                                                  1609)
                                              .toStringAsFixed(2) +
                                          " mi",
                                      style: TextStyle(
                                          background: Paint()
                                            ..color =
                                                Color.fromARGB(200, 0, 0, 0)
                                            ..strokeWidth = 14
                                            ..strokeJoin = StrokeJoin.round
                                            ..strokeCap = StrokeCap.round
                                            ..style = PaintingStyle.stroke,
                                          color: Colors.white,
                                          // fontWeight: FontWeight.bold,
                                          fontSize: 12),
                                    ),
                              SizedBox(
                                height: 20,
                              ),
                              yelp_json["businesses"][index]["price"] != null
                                  ? Text(
                                      "${yelp_json["businesses"][index]["price"]}",
                                      style: TextStyle(
                                          background: Paint()
                                            ..color =
                                                Color.fromARGB(200, 0, 0, 0)
                                            ..strokeWidth = 14
                                            ..strokeJoin = StrokeJoin.round
                                            ..strokeCap = StrokeCap.round
                                            ..style = PaintingStyle.stroke,
                                          color: Colors.white,
                                          // fontWeight: FontWeight.bold,
                                          fontSize: 12),
                                    )
                                  : Text(""),
                            ],
                          ),
                        )
                      ]),
                    ),
                    Stack(children: [
                      Padding(
                        padding: const EdgeInsets.fromLTRB(18.0, 0.0, 8.0, 0.0),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            RatingBarIndicator(
                              rating: yelp_json["businesses"][index]["rating"],
                              itemBuilder: (context, index) =>
                                  _image('assets/icons/not_a_watermelon.png'),
                              itemCount: 5,
                              itemSize: 24.0,
                              unratedColor: Color.fromARGB(255, 122, 156, 65),
                            ),
                            Spacer(),
                            ButtonBar(
                              children: [
                                TextButton(
                                    child: const Text('Directions'),
                                    onPressed: () {}),
                                TextButton(
                                  child: const Text('View on Yelp'),
                                  onPressed: () {
                                    _launchUrl(Uri(
                                        path: yelp_json["businesses"][index]
                                            ["url"]));
                                  },
                                )
                              ],
                            ),
                          ],
                        ),
                      )
                    ])
                  ],
                ));
          }),
    );
    var emptyPage = Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        !_runLoadingIcon
            ? ElevatedButton(
                onPressed: () {
                  _savePositionF();
                  _runLoadingIcon = true;
                },
                child: const Text('Get restaurants'),
              )
            : CircularProgressIndicator()
      ],
    );

    List<Widget> _widgetOptions = <Widget>[
      Text(
        'Index 0: Likes',
      ),
      yelp_json["businesses"].isEmpty ? emptyPage : containerPage,
      settingsPage
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        centerTitle: true,
      ),
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite),
            label: 'Likes',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.explore),
            label: 'Explore',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.restaurant),
            label: 'Preferences',
          ),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }
}

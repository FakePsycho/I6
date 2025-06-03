import 'package:flutter/material.dart';
import 'package:i6/first.dart';
import 'package:i6/second.dart';
import 'package:i6/third.dart';
import 'package:i6/four.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'TabBar App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark(),
      home: HomeWithTabs(),
    );
  }
}

class HomeWithTabs extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.black,
          centerTitle: true,
          title: Text("Today's Tasks", style: TextStyle(color: Colors.green)),
          bottom: const TabBar(
            indicatorColor: Colors.green,
            labelColor: Colors.green,
            unselectedLabelColor: Colors.green,
            tabs: [
              Tab(text: "Personal"),
              Tab(text: "Default"),
              Tab(text: "Study"),
              Tab(text: "Work"),
            ],
          ),
        ),
        body: const TabBarView(children: [Page1(), Page2(), Page3(), Page4()]),
      ),
    );
  }
}

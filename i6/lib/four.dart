import 'dart:convert';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Page4 extends StatefulWidget {
  const Page4({super.key});

  @override
  State<Page4> createState() => _Page4State();
}

class _Page4State extends State<Page4> {
  List<TestList> d1 = [];
  int obbal = 0;

  final TextEditingController taskController = TextEditingController();
  final TextEditingController descController = TextEditingController();

  Future<void> saveList() async {
    final prefs = await SharedPreferences.getInstance();
    List<String> jsonList =
        d1.map((item) => jsonEncode(item.toJson())).toList();
    await prefs.setStringList('userList_page4', jsonList);
  }

  Future<void> loadList() async {
    final prefs = await SharedPreferences.getInstance();
    List<String>? jsonList = prefs.getStringList('userList_page4');
    if (jsonList != null) {
      setState(() {
        d1 =
            jsonList
                .map((item) => TestList.fromJson(jsonDecode(item)))
                .toList();
      });
    }
  }

  Future<void> saveObbal() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('obbal_page4', obbal);
  }

  Future<void> loadObbal() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      obbal = prefs.getInt('obbal_page4') ?? 0;
    });
  }

  @override
  void initState() {
    super.initState();
    loadList();
    loadObbal();
  }

  Widget t1(int e) {
    return Dismissible(
      key: UniqueKey(),
      direction: DismissDirection.endToStart,
      onDismissed: (direction) {
        final removedItem = d1[e];
        final value = int.tryParse(removedItem.qarzi ?? '0') ?? 0;

        setState(() {
          obbal -= value;
          d1.removeAt(e);
        });

        saveList();
        saveObbal();
      },

      child: Container(
        height: 80,
        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        margin: EdgeInsets.only(top: 10, bottom: 10),
        decoration: BoxDecoration(
          color: Colors.black87,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(blurRadius: 2, color: Colors.grey, offset: Offset(0, 0)),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "${d1[e].name}",
              style: TextStyle(color: Colors.green, fontSize: 20),
            ),
            Text("${d1[e].qarzi}", style: TextStyle(color: Colors.green)),
            Row(
              children: [
                Text(
                  "${d1[e].datelist}   ",
                  style: TextStyle(color: Colors.green),
                ),
                Text(
                  "${d1[e].timelist}",
                  style: TextStyle(color: Colors.white),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _showAddDialog() {
    taskController.clear();
    descController.clear();

    showDialog(
      context: context,
      builder:
          (context) => SimpleDialog(
            backgroundColor: Colors.black87,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  controller: taskController,
                  style: TextStyle(color: Colors.grey[400]),
                  decoration: InputDecoration(
                    hintText: "Task",
                    hintStyle: TextStyle(color: Colors.grey[400]),
                  ),
                  autofocus: true,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  controller: descController,
                  style: TextStyle(color: Colors.grey[400]),
                  decoration: InputDecoration(
                    hintText: "Description",
                    hintStyle: TextStyle(color: Colors.grey[400]),
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () {
                      final task = taskController.text.trim();
                      final desc = descController.text.trim();

                      if (task.isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text("Поле 'Task' не должно быть пустым"),
                            backgroundColor: Colors.red,
                          ),
                        );
                      } else {
                        final now = DateTime.now();
                        final date = DateFormat('MMMM, d y').format(now);
                        final time = DateFormat('HH:mm').format(now);

                        final value = int.tryParse(desc) ?? 0;

                        setState(() {
                          obbal += value;
                          d1.add(
                            TestList(
                              name: task,
                              qarzi: desc,
                              datelist: date,
                              timelist: time,
                            ),
                          );
                        });
                        saveObbal();
                        saveList();
                        Navigator.pop(context);
                      }
                    },
                    child: Text(
                      "Add",
                      style: TextStyle(color: Colors.greenAccent),
                    ),
                  ),
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: Text(
                      "Cancel",
                      style: TextStyle(color: Colors.redAccent),
                    ),
                  ),
                ],
              ),
            ],
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black87,
      body: Container(
        width: double.infinity,
        height: double.infinity,
        padding: EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              obbal.toString(),
              style: TextStyle(fontSize: 20, color: Colors.white70),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: d1.length,
                itemBuilder: (context, index) => t1(index),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              spreadRadius: 1,
              blurRadius: 3,
              color: Colors.grey,
              offset: Offset(0, 0),
            ),
          ],
        ),
        child: FloatingActionButton(
          backgroundColor: Colors.black,
          foregroundColor: Colors.greenAccent,
          onPressed: _showAddDialog,
          child: Icon(Icons.add),
        ),
      ),
    );
  }
}

class TestList {
  String? name;
  String? qarzi;
  String? timelist;
  String? datelist;

  TestList({this.name, this.qarzi, this.timelist, this.datelist});

  Map<String, dynamic> toJson() => {
    'name': name,
    'qarzi': qarzi,
    'timelist': timelist,
    'datelist': datelist,
  };

  factory TestList.fromJson(Map<String, dynamic> json) => TestList(
    name: json['name'],
    qarzi: json['qarzi'],
    timelist: json['timelist'],
    datelist: json['datelist'],
  );
}

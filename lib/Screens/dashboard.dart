import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  @override
  void initState() {
    getLocalStorage();
    super.initState();
  }

  dynamic getLocalStorage() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    List<String> tempTodo = [];
    for (var val in todolist) {
      tempTodo.add(toAString(val));
    }
    dynamic todo;
    try {
      todo = prefs.getStringList("todolist")!;
    } catch (e) {
      await prefs.setStringList("todolist", tempTodo);
      todo = prefs.getStringList("todolist");
    }
    setState(() {
      todolist = [];
      for (var i in todo) {
        todolist.add(jsonDecode(i));
      }
    });
  }

  dynamic saveToLocalStore() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> tempTodo = [];
    for (var val in todolist) {
      tempTodo.add(toAString(val));
    }
    await prefs.setStringList("todolist", tempTodo);
  }

  String toAString(Map<String, dynamic> abc) {
    return jsonEncode(abc);
  }

  List<Map<String, dynamic>> todolist = [
    {"title": "Learn Flutter", "isTicked": true},
    {"title": "Learn Igbo", "isTicked": false}
  ];

  final _controller = TextEditingController();

  void checkboxChange(int index) {
    setState(() {
      todolist[index]["isTicked"] = !todolist[index]["isTicked"];
    });
    saveToLocalStore();
  }

  void deleteTask(int index) {
    setState(() {
      todolist.removeAt(index);
    });
    saveToLocalStore();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.deepPurple.shade300,
      appBar: AppBar(
        title: const Center(
          child: Text("What ToDo?"),
        ),
        backgroundColor: Colors.deepPurple,
        titleTextStyle: const TextStyle(
          fontWeight: FontWeight.w500,
          fontSize: 20.0,
        ),
      ),
      body: ListView.builder(
          itemCount: todolist.length,
          itemBuilder: (BuildContext context, index) {
            return Padding(
              padding: const EdgeInsets.only(top: 20, left: 20, right: 20),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  color: Colors.deepPurple.shade200,
                ),
                padding: const EdgeInsets.fromLTRB(20, 0, 0, 0),
                child: Slidable(
                  endActionPane: ActionPane(
                    motion: StretchMotion(),
                    children: [
                      SlidableAction(
                        onPressed: (context) => deleteTask(index),
                        icon: Icons.delete,
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      Checkbox(
                        value: todolist[index]["isTicked"],
                        onChanged: (value) => checkboxChange(index),
                      ),
                      Text(
                        todolist[index]["title"],
                        style: TextStyle(
                          height: 3,
                          fontSize: 18,
                          fontWeight: FontWeight.w400,
                          decoration: todolist[index]["isTicked"]
                              ? TextDecoration.lineThrough
                              : null,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }),
      floatingActionButton: Row(
        children: [
          Expanded(
              child: Padding(
            padding: const EdgeInsets.only(
              left: 40,
              right: 20,
            ),
            child: TextField(
                onEditingComplete: () {
                  if (_controller.text != "") {
                    setState(() {
                      todolist
                          .add({"title": _controller.text, "isTicked": false});
                    });
                    _controller.clear();
                    saveToLocalStore();
                  }
                },
                controller: _controller,
                decoration: const InputDecoration(
                  hintText: "Add new items",
                  hintStyle: TextStyle(color: Colors.black26),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white, width: 2),
                    borderRadius: BorderRadius.all(Radius.circular(20)),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.deepPurple, width: 2),
                    borderRadius: BorderRadius.all(Radius.circular(20)),
                  ),
                )),
          )),
          FloatingActionButton(
            backgroundColor: Colors.deepPurple.shade600,
            foregroundColor: Colors.deepPurple.shade100,
            onPressed: () {
              if (_controller.text != "") {
                setState(() {
                  todolist.add({"title": _controller.text, "isTicked": false});
                });
                _controller.clear();
                saveToLocalStore();
              }
            },
            child: const Icon(
              Icons.add,
            ),
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:untitled8/DB_HELPER.dart';

import 'blankpage.dart';
import 'dart:async';
import 'dart:developer';
import 'dart:io';
import 'package:flutter/services.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';


class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      // Remove the debug banner
      debugShowCheckedModeBanner: false,
      title: 'Search',
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
// Open the database and store the reference.

  // This holds a list of fiction users
  // You can use data fetched from a database or a server as well
  Future<void> runSqlQuery() async {
    _allUsers = await LocalDB().readDB("SELECT * FROM Phd UNION select * from Mtech union select * from Adhoc;");

    setState(() {
      _allUsers=_allUsers;
    });
  }

  List<bool> _selected = []; //selected students list
  // This list holds the data for the list view
  List<Map<String, dynamic>> _foundUsers = [];
  List<Map<String, dynamic>> _allUsers = [];
  @override
  @override
  void initState() {
    super.initState();
    // wait for the database to be opened before setting the state
    runSqlQuery().then((_) {
      // at the beginning, all users are shown
      _foundUsers = _allUsers;

      _selected = List<bool>.generate(_allUsers.length, (index) => false);
      // update the state with the fetched data
      setState(() {});
    });
  }


  // This function is called whenever the text field changes
  void _runFilter(String enteredKeyword) {
    List<Map<String, dynamic>> results = [];
    if (enteredKeyword.isEmpty) {
      // if the search field is empty or only contains white-space, we'll display all users
      results = _allUsers;
    } else {
      results = _allUsers
          .where((user) =>
      user["RollNo"].toLowerCase().contains(enteredKeyword.toLowerCase()) || user["Name"].toLowerCase().contains(enteredKeyword.toLowerCase()) )
          .toList();
      // we use the toLowerCase() method to make it case-insensitive
    }

    // Refresh the UI
    setState(() {
      _foundUsers = results;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Search'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          children: [
            const SizedBox(
              height: 20,
            ),
            TextField(
              onChanged: (value) => _runFilter(value),
              decoration: const InputDecoration(
                  labelText: 'Search', suffixIcon: Icon(Icons.search)),
            ),
            const SizedBox(
              height: 20,
            ),
            Expanded(
              child: _foundUsers.isNotEmpty
                  ? ListView.builder(
                itemCount: _foundUsers.length,
                itemBuilder: (context, index) => Card(
                  key: ValueKey(_foundUsers[index]["id"]),
                  color: Colors.blueAccent,
                  elevation: 4,
                  margin: const EdgeInsets.symmetric(vertical: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Checkbox(
                        value: _selected[index],
                        onChanged: (value) {
                          setState(() {
                            _selected[index] = value!;
                          });
                        },
                      ),
                      Text('Roll No: ${_foundUsers[index]["RollNo"]}'),
                      Text('Name: ${_foundUsers[index]["Name"]}'),
                      Text('Dept: ${_foundUsers[index]["DEPARTMENT"]}'),
                    ],
                  ),
                ),
              )
                  : const Text(
                'No results found',
                style: TextStyle(fontSize: 24),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                List<Map<String, dynamic>> selectedUsers = [];
                for (int i = 0; i < _foundUsers.length; i++) {
                  if (_selected[i]) {
                    selectedUsers.add(_foundUsers[i]);
                  }
                }
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => BlankPage(selectedusers: selectedUsers)),
                );
              },
              child: const Text('Submit'),
            )

          ],
        ),
      ),
    );
  }
}
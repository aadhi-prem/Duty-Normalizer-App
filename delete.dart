import 'dart:ffi';

import 'package:flutter/material.dart';
import 'DB_HELPER.dart';

//import 'blankpage.dart';
import 'dart:async';
import 'dart:developer';
import 'dart:io';
import 'package:flutter/services.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class DeletePage extends StatelessWidget {
  const DeletePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      // Remove the debug banner
      debugShowCheckedModeBanner: false,
      title: 'Search',
      home: Delete(),
    );
  }
}

class Delete extends StatefulWidget {
  const Delete({Key? key}) : super(key: key);

  @override
  State<Delete> createState() => _DeleteState();
}

class _DeleteState extends State<Delete> {
// Open the database and store the reference.

  // This holds a list of fiction users
  // You can use data fetched from a database or a server as well
  Future<void> runSqlQuery() async {
    _allUsers = await LocalDB().readDB("SELECT * FROM Phd UNION select * from Mtech union select * from Adhoc;");

    setState(() {
      _allUsers=_allUsers;
    });
  }

  Map<String,bool> _selected={};//selected students list
  // This list holds the data for the list view
  List<Map<String, dynamic>> _foundUsers = [];
  List<Map<String, dynamic>> _allUsers = [];
  late String searchWord;
  @override
  @override
  void initState() {
    super.initState();
    // wait for the database to be opened before setting the state
    runSqlQuery().then((_) {
      // at the beginning, all users are shown
      _foundUsers = _allUsers;

      for(Map<String,dynamic>row in _allUsers){
        _selected[row["RollNo"]]=false;
      }
      // update the state with the fetched data
      setState(() {});
    });
  }


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

  Future<void> _deletecandidate(List<Map<String, dynamic>> selectedusers) async {
    String table;
    String statement;
    debugPrint('This is the list : $selectedusers');
    for (int i = 0; i < selectedusers.length; i++) {
      String rollNo = selectedusers[i]["RollNo"];
      if(rollNo[0] == 'M'){
        table = 'Mtech';
      }
      else if(rollNo[0] == 'P'){
        table = 'Phd';
      }
      else{
        table = 'Adhoc';
      }
      statement = "DELETE FROM $table where RollNo = '$rollNo';";
      debugPrint(statement);
      await LocalDB().executeDB(statement);
    }
    debugPrint("delete completed");
    // Refresh the UI
    await runSqlQuery();
    setState(() {
      _runFilter(searchWord);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xff9381ff),
        title: const Text('Search'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          children: [
            const SizedBox(
              height: 20,
            ),
            Container(
              decoration: BoxDecoration(boxShadow: [
                BoxShadow(
                    offset: const Offset(12, 26),
                    blurRadius: 50,
                    spreadRadius: 0,
                    color: Colors.grey.withOpacity(.1)),
              ]),
              child: TextField(
                // controller: textController,
                onChanged: (value) {
                  searchWord = value;
                  _runFilter(value);
                } ,
                decoration: InputDecoration(
                  prefixIcon: Icon(
                    Icons.search,
                    color: Colors.grey[500]!,
                  ),
                  filled: true,
                  fillColor: Colors.white,
                  hintText: 'Search',
                  hintStyle:
                  const TextStyle(color: Colors.grey, fontWeight: FontWeight.w300),
                  contentPadding:
                  const EdgeInsets.symmetric(vertical: 20.0, horizontal: 20.0),
                  border: const OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(45.0)),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey[300]!, width: 1.0),
                    borderRadius: BorderRadius.all(Radius.circular(45.0)),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey[400]!, width: 1.5),
                    borderRadius: BorderRadius.all(Radius.circular(45.0)),
                  ),
                ),
              ),
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
                  color: Color(0xff9381ff),
                  elevation: 4,
                  margin: const EdgeInsets.symmetric(vertical: 10),
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Checkbox(
                          activeColor: Color(0xfff28482),
                          checkColor: Colors.black,
                          value: _selected[_foundUsers[index]["RollNo"]],
                          onChanged: (value) {
                            setState(() {
                              _selected[_foundUsers[index]["RollNo"]] = value!;
                            });
                          },
                        ),
                        Text('Roll No: ${_foundUsers[index]["RollNo"]} '),
                        Text('Name: ${_foundUsers[index]["Name"]} '),
                        Text('Dept: ${_foundUsers[index]["DEPARTMENT"]} '),
                      ],
                    ),
                  ),
                ),
              )
                  : const Text(
                'No results found',
                style: TextStyle(fontSize: 24),
              ),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom( primary: Color(0xffff595e),),
              onPressed: () {
                List<Map<String, dynamic>> selectedUsers = [];
                for (Map<String,dynamic>r in _allUsers) {
                  if (_selected[r["RollNo"]]!) {
                    selectedUsers.add(r);
                  }
                }
                _deletecandidate(selectedUsers);

                // Navigator.push(
                //   context,
                //   MaterialPageRoute(builder: (context) => BlankPage(selectedusers: selectedUsers)),
                // );
              },
              child: const Text('Delete',style: TextStyle(fontSize: 17),),
            )

          ],
        ),
      ),
    );
  }
}
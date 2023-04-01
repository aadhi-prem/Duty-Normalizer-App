import 'package:flutter/material.dart';
import 'DB_HELPER.dart';

// import 'blankpage.dart';
import 'dart:async';
import 'dart:developer';
import 'dart:io';
import 'package:flutter/services.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

void main() {
  runApp(const block());
}

class block extends StatelessWidget {
  const block({Key? key}) : super(key: key);

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
    blockedusers = await LocalDB().readDB("SELECT * FROM Phd where Status = 'Blocked' UNION select * from Mtech where Status = 'Blocked' union select * from Adhoc where Status = 'Blocked';");
    unblockedusers = await LocalDB().readDB("SELECT * FROM Phd where Status = 'Unblocked' UNION select * from Mtech where Status = 'Unblocked' union select * from Adhoc where Status = 'UnBlocked';");
    setState(() {
      _allUsers=_allUsers;
      blockedusers=blockedusers;
      unblockedusers=unblockedusers;
    });
  }

  Map<String,bool> _selected={};//selected students list
  // This list holds the data for the list view
  List<Map<String,dynamic>> blockedusers=[];
  List<Map<String,dynamic>> unblockedusers=[];
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
      blockedusers= results
          .where((user) =>
      user["Status"]=="Blocked" )
          .toList();
      unblockedusers= results
          .where((user) =>
          user["Status"]=="Unblocked"  )
          .toList();
    });
  }

  Future<void> _statuschange(List<Map<String, dynamic>> selectedusers) async {
    String table;

    debugPrint('This is the initial list : $selectedusers');
    for (int i = 0; i < selectedusers.length; i++) {
      String rollNo = selectedusers[i]["RollNo"];
      if (rollNo[0] == 'M') {
        table = 'Mtech';
      }
      else if (rollNo[0] == 'P') {
        table = 'Phd';
      }
      else {
        table = 'Adhoc';
      }
      if (selectedusers[i]["Status"] == 'Unblocked') {
        await LocalDB().executeDB("Update $table set Status = 'Blocked' where RollNo = '$rollNo';");
      }
      else {
        await LocalDB().executeDB("Update $table set Status = 'Unblocked' where RollNo = '$rollNo';");
      }
    }
    await runSqlQuery();
    setState(() {
      debugPrint('fking work $searchWord');
      _runFilter(searchWord);
    });

   // blockedusers = await LocalDB().readDB("SELECT * FROM Phd where Status = 'Blocked' UNION select * from Mtech where Status = 'Blocked' union select * from Adhoc where Status = 'Blocked';");
    //debugPrint('$blockedusers');
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
              onChanged: (value) {
                searchWord = value;
                _runFilter(value);

              },
              decoration: const InputDecoration(
                  labelText: 'Search', suffixIcon: Icon(Icons.search)),
            ),
            const SizedBox(
              height: 20,
            ),
            Expanded(
              child: blockedusers.isNotEmpty
                  ? ListView.builder(
                itemCount: blockedusers.length,
                itemBuilder: (context, index) => Card(
                  key: ValueKey(blockedusers[index]["id"]),
                  color: Colors.red,
                  elevation: 4,
                  margin: const EdgeInsets.symmetric(vertical: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Checkbox(
                        value: _selected[blockedusers[index]["RollNo"]],
                        onChanged: (value) {
                          setState(() {
                            _selected[blockedusers[index]["RollNo"]] = value!;
                          });
                        },
                      ),
                      Text('Roll No: ${blockedusers[index]["RollNo"]}'),
                      Text('Name: ${blockedusers[index]["Name"]}'),
                      Text('Dept: ${blockedusers[index]["DEPARTMENT"]}'),
                    ],
                  ),
                ),
              )
                  : const Text(
                'No results found',
                style: TextStyle(fontSize: 24),
              ),
            ),
            Expanded(
              child: unblockedusers.isNotEmpty
                  ? ListView.builder(
                itemCount: unblockedusers.length,
                itemBuilder: (context, index) => Card(
                  key: ValueKey(unblockedusers[index]["id"]),
                  color: Colors.blueAccent,
                  elevation: 4,
                  margin: const EdgeInsets.symmetric(vertical: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Checkbox(
                        value: _selected[unblockedusers[index]["RollNo"]],
                        onChanged: (value) {
                          setState(() {
                            _selected[unblockedusers[index]["RollNo"]] = value!;
                          });
                        },
                      ),
                      Text('Roll No: ${unblockedusers[index]["RollNo"]}'),
                      Text('Name: ${unblockedusers[index]["Name"]}'),
                      Text('Dept: ${unblockedusers[index]["DEPARTMENT"]}'),
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
              onPressed: () async {
                List<Map<String, dynamic>> selectedUsers = [];
                for (Map<String,dynamic>r in _allUsers) {
                  if (_selected[r["RollNo"]]!) {
                    selectedUsers.add(r);
                  }
                }
                // debugPrint('$selectedUsers');
                await _statuschange(selectedUsers);
                await runSqlQuery();
                setState(() {
                  for(Map<String,dynamic>row in _allUsers){
                    _selected[row["RollNo"]]=false;
                  }
                });

                // Navigator.push(
                //   context,
                //   MaterialPageRoute(builder: (context) => BlankPage(selectedusers: selectedUsers)),
                // );
              },
              child: const Text('Block/Unblock'),
            )

          ],
        ),
      ),
    );
  }
}
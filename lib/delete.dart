import 'dart:ffi';

import 'package:demoapp/dashboard.dart';
import 'package:flutter/material.dart';
import 'DB_HELPER.dart';
import 'package:fluttertoast/fluttertoast.dart';

//import 'blankpage.dart';
import 'dart:async';
import 'dart:developer';
import 'dart:io';
import 'package:flutter/services.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'filter_delete.dart';

class DeletePage extends StatelessWidget {
  // const DeletePage({Key? key}) : super(key: key);

  String? dept,category;
  DeletePage({required this.dept, required this.category});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // Remove the debug banner
      debugShowCheckedModeBanner: false,
      title: 'Search',
      home: Delete(dept,category),
    );
  }
}

class Delete extends StatefulWidget {
//   const Delete({Key? key}) : super(key: key);

  String? dept,category;
  Delete(this.dept, this.category);

  @override
  State<Delete> createState() => _DeleteState(dept,category);
}

class _DeleteState extends State<Delete> {

  String? dept,category;
  _DeleteState(this.dept,this.category);
// Open the database and store the reference.

  // This holds a list of fiction users
  // You can use data fetched from a database or a server as well
  Future<void> runSqlQuery() async {
    if('$dept'=='null' && '$category'=='null' )
      _allUsers = await LocalDB().readDB("SELECT * FROM Phd UNION select * from Mtech union select * from Faculty ;");
    else if('$dept'!='null' && '$category'=='null')
      _allUsers = await LocalDB().readDB("SELECT * FROM Phd where department='$dept' union SELECT * FROM Mtech where department='$dept' union SELECT * FROM Faculty where department='$dept'");
    else if('$dept'=='null' && '$category'!='null')
      _allUsers = await LocalDB().readDB("SELECT * FROM '$category';");
    else
      _allUsers = await LocalDB().readDB("SELECT * FROM '$category' where department='$dept';");

    setState(() {
      _allUsers=_allUsers;
    });
  }

  Map<String,bool> _selected={};//selected students list
  // This list holds the data for the list view
  bool selectall=false;
  List<Map<String, dynamic>> _foundUsers = [];
  List<Map<String, dynamic>> _allUsers = [];
  late String searchWord = "";
  @override
  @override
  void initState() {
    super.initState();
    // wait for the database to be opened before setting the state
    runSqlQuery().then((_) {
      // at the beginning, all users are shown
      _foundUsers = _allUsers;

      for(Map<String,dynamic>row in _allUsers){
        _selected[row["ID"]]=false;
      }
      // update the state with the fetched data
      setState(() {});
    });
  }


  void _runFilter(String enteredKeyword) {
    List<Map<String, dynamic>> results = [];
    if (enteredKeyword == "") {
      // if the search field is empty or only contains white-space, we'll display all users
      results = _allUsers;
    } else {
      results = _allUsers
          .where((user) =>
      user["ID"].toLowerCase().contains(enteredKeyword.toLowerCase()) || user["Name"].toLowerCase().contains(enteredKeyword.toLowerCase()) )
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
    List<Map<String, dynamic>> retrieved = [];
    for (int i = 0; i < selectedusers.length; i++) {
      String rollNo = selectedusers[i]["ID"];
      retrieved = await LocalDB().readDB("select * from Mtech where ID='$rollNo';");
      if(retrieved.length != 0){
        table = 'Mtech';
      }
      else{
        retrieved = await LocalDB().readDB("select * from Phd where ID='$rollNo';");
        if(retrieved.length != 0){
          table = 'Phd';
        }
        else{
          table = 'Faculty';
        }
      }
      await LocalDB().executeDB("DELETE FROM DutyDetails where ID = '$rollNo'");
      statement = "DELETE FROM $table where ID = '$rollNo';";
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

    showDelAlertDialog(BuildContext context, List<Map<String, dynamic>> selectedUsers) {
      // set up the buttons
      Widget cancelButton = TextButton(
        onPressed: () {
          Navigator.of(context, rootNavigator: true).pop();
          // Navigator.pushReplacement(context, MaterialPageRoute(
          //   builder: (context) => Dashboard(),
          // ),); //dismiss dialog
        },
        child: Text("Cancel"),
      );
      Widget continueButton = TextButton(
        onPressed: () {
          selectall=false; // Remove this line in case of er
          _deletecandidate(selectedUsers);
          Navigator.of(context, rootNavigator: true).pop();
          // Navigator.push(context, MaterialPageRoute(
          //   builder: (context) => PinEntryPage(),
          // ),);
          Fluttertoast.showToast(
              msg: "Deleted Successfully",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.BOTTOM,
              timeInSecForIosWeb: 1,
              backgroundColor: Colors.grey[600],
              textColor: Colors.white,
              fontSize: 16.0
          );
        },
        child: Text("Continue"),
      );
      // set up the AlertDialog
      AlertDialog alert = AlertDialog(
        title: Text("Alert"),
        content: Text(
          "Are you sure you want to delete this member?", style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 16.0,
        ),),
        actions: [
          cancelButton,
          continueButton,
        ],
      );
      // show the dialog
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return alert;
        },
      );
    }
    var delpg= Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xff9381ff),
        title: const Text('Delete Student/Faculty'),
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
                  _runFilter(searchWord);
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
              height: 5,
            ),
            Row(

              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Container(
                      width: 25,
                      child: CheckboxListTile(
                        activeColor: Color(0xfff28482),
                        checkColor: Colors.black,
                        // title: Text('Select All'),
                        value: selectall,
                        onChanged: (value) {
                          setState(() {
                            selectall = value!;
                            _foundUsers.forEach((user) {
                              _selected[user["ID"]] = selectall;
                            });
                          });
                        },

                        controlAffinity: ListTileControlAffinity.leading,
                      ),
                    ),
                    Text("  Select All",style: TextStyle(color: Colors.black87),),
                  ],
                ),

                ElevatedButton.icon(
                  onPressed: (){
                    Navigator.push(context, MaterialPageRoute(builder: (context) => FilterPage()),
                    );
                  },
                  icon: Icon(Icons.filter_alt,color: Colors.black87,),

                  label: Text('Filter',style: TextStyle(color: Colors.black87),),
                  style:
                  ElevatedButton.styleFrom(
                      primary:
                      Colors.grey[300]
                  ),
                )

              ],

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
                          value: _selected[_foundUsers[index]["ID"]],
                          onChanged: (value) {
                            setState(() {
                              _selected[_foundUsers[index]["ID"]] = value!;
                            });
                          },
                        ),
                        Text(' ${_foundUsers[index]["ID"]} '),
                        Text(' ${_foundUsers[index]["Name"]} '),
                        Text(' ${_foundUsers[index]["DEPARTMENT"]} '),
                      ],
                    ),
                  ),
                ),
              )
                  : const Text(
                'No results found',
                style: TextStyle(fontSize: 24,color: Color(0xffff595e),),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Container(
                  width: 110,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      primary: Color(0xff0077b6),
                    ),
                    onPressed: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => Dashboard(),
                        ),
                      );
                    },
                    child: Text('Done',style: TextStyle(fontSize: 17),),
                  ),
                ),

            Container(
              width: 110,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom( primary: Color(0xffff595e),),
                onPressed: () {


                  // selectall=false;
                  List<Map<String, dynamic>> selectedUsers = [];
                  for (Map<String,dynamic>r in _allUsers) {
                    if (_selected[r["ID"]]!) {
                      selectedUsers.add(r);
                    }
                  }
                  if(selectedUsers.isNotEmpty){
                    showDelAlertDialog(context,selectedUsers);
                  }
                  // _deletecandidate(selectedUsers);

                  // Navigator.push(
                  //   context,
                  //   MaterialPageRoute(builder: (context) => BlankPage(selectedusers: selectedUsers)),
                  // );
                },
                child: const Text('Delete',style: TextStyle(fontSize: 17),),
              ),
            )
              ],
            ),
          ],
        ),
      ),
    );
    return delpg;
  }
}
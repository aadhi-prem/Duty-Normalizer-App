import 'package:demoapp/dashboard.dart';
import 'package:flutter/material.dart';
import 'DB_HELPER.dart';
import 'package:fluttertoast/fluttertoast.dart';

// import 'blankpage.dart';
import 'dart:async';
import 'dart:developer';
import 'dart:io';
import 'package:flutter/services.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'filter_BlockUnblock.dart';

// void main() {
//   runApp(const block());
// }

class block extends StatelessWidget {
  // const block({Key? key}) : super(key: key);

  String? dept,category;
  block({required this.dept, required this.category});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // Remove the debug banner
      debugShowCheckedModeBanner: false,
      title: 'Search',
      home: HomePage(dept,category),
    );
  }
}

class HomePage extends StatefulWidget {
  // const HomePage({Key? key}) : super(key: key);

  String? dept,category;
  HomePage(this.dept, this.category);

  @override
  State<HomePage> createState() => _HomePageState(dept,category);
}

class _HomePageState extends State<HomePage> {

  String? dept,category;
  _HomePageState(this.dept,this.category);
// Open the database and store the reference.

  // This holds a list of fiction users
  // You can use data fetched from a database or a server as well
  Future<void> runSqlQuery() async {
    // _allUsers = await LocalDB().readDB("SELECT * FROM Phd UNION select * from Mtech union select * from Adhoc  order by name ;");

    if('$dept'=='null' && '$category'=='null' )
      _allUsers = await LocalDB().readDB("SELECT * FROM Phd UNION select * from Mtech union select * from Faculty;");
    else if('$dept'!='null' && '$category'=='null')
      _allUsers = await LocalDB().readDB("SELECT * FROM Phd where department='$dept' union SELECT * FROM Mtech where department='$dept' union SELECT * FROM Faculty where department='$dept'");
    else if('$dept'=='null' && '$category'!='null')
      _allUsers = await LocalDB().readDB("SELECT * FROM '$category';");
    else
      _allUsers = await LocalDB().readDB("SELECT * FROM '$category' where department='$dept';");




    // blockedusers = await LocalDB().readDB("SELECT * FROM Phd where Status = 'Blocked' UNION select * from Mtech where Status = 'Blocked' union select * from Adhoc where Status = 'Blocked';");

    if('$dept'=='null' && '$category'=='null' )
      blockedusers = await LocalDB().readDB("SELECT * FROM Phd where Status = 'Blocked' UNION select * from Mtech where Status = 'Blocked' union select * from Faculty where Status = 'Blocked';");
    else if('$dept'!='null' && '$category'=='null')
      blockedusers = await LocalDB().readDB("SELECT * FROM Phd where department='$dept' and Status = 'Blocked' union SELECT * FROM Mtech where department='$dept'  and Status = 'Blocked'  union SELECT * FROM Faculty where department='$dept'  and Status = 'Blocked' ");
    else if('$dept'=='null' && '$category'!='null')
      blockedusers = await LocalDB().readDB("SELECT * FROM '$category' where Status = 'Blocked';");
    else
      blockedusers = await LocalDB().readDB("SELECT * FROM '$category' where department='$dept' and Status = 'Blocked';");



    // unblockedusers = await LocalDB().readDB("SELECT * FROM Phd where Status = 'Unblocked' UNION select * from Mtech where Status = 'Unblocked' union select * from Adhoc where Status = 'UnBlocked';");

    if('$dept'=='null' && '$category'=='null' )
      unblockedusers = await LocalDB().readDB("SELECT * FROM Phd where Status = 'Unblocked' UNION select * from Mtech where Status = 'Unblocked' union select * from Faculty where Status = 'Unblocked';");
    else if('$dept'!='null' && '$category'=='null')
      unblockedusers = await LocalDB().readDB("SELECT * FROM Phd where department='$dept' and Status = 'Unblocked' union SELECT * FROM Mtech where department='$dept'  and Status = 'Unblocked'  union SELECT * FROM Faculty where department='$dept'  and Status = 'Unblocked' ");
    else if('$dept'=='null' && '$category'!='null')
      unblockedusers = await LocalDB().readDB("SELECT * FROM '$category' where Status = 'Unblocked';");
    else
      unblockedusers = await LocalDB().readDB("SELECT * FROM '$category' where department='$dept' and Status = 'Unblocked';");


    setState(() {
      _allUsers=_allUsers;
      blockedusers=blockedusers;
      unblockedusers=unblockedusers;
    });
  }

  Map<String,bool> _selected={};//selected students list
  // This list holds the data for the list view
  bool selectall1=false;
  bool selectall2=false;
  List<Map<String,dynamic>> blockedusers=[];
  List<Map<String,dynamic>> unblockedusers=[];
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


  // This function is called whenever the text field changes
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
      String rollNo = selectedusers[i]["ID"];
      if (rollNo[0] == 'M') {
        table = 'Mtech';
      }
      else if (rollNo[0] == 'P') {
        table = 'Phd';
      }
      else {
        table = 'Faculty';
      }
      if (selectedusers[i]["Status"] == 'Unblocked') {
        await LocalDB().executeDB("Update $table set Status = 'Blocked' where ID = '$rollNo';");
        Fluttertoast.showToast(
            msg: "Status Updated",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.grey[600],
            textColor: Colors.white,
            fontSize: 16.0
        );
      }
      else {
        await LocalDB().executeDB("Update $table set Status = 'Unblocked' where ID = '$rollNo';");
        Fluttertoast.showToast(
            msg: "Status Updated",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.grey[600],
            textColor: Colors.white,
            fontSize: 16.0
        );
      }
    }
    await runSqlQuery();
    setState(() {
      _runFilter(searchWord);
    });

    // blockedusers = await LocalDB().readDB("SELECT * FROM Phd where Status = 'Blocked' UNION select * from Mtech where Status = 'Blocked' union select * from Adhoc where Status = 'Blocked';");
    //debugPrint('$blockedusers');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Block/Unblock'),
        elevation: .1,
        backgroundColor: Color(0xff9381ff),
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
                        activeColor: Color(0xff06d6a0),
                        checkColor: Colors.black,
                        value: selectall1,
                        onChanged: (value) {
                          setState(() {
                            selectall1 = value!;
                            blockedusers.forEach((user) {
                              _selected[user["ID"]] = selectall1;
                            });
                          });
                        },
                        controlAffinity: ListTileControlAffinity.leading,
                      ),
                    ),

                    Text("  Select All",style: TextStyle(color: Colors.black),),
                  ],
                ),
                Text("Blocked Users",style: TextStyle(fontSize: 20,color: Colors.deepPurple[900]),),
                ElevatedButton.icon(
                  onPressed: (){
                    Navigator.push(context, MaterialPageRoute(builder: (context) => FilterPage_BlockUnblock()),
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
              child: blockedusers.isNotEmpty
                  ? ListView.builder(
                itemCount: blockedusers.length,
                itemBuilder: (context, index) => Card(
                  key: ValueKey(blockedusers[index]["id"]),
                  color: Colors.red,
                  elevation: 4,
                  margin: const EdgeInsets.symmetric(vertical: 10),
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Checkbox(
                          activeColor:  Color(0xff06d6a0),
                          checkColor: Colors.black,
                          value: _selected[blockedusers[index]["ID"]],
                          onChanged: (value) {
                            setState(() {
                              _selected[blockedusers[index]["ID"]] = value!;
                            });
                          },
                        ),
                        Text('${blockedusers[index]["ID"]} '),
                        Text('${blockedusers[index]["Name"]} '),
                        Text('${blockedusers[index]["DEPARTMENT"]} '),
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
              children: [
                Container(
                  width: 25,
                  child: CheckboxListTile(
                    activeColor: Color(0xfff28482),
                    checkColor: Colors.black,
                    value: selectall2,
                    onChanged: (value) {
                      setState(() {
                        selectall2 = value!;
                        unblockedusers.forEach((user) {
                          _selected[user["ID"]] = selectall2;
                        });
                      });
                    },
                    controlAffinity: ListTileControlAffinity.leading,
                  ),
                ),
                Text("  Select All",style: TextStyle(color: Colors.black),),
                SizedBox(width: 33,),
                Text("Unblocked Users",style: TextStyle(fontSize: 20,color: Colors.deepPurple[900]),),
              ],
            ),

            Expanded(
              child: unblockedusers.isNotEmpty
                  ? ListView.builder(
                itemCount: unblockedusers.length,
                itemBuilder: (context, index) => Card(
                  key: ValueKey(unblockedusers[index]["id"]),
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
                          value: _selected[unblockedusers[index]["ID"]],
                          onChanged: (value) {
                            setState(() {
                              _selected[unblockedusers[index]["ID"]] = value!;
                            });
                          },
                        ),
                        Text('${unblockedusers[index]["ID"]} '),
                        Text('${unblockedusers[index]["Name"]} '),
                        Text('${unblockedusers[index]["DEPARTMENT"]} '),
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
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton.icon(
                  icon: Icon(Icons.arrow_back),
                  style: ElevatedButton.styleFrom(
                    primary: Color(0xff9381ff),
                  ),
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => Dashboard(),
                      ),
                    );
                  },
                  label: Text('Back',style: TextStyle(color: Colors.white,fontSize: 18),),
                ),
                SizedBox(width: 32,),

                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    primary: Color(0xff9381ff),
                  ),
                  onPressed: () async {
                    selectall1=false;
                    selectall2=false;
                    List<Map<String, dynamic>> selectedUsers = [];
                    for (Map<String,dynamic>r in _allUsers) {
                      if (_selected[r["ID"]]!) {
                        selectedUsers.add(r);
                      }
                    }
                    // debugPrint('$selectedUsers');
                    await _statuschange(selectedUsers);
                    // await runSqlQuery();
                    setState(() {
                      for(Map<String,dynamic>row in _allUsers){
                        _selected[row["ID"]]=false;
                      }
                    });

                    // Navigator.push(
                    //   context,
                    //   MaterialPageRoute(builder: (context) => BlankPage(selectedusers: selectedUsers)),
                    // );
                  },
                  child: const Text('Block/Unblock',style: TextStyle(color: Colors.white,fontSize: 18),),
                )
              ],
            ),

          ],
        ),
      ),
    );
  }
}
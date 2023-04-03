

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:sqflite/sqflite.dart';
import 'assign.dart';
import 'DB_HELPER.dart';
import 'dashboard.dart';

class ReassignPage extends StatelessWidget {
  String? name;
  ReassignPage({required this.name});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // Remove the debug banner
      debugShowCheckedModeBanner: false,
      title: 'Reassign',
      home: Reassign(name),
    );
  }
}

class Reassign extends StatefulWidget {
  String? name;
  Reassign(this.name);

  @override
  State<Reassign> createState() => ReassignState(name);
}

class ReassignState extends State<Reassign> {
  String? name;
  ReassignState(this.name);
  Future<void> runSqlQuery() async {
    
    _allUsers=await LocalDB().readDB("SELECT * FROM Mtech where ID IN (SELECT ID FROM DutyDetails where DUTY_NAME='$name') union SELECT * FROM Phd where ID IN (SELECT ID FROM DutyDetails where DUTY_NAME='$name') union SELECT * FROM Faculty where ID IN (SELECT ID FROM DutyDetails where DUTY_NAME='$name');");
      //debugPrint("$_allUsers");
    setState(() {
      _allUsers=_allUsers;
    });
  }

  Map<String,bool> _selected={};//selected students list
  // This list holds the data for the list view
  bool selectall=false;
  bool possible=true;
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
  Future<String>check_table(String s)async{
    List<Map<String, dynamic>>l=[];
    l=await LocalDB().readDB("select * from Mtech where ID='$s';");
    if(l.length!=0){
      return "Mtech";
    }
    else{
      l=await LocalDB().readDB("select * from Phd where ID='$s';");
      if(l.length!=0)
        return "Phd";
      else
        return "Faculty";
    }
  }
  Future<bool> check_limit(String type,int entered,String d)async {

    List<Map<String,dynamic>>m=[];
    if(type=="MTech"){
        m = await LocalDB().readDB("select * from Mtech where DEPARTMENT='$d' and Status='Unblocked'");
        if ( m.isEmpty ||(m.isNotEmpty && m.length < entered)) {
          return false;
        }
    }
    else if(type=="PhD"){
        m = await LocalDB().readDB("select * from PhD where DEPARTMENT='$d' and Status='Unblocked'");
        if (m.isEmpty ||(m.isNotEmpty && m.length < entered)) {
          return false;
        }
    }
    else if(type=="Faculty"){
        m = await LocalDB().readDB("select * from Faculty where DEPARTMENT='$d' and Status='Unblocked'");
        if (m.isEmpty ||(m.isNotEmpty && m.length < entered)) {
          return false;
        }
    }
    return true;
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

  Future<void> reass(List<Map<String, dynamic>> selectedusers) async {
    Database db=await LocalDB().givedb();
    List<Map<String,dynamic>>k=await db.rawQuery("select * from DUTY where DUTY_NAME='$name';");
    int hours=k[0]["WorkHours"];
    for(Map<String,dynamic>row in _allUsers){
      String t=await check_table(row["ID"]);
      await LocalDB().executeDB("Update $t set Status = 'Blocked' where ID = '${row["ID"]}';");
      int new_work=row["WorkHours"]-hours;
      await LocalDB().executeDB("Update $t set WorkHours = $new_work where ID = '${row["ID"]}';");
    }
    int mtech=0,phd=0,fac=0;
    String dept=selectedusers[0]["DEPARTMENT"];
    for(Map<String,dynamic>row in selectedusers){
     String table=await check_table(row["ID"]);
     switch(table){
       case "Mtech":mtech++;break;
       case "Phd":phd++;break;
       case "Faculty":fac++;break;
     }
    }
    if(await check_limit("MTech",mtech,dept) && await check_limit("PhD",phd,dept) && await check_limit("Faculty",fac,dept)){
      setState(() {
        possible=true;
      });
      List<Map<String, dynamic>> results = [];
      List<Map<String, dynamic>> randomValues3 = [];
      List<Map<String, dynamic>> randomValues2 = [];
      List<Map<String, dynamic>> randomValues = [];

      randomValues = List.from(await LocalDB().readDB(
          "SELECT * FROM Mtech WHERE DEPARTMENT='$dept' and Status='Unblocked' order by WorkHours,RANDOM() LIMIT $mtech;"));
      for (Map<String, dynamic>row in randomValues) {
        String r = row["ID"];
        int w = row["WorkHours"];
        w += hours;
        await LocalDB().executeDB(
            "UPDATE Mtech set WorkHours=$w where ID='$r';");
        await LocalDB().executeDB(
            "INSERT into DutyDetails values ('$r','$name');");
      }
      //debugPrint("$randomValues");
      randomValues2 = List.from(await LocalDB().readDB(
          "SELECT * FROM PhD WHERE DEPARTMENT='$dept' and Status='Unblocked' order by WorkHours,RANDOM() LIMIT $phd;"));
      for (Map<String, dynamic>row in randomValues2) {
        String r = row["ID"];
        int w = row["WorkHours"];
        w += hours;
        await LocalDB().executeDB(
            "UPDATE PhD set WorkHours=$w where ID='$r';");
        await LocalDB().executeDB(
            "INSERT into DutyDetails values ('$r','$name');");
      }
      randomValues3 = List.from(await LocalDB().readDB(
          "SELECT * FROM Faculty WHERE DEPARTMENT='$dept' and Status='Unblocked' order by WorkHours,RANDOM() LIMIT $fac"));
      for (Map<String, dynamic>row in randomValues3) {
        String r = row["ID"];
        int w = row["WorkHours"];
        w += hours;
        await LocalDB().executeDB(
            "UPDATE Faculty set WorkHours=$w where ID='$r';");
        await LocalDB().executeDB(
            "INSERT into DutyDetails values ('$r','$name');");
      }
      //results = [...randomValues, ...randomValues2, ...randomValues3];
      for(Map<String,dynamic>row in selectedusers) {
        String t=await check_table(row["ID"]);
        debugPrint("$row");
        //await LocalDB().executeDB("Delete from $t where ID='${row["ID"]}'");
        await LocalDB().executeDB("Delete from DutyDetails where ID='${row["ID"]}' and DUTY_NAME='$name'");
      }
      for(Map<String,dynamic>row in _allUsers){
        String t=await check_table(row["ID"]);
        await LocalDB().executeDB("Update $t set Status = 'Unblocked' where ID = '${row["ID"]}';");
      }
      await runSqlQuery();
      setState(() {
        _runFilter(searchWord);
        for(Map<String,dynamic>row in _allUsers){
          _selected[row["ID"]]=false;
        }
      });
    }
    else{
      setState(() {
        possible=false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xff9381ff),
        title: const Text('Reassign Student/Faculty'),
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
              ],

            ),

            Expanded(
              child: _foundUsers.isNotEmpty
                  ? ListView.builder(
                itemCount: _foundUsers.length,
                itemBuilder: (context, index) => Card(
                  key: ValueKey(_foundUsers[index]["ID"]),
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
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
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
                  child: Text('Cancel',style: TextStyle(fontSize: 17),),
                ),

                SizedBox(width: 32,),
                ElevatedButton(
                  style: ElevatedButton.styleFrom( primary: Color(0xffff595e),),
                  onPressed: () async {


                      selectall = false;
                      List<Map<String, dynamic>> selectedUsers = [];
                      for (Map<String, dynamic>r in _allUsers) {
                        if (_selected[r["ID"]]!) {
                          selectedUsers.add(r);
                        }
                      }
                      await reass(selectedUsers);
                    if(!possible){
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: Text('Ooops!'),
                            content: Text('There arent enough people in respective categories to reassign'),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.pop(context),
                                child: Text('OK'),
                              ),
                            ],
                          );
                        },
                      );
                    }
                    else{
                      Fluttertoast.showToast(
                          msg: "Reassigned Successfully",
                          toastLength: Toast.LENGTH_SHORT,
                          gravity: ToastGravity.BOTTOM,
                          timeInSecForIosWeb: 1,
                          backgroundColor: Colors.grey[600],
                          textColor: Colors.white,
                          fontSize: 16.0
                      );
                    }
                    // Navigator.push(
                    //   context,
                    //   MaterialPageRoute(builder: (context) => BlankPage(selectedusers: selectedUsers)),
                    // );
                  },
                  child: const Text('Reassign',style: TextStyle(fontSize: 17),),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
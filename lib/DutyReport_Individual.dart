import 'dart:ffi';

import 'DB_HELPER.dart';
import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'DutyReport_Individual2.dart';
import 'ReportGeneration.dart';
import 'filter_reportINDV.dart';

class IndividualReport extends StatefulWidget {

  String? dept,category;
  IndividualReport({required this.dept, required this.category});

  @override
  State<IndividualReport> createState() => _IndividualReportState(dept,category);
}

class _IndividualReportState extends State<IndividualReport> {

  String? dept,category;
  _IndividualReportState(this.dept,this.category);
// Open the database and store the reference.

  // This holds a list of fiction users
  // You can use data fetched from a database or a server as well
  Future<void> runSqlQuery() async {
    if('$dept'=='null' && '$category'=='null' )
      _allUsers = await LocalDB().readDB("SELECT * FROM Phd UNION select * from Mtech union select * from Faculty order by name ;");
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xff9381ff),
        title: const Text('Report Generation on Individual'),
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
                    Navigator.push(context, MaterialPageRoute(builder: (context) => Filter_Indv()),
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
                        builder: (context) => ReportGeneration(),
                      ),
                    );
                  },
                  child: Text('Cancel',style: TextStyle(fontSize: 17),),
                ),

                SizedBox(width: 32,),
                ElevatedButton(
                  style: ElevatedButton.styleFrom( primary: Color(0xffff595e),),
                  onPressed: () {
                    // Fluttertoast.showToast(
                    //     msg: "Deleted Successfully",
                    //     toastLength: Toast.LENGTH_SHORT,
                    //     gravity: ToastGravity.BOTTOM,
                    //     timeInSecForIosWeb: 1,
                    //     backgroundColor: Colors.grey[600],
                    //     textColor: Colors.white,
                    //     fontSize: 16.0
                    // );
                    selectall=false;
                    List<Map<String, dynamic>> selectedUsers = [];
                    for (Map<String,dynamic>r in _allUsers) {
                      if (_selected[r["ID"]]!) {
                        selectedUsers.add(r);
                      }
                    }
                    // _deletecandidate(selectedUsers);

                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => IndividualReport2(selectedUsers: selectedUsers)),
                    );
                  },
                  child: const Text('View Report(s)',style: TextStyle(fontSize: 17),),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}

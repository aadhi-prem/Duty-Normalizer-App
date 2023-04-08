import 'DB_HELPER.dart';
import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'dashboard.dart';

void main() => runApp(DeleteDutyPage());

class DeleteDutyPage extends StatelessWidget {
  const DeleteDutyPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Duty Report Generation',
      home: DeleteDuty(),
    );
  }
}


class DeleteDuty extends StatefulWidget {
  const DeleteDuty({Key? key}) : super(key: key);

  @override
  State<DeleteDuty> createState() => _DeleteDutyState();
}

class _DeleteDutyState extends State<DeleteDuty> {
  List<Map<String, dynamic>> _foundDuties = [];
  List<Map<String, dynamic>> _allDuties = [];
  Map<String,List<String>> ppl_in_duties = {};
  late String searchWord = "";
  Map<String,bool> _selected = {};
  Map<String,Map<String,bool>> _selected_from_duties = {};
  bool selectall = false;

  Future<void> runSqlQuery() async {
    _allDuties = await LocalDB().readDB("SELECT* from Duty order by DUTY_NAME;");
    setState(() {
      _allDuties=_allDuties;
    });
  }

  @override
  void initState () {
    super.initState();
    // wait for the database to be opened before setting the state
    runSqlQuery().then((_) async {
      // at the beginning, all users are shown
      _foundDuties = _allDuties;

      for(Map<String,dynamic>row in _allDuties){
        _selected[row["DUTY_NAME"]]=false;
        ppl_in_duties[row["DUTY_NAME"]]=[];
        _selected_from_duties[row["DUTY_NAME"]] = {};
        String s = "Select* from (Select* from Mtech union Select* from Phd union Select* from Faculty) where ID in (Select ID from DutyDetails where DUTY_NAME = '${row['DUTY_NAME']}')";
        List<Map<String, dynamic>> Candidates = await LocalDB().readDB(s);
        for(var i in Candidates){
          _selected_from_duties[row["DUTY_NAME"]]![i["ID"]] = false;
          ppl_in_duties[row["DUTY_NAME"]]!.add(i["ID"]);
        }
      }
      // update the state with the fetched data
      setState(() {});
    });
  }

  void _runFilter(String enteredKeyword) {
    List<Map<String, dynamic>> results = [];
    if (enteredKeyword == "") {
      // if the search field is empty or only contains white-space, we'll display all users
      results = _allDuties;
    } else {
      results = _allDuties
          .where((duty) =>
          duty["DUTY_NAME"].toLowerCase().contains(enteredKeyword.toLowerCase()))
          .toList();
      // we use the toLowerCase() method to make it case-insensitive
    }

    // Refresh the UI
    setState(() {
      _foundDuties = results;
    });
  }

  Future<List<Widget>> _Candidates(Map<String, dynamic> item) async{
    List<Widget> CandidateCards = [];
    String s = "Select* from (Select* from Mtech union Select* from Phd union Select* from Faculty) where ID in (Select ID from DutyDetails where DUTY_NAME = '${item['DUTY_NAME']}')";
    List<Map<String, dynamic>> Candidates = await LocalDB().readDB(s);

    for (var i in Candidates) {
      CandidateCards.add(Card(
          color: Color(0xffb8b8ff),
          elevation: 4,
          margin: const EdgeInsets.symmetric(vertical: 10),
          child: Container(
            height: 30,width: 350,
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Checkbox(
                    activeColor: Color(0xfff28482),
                    checkColor: Colors.black,
                    value: _selected_from_duties[item["DUTY_NAME"]]![i["ID"]],
                    onChanged: (value) {
                      setState(() {
                        _selected_from_duties[item["DUTY_NAME"]]![i["ID"]] = value!;
                      });
                    },
                  ),
                  Text('  ${i["ID"]}  ${i["Name"]}  ${i["DEPARTMENT"]} ',
                    style: TextStyle(fontSize: 15, color: Colors.black.withOpacity(0.9)),
                  ),

                ],
              ),
            ),
          )
      )
      );
    }

    return CandidateCards;
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

  Future<void> _deleteDuty(Map<String, dynamic> selectedDuty) async {
    String statement;
    debugPrint('This is the list : $selectedDuty');
    await LocalDB().executeDB("DELETE FROM DutyDetails where DUTY_NAME = '${selectedDuty["DUTY_NAME"]}';");
    await LocalDB().executeDB("DELETE FROM Duty where DUTY_NAME = '${selectedDuty["DUTY_NAME"]}';");
    int hours = selectedDuty["WorkHours"];
    for(String ID in ppl_in_duties[selectedDuty["DUTY_NAME"]]!){
      String table = await check_table(ID);
      List<Map<String, dynamic>> person = await LocalDB().readDB("Select* from $table where ID = '$ID'");
      int new_work = person[0]["WorkHours"] - hours;
      await LocalDB().executeDB("Update $table set WorkHours = $new_work where ID = '$ID'");
    }
    debugPrint("delete completed");
    // Refresh the UI
    await runSqlQuery();
    setState(() {
      _runFilter(searchWord);
    });
  }

  Future<void> _deleteCandidateFromDuty(Map<String, dynamic> Duty,String ID) async{
    await LocalDB().executeDB("DELETE FROM DutyDetails where DUTY_NAME = '${Duty["DUTY_NAME"]}' and ID = '$ID';");
    int hours = Duty["WorkHours"];
    String table = await check_table(ID);
    List<Map<String, dynamic>> person = await LocalDB().readDB("Select* from $table where ID = '$ID'");
    int new_work = person[0]["WorkHours"] - hours;
    await LocalDB().executeDB("Update $table set WorkHours = $new_work where ID = '$ID'");
    await runSqlQuery();
    setState(() {
      _runFilter(searchWord);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text('Delete Duty'),
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
                        activeColor: Color(0xfff28482),
                        checkColor: Colors.black,
                        // title: Text('Select All'),
                        value: selectall,
                        onChanged: (value) {
                          setState(() {
                            selectall = value!;
                            _foundDuties.forEach((duty) {
                              _selected[duty["DUTY_NAME"]] = selectall;
                            });
                          });
                        },

                        controlAffinity: ListTileControlAffinity.leading,
                      ),
                    ),
                    Text("  Select All",style: TextStyle(color: Colors.black87),),
                  ],
                ),

                // ElevatedButton.icon(
                //   onPressed: (){
                //     Navigator.push(context, MaterialPageRoute(builder: (context) => FilterPage()),
                //     );
                //   },
                //   icon: Icon(Icons.filter_alt,color: Colors.black87,),
                //
                //   label: Text('Filter',style: TextStyle(color: Colors.black87),),
                //   style:
                //   ElevatedButton.styleFrom(
                //       primary:
                //       Colors.grey[300]
                //   ),
                // )

              ],

            ),

            Expanded(
              child: _foundDuties.isNotEmpty
                  ? ListView.builder(
                itemCount: _foundDuties.length,
                itemBuilder: (context, index) => FutureBuilder<List<Widget>>(
                  future: _Candidates(_foundDuties[index]),
                  builder: (context,snapshot){
                    if(snapshot.hasData){
                      return ExpansionTile(
                        title: Container(
                          height: 60,
                          child: Card(
                            color: Color(0xff9381ff),
                            elevation: 4,
                            margin: const EdgeInsets.symmetric(vertical: 10),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Checkbox(
                                  activeColor: Color(0xfff28482),
                                  checkColor: Colors.black,
                                  value: _selected[_foundDuties[index]["DUTY_NAME"]],
                                  onChanged: (value) {
                                    setState(() {
                                      _selected[_foundDuties[index]["DUTY_NAME"]] = value!;
                                    });
                                  },
                                ),
                                Text(
                                  '   ${_foundDuties[index]["DUTY_NAME"]}    Duty Hours: ${_foundDuties[index]['WorkHours']}',
                                  style: TextStyle(fontSize: 17, color: Colors.black.withOpacity(0.8)),
                                ),
                              ],
                            ),
                          ),
                        ),
                        children: snapshot.data!,
                      );
                    }
                    else if(snapshot.hasError){
                      return Text("Error: ${snapshot.error}");
                    }
                    else{
                      return CircularProgressIndicator();
                    }
                  }
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
                    // List<Map<String, dynamic>> selectedDuties = [];
                    for (Map<String,dynamic>r in _allDuties) {
                      if (_selected[r["DUTY_NAME"]]!) {
                        _deleteDuty(r);
                      }
                      else{
                        for(String ID in ppl_in_duties[r["DUTY_NAME"]]!){
                          if(_selected_from_duties[r["DUTY_NAME"]]![ID]!){
                            _deleteCandidateFromDuty(r,ID);
                          }
                        }
                      }
                    }
                    // _deleteDuty(selectedDuties);

                    // Navigator.push(
                    //   context,
                    //   MaterialPageRoute(builder: (context) => DutyReport2(selectedDuties: selectedDuties)),
                    // );
                  },
                  child: const Text('Delete Duty',style: TextStyle(fontSize: 17),),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
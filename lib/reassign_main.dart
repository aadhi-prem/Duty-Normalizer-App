
import 'package:demoapp/dashboard.dart';
import 'package:demoapp/reassign.dart';


import 'DB_HELPER.dart';
import 'package:flutter/material.dart';
//import 'DutyReport_Duty2.dart';

class DutyReport1 extends StatefulWidget {
  const DutyReport1({Key? key}) : super(key: key);

  @override
  State<DutyReport1> createState() => _DutyReportState1();
}

class _DutyReportState1 extends State<DutyReport1> {

  List<Map<String, dynamic>> _foundDuties = [];
  List<Map<String, dynamic>> _allDuties = [];
  late String searchWord = "";
  String? selected;
  bool selectall = false;

  Future<void> runSqlQuery() async {
    _allDuties = await LocalDB().readDB("SELECT* from Duty order by DUTY_NAME;");
    setState(() {
      _allDuties=_allDuties;
    });
  }

  @override
  void initState() {
    super.initState();
    // wait for the database to be opened before setting the state
    runSqlQuery().then((_) {
      // at the beginning, all users are shown
      _foundDuties = _allDuties;
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Reallocate Duty'),
        elevation: .1,
        backgroundColor: const Color(0xff9381ff),
        automaticallyImplyLeading: false,
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
                    borderRadius: const BorderRadius.all(Radius.circular(45.0)),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey[400]!, width: 1.5),
                    borderRadius: const BorderRadius.all(Radius.circular(45.0)),
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 5,
            ),

            Expanded(
              child: _foundDuties.isNotEmpty
                  ? ListView.builder(
                itemCount: _foundDuties.length,
                itemBuilder: (context, index) => Card(
                  key: ValueKey(_foundDuties[index]["id"]),
                  color: const Color(0xff9381ff),
                  elevation: 4,
                  margin: const EdgeInsets.symmetric(vertical: 10),
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        //${_foundDuties[index]["DUTY_NAME"]}
                        SizedBox(
                          width: 392,height: 40,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xff9381ff),
                            ),
                            onPressed: (){
                              Navigator.push(context, MaterialPageRoute(builder: (context) => Reassign(_foundDuties[index]["DUTY_NAME"])),
                              );
                            },
                            child: SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: Text('${_foundDuties[index]["DUTY_NAME"]} ',
                                style: TextStyle(fontSize: 15, color: Colors.black.withOpacity(0.8)),
                              ),
                            ),

                          ),
                        ),

                      ],
                    ),
                  ),
                ),
              ) : const Text(
                'No results found',
                style: TextStyle(fontSize: 24,color: Color(0xffff595e),),
              ),
            )
            ,
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xffff595e),
                  ),
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => Dashboard(),
                      ),
                    );
                  },
                  child: const Text('Cancel',style: TextStyle(fontSize: 17),),
                ),
                
              ],
            ),
          ],
        ),
      ),
    );
  }
}

import 'dart:ffi';

import 'ReportGeneration.dart';

import 'DB_HELPER.dart';
import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class IndividualReport2 extends StatefulWidget {
  List<Map<String, dynamic>> selectedUsers;
  IndividualReport2({required this.selectedUsers});

  @override
  State<IndividualReport2> createState() => _IndividualReport2State(selectedUsers);
}

class _IndividualReport2State extends State<IndividualReport2> {

  List<Map<String, dynamic>> selectedUsers;
  _IndividualReport2State(this.selectedUsers);

  Future<List<Widget>> _Duties(Map<String, dynamic> item) async{
    List<Widget> DutyCards = [];
    String s = "Select* from Duty where DUTY_NAME in (Select DUTY_NAME from DutyDetails where ID = '${item['ID']}')";
    List<Map<String, dynamic>> Duties = await LocalDB().readDB(s);

    for (var i in Duties) {
      DutyCards.add(Card(
          color: Color(0xff9381ff),
          elevation: 4,
          margin: const EdgeInsets.symmetric(vertical: 10),
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Text('${i["DUTY_NAME"]} '),
                Text('${i["WorkHours"]} '),
              ],
            ),
          )
      )
      );
    }

    return DutyCards;
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text('Duty Reports')
      ),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          children: [
            const SizedBox(
              height: 20,
            ),

            Expanded(
              child: selectedUsers.isNotEmpty
                  ? ListView.builder  (
                  itemCount: selectedUsers.length,
                  itemBuilder: (context, index) => FutureBuilder<List<Widget>>(
                      future: _Duties(selectedUsers[index]),
                      builder: (context, snapshot){
                        if(snapshot.hasData) {
                          return ExpansionTile(
                            title: Card(
                              child: Text(
                                  '${selectedUsers[index]["ID"]} ${selectedUsers[index]['Name']} ${selectedUsers[index]['DEPARTMENT']}'
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
                  )
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
                    // selectall=false;
                    // List<Map<String, dynamic>> selectedDuties = [];
                    // for (Map<String,dynamic>r in _allDuties) {
                    //   if (_selected[r["DUTY_NAME"]]!) {
                    //     selectedDuties.add(r);
                    //   }
                    // }
                    // Navigator.push(
                    //   context,
                    //   MaterialPageRoute(builder: (context) => DutyReport2(selectedDuties: selectedDuties)),
                    // );
                  },
                  child: const Text('Download',style: TextStyle(fontSize: 17),),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}

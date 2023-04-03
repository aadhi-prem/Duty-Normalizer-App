import 'dart:ffi';

import 'ReportGeneration.dart';

import 'DB_HELPER.dart';
import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DutyReport2 extends StatefulWidget {
  List<Map<String, dynamic>> selectedDuties;

  DutyReport2({required this.selectedDuties});

  @override
  State<DutyReport2> createState() => _DutyReport2State(selectedDuties);
}

class _DutyReport2State extends State<DutyReport2> {

  List<Map<String, dynamic>> selectedDuties;
  _DutyReport2State(this.selectedDuties);

  Future<List<Widget>> _Candidates(Map<String, dynamic> item) async{
    List<Widget> CandidateCards = [];
    String s = "Select* from (Select* from Mtech union Select* from Phd union Select* from Faculty) where ID in (Select ID from DutyDetails where DUTY_NAME = '${item['DUTY_NAME']}')";
    List<Map<String, dynamic>> Candidates = await LocalDB().readDB(s);

    for (var i in Candidates) {
      CandidateCards.add(Card(
          color: Color(0xff9381ff),
          elevation: 4,
          margin: const EdgeInsets.symmetric(vertical: 10),
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Text('${i["ID"]} '),
                Text('${i["Name"]} '),
                Text('${i["DEPARTMENT"]} '),
              ],
            ),
          )
        )
      );
    }

    return CandidateCards;
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
              child: selectedDuties.isNotEmpty
                  ? ListView.builder  (
                itemCount: selectedDuties.length,
                itemBuilder: (context, index) => FutureBuilder<List<Widget>>(
                    future: _Candidates(selectedDuties[index]),
                    builder: (context, snapshot){
                      if(snapshot.hasData) {
                        return ExpansionTile(
                          title: Card(
                            child: Text(
                              '${selectedDuties[index]["DUTY_NAME"]} ${selectedDuties[index]['WorkHours']}'
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



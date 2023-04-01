// import 'package:demo/DB_HELPER.dart';
import 'package:flutter/material.dart';

import 'DB_HELPER.dart';
import 'BlockUnblock.dart';

class FilterPage_BlockUnblock extends StatefulWidget {
  @override
  _FilterState_UB createState() => _FilterState_UB();
}

class _FilterState_UB extends State<FilterPage_BlockUnblock>{


  // Future<void> runSqlQuery() async {
  //   _deptList = await LocalDB().readDB("SELECT * FROM Phd UNION select * from Mtech union select * from Adhoc  order by name ;");
  //
  //   setState(() {
  //     _deptList=_deptList;
  //   });
  // }
  // List<Map<String, dynamic>> _deptList = [];



  List _deptList=["CSE","CE","EEE","ECE","ME","CHE","EP","PE","MSE","BT","AR","MCA"];
  List _catList=["MTech","PhD","Adhoc"];
  // String _year='';
  String? dept;
  String? category;
  late String newValue;
  late String newValue2;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Filter Page'),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Container(
              padding: EdgeInsets.only(left:16, right: 16),
              decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey,width: 1),
                  borderRadius: BorderRadius.circular(15)
              ),
              child: DropdownButton(
                hint: Text("Select Stream: "),
                icon: Icon(Icons.arrow_drop_down),
                iconSize: 36,
                isExpanded: true,
                underline: SizedBox(),
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 22
                ),
                value: dept,
                onChanged: (newValue){
                  setState(() {
                    dept = newValue as String;
                  });
                },
                items: _deptList.map((valueItem) {
                  return DropdownMenuItem(
                    value: valueItem,
                    child: Text(valueItem),
                  );
                }).toList(),
              ),
            ),
          ),

          Padding(padding: EdgeInsets.all(2),),

          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Container(
              padding: EdgeInsets.only(left:16, right: 16),
              decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey,width: 1),
                  borderRadius: BorderRadius.circular(15)
              ),
              child: DropdownButton(
                hint: Text("Select Category: "),
                icon: Icon(Icons.arrow_drop_down),
                iconSize: 36,
                isExpanded: true,
                underline: SizedBox(),
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 22
                ),
                value: category,
                onChanged: (newValue2){
                  setState(() {
                    category = newValue2 as String;
                  });
                },
                items: _catList.map((valueItem2) {
                  return DropdownMenuItem(
                    value: valueItem2,
                    child: Text(valueItem2),
                  );
                }).toList(),
              ),
            ),
          ),


          MaterialButton(
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => block(dept: dept, category: category)),
              );
            },
            color: Colors.blueAccent,
            child: const Text('Filter',style: TextStyle(color: Colors.white),),
          ),
        ],
      ),
    );
  }
}

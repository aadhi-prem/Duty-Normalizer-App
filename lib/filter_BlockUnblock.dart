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



  List _deptList=["CSED","CED","EED","ECED","MED","CHED","EPD","PED","BTD","ARD"];
  List _catList=["MTech","PhD","Faculty"];
  // String _year='';
  String? dept;
  String? category;
  late String newValue;
  late String newValue2;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   title: Text('Filter Page'),
      // ),
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: <Widget>[
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/background.png'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 64.0),
              child: SizedBox(
                height: MediaQuery.of(context).size.height * 0.75,
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(32.0),
                      topRight: Radius.circular(32.0),
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(32.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Padding(padding: EdgeInsets.all(16),
                          child: Container(child: Text("Filter",style: TextStyle(fontSize: 28,fontFamily: 'Alkatra',color: Colors.deepPurple[900],),
                          ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(bottom: 10),
                          child: Container(
                            width: 380,
                            padding: EdgeInsets.symmetric(horizontal: 2,vertical: 20),
                            child: DropdownButtonFormField(
                              decoration: InputDecoration(
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: Color.fromRGBO(143, 148, 251, 1), width: 3),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                border: OutlineInputBorder(
                                  borderSide: BorderSide(color: Color.fromRGBO(143, 148, 251, .6), width: 3),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                filled: true,
                                fillColor: Colors.white,//Color(0xff9381ff),
                              ),
                              dropdownColor: Color(0xff9381ff),
                              hint: Text("Select Department: "),
                              icon: Icon(Icons.arrow_drop_down),
                              iconSize: 30,
                              style: TextStyle(
                                  color: Colors.deepPurple[900],
                                  fontSize: 20
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

                        Padding(
                          padding: const EdgeInsets.all(0),
                          child: Container(
                            width: 380,
                            padding: EdgeInsets.only(left: 2,right: 2,bottom: 25,),
                            child: DropdownButtonFormField(
                              decoration: InputDecoration(
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: Color.fromRGBO(143, 148, 251, 1), width: 3),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                border: OutlineInputBorder(
                                  borderSide: BorderSide(color: Color.fromRGBO(143, 148, 251, .6), width: 3),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                filled: true,
                                fillColor: Colors.white,//Color(0xff9381ff),
                              ),
                              dropdownColor: Color(0xff9381ff),
                              hint: Text("Select Category: "),
                              icon: Icon(Icons.arrow_drop_down),
                              iconSize: 30,
                              style: TextStyle(
                                  color: Colors.deepPurple[900],
                                  fontSize: 20
                              ),


                              value: category,
                              onChanged: (newValue2) {
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
                                    builder: (context) => block(dept: 'null', category: 'null'),
                                  ),
                                );
                              },
                              child: Text('Cancel',style: TextStyle(color: Colors.white,fontSize: 18),),
                            ),
                            SizedBox(width: 32,),
                            ElevatedButton(

                              onPressed: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(builder: (context) => block(dept: dept, category: category)),
                                );
                              },
                              style: ElevatedButton.styleFrom(
                                primary: Color(0xff9381ff),
                              ),
                              child: const Text('Filter',style: TextStyle(color: Colors.white,fontSize: 18),),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),


      // body: Column(
      //   crossAxisAlignment: CrossAxisAlignment.center,
      //   mainAxisAlignment: MainAxisAlignment.start,
      //   children: [
      //     Padding(
      //       padding: const EdgeInsets.all(16.0),
      //       child: Container(
      //         padding: EdgeInsets.only(left:16, right: 16),
      //         decoration: BoxDecoration(
      //             border: Border.all(color: Colors.grey,width: 1),
      //             borderRadius: BorderRadius.circular(15)
      //         ),
      //         child: DropdownButton(
      //           hint: Text("Select Stream: "),
      //           icon: Icon(Icons.arrow_drop_down),
      //           iconSize: 36,
      //           isExpanded: true,
      //           underline: SizedBox(),
      //           style: TextStyle(
      //               color: Colors.black,
      //               fontSize: 22
      //           ),
      //           value: dept,
      //           onChanged: (newValue){
      //             setState(() {
      //               dept = newValue as String;
      //             });
      //           },
      //           items: _deptList.map((valueItem) {
      //             return DropdownMenuItem(
      //               value: valueItem,
      //               child: Text(valueItem),
      //             );
      //           }).toList(),
      //         ),
      //       ),
      //     ),
      //
      //     Padding(padding: EdgeInsets.all(2),),
      //
      //     Padding(
      //       padding: const EdgeInsets.all(16.0),
      //       child: Container(
      //         padding: EdgeInsets.only(left:16, right: 16),
      //         decoration: BoxDecoration(
      //             border: Border.all(color: Colors.grey,width: 1),
      //             borderRadius: BorderRadius.circular(15)
      //         ),
      //         child: DropdownButton(
      //           hint: Text("Select Category: "),
      //           icon: Icon(Icons.arrow_drop_down),
      //           iconSize: 36,
      //           isExpanded: true,
      //           underline: SizedBox(),
      //           style: TextStyle(
      //               color: Colors.black,
      //               fontSize: 22
      //           ),
      //           value: category,
      //           onChanged: (newValue2){
      //             setState(() {
      //               category = newValue2 as String;
      //             });
      //           },
      //           items: _catList.map((valueItem2) {
      //             return DropdownMenuItem(
      //               value: valueItem2,
      //               child: Text(valueItem2),
      //             );
      //           }).toList(),
      //         ),
      //       ),
      //     ),
      //
      //
      //     MaterialButton(
      //       onPressed: () {
      //         Navigator.of(context).push(
      //           MaterialPageRoute(builder: (context) => block(dept: dept, category: category)),
      //         );
      //       },
      //       color: Colors.blueAccent,
      //       child: const Text('Filter',style: TextStyle(color: Colors.white),),
      //     ),
      //   ],
      // ),
    );
  }
}
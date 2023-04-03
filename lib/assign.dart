import 'DB_HELPER.dart';
import 'report.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sqflite/sqflite.dart';

class AssignPage extends StatelessWidget {
  AssignPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Search',
      home: assign(),
    );
  }
}

class assign extends StatefulWidget {
  assign();

  @override
  State<assign> createState() => _AssignState();
}

class _AssignState extends State<assign> {
  List _deptList=["CSED","CED","EED","ECED","MED","CHE","PED","MSE","BT","AR","MCA"];
  String? dept,name;
  bool f1=false,f2=false,f3=false;
  int mtech=0,phd=0,faculty=0,hours=0;
  String _selectedDepartment="";
  String _warningTextm = '',_warningTextp = '',_warningTexta = '',_warningTextn = 'Please Enter a Name',warningTexth='Please choose the work hours';
  final TextEditingController _mtechController = TextEditingController(text: '0');
  final TextEditingController _phdController = TextEditingController(text: '0');
  final TextEditingController _facultyController = TextEditingController(text: '0');
  final TextEditingController _dutyNameController = TextEditingController();
  final TextEditingController _hoursController = TextEditingController();
  Future<bool> check_limit(String type,int entered,String? d)async {
    List<Map<String,dynamic>>m=[];
    if(type=="MTech"){
      if(d==null) {
        return false;
      }
      else{
        m = await LocalDB().readDB("select * from MTech where DEPARTMENT='$d' and Status='Unblocked'");
        m ??= [];
        if ( m.isEmpty ||(m.isNotEmpty && m.length < entered)) {
          return false;
        }
      }
    }
    else if(type=="PhD"){
      if(d==null) {
        return false;
      }
      else{
        m = await LocalDB().readDB("select * from PhD where DEPARTMENT='$d' and Status='Unblocked'");
        m ??= [];
        if (m.isEmpty ||(m.isNotEmpty && m.length < entered)) {
          return false;
        }
      }
    }
    else if(type=="Faculty"){
      if(d==null) {
        return false;
      }
      else{
        m = await LocalDB().readDB("select * from Faculty where DEPARTMENT='$d' and Status='Unblocked'");
        m ??= [];
        if (m.isEmpty ||(m.isNotEmpty && m.length < entered)) {
          return false;
        }
      }
    }
    return true;
  }
  bool isValid(String name) {
    // A valid username contains only letters, numbers, and underscores
    final RegExp regex = RegExp(r'^[a-zA-Z0-9_]+$');
    return name!="" && regex.hasMatch(name);
  }


  Future<bool> check_name(String s)async{
    Database db= await LocalDB().givedb();
    List<Map<String,dynamic>> m= await db.rawQuery("select * from Duty where DUTY_NAME='$s';");
    if(m.length!=0)
      return false;
    return true;
  }
  _AssignState();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Assign Duty'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _dutyNameController,
              decoration: const InputDecoration(
                labelText: 'Duty Name',
                border: OutlineInputBorder(),
              ),
              onChanged: (String value) async {
                if(isValid(value)) {
                  debugPrint("aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa$value");
                  if (await check_name(value)) {
                    setState(() {
                      name=value;
                      _warningTextn = '';
                    });
                  } else {
                    setState(() {
                      _warningTextn = 'Duty Name already exists';
                    });
                  }
                }
                else{
                  setState(() {
                    _warningTextn = 'Please enter a valid duty name';
                  });
                }
              },
            ),
            const SizedBox(height: 16),
            if (_warningTextn.isNotEmpty) Container(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                _warningTextn,
                style: const TextStyle(
                  color: Colors.red,
                ),
              ),
            ),
            const SizedBox(height: 16),
            DropdownButton(
              hint: const Text("Select Department"),
              icon: const Icon(Icons.arrow_drop_down),
              iconSize: 36,
              isExpanded: true,
              underline: const SizedBox(),
              style: const TextStyle(
                  color: Colors.black,
                  fontSize: 22
              ),
              value: dept,
              onChanged: (newValue){
                if(newValue!=null) {
                  setState(() {
                    dept = newValue as String;
                  });
                }
                else{
                  debugPrint("nooooooooooooooooooooooooooooooooooooooooooooooooo");
                }
              },
              items: _deptList.map((valueItem) {
                return DropdownMenuItem(
                  value: valueItem,
                  child: Text(valueItem),
                );
              }).toList(),
            ),
            TextField(
              controller: _hoursController,
              decoration: const InputDecoration(
                labelText: 'Work Hours',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
              inputFormatters: <TextInputFormatter>[
                FilteringTextInputFormatter.digitsOnly
              ],
              onChanged: (String value) async {
                if(value==""){
                  setState(() {
                    warningTexth="Enter a valid number of hours";
                  });

                }
                else{
                  setState(() {
                    warningTexth="";
                    hours=int.parse(value);
                  });
                }
              },
            ),
            const SizedBox(height: 16),
            if (warningTexth.isNotEmpty) Container(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                warningTexth,
                style: const TextStyle(
                  color: Colors.red,
                ),
              ),
            ),
            const SizedBox(height: 16),
            Visibility(
              visible: dept != null,
              child: TextField(
                controller: _mtechController,
                decoration: const InputDecoration(
                  labelText: 'MTech',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
                inputFormatters: <TextInputFormatter>[
                  FilteringTextInputFormatter.digitsOnly
                ],
                onChanged: (String value) async {
                  if(value=="") value="0";
                  if (await check_limit("MTech", int.parse(value), dept!)) {
                    setState(() {
                      f1=true;
                      _warningTextm = '';
                      mtech = int.parse(value);
                    });
                  } else {
                    setState(() {
                      f1=false;
                      _warningTextm = 'The input exceeds available limit';
                    });
                  }
                },
              ),
            ),
            const SizedBox(height: 16),
            if (_warningTextm.isNotEmpty) Container(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                _warningTextm,
                style: const TextStyle(
                  color: Colors.red,
                ),
              ),
            ),
            const SizedBox(height: 16),
            const SizedBox(height: 16),
            Visibility(
              visible: dept!=null,
              child:TextField(
                controller: _phdController,
                decoration: const InputDecoration(
                  labelText: 'PhD',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
                inputFormatters: <TextInputFormatter>[
                  FilteringTextInputFormatter.digitsOnly
                ],
                onChanged: (String value) async {
                  if(value=="") value="0";
                  if(await check_limit("PhD", int.parse(value),dept!)){
                    setState(() {
                      f2=true;
                      _warningTextp = '';
                      phd=int.parse(value);
                    });
                  } else {
                    setState(() {
                      f2=false;
                      _warningTextp = 'The input exceeds available limit';
                    });
                  }
                },
              ),
            ),
            const SizedBox(height: 16),
            if (_warningTextp.isNotEmpty) Container(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                _warningTextp,
                style: const TextStyle(
                  color: Colors.red,
                ),
              ),
            ),
            const SizedBox(height: 16),
            Visibility(
              visible: dept!=null,
              child: TextField(
                controller: _facultyController,
                decoration: const InputDecoration(
                  labelText: 'Faculty',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
                inputFormatters: <TextInputFormatter>[
                  FilteringTextInputFormatter.digitsOnly
                ],
                onChanged: (String value) async {
                  if(value=="") value="0";
                  if(await check_limit("Faculty", int.parse(value),dept!)){
                    setState(() {
                      f3=true;
                      _warningTexta = '';
                      faculty=int.parse(value);
                    });
                  } else {
                    setState(() {
                      f3=false;
                      _warningTexta = 'The input exceeds available limit';
                    });
                  }
                },
              ),),

            const SizedBox(height: 16),
            if (_warningTexta.isNotEmpty) Container(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                _warningTexta,
                style: const TextStyle(
                  color: Colors.red,
                ),
              ),
            ),
            const SizedBox(height: 16),
            Visibility(visible: dept!=null,
              child: ElevatedButton(
                  onPressed:(){
                    if(!(f1==false && f2==false && f3==false) && (_warningTexta=="" && _warningTextm=="" && _warningTextn=="" && _warningTextp=="" && warningTexth=="")) {
                      debugPrint("ffffffffff$f1 $f2 $f3");
                      Navigator.push(context, MaterialPageRoute(
                          builder: (context) =>
                              Report(mtech, phd, faculty, dept, hours, name)),
                      );
                    }
                    else if(f1==false && f2==false && f3==false){
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: Text('Caution'),
                            content: Text('Choose Atleast one member to assign duty'),
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
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: Text('Caution'),
                            content: Text('Please fix the errors before submitting.'),
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
                  }
                  , child: Text("Submit")),),

          ],
        ),
      ),
    );
  }
}


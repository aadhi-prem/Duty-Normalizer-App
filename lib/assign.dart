import 'DB_HELPER.dart';
import 'report.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sqflite/sqflite.dart';
import 'dashboard.dart';

class AssignPage extends StatelessWidget {
  const AssignPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Search',
      home: assign(),
    );
  }
}

class assign extends StatefulWidget {
  const assign({super.key});

  @override
  State<assign> createState() => _AssignState();
}

class _AssignState extends State<assign> {
  final List _deptList=["CSED","CED","EED","ECED","MED","CHE","PED","MSE","BT","AR","MCA"];
  String? dept,name;
  bool f1=false,f2=false,f3=false;
  int mtech=0,phd=0,faculty=0,hours=0;
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
        if ((m.isEmpty && entered!=0) ||(m.isNotEmpty && m.length < entered)) {
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
        if ((m.isEmpty && entered!=0) ||(m.isNotEmpty && m.length < entered)) {
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
        if ((m.isEmpty && entered!=0) ||(m.isNotEmpty && m.length < entered)) {
          return false;
        }
      }
    }
    return true;
  }
  bool isValid(String name) {
    // A valid username contains only letters, numbers, and underscores
    final RegExp regex = RegExp(r'^[\w\s]+$');
    return name!="" && regex.hasMatch(name);
  }
  String trimName(String name) {

    // Remove any extra spaces at the beginning or end
    name = name.trim();

    // Replace any multiple spaces in the middle with a single space
    name = name.replaceAll(RegExp('\\s+'), ' ');

    return name;
  }


  Future<bool> check_name(String s)async{
    Database db= await LocalDB().givedb();
    List<Map<String,dynamic>> m= await db.rawQuery("select * from Duty where DUTY_NAME='$s';");
    if(m.isNotEmpty) {
      return false;
    }
    return true;
  }
  _AssignState();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Assign Duty'),
        elevation: .1,
        backgroundColor: const Color(0xff9381ff),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 30,),
              SizedBox(
                width: 380,
                child: TextField(
                  controller: _dutyNameController,
                  decoration: InputDecoration(
                    labelText: 'Duty Name',
                    enabledBorder: OutlineInputBorder(
                      borderSide: const BorderSide(
                        width: 3, //<-- SEE HERE
                        color: Color.fromRGBO(143, 148, 251, 1),
                      ),
                      borderRadius: BorderRadius.circular(50.0),
                    ),
                  ),
                  onChanged: (String value) async {
                    if(isValid(value)) {
                      value=trimName(value);
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
              ),
              const SizedBox(height: 6),
              if (_warningTextn.isNotEmpty) Container(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Text(
                  _warningTextn,
                  style: const TextStyle(
                    color: Colors.red,
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 2.0,vertical: 0),
                child: SizedBox(
                  width: 380,height: 60,
                  child: DropdownButtonFormField(
                    decoration: InputDecoration(
                      enabledBorder: OutlineInputBorder(
                        borderSide: const BorderSide(color: Color.fromRGBO(143, 148, 251, 1), width: 3),
                        // borderRadius: BorderRadius.circular(20),
                        borderRadius: BorderRadius.circular(50.0),
                      ),
                      border: OutlineInputBorder(
                        borderSide: const BorderSide(color: Color.fromRGBO(143, 148, 251, .6), width: 3),
                        // borderRadius: BorderRadius.circular(20),
                        borderRadius: BorderRadius.circular(50.0),
                      ),
                      filled: true,
                      fillColor: Colors.white70,//Color(0xff9381ff),
                    ),
                    dropdownColor: const Color(0xff9381ff),
                    hint: const Text("Select Department "),
                    icon: const Icon(Icons.arrow_drop_down),
                    iconSize: 30,
                    style: TextStyle(
                        color: Colors.deepPurple[900],
                        fontSize: 16
                    ),
                    value: dept,
                    onChanged: (newValue) {
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
              const SizedBox(height: 15,),
              SizedBox(
                width: 380,
                child: TextField(
                  controller: _hoursController,
                  decoration: InputDecoration(
                    labelText: 'Work Hours',
                    enabledBorder: OutlineInputBorder(
                      borderSide: const BorderSide(
                        width: 3, //<-- SEE HERE
                        color: Color.fromRGBO(143, 148, 251, 1),
                      ),
                      borderRadius: BorderRadius.circular(50.0),
                    ),
                  ),
                  keyboardType: TextInputType.number,
                  inputFormatters: <TextInputFormatter>[
                    FilteringTextInputFormatter.digitsOnly
                  ],
                  onChanged: (String value) async {
                    if(value=="" || value=="0"){
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
              ),
              const SizedBox(height: 6),
              if (warningTexth.isNotEmpty) Container(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Text(
                  warningTexth,
                  style: const TextStyle(
                    color: Colors.red,
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Visibility(
                visible: dept != null,
                child: SizedBox(
                  width: 380,
                  child: TextField(
                    controller: _mtechController,
                    decoration: InputDecoration(
                      labelText: 'MTech',
                      enabledBorder: OutlineInputBorder(
                        borderSide:
                        const BorderSide(
                          width: 3, //<-- SEE HERE
                          color: Color.fromRGBO(143, 148, 251, 1),
                        ),
                        borderRadius: BorderRadius.circular(50.0),
                      ),
                    ),
                    keyboardType: TextInputType.number,
                    inputFormatters: <TextInputFormatter>[
                      FilteringTextInputFormatter.digitsOnly
                    ],
                    onChanged: (String value) async {
                      if(value=="") value="0";
                      if (await check_limit("MTech", int.parse(value), dept!)) {
                        setState(() {
                          if(value!="0") {
                        f1=true;
                      } else {
                        f1=false;
                      }
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
              ),
              const SizedBox(height: 6),
              if (_warningTextm.isNotEmpty) Container(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Text(
                  _warningTextm,
                  style: const TextStyle(
                    color: Colors.red,
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Visibility(
                visible: dept!=null,
                child:SizedBox(
                  width: 380,
                  child: TextField(
                    controller: _phdController,
                    decoration: InputDecoration(
                      labelText: 'Phd',
                      enabledBorder: OutlineInputBorder(
                        borderSide:
                        const BorderSide(
                          width: 3, //<-- SEE HERE
                          color: Color.fromRGBO(143, 148, 251, 1),
                        ),
                        borderRadius: BorderRadius.circular(50.0),
                      ),
                    ),
                    keyboardType: TextInputType.number,
                    inputFormatters: <TextInputFormatter>[
                      FilteringTextInputFormatter.digitsOnly
                    ],
                    onChanged: (String value) async {
                      if(value=="") value="0";
                      if(await check_limit("PhD", int.parse(value),dept!)){
                        setState(() {
                          if(value!="0") {
                        f2=true;
                      } else {
                        f2=false;
                      }
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
              ),
              const SizedBox(height: 6),
              if (_warningTextp.isNotEmpty) Container(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Text(
                  _warningTextp,
                  style: const TextStyle(
                    color: Colors.red,
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Visibility(
                visible: dept!=null,
                child: SizedBox(
                  width: 380,
                  child: TextField(
                    controller: _facultyController,
                    decoration: InputDecoration(
                      labelText: 'Faculty',
                      enabledBorder: OutlineInputBorder(
                        borderSide:
                        const BorderSide(
                          width: 3, //<-- SEE HERE
                          color: Color.fromRGBO(143, 148, 251, 1),
                        ),
                        borderRadius: BorderRadius.circular(50.0),
                      ),
                    ),
                    keyboardType: TextInputType.number,
                    inputFormatters: <TextInputFormatter>[
                      FilteringTextInputFormatter.digitsOnly
                    ],
                    onChanged: (String value) async {
                      if(value=="") value="0";
                      if(await check_limit("Faculty", int.parse(value),dept!)){
                        setState(() {
                          if(value!="0") {
                        f3=true;
                      } else {
                        f3=false;
                      }
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
                  ),
                ),),

              const SizedBox(height: 14),
              if (_warningTexta.isNotEmpty) Container(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Text(
                  _warningTexta,
                  style: const TextStyle(
                    color: Colors.red,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Visibility(visible: dept!=null,
                child: SizedBox(
                  width: 90,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xff0077b6),
                    ),
                      onPressed:(){
                        if(!(f1==false && f2==false && f3==false) && (_warningTexta=="" && _warningTextm=="" && _warningTextn=="" && _warningTextp=="" && warningTexth=="")) {
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
                                title: const Text('Caution'),
                                content: const Text('Choose Atleast one member to assign duty'),
                                actions: [
                                  TextButton(
                                    onPressed: () => Navigator.pop(context),
                                    child: const Text('OK'),
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
                                title: const Text('Caution'),
                                content: const Text('Please fix the errors before submitting.'),
                                actions: [
                                  TextButton(
                                    onPressed: () => Navigator.pop(context),
                                    child: const Text('OK'),
                                  ),
                                ],
                              );
                            },
                          );
                        }
                      }
                      , child: const Text("Submit")
                  ),
                ),
              ),
                const SizedBox(height:5),
              ElevatedButton.icon(
                icon: const Icon(Icons.arrow_back),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xff9381ff),
                ),
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => Dashboard(),
                    ),
                  );
                },
                label: const Text('Back'),
              ),


            ],
          ),
        ),
      ),
    );
  }
}

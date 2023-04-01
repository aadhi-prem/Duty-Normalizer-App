
import 'package:flutter/material.dart';
import 'DB_HELPER.dart';

void main() {
  runApp(const Add_indv());
}

class Add_indv extends StatelessWidget {
  const Add_indv({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      // Remove the debug banner
      debugShowCheckedModeBanner: false,
      title: 'Search',
      home: MyCustomForm(),
    );
  }

}
class MyCustomForm extends StatefulWidget {
  const MyCustomForm({super.key});
  @override
  MyCustomFormState createState() {
    return MyCustomFormState();
  }
}
class MyCustomFormState extends State<MyCustomForm> {
  final _formKey = GlobalKey<FormState>();
  String?batch;
  String?rollno;
  String?rollno1;
  String?name;
  String?dep;
  String?phno;
  String?email;
  int pop=-1;
  late String newValue;
  late String newValue2;
  List _deptList=["CSE","CE","EEE","ECE","ME","CHE","EP","PE","MSE","BT","AR","MCA"];
  List _catList=["MTech","PhD","Adhoc"];
  String mychar='';
  //String mychar1='';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Fill the Form'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
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
                    value: batch,
                    onChanged: (newValue2){
                      setState(() {
                        batch = newValue2 as String;
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
              Padding(padding: EdgeInsets.all(2),),
              TextFormField(
                decoration: InputDecoration(
                  hintText: 'Enter your roll number',
                ),
                validator: (value) {
                  //value=value?.toUpperCase();
                  if (value==null||value.isEmpty) {
                    //debugPrint("1");
                    return 'Please enter your roll number';
                  }
                  if(batch=='MTech')
                  {
                    mychar='M';
                    //mychar1='m';
                  }
                  else if(batch=='PhD')
                  {
                    mychar='P';
                    //mychar1='p';
                  } else
                  {
                    mychar='A';
                   // mychar1='a';
                  }
                    if (value.toUpperCase().startsWith(mychar)==false) {
                      debugPrint("NO: starts with correct letter");
                      return 'Invalid Roll number';
                    }

                  return null;
                },
                onSaved: (value) {
                  rollno1 = value;
                  rollno=rollno1?.toUpperCase();
                  debugPrint(rollno);
                },
              ),

              TextFormField(
                decoration: InputDecoration(
                  hintText: 'Enter your name',
                ),
                validator: (value) {
                  if (value==null||value.isEmpty) {
                    //debugPrint("2");
                    return 'Please enter your name';
                  }
                  return null;
                },
                onSaved: (value) {
                  name = value;
                },
              ),
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
                    value: dep,
                    onChanged: (newValue){
                      setState(() {
                        dep = newValue as String;
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
              TextFormField(
                decoration: InputDecoration(
                  hintText: 'Enter your Phone number',
                ),
                validator: (value) {
                  if (value==null||value.isEmpty) {
                    //debugPrint("3");
                    return 'Please enter your Phone number';
                  }
                  return null;
                },
                onSaved: (value) {
                  //debugPrintStack(label: value);
                  phno = value;
                },
              ),
              TextFormField(
                decoration: InputDecoration(
                  hintText: 'Enter your email',
                ),
                validator: (value) {
                  if (value==null||value.isEmpty) {
                    // debugPrint("4");
                    return 'Please enter your email';
                  }
                  if(validateEmail(value)==false)
                    return 'Invalid Email';
                  return null;
                },
                onSaved: (value) {
                  email = value;
                },
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                child: ElevatedButton(
                  onPressed: () async {
                    _formKey.currentState?.save();
                    if (_formKey.currentState?.validate()==true) {
                      // Save form fields


                      // Do something with the form data
                      debugPrint('Name: $name');
                      debugPrint('Email: $email');
                      debugPrint('Roll number: $rollno');
                      debugPrint('Phone number: $phno');
                      debugPrint('Department: $dep');
                      debugPrint('Batch: $batch');

                      Map<String, dynamic> a = {
                        'Rollnumber': rollno,
                        'Name': name,
                        'Department': dep,
                        'PhoneNo': phno,
                        'Email': email,
                      };

                     // pop=check(rollno!) as int;
                      List<Map<String, dynamic>> _allUsers = [];
                      _allUsers = await LocalDB().readDB("SELECT * FROM $batch where RollNo = '$rollno';") as List<Map<String, dynamic>>;
                      if(_allUsers.length==0) pop= 1;
                      else {
                        pop= 0;
                      }
                      if(pop==1) {
                        insertform(a, batch!);

                        showDialog(
                          context: context,
                          builder: (ctx) =>
                              AlertDialog(
                                title: const Text("Alert Dialog Box"),
                                content: const Text(
                                    "Data Entered into DB successfully"),
                                actions: <Widget>[
                                  TextButton(
                                    onPressed: () {
                                      Navigator.of(ctx).pop();
                                    },
                                    child: Container(
                                      color: Colors.lightBlueAccent,
                                      padding: const EdgeInsets.all(14),
                                      child: const Text("ok"),
                                    ),
                                  ),
                                ],
                              ),
                        );
                      }
                      else if(pop==0){
                        showDialog(
                          context: context,
                          builder: (ctx) =>
                              AlertDialog(
                                title: const Text("Pop Up"),
                                content: Text("$rollno already exist in database!"),
                                actions: <Widget>[
                                  TextButton(
                                    onPressed: () {
                                      Navigator.of(ctx).pop();
                                    },
                                    child: Container(
                                      color: Colors.blueAccent,
                                      padding: const EdgeInsets.all(14),
                                      child: const Text("ok"),
                                    ),
                                  ),
                                ],
                              ),
                        );
                      }
                      else{
                        debugPrint("Pop is -1");
                      }

                    }
                    else{
                      debugPrint("Fail");

                      showDialog(
                        context: context,
                        builder: (ctx) =>
                            AlertDialog(
                              title: const Text("Pop Up"),
                              content: Text("Please enter valid field data!"),
                              actions: <Widget>[
                                TextButton(
                                  onPressed: () {
                                    Navigator.of(ctx).pop();
                                  },
                                  child: Container(
                                    color: Colors.blueAccent,
                                    padding: const EdgeInsets.all(14),
                                    child: const Text("ok"),
                                  ),
                                ),
                              ],
                            ),
                      );

                    }
                  },
                  child: Text('Submit'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> insertform(Map<String,dynamic> a,String B)async {
    if(B=='MTech') {
      await LocalDB().writeDB(a, 'Mtech');
    }
    if(B=='PhD') {
      await LocalDB().writeDB(a, 'Phd');
    }
    if(B=='Adhoc') {
      await LocalDB().writeDB(a, 'Adhoc');
    }
  }

  bool validateEmail(String email) {
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (email.isEmpty) {
      return false;
    }
    return emailRegex.hasMatch(email);
  }

  // Future<int> check(String s) async {
  //   List<Map<String, dynamic>> _allUsers = [];
  //   _allUsers = await LocalDB().readDB("SELECT Name FROM Mtech where RollNo='$s';");
  //   if(_allUsers.length==0) return 1;
  //   else {
  //     return 0;
  //   }
  // }

}

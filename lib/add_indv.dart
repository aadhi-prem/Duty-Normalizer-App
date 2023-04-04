import 'package:flutter/material.dart';
import 'DB_HELPER.dart';
import 'add_main.dart';
import 'package:fluttertoast/fluttertoast.dart';

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
  int pop = -1;
  late String newValue;
  late String newValue2;
  List _deptList = ["CSED","CED","EED","ECED","MED","CHED","EPD","PED","BTD","ARD"];
  List _catList = ["MTech", "PhD", "Faculty"];
  String mychar = '';

  //String mychar1='';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Fill the form",
        ),
        elevation: .1,
        backgroundColor: Color(0xff9381ff), //Color.fromRGBO(143, 148, 251, 1), //violet color
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 2.0,vertical: 16),
                  child: Container(
                    width: 380,
                    height: 60,
                    child: DropdownButtonFormField(
                      decoration: InputDecoration(
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Color.fromRGBO(143, 148, 251, 1), width: 3),
                          // borderRadius: BorderRadius.circular(20),
                          borderRadius: BorderRadius.circular(50.0),
                        ),
                        border: OutlineInputBorder(
                          borderSide: BorderSide(color: Color.fromRGBO(143, 148, 251, .6), width: 3),
                          // borderRadius: BorderRadius.circular(20),
                          borderRadius: BorderRadius.circular(50.0),
                        ),
                        filled: true,
                        fillColor: Colors.white,//Color(0xff9381ff),
                      ),
                      dropdownColor: Color(0xff9381ff),
                      hint: Text("Select Category "),
                      icon: Icon(Icons.arrow_drop_down),
                      iconSize: 30,
                      style: TextStyle(
                          color: Colors.deepPurple[900],
                          fontSize: 16
                      ),

                      //Container(
                      //   padding: EdgeInsets.only(left: 16, right: 16),
                      //   decoration: BoxDecoration(
                      //       border: Border.all(color: Color(0xff9381ff), width: 2),
                      //       borderRadius: BorderRadius.circular(15)
                      //   ),
                      //   child: DropdownButton(
                      //     dropdownColor: Color(0xff9381ff),
                      //     hint: Text("Select Category: "),
                      //     icon: Icon(Icons.arrow_drop_down),
                      //     iconSize: 34,
                      //     isExpanded: true,
                      //     underline: SizedBox(),
                      //     style: TextStyle(
                      //         color: Colors.white,
                      //         fontSize: 22
                      //     ),
                      value: batch,
                      onChanged: (newValue2) {
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
                    hintText: 'Enter your ID',
                    enabledBorder: OutlineInputBorder(
                      borderSide:
                      BorderSide(
                        width: 3, //<-- SEE HERE
                        color: Color.fromRGBO(143, 148, 251, 1),),
                      borderRadius: BorderRadius.circular(50.0),
                    ),
                  ),

                  validator: (value) {
                    //value=value?.toUpperCase();
                    if (value == null || value.isEmpty) {
                      //debugPrint("1");
                      return 'Please enter your ID';
                    }
                    if (batch == 'MTech') {
                      mychar = 'M';
                      //mychar1='m';
                    }
                    else if (batch == 'PhD') {
                      mychar = 'P';
                      //mychar1='p';
                    } else {
                      mychar = 'A';
                      // mychar1='a';
                    }
                    if (value.toUpperCase().startsWith(mychar) == false) {
                      debugPrint("NO: starts with correct letter");
                      return 'Invalid ID';
                    }

                    return null;
                  },
                  onSaved: (value) {
                    rollno1 = value;
                    rollno = rollno1?.toUpperCase();
                    debugPrint(rollno);
                  },
                ),
                SizedBox(height: 15,),
                TextFormField(
                  decoration: InputDecoration(
                    hintText: 'Enter your name',
                    enabledBorder: OutlineInputBorder(
                      borderSide:
                      BorderSide(
                        width: 3, //<-- SEE HERE
                        color: Color.fromRGBO(143, 148, 251, 1),),
                      borderRadius: BorderRadius.circular(50.0),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      //debugPrint("2");
                      return 'Please enter your name';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    name = value;
                  },
                ),
                SizedBox(height: 2,),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 2.0,vertical: 16),
                  child: Container(
                    width: 380,
                    height: 60,
                    child: DropdownButtonFormField(
                      decoration: InputDecoration(
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Color.fromRGBO(143, 148, 251, 1), width: 3),
                          // borderRadius: BorderRadius.circular(20),
                          borderRadius: BorderRadius.circular(50.0),
                        ),
                        border: OutlineInputBorder(
                          borderSide: BorderSide(color: Color.fromRGBO(143, 148, 251, .6), width: 3),
                          // borderRadius: BorderRadius.circular(20),
                          borderRadius: BorderRadius.circular(50.0),
                        ),
                        filled: true,
                        fillColor: Colors.white,//Color(0xff9381ff),
                      ),
                      dropdownColor: Color(0xff9381ff),
                      hint: Text("Select Department "),
                      icon: Icon(Icons.arrow_drop_down),
                      iconSize: 30,
                      style: TextStyle(
                          color: Colors.deepPurple[900],
                          fontSize: 16
                      ),
                      value: dep,
                      onChanged: (newValue) {
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
                    enabledBorder: OutlineInputBorder(
                      borderSide:
                      BorderSide(
                        width: 3, //<-- SEE HERE
                        color: Color.fromRGBO(143, 148, 251, 1),),
                      borderRadius: BorderRadius.circular(50.0),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
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
                SizedBox(height: 15,),
                TextFormField(
                  decoration: InputDecoration(
                    hintText: 'Enter your email',
                    enabledBorder: OutlineInputBorder(
                      borderSide:
                      BorderSide(
                        width: 3, //<-- SEE HERE
                        color: Color.fromRGBO(143, 148, 251, 1),),
                      borderRadius: BorderRadius.circular(50.0),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      // debugPrint("4");
                      return 'Please enter your email';
                    }
                    if (validateEmail(value) == false)
                      return 'Invalid Email';
                    return null;
                  },
                  onSaved: (value) {
                    email = value;
                  },
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          primary: Color(0xffff595e),
                        ),
                        onPressed: () {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => Add(),
                            ),
                          );
                        },
                        child: Text('Cancel'),
                      ),
                      SizedBox(width: 32,),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom( primary: Color(0xff0077b6),), //darkblue color
                        onPressed: () async {
                          _formKey.currentState?.save();
                          if (_formKey.currentState?.validate() == true) {
                            // Save form fields


                            // Do something with the form data
                            debugPrint('Name: $name');
                            debugPrint('Email: $email');
                            debugPrint('Roll number: $rollno');
                            debugPrint('Phone number: $phno');
                            debugPrint('Department: $dep');
                            debugPrint('Batch: $batch');

                            Map<String, dynamic> a = {
                              'ID': rollno,
                              'Name': name,
                              'Department': dep,
                              'PhoneNo': phno,
                              'Email': email,
                            };

                            // pop=check(rollno!) as int;
                            List<Map<String, dynamic>> _allUsers = [];
                            _allUsers = await LocalDB().readDB(
                                "SELECT * FROM $batch where ID = '$rollno';") as List<
                                Map<String, dynamic>>;
                            if (_allUsers.length == 0)
                              pop = 1;
                            else {
                              pop = 0;
                            }
                            if (pop == 1) {
                              insertform(a, batch!);

                              showDialog(
                                context: context,
                                builder: (ctx) =>
                                    AlertDialog(
                                      title: const Text("Added Successfully"),
                                      content: const Text(
                                          "Data Entered into DB successfully"),
                                      actions: <Widget>[
                                        TextButton(
                                          onPressed: () {
                                            Fluttertoast.showToast(
                                                msg: "Added Successfully",
                                                toastLength: Toast.LENGTH_SHORT,
                                                gravity: ToastGravity.BOTTOM,
                                                timeInSecForIosWeb: 1,
                                                backgroundColor: Colors.grey[600],
                                                textColor: Colors.white,
                                                fontSize: 16.0
                                            );
                                            Navigator.pushReplacement(ctx, MaterialPageRoute(
                                              builder: (ctx) => Add(),
                                            ),);
                                          },
                                          child: Container(
                                            color: Color(0xff9381ff),
                                            padding: const EdgeInsets.all(14),
                                            child: const Text("OK",style: TextStyle(color: Colors.white),),
                                          ),
                                        ),
                                      ],
                                    ),
                              );
                            }
                            else if (pop == 0) {
                              showDialog(
                                context: context,
                                builder: (ctx) =>
                                    AlertDialog(
                                      title: const Text("Invalid Credentials"),
                                      content: Text(
                                          "$rollno already exist in database!"),
                                      actions: <Widget>[
                                        TextButton(
                                          onPressed: () {
                                            Navigator.of(ctx).pop();
                                          },
                                          child: Container(
                                            color: Color(0xff9381ff),
                                            padding: const EdgeInsets.all(14),
                                            child: const Text("OK",style: TextStyle(color: Colors.white),),
                                          ),
                                        ),
                                      ],
                                    ),
                              );
                            }
                            else {
                              debugPrint("Pop is -1");
                            }
                          }
                          else {
                            debugPrint("Fail");

                            showDialog(
                              context: context,
                              builder: (ctx) =>
                                  AlertDialog(
                                    title: const Text("Invalid Credentials"),
                                    content: Text("Please enter valid field data!"),
                                    actions: <Widget>[
                                      TextButton(
                                        onPressed: () {
                                          Navigator.of(ctx).pop();
                                        },
                                        child: Container(
                                          color: Color(0xff9381ff),
                                          padding: const EdgeInsets.all(14),
                                          child: const Text("OK",style: TextStyle(color: Colors.white),),
                                        ),
                                      ),
                                    ],
                                  ),
                            );
                          }
                        },
                        child: Text('Submit'),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> insertform(Map<String, dynamic> a, String B) async {
    if (B == 'MTech') {
      await LocalDB().writeDB(a, 'Mtech');
    }
    if (B == 'PhD') {
      await LocalDB().writeDB(a, 'Phd');
    }
    if (B == 'Faculty') {
      await LocalDB().writeDB(a, 'Faculty');
    }
  }

  bool validateEmail(String email) {
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (email.isEmpty) {
      return false;
    }
    return emailRegex.hasMatch(email);
  }
}
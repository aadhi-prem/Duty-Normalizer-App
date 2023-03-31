import 'dart:ui';
import 'package:csv/csv.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import 'package:file_picker/file_picker.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'dart:convert' show utf8;
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:untitled8/DB_HELPER.dart';
import 'package:untitled8/search.dart';
//import 'package:untitled6/search.dart';
import 'package:email_validator/email_validator.dart';

Future<void> main() async {
  runApp(const MaterialApp(
    title: 'Navigation Basics',
    home: FirstRoute(),
  ));
}

class FirstRoute extends StatelessWidget {
  const FirstRoute({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Student and Faculty'),
      ),
      body: Center(
        child: Column(
          children: [
            ElevatedButton(
              child: const Text('Add Student and Faculty in batches [M.Tech]'),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const FilePickerApp()),
                );
              },
            ),
            ElevatedButton(
              onPressed: () async {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const MyApp()),
                );
              },
              child: const Text("Search"),
            ),
            ElevatedButton(
              onPressed: () async {
                //await LocalDB().writeDB();
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const FilePickerApp_phd()),
                );
              },
              child: const Text("Add Student and Faculty in batches [Ph.D.]"),
            ),
            ElevatedButton(
              onPressed: () async {
                //await LocalDB().writeDB();
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const FilePickerApp_adhoc()),
                );
              },
              child: const Text("Add Student and Faculty in batches [Adhoc]"),
            ),
            ElevatedButton(
              child: const Text('Add Student and Faculty individually'),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const MyCustomForm()),
                );
              },
            ),
          ],
        ),



      ),
    );
  }
}

class FilePickerApp extends StatelessWidget {
  const FilePickerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Select your csv file"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () async {
                final result = await FilePicker.platform.pickFiles();
                if (result == null) {
                  print("No file selected");

                  showDialog(
                    context: context,
                    builder: (ctx) => AlertDialog(
                      title: const Text("Alert Dialog Box"),
                      content: const Text("No file picked!"),
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

                } else {
                  final file = result.files.first;

                  openFile(file);

                  showDialog(
                    context: context,
                    builder: (ctx) => AlertDialog(
                      title: const Text("Pop Up"),
                      content: const Text("File picked and added to DB sucessfully!"),
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
              child: const Text("Select File"),
            ),
            const SizedBox(height: 20), // Added SizedBox for spacing
            // ElevatedButton(
            //   onPressed: () async {
            //     Navigator.push(
            //       context,
            //       MaterialPageRoute(builder: (context) => MyApp()),
            //     );
            //   },
            //   child: const Text("Go to MyApp"),
            // ),
          ],
        ),
      ),
    );
  }

   Future<void> openFile(PlatformFile file) async {
     final input = File(file.path!).openRead();
     final fields = await input
         .transform(utf8.decoder)
         .transform(CsvToListConverter())
         .toList();
     print(fields);
     final headers = fields.first;
     final List<Map<String, dynamic>> rows = [];

     for (var i = 1; i < fields.length; i++) {
       final row = fields[i];
       final Map<String, dynamic> rowMap = {};
       for (var j = 0; j < headers.length; j++) {
         rowMap[headers[j]] = row[j];
       }
       rows.add(rowMap);
     }


       for (Map<String, dynamic> a in rows) {
         await LocalDB().writeDB(a,'Mtech');
         // await LocalDB().writeD

       }

    }
}

class FilePickerApp_phd extends StatelessWidget {
  const FilePickerApp_phd({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Select your csv file"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () async {
                final result = await FilePicker.platform.pickFiles();
                if (result == null) {
                  print("No file selected");
                  showDialog(
                    context: context,
                    builder: (ctx) => AlertDialog(
                      title: const Text("Alert Dialog Box"),
                      content: const Text("No file picked!"),
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
                } else {
                  final file = result.files.first;
                  openFile(file);
                  showDialog(
                    context: context,
                    builder: (ctx) => AlertDialog(
                      title: const Text("Pop-Up Box"),
                      content: const Text("File picked and added to DB sucessfully!"),
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
              },
              child: const Text("Select File"),
            ),
            const SizedBox(height: 20), // Added SizedBox for spacing
            // ElevatedButton(
            //   onPressed: () async {
            //     Navigator.push(
            //       context,
            //       MaterialPageRoute(builder: (context) => MyApp()),
            //     );
            //   },
            //   child: const Text("Go to MyApp"),
            // ),
          ],
        ),
      ),
    );
  }

  Future<void> openFile(PlatformFile file) async {
    final input = File(file.path!).openRead();
    final fields = await input
        .transform(utf8.decoder)
        .transform(CsvToListConverter())
        .toList();
    print(fields);
    final headers = fields.first;
    final List<Map<String, dynamic>> rows = [];

    for (var i = 1; i < fields.length; i++) {
      final row = fields[i];
      final Map<String, dynamic> rowMap = {};
      for (var j = 0; j < headers.length; j++) {
        rowMap[headers[j]] = row[j];
      }
      rows.add(rowMap);
    }


    for (Map<String, dynamic> a in rows) {
      await LocalDB().writeDB(a,'Phd');
      // await LocalDB().writeD

    }

  }
}

class FilePickerApp_adhoc extends StatelessWidget {
  const FilePickerApp_adhoc({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Select your csv file"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () async {
                final result = await FilePicker.platform.pickFiles();
                if (result == null) {
                  print("No file selected");
                  showDialog(
                    context: context,
                    builder: (ctx) => AlertDialog(
                      title: const Text("Alert Dialog Box"),
                      content: const Text("No file picked!"),
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
                } else {
                  final file = result.files.first;
                  openFile(file);
                  showDialog(
                    context: context,
                    builder: (ctx) => AlertDialog(
                      title: const Text("Pop-Up Box"),
                      content: const Text("File picked and added to DB sucessfully!"),
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
              },
              child: const Text("Select File"),
            ),
            const SizedBox(height: 20), // Added SizedBox for spacing
            // ElevatedButton(
            //   onPressed: () async {
            //     Navigator.push(
            //       context,
            //       MaterialPageRoute(builder: (context) => MyApp()),
            //     );
            //   },
            //   child: const Text("Go to MyApp"),
            // ),
          ],
        ),
      ),
    );
  }

  Future<void> openFile(PlatformFile file) async {
    final input = File(file.path!).openRead();
    final fields = await input
        .transform(utf8.decoder)
        .transform(CsvToListConverter())
        .toList();
    print(fields);
    final headers = fields.first;
    final List<Map<String, dynamic>> rows = [];

    for (var i = 1; i < fields.length; i++) {
      final row = fields[i];
      final Map<String, dynamic> rowMap = {};
      for (var j = 0; j < headers.length; j++) {
        rowMap[headers[j]] = row[j];
      }
      rows.add(rowMap);
    }


    for (Map<String, dynamic> a in rows) {
      await LocalDB().writeDB(a,'Adhoc');
      // await LocalDB().writeD

    }

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
  String?name;
  String?dep;
  String?phno;
  String?email;
  late String newValue;
  late String newValue2;
  List _deptList=["CSE","CE","EEE","ECE","ME","CHE","EP","PE","MSE","BT","AR","MCA"];
  List _catList=["MTech","PhD","Adhoc"];
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

              TextFormField(
                decoration: InputDecoration(
                  hintText: 'Enter your roll number',
                ),
                validator: (value) {
                  if (value==null||value.isEmpty) {
                    //debugPrint("1");
                    return 'Please enter your roll number';
                  }
                  return null;
                },
                onSaved: (value) {
                  rollno = value;
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
                  return null;
                },
                onSaved: (value) {
                  email = value;
                },
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                child: ElevatedButton(
                  onPressed: () {
                    _formKey.currentState?.save();
                    if (_formKey.currentState?.validate()==true) {
                      // Save form fields


                      // Do something with the form data
                      debugPrint('Name: $name');
                      debugPrint('Email: $email');
                      debugPrint('Roll number: $rollno');
                      debugPrint('Phone number: $phno');
                      debugPrint('Department: $dep');

                      Map<String, dynamic> a = {
                        'RollNumber': rollno,
                        'Name': name,
                        'Department': dep,
                        'PhoneNo': phno,
                        'Email': email,
                      };

                      if(batch=='Mtech') {
                        LocalDB().writeDB(a, 'Mtech');
                      }
                      if(batch=='PhD') {
                        LocalDB().writeDB(a, 'Phd');
                      }
                      if(batch=='Adhoc') {
                        LocalDB().writeDB(a, 'Adhoc');
                      }

                    }
                    else{
                      debugPrint("Fail");
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
}




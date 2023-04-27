import 'dart:convert';
import 'package:csv/csv.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/services.dart';
import 'dart:io';
import 'dart:convert' show utf8;
import 'DB_HELPER.dart';
import 'dart:core';
import 'add_main.dart';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share/share.dart';

class Add_batch extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Toggle Button Example',
      home: ToggleButtonScreen(),
    );
  }
}

class ToggleButtonScreen extends StatefulWidget {
  @override
  _ToggleButtonScreenState createState() => _ToggleButtonScreenState();
}

class _ToggleButtonScreenState extends State<ToggleButtonScreen> {
  String? _buttonValue;

  void _toggleButton(String value) {
    setState(() {
      if (_buttonValue == value) {
        _buttonValue = null; // Deselect if button is already selected
      } else {
        _buttonValue = value;
      }
    });
  }
  Color buttonColor = Color(0xff9381ff);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Students/Faculty in batches'),
        elevation: .1,
        backgroundColor: Color(0xff9381ff),
      ),
      body: Center(
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.all(
                16,
              ),
            ),
            // ElevatedButton(
            //   style: ElevatedButton.styleFrom( primary: Color(0xff9381ff),),
            //   onPressed: () async { // Get the path to the application's document directory
            //     final directory = await getApplicationDocumentsDirectory();
            //     final path = directory.path;
            //
            //     // Create a File object for the CSV file
            //     final file = File('$path/Template.csv');
            //
            //     // Copy the CSV file from assets to the File object
            //     final data = await rootBundle.load('assets/Template.csv');
            //     await file.writeAsBytes(data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes));
            //
            //     // Share the CSV file with the user
            //     Share.shareFiles([file.path]);},
            //   child: Text('Download CSV Template',style: TextStyle(fontSize: 20),),
            // ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                InkWell(
                  onTap: () {
                    setState(() {
                      buttonColor = Colors.red; // change button color when clicked
                    });
                  },
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      primary: buttonColor,
                    ),
                    onPressed: () => _toggleButton('Mtech'),
                    child: Text(
                      'Mtech',
                      style: TextStyle(fontSize: 20),
                    ),
                  ),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    primary: buttonColor,
                  ),
                  onPressed: () => _toggleButton('Phd'),
                  child: Text(
                    'Phd',
                    style: TextStyle(fontSize: 20),
                  ),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    primary: Color(0xff9381ff),
                  ),
                  onPressed: () => _toggleButton('Faculty'),
                  child: Text(
                    'Faculty',
                    style: TextStyle(fontSize: 20),
                  ),
                ),
              ],
            ),

            SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                _buttonValue ?? 'No category selected',
                style: TextStyle(fontSize: 26, fontFamily: 'Alkatra'),
              ),
            ),
            SizedBox(height: 10),

            DottedBorder(
              dashPattern: [7, 7],
              color: Colors.grey[400]!,
              borderType: BorderType.RRect,
              radius: Radius.circular(12),
              strokeWidth: 2,
              child: Container(
                width: 370,
                height: 250,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.cloud_upload,
                      size: 64.0,
                      color: Colors.grey[400],
                    ),
                    SizedBox(height: 16.0),
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Text(
                        "*Enter files in .csv format. Files must contain fields: ID, Name, Department, Phone No.,Email ID. Download the template and Do not remove the given header",
                        style: TextStyle(
                          fontSize: 16.0,
                          color: Colors.grey[400],
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
                          onPressed: () async {
                            final result =
                            await FilePicker.platform.pickFiles();
                            if (result == null) {
                              print("No file selected");

                              showDialog(
                                context: context,
                                builder: (ctx) => AlertDialog(
                                  title: const Text("Alert"),
                                  content: const Text("No file picked!",style: TextStyle(fontWeight: FontWeight.bold),),
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
                            } else {
                              final file = result.files.first;


                                openFile(file, _buttonValue!);

                              // showDialog(
                              //   context: context,
                              //   builder: (ctx) =>
                              //       AlertDialog(
                              //         title: const Text("Pop Up"),
                              //         content: const Text("File picked sucessfully!"),
                              //         actions: <Widget>[
                              //           TextButton(
                              //             onPressed: () {
                              //               Navigator.of(ctx).pop();
                              //             },
                              //             child: Container(
                              //               color: Colors.blueAccent,
                              //               padding: const EdgeInsets.all(14),
                              //               child: const Text("ok"),
                              //             ),
                              //           ),
                              //         ],
                              //       ),
                              // );
                            }
                          },
                          child: const Text("Select File"),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            SizedBox(height: 20),
            // Invisible button that receives the selected value

            const SizedBox(height: 20),
            // Added SizedBox for spacing
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                primary: Color(0xff0077b6),//Color(0xff4cc9f0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              onPressed: () async {
                // Get the path to the application's document directory
                final directory = await getApplicationDocumentsDirectory();
                final path = directory.path;

                // Create a File object for the CSV file
                final file = File('$path/Template.csv');

                // Copy the CSV file from assets to the File object
                final data = await rootBundle.load('assets/Template.csv');
                await file.writeAsBytes(data.buffer
                    .asUint8List(data.offsetInBytes, data.lengthInBytes));

                // Share the CSV file with the user
                Share.shareFiles([file.path]);
              },
              icon: Icon(Icons.download_sharp),
              label: Text(
                'Download CSV Template',
                style: TextStyle(fontSize: 20),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              icon: Icon(Icons.arrow_back),
              style: ElevatedButton.styleFrom(
                primary: Color(0xff9381ff),
              ),
              onPressed: () {
                //Navigator.of(context, rootNavigator: true).pop();
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => Add(),
                  ),
                );
              },
              label: Text('Back'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> openFile(PlatformFile file, String _buttonvalue) async {
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
    int i = 0;
    int flag = 0;
    String mychar = '';

    if (_buttonValue == 'Mtech') {
      mychar = 'M';
    } else if (_buttonValue == 'PhD') {
      mychar = 'P';
    } else {
      mychar = 'A';
    }
    int count = 0;
    debugPrint('$rows');
    for (Map<String, dynamic> r in rows) {
      if (r['ID'].startsWith(mychar)) {
        debugPrint("YES: starts with correct letter");
        i++;
      } else {
        debugPrint("NO: doesnt start with correct letter");
        flag = 1;
      }
      if (validateEmail(r['Email'])) {
        debugPrint("Valid Email");
      } else {
        debugPrint("Invalid Email");
        flag = 1;
      }
      if (flag == 1) count++;
    }

    if (flag == 0) {
      for (Map<String, dynamic> a in rows) {
        debugPrint("FLAG IS TRUE");
        await LocalDB().writeDB(a, _buttonvalue);
      }
      // await LocalDB().writeD
      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: const Text("Added Successfully"),
          content: const Text("File picked and added sucessfully!",style: TextStyle(fontWeight: FontWeight.bold),),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(ctx).pop();
              },
              child: Container(
                color: Color(0xff9381ff),
                padding: const EdgeInsets.all(14),
                child: const Text(
                  "OK",
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      );
    } else {
      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: const Text("Invalid Format"),
          content: Text(
              "Invalid Data in $count row in CSV File. Upload the correct CSV file!",style: TextStyle(fontWeight: FontWeight.bold),),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(ctx).pop();
              },
              child: Container(
                color: Colors.blueAccent,
                padding: const EdgeInsets.all(14),
                child: const Text("OK",style: TextStyle(color: Colors.white),),
              ),
            ),
          ],
        ),
      );
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
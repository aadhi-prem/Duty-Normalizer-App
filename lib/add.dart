import 'dart:convert';
import 'package:csv/csv.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:file_picker/file_picker.dart';
import 'dart:io';
import 'dart:convert' show utf8;
import 'DB_HELPER.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Students/Faculty in batches'),
      ),
      body: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () => _toggleButton('Mtech'),
              child: Text('Mtech'),
            ),
            ElevatedButton(
              onPressed: () => _toggleButton('Phd'),
              child: Text('Phd'),
            ),
            ElevatedButton(
              onPressed: () => _toggleButton('Adhoc'),
              child: Text('Adhoc'),
            ),
            SizedBox(height: 20),
            Text(
              _buttonValue ?? 'No category selected',
              style: TextStyle(fontSize: 24),
            ),
            SizedBox(height: 20),
            // Invisible button that receives the selected value
            ElevatedButton(
              onPressed: () async {
                final result = await FilePicker.platform.pickFiles();
                if (result == null) {
                  print("No file selected");

                  showDialog(
                    context: context,
                    builder: (ctx) =>
                        AlertDialog(
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

                  openFile(file,_buttonValue!);

                  showDialog(
                    context: context,
                    builder: (ctx) =>
                        AlertDialog(
                          title: const Text("Pop Up"),
                          content: const Text(
                              "File picked and added to DB sucessfully!"),
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

          ],
        ),
      ),
    );
  }
  Future<void> openFile(PlatformFile file,String _buttonvalue) async {
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
      await LocalDB().writeDB(a,_buttonvalue);
      // await LocalDB().writeD

    }

  }
}



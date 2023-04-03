import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

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
  final List _deptList=["CSE","CE","EEE","ECE","ME","CHE","EP","PE","MSE","BT","AR","MCA"];
  String dept="";
  final TextEditingController _mtechController = TextEditingController();
  final TextEditingController _phdController = TextEditingController();
  final TextEditingController _facultyController = TextEditingController();
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
              controller: _mtechController,
              decoration: const InputDecoration(
                labelText: 'Mtech',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
              inputFormatters: <TextInputFormatter>[
                FilteringTextInputFormatter.digitsOnly
              ],
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _phdController,
              decoration: const InputDecoration(
                labelText: 'PhD',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
              inputFormatters: <TextInputFormatter>[
                FilteringTextInputFormatter.digitsOnly
              ],
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _facultyController,
              decoration: const InputDecoration(
                labelText: 'Faculty',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
              inputFormatters: <TextInputFormatter>[
                FilteringTextInputFormatter.digitsOnly
              ],
            ),
          ],
        ),
      ),
    );
  }
}
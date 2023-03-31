import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:untitled8/add_indv.dart';

import 'add.dart';

void main() {
  runApp(const Add());
}

class Add extends StatelessWidget {
  const Add({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      // Remove the debug banner
      debugShowCheckedModeBanner: false,
      title: 'Search',
      home: AddPage(),
    );
  }
}

class AddPage extends StatefulWidget {
  const AddPage({Key? key}) : super(key: key);

  @override
  State<AddPage> createState() => _AddPageState();
}

class _AddPageState extends State<AddPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body:Padding(
            padding: const EdgeInsets.all(10),
            child:Column(
              children: [
                ElevatedButton(
                  child: const Text('Add Students/Faculty in batches'),
                  onPressed: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context)=>MyApp()),);
                  },
                ),
                ElevatedButton(
                  child: const Text('Add Student/Faculty individually'),
                  onPressed: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context)=>const Add_indv()),);
                  },
                ),
              ],
            )

        )
    );
  }
}

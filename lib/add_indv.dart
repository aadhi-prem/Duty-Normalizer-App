
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

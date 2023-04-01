import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:sqflite/sqflite.dart';
import 'dashboard.dart';
import 'DB_HELPER.dart';

class PinEntryPage extends StatefulWidget {
  @override
  _PinEntryPageState createState() => _PinEntryPageState();
}

class _PinEntryPageState extends State<PinEntryPage> {
  String pin = '1234';

  @override

  Future<void> _reset() async {
    await LocalDB().executeDB("Update Mtech set WorkHours = 0;");
    await LocalDB().executeDB("Update Phd set WorkHours = 0;");
    await LocalDB().executeDB("Update Adhoc set WorkHours = 0;");
  }

  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: <Widget>[
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/background.png'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 64.0),
              child: SizedBox(
                height: MediaQuery.of(context).size.height * 0.75,
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(32.0),
                      topRight: Radius.circular(32.0),
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(32.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[

                        Text(
                          'Please Enter Your PIN',
                          style: TextStyle(
                            fontSize: 24.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 32.0),

                        Container(
                          padding: EdgeInsets.all(5),
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10),
                              boxShadow: [
                                BoxShadow(
                                    color: Color.fromRGBO(143, 148, 251, .7),
                                    blurRadius: 20.0,
                                    offset: Offset(0, 12))
                              ]),
                          child: Column(
                            children: <Widget>[
                              Container(
                                padding: EdgeInsets.all(8.0),
                                child: TextFormField(
                                  keyboardType: TextInputType.number,
                                  obscureText: true,
                                  decoration: InputDecoration(
                                      border: InputBorder.none,
                                      hintText: "Enter your PIN",
                                      hintStyle:
                                      TextStyle(color: Colors.grey[400])),
                                  onChanged: (value) {
                                    setState(() {
                                      pin = value;
                                    });
                                  },
                                ),

                              ),

                            ],
                          ),

                        ),

                        // TextField(
                        //   obscureText: true,
                        //   keyboardType: TextInputType.number,
                        //   decoration: InputDecoration(
                        //     hintText: 'Enter your 4 digit PIN',
                        //     hintStyle: TextStyle(
                        //       fontSize: 16.0,
                        //     ),
                        //   ),
                        //   onChanged: (value) {
                        //     setState(() {
                        //       pin = value;
                        //     });
                        //   },
                        // ),
                        SizedBox(height: 50.0),
                        Row(
                          children: [
                            Expanded(
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom( primary: Color(0xffff595e),),  //red color
                                onPressed: (){
                                  Navigator.pushReplacement(context, MaterialPageRoute(
                                    builder: (context) => Dashboard(),
                                  ),);
                                },
                                child: Text('Cancel'),
                              ),
                            ),
                            SizedBox(width: 16,),
                            Expanded(
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom( primary: Color(0xff06d6a0),),  //green color
                                onPressed: _onSubmit,
                                child: Text('Confirm'),
                              ),
                            ),
                          ],
                        ),

                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
  void _onSubmit() {
    if (pin == "1234") {
      _reset();
      Fluttertoast.showToast(
          msg: "Reset Successfull",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.grey[600],
          textColor: Colors.white,
          fontSize: 16.0
      );
      Navigator.pushReplacement(context, MaterialPageRoute(
        builder: (context) => Dashboard(),
      ),);
      print("Call Reset");
    } else {
      showDialog(
        context: context,
        builder: (BuildContext context) => AlertDialog(
          title: Text('ERROR'),
          content: Text('INCORRECT PASSWORD!'),
          actions: [
            TextButton(
              onPressed: (){
                Navigator.pop(context);
              },
              child: Text('OK'),
            ),
          ],
        ),
      );
    }
  }
}

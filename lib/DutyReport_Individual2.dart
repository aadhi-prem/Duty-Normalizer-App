import 'dart:ffi';
import 'dart:typed_data';

import 'ReportGeneration.dart';

import 'DB_HELPER.dart';
import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'dart:io';
import 'dart:typed_data';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'ReportGeneration.dart';
import 'DB_HELPER.dart';
import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

class IndividualReport2 extends StatefulWidget {
  List<Map<String, dynamic>> selectedUsers;
  IndividualReport2({required this.selectedUsers});

  @override
  State<IndividualReport2> createState() => _IndividualReport2State(selectedUsers);
}

class _IndividualReport2State extends State<IndividualReport2> {

  List<Map<String, dynamic>> selectedUsers;
  _IndividualReport2State(this.selectedUsers);

  Future<List<Widget>> _Duties(Map<String, dynamic> item) async{
    List<Widget> DutyCards = [];
    String s = "Select* from Duty where DUTY_NAME in (Select DUTY_NAME from DutyDetails where ID = '${item['ID']}')";
    List<Map<String, dynamic>> Duties = await LocalDB().readDB(s);

    if(Duties.isEmpty){
      DutyCards.add(
        Text(
          "${item['Name']} has not been assigned any duties",
          style: TextStyle(
            color: Colors.red
          ),
        )
      );
    }
    for (var i in Duties) {
      DutyCards.add(Card(
          color: Color(0xff9381ff),
          elevation: 4,
          margin: const EdgeInsets.symmetric(vertical: 10),
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Text('${i["DUTY_NAME"]} '),
                Text('${i["WorkHours"]} '),
              ],
            ),
          )
      )
      );
    }

    return DutyCards;
  }

  List<Map<String, dynamic>> selectedUsers1=[];
  List<List<String>> ll=[];
  int flag=0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text('Duty Reports')
      ),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          children: [
            const SizedBox(
              height: 20,
            ),

            Expanded(
              child: selectedUsers.isNotEmpty
                  ? ListView.builder  (
                  itemCount: selectedUsers.length,
                  itemBuilder: (context, index) => FutureBuilder<List<Widget>>(
                      future: _Duties(selectedUsers[index]),
                      builder: (context, snapshot){
                        if(snapshot.hasData) {
                          return ExpansionTile(
                            title: Card(
                              child: Text(
                                  '${selectedUsers[index]["ID"]} ${selectedUsers[index]['Name']} ${selectedUsers[index]['DEPARTMENT']}'
                              ),
                            ),
                            children: snapshot.data!,
                          );
                        }
                        else if(snapshot.hasError){
                          return Text("Error: ${snapshot.error}");
                        }
                        else{
                          return CircularProgressIndicator();
                        }
                      }
                  )
              )
                  : const Text(
                'No results found',
                style: TextStyle(fontSize: 24,color: Color(0xffff595e),),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    primary: Color(0xff9381ff),
                  ),
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ReportGeneration(),
                      ),
                    );
                  },
                  child: Text('Cancel',style: TextStyle(fontSize: 17),),
                ),

                SizedBox(width: 32,),
                ElevatedButton(
                  style: ElevatedButton.styleFrom( primary: Color(0xffff595e),),
                  onPressed: () async {
                    final pdf = pw.Document();
                    final tableHeaders = ['Duty Name', 'Work Hours'];

                    for(Map<String,dynamic> d in selectedUsers){
                      selectedUsers1=await dutyassigned(d);
                      if(selectedUsers1.length==0) {
                        debugPrint("NO DUTIES HAVE BEEN ASSIGNED");
                        flag=1;
                      }
                      if(flag==0) {
                        var tableData = await download(selectedUsers1, d);
                        const chunkSize = 15;
                        final chunks = <List<List<String>>>[];
                        for (var i = 0; i < tableData.length; i += chunkSize) {
                          final end = (i + chunkSize < tableData.length) ? i +
                              chunkSize : tableData.length;
                          chunks.add(tableData.sublist(i, end));
                        }
                        for (var chunk in chunks) {
                          pdf.addPage(pw.Page(
                            build: (context) =>
                                pw.Column(
                                  crossAxisAlignment: pw.CrossAxisAlignment
                                      .start,
                                  children: [
                                    pw.Text('DUTY REPORT ON INDIVIDUAL',
                                      style: pw.TextStyle(fontSize: 10,
                                          fontWeight: pw.FontWeight.bold),
                                      textAlign: pw.TextAlign.center,
                                    ),
                                    pw.SizedBox(height: 15),
                                    pw.Text("ID OF THE INDIVIDUAL: ${d['ID']}",
                                        style: pw.TextStyle(fontSize: 10,
                                            fontWeight: pw.FontWeight.bold)
                                    ),
                                    pw.SizedBox(height: 15),
                                    pw.Text(
                                        "NAME OF THE INDIVIDUAL: ${d['Name']}",
                                        style: pw.TextStyle(fontSize: 10,
                                            fontWeight: pw.FontWeight.bold)
                                    ),
                                    pw.SizedBox(height: 15),
                                    pw.Table.fromTextArray(
                                      headers: tableHeaders,
                                      data: chunk,
                                      cellAlignment: pw.Alignment.centerLeft,
                                      cellStyle: const pw.TextStyle(
                                          fontSize: 10),
                                      cellHeight: 15,
                                      // cellDecoration: cellDecoration,
                                    ),
                                  ],
                                ),
                          ));
                        }
                      }
                      else{
                        debugPrint("Nothing to print");
                        pdf.addPage(pw.Page(
                          build: (context) =>
                              pw.Column(
                                crossAxisAlignment: pw.CrossAxisAlignment
                                    .start,
                                children: [
                                  pw.Text('DUTY REPORT ON INDIVIDUAL',
                                    style: pw.TextStyle(fontSize: 10,
                                        fontWeight: pw.FontWeight.bold),
                                    textAlign: pw.TextAlign.center,
                                  ),
                                  pw.SizedBox(height: 15),
                                  pw.Text("ID OF THE INDIVIDUAL: ${d['ID']}",
                                      style: pw.TextStyle(fontSize: 10,
                                          fontWeight: pw.FontWeight.bold)
                                  ),
                                  pw.SizedBox(height: 15),
                                  pw.Text(
                                      "NAME OF THE INDIVIDUAL: ${d['Name']}",
                                      style: pw.TextStyle(fontSize: 10,
                                          fontWeight: pw.FontWeight.bold)
                                  ),
                                  pw.SizedBox(height: 15),
                                  pw.Text("No Duties Assigned",
                                      style: pw.TextStyle(fontSize: 10,
                                          fontWeight: pw.FontWeight.bold)
                                  ),
                                  pw.SizedBox(height: 15),
                                ],
                              ),
                        ));
                        flag=0;
                      }
                      // ll.addAll(await download(selectedDuties1, d));
                    }
                    final Uint8List pdfBytes = await pdf.save();
                    await downloadPdf(pdfBytes);
                    debugPrint("DOWNLOAD");
                  },
                  child: const Text('Download',style: TextStyle(fontSize: 17),),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
  Future<List<Map<String, dynamic>>> dutyassigned(Map<String, dynamic> item) async {
    String s = "Select* from Duty where DUTY_NAME in (Select DUTY_NAME from DutyDetails where ID = '${item['ID']}')";
    List<Map<String, dynamic>> Duties = await LocalDB().readDB(s);
    // for(Map<String,dynamic> person in Candidates){
    //   print(person);
    // }
    return Duties;
  }
  Future<List<List<String>>> download(List<Map<String,dynamic>> m,Map<String,dynamic> duty) async {
    debugPrint("IN DOWNLOAD");
    List<List<String>> l = [];
    for (Map<String, dynamic>r in m) {
      debugPrint("${r["DUTY_NAME"]}");
      List<String> a = [];
      a.add(r["DUTY_NAME"]);
      a.add(r["WorkHours"].toString());
      l.add(a);
    }
    //Uint8List pdf= await createPdf(l) as Uint8List;
    // await downloadPdf(pdf);
    return l;
  }

  Future<Uint8List> createPdf(List<List<String>> data) async{
    final pdf = pw.Document();
    final tableHeaders = ['ID', 'Name', 'PhoneNo', 'Email'];
    var tableData=data;
    // Create a table for each chunk of data
    const chunkSize = 15;
    final chunks = <List<List<String>>>[];
    for (var i = 0; i < data.length; i += chunkSize) {
      final end = (i + chunkSize < data.length) ? i + chunkSize : data.length;
      chunks.add(data.sublist(i, end));
    }
    for (var chunk in chunks) {
      pdf.addPage(pw.Page(
        build: (context) => pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.Text('DUTY REPORT', style: pw.TextStyle(fontSize: 10, fontWeight: pw.FontWeight.bold) ,textAlign: pw.TextAlign.center,
            ),
            pw.SizedBox(height: 15),


            // pw.Text('DUTY NAME: $name', style: pw.TextStyle(fontSize: 10, fontWeight: pw.FontWeight.bold)
            // ),
            // pw.SizedBox(height: 15),
            //
            // pw.Text('DEPARTMENT: $dept', style: pw.TextStyle(fontSize: 10, fontWeight: pw.FontWeight.bold)
            // ),
            // pw.SizedBox(height: 15),
            pw.Table.fromTextArray(
              headers: tableHeaders,
              data: chunk,
              cellAlignment: pw.Alignment.centerLeft,
              cellStyle: const pw.TextStyle(fontSize: 10),
              cellHeight: 15,
              // cellDecoration: cellDecoration,
            ),
          ],
        ),
      ));
    }

    return pdf.save();
  }

  Future<void> downloadPdf(Uint8List pdf) async {
    // Save the PDF file to the local file system
    Directory tempDirectory = await getTemporaryDirectory();
    String tempPath = tempDirectory.path;
    File file = File('$tempPath/data.pdf');
    await file.writeAsBytes(pdf);
    // Open the PDF file using the open_file package
    await OpenFile.open(file.path);
  }
}

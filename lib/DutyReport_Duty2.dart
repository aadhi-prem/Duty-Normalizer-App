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

class DutyReport2 extends StatefulWidget {
  List<Map<String, dynamic>> selectedDuties;
  DutyReport2({required this.selectedDuties});

  @override
  State<DutyReport2> createState() => _DutyReport2State(selectedDuties);
}

class _DutyReport2State extends State<DutyReport2> {

  List<Map<String, dynamic>> selectedDuties;
  _DutyReport2State(this.selectedDuties);

  Future<List<Widget>> _Candidates(Map<String, dynamic> item) async{
    List<Widget> CandidateCards = [];
    String s = "Select* from (Select* from Mtech union Select* from Phd union Select* from Faculty) where ID in (Select ID from DutyDetails where DUTY_NAME = '${item['DUTY_NAME']}')";
    List<Map<String, dynamic>> Candidates = await LocalDB().readDB(s);

    for (var i in Candidates) {
      CandidateCards.add(Card(
          color: Color(0xffb8b8ff),
          elevation: 4,
          margin: const EdgeInsets.symmetric(vertical: 10),
          child: Container(
            height: 30,width: 350,
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Text('  ${i["ID"]}  ${i["Name"]}  ${i["DEPARTMENT"]} ',
                    style: TextStyle(fontSize: 15, color: Colors.black.withOpacity(0.9)),
                  ),

                ],
              ),
            ),
          )
      )
      );
    }

    return CandidateCards;
  }

  List<Map<String, dynamic>> selectedDuties1=[];
  List<List<String>> ll=[];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
          title: Text('Duty Reports'),
        elevation: .1,
        backgroundColor: Color(0xff9381ff),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          children: [
            const SizedBox(
              height: 20,
            ),

            Expanded(
              child: selectedDuties.isNotEmpty
                  ? ListView.builder  (
                itemCount: selectedDuties.length,
                itemBuilder: (context, index) => FutureBuilder<List<Widget>>(
                    future: _Candidates(selectedDuties[index]),
                    builder: (context, snapshot){
                      if(snapshot.hasData) {
                        return ExpansionTile(
                          title: Container(
                            height: 60,
                            child: Card(
                              color: Color(0xff9381ff),
                              elevation: 4,
                              margin: const EdgeInsets.symmetric(vertical: 10),
                              child: SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Text(
                                      '   ${selectedDuties[index]["DUTY_NAME"]}    Duty Hours: ${selectedDuties[index]['WorkHours']}  ',
                                      style: TextStyle(fontSize: 17, color: Colors.black.withOpacity(0.8)),
                                    ),
                                  ],
                                ),
                              ),
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
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Container(
                  width: 125,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      primary: Color(0xff0077b6), //0xff9381ff
                    ),
                    onPressed: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ReportGeneration(),
                        ),
                      );
                    },
                    child: Text('Done',style: TextStyle(fontSize: 17),),
                  ),
                ),
                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom( primary: Color(0xff9381ff),),
                  onPressed: () async {
                    // Fluttertoast.showToast(
                    //     msg: "Deleted Successfully",
                    //     toastLength: Toast.LENGTH_SHORT,
                    //     gravity: ToastGravity.BOTTOM,
                    //     timeInSecForIosWeb: 1,
                    //     backgroundColor: Colors.grey[600],
                    //     textColor: Colors.white,
                    //     fontSize: 16.0
                    // );
                    // selectall=false;
                    // List<Map<String, dynamic>> selectedDuties = [];
                    // for (Map<String,dynamic>r in _allDuties) {
                    //   if (_selected[r["DUTY_NAME"]]!) {
                    //     selectedDuties.add(r);
                    //   }
                    // }
                    // Navigator.push(
                    //   context,
                    //   MaterialPageRoute(builder: (context) => DutyReport2(selectedDuties: selectedDuties)),
                    // );
                    final pdf = pw.Document();
                    final tableHeaders = ['ID', 'Name', 'PhoneNo', 'Email'];

                    for(Map<String,dynamic> d in selectedDuties){
                       selectedDuties1=await peopleassigned(d);
                       var tableData=await download(selectedDuties1, d);
                       const chunkSize = 15;
                       final chunks = <List<List<String>>>[];
                       for (var i = 0; i < tableData.length; i += chunkSize) {
                         final end = (i + chunkSize < tableData.length) ? i + chunkSize : tableData.length;
                         chunks.add(tableData.sublist(i, end));
                       }
                       for (var chunk in chunks) {
                         pdf.addPage(pw.Page(
                           build: (context) => pw.Column(
                             crossAxisAlignment: pw.CrossAxisAlignment.start,
                             children: [
                               pw.Text('DUTY REPORT', style: pw.TextStyle(fontSize: 10, fontWeight: pw.FontWeight.bold) ,textAlign: pw.TextAlign.center,
                               ),
                               pw.SizedBox(height: 15),
                               pw.Text("DUTY NAME: ${d['DUTY_NAME']}", style: pw.TextStyle(fontSize: 10, fontWeight: pw.FontWeight.bold)
                               ),
                               pw.SizedBox(height: 15),
                               pw.Text("DUTY HOURS: ${d['WorkHours']}", style: pw.TextStyle(fontSize: 10, fontWeight: pw.FontWeight.bold)
                               ),
                               pw.SizedBox(height: 15),
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

                    // ll.addAll(await download(selectedDuties1, d));
                    }


                    // Uint8List pdf= await createPdf(ll);
                    final Uint8List pdfBytes = await pdf.save();
                    await downloadPdf(pdfBytes);
                    // debugPrint("downloaded");


                  },
                  label: const Text('Download',style: TextStyle(fontSize: 17),),
                  icon: Icon(Icons.download_sharp),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }

   Future<List<Map<String, dynamic>>> peopleassigned(Map<String, dynamic> item) async {
    String s = "Select* from (Select* from Mtech union Select* from Phd union Select* from Faculty) where ID in (Select ID from DutyDetails where DUTY_NAME = '${item['DUTY_NAME']}')";
    List<Map<String, dynamic>> Candidates = await LocalDB().readDB(s);
    // for(Map<String,dynamic> person in Candidates){
    //   print(person);
    // }
    return Candidates;
  }
  Future<List<List<String>>> download(List<Map<String,dynamic>> m,Map<String,dynamic> duty) async {
    debugPrint("IN DOWNLOAD");
    List<List<String>> l = [];
    for (Map<String, dynamic>r in m) {
      debugPrint("${r["Name"]}");
      List<String> a = [];
      a.add(r["ID"]);
      a.add(r["Name"]);
      // a.add(r["DEPARTMENT"]);
      a.add(r["PhoneNo"]);
      a.add(r["Email"]);
      //a.add(r["WorkHours"]);
      l.add(a);
    }
    //Uint8List pdf= await createPdf(l) as Uint8List;
   // await downloadPdf(pdf);
    return l;
  }

  Future<Uint8List> createPdf(List<List<String>> data) async{
    final pdf = pw.Document();
    final tableHeaders = ['ID', 'Name', 'PhoneNo', 'Email', 'WorkHours'];
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



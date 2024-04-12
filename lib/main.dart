import 'dart:io';
import 'package:flutter/material.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: PdfGenerator(),
    );
  }
}

class PdfGenerator extends StatelessWidget {
  final List<Map<String, dynamic>> data = [
    {'name': 'Regendra Suman', 'age': 27, 'city': 'Gwalior'},
    {'name': 'Raju', 'age': 26, 'city': 'Indore'},
    {'name': 'Boby', 'age': 28, 'city': 'Bhopla'},
  ];

  pw.Widget _buildTable() {
    final headers = ['Name', 'Age', 'City'];

    return pw.Table.fromTextArray(
      headers: headers,
      data: List<List<String>>.generate(
        data.length,
            (row) => [
          data[row]['name'].toString(),
          data[row]['age'].toString(),
          data[row]['city'].toString(),
        ],
      ),
    );
  }

  Future<File> _generatePdf() async {
    final pdf = pw.Document();
    pdf.addPage(pw.Page(build: (pw.Context context) {
          return pw.Center(
            child: pw.Column(
              children: [
                pw.Text('Generated PDF', style: pw.TextStyle(fontSize: 24)),
                pw.SizedBox(height: 20),
                _buildTable(),
              ],
            ),
          );
        }),);


    final directory = await getExternalStorageDirectory();
    print("kasjdkla ${directory}");
    final output = File("${directory?.path}/example.pdf");
    await output.writeAsBytes(await pdf.save());

    OpenFile.open(output.path);


    return output;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('PDF Generation'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () async {
            final pdfFile = await _generatePdf();
            print('PDF Generated: ${pdfFile.path}');



          },
          child: Text('Generate PDF'),
        ),
      ),
    );
  }
}

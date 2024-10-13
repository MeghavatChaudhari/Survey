import 'package:flutter/material.dart';

class TrustComponentTable extends StatelessWidget {
  final List<Map<String, dynamic>> data;

  // Constructor to accept data
  TrustComponentTable({Key? key, required this.data}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      child: Table(
        border: TableBorder.all(color: Colors.black),
        columnWidths: {
          0: FlexColumnWidth(3),
          1: FlexColumnWidth(2),
        },
        children: [
          _buildHeaderRow(),
          ...data.map((row) {
            return _buildDataRow(row['component'], row['grade'], row['color']);
          }).toList(),
        ],
      ),
    );
  }

  TableRow _buildHeaderRow() {
    return TableRow(
      children: [
        _buildCell('Trust Component (weight)', backgroundColor: Colors.black, textColor: Colors.white, fontWeight: FontWeight.bold),
        _buildCell('Grade', backgroundColor: Colors.black, textColor: Colors.white, fontWeight: FontWeight.bold),
      ],
    );
  }

  TableRow _buildDataRow(String component, String grade, Color gradeColor) {
    return TableRow(
      children: [
        _buildCell(component, backgroundColor: Colors.white),
        _buildCell(grade, backgroundColor: gradeColor),
      ],
    );
  }

  Widget _buildCell(String text, {Color backgroundColor = Colors.white, Color textColor = Colors.black, FontWeight fontWeight = FontWeight.normal}) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 6, horizontal: 5),
      color: backgroundColor,
      child: Text(
        text,
        style: TextStyle(color: textColor, fontWeight: fontWeight),
      ),
    );
  }
}

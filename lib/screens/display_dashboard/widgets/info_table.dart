import 'package:flutter/material.dart';


class InfoTable extends StatelessWidget {
  final String title;
  final List<TableRow> tableItems;
  const InfoTable({super.key, required this.title, required this.tableItems});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          decoration: BoxDecoration(
            border: Border.all(width: 1,color: Colors.black),
            color: Colors.blueAccent,
          ),
          child: Center(
              child:  Text(title,style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 16
              ),)),
          width: 345,
          height: 30,
        ),
        Table(
          border: TableBorder.all(color: Colors.transparent, width: 0),
          columnWidths: const {
            0: FixedColumnWidth(235),
            1: FixedColumnWidth(110),
          },
          children: tableItems,
        ),
      ],
    );
  }
}
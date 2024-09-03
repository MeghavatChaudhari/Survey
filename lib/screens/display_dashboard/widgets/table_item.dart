import 'package:flutter/material.dart';



TableRow buildTableRow({
  required String title,
  required String value,
})
{
  return TableRow(
    children: [
      Container(
        decoration: BoxDecoration(
            border: Border.all(width: 0.8,color: Colors.black),
            color: const Color(0xFFdbe9f4)
        ),
        height: 40,
        child: Center(
          child: Text(
            title,
            style: const TextStyle(color: Colors.black,fontWeight: FontWeight.w500),
          ),
        ),
      ),
      Container(
        decoration: BoxDecoration(
          border: Border.all(width: 0.8,color: Colors.black),
          color: Colors.green,
        ),
        height: 40,
        child: Center(
          child: Text(
            value,
            style: const TextStyle(color: Colors.white,fontWeight: FontWeight.w500),
          ),
        ),
      ),
    ],
  );
}



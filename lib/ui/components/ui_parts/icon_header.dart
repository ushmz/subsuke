import 'package:flutter/material.dart';

class IconHeader extends StatelessWidget {
  final IconData icon;
  final String title;

  IconHeader(this.icon, this.title);

  @override
  Widget build(BuildContext ctx) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon),
        Padding(
          padding: EdgeInsets.only(left: 5),
          child: Text(
            title,
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        )
      ],
    );
  }
}

import 'package:flutter/material.dart';

class ResolvedThemeText extends Text {
  final String data;
  ResolvedThemeText(this.data) : super(data);

  @override
  Widget build(BuildContext context) {
    return Text(
      data,
      style: TextStyle(
        color: Theme.of(context).textTheme.titleLarge!.color,
      ),
    );
  }
}

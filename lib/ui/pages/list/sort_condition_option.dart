import 'package:flutter/material.dart';

class SortConditionOption extends StatelessWidget {
  final String option;
  final Function() onTap;
  final bool? selected;

  SortConditionOption({
    required this.option,
    required this.onTap,
    required this.selected,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 8),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  option,
                  textAlign: TextAlign.justify,
                  style: TextStyle(fontSize: 18),
                ),
                Padding(
                  padding: EdgeInsets.only(right: 16),
                  child: Icon(
                    Icons.check,
                    color: selected != null && selected!
                        ? Theme.of(context).primaryColor
                        : Colors.transparent,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}


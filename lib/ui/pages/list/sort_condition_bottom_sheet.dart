import 'package:flutter/material.dart';
import 'package:subsuke/ui/pages/list/sort_condition_option.dart';

class SortConditionBottomSheet extends StatelessWidget {
  final List<SortConditionOption> children;
  final Function() onPressClear;
  SortConditionBottomSheet(
      {required this.children, required this.onPressClear});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 300,
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 8),
            child: Container(
              height: 40,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("並び替え順序", style: TextStyle(fontSize: 16)),
                  InkWell(
                    onTap: onPressClear,
                    child: Text("クリア", style: TextStyle(fontSize: 16)),
                  ),
                ],
              ),
            ),
          ),
          Divider(
            color: Theme.of(context).hintColor,
            height: 1,
          ),
          ...children
        ],
      ),
    );
  }
}

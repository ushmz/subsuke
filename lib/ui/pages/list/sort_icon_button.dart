import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:subsuke/models/subsc.dart';
import 'package:subsuke/ui/pages/list/sort_condition_option.dart';
import 'package:subsuke/ui/pages/list/sort_condition_bottom_sheet.dart';

IconData getPlatformSortIcon() {
  if (Platform.isIOS) {
    return CupertinoIcons.sort_down;
  } else {
    return Icons.sort;
  }
}

class SortIconButton extends StatelessWidget {
  final Function(ItemSortCondition) onChange;
  final Stream<ItemSortCondition> stream;

  SortIconButton({
    required this.onChange,
    required this.stream,
  });

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: stream,
      builder: (BuildContext ctx, AsyncSnapshot<ItemSortCondition> ss) {
        return CupertinoButton(
          padding: EdgeInsets.zero,
          child: Icon(
            getPlatformSortIcon(),
            size: 28,
            color: Theme.of(context).iconTheme.color,
          ),
          onPressed: (() {
            showModalBottomSheet(
              context: context,
              builder: (BuildContext ctx) {
                return SortConditionBottomSheet(
                  onPressClear: () {
                    onChange(ItemSortCondition.None);
                    Navigator.pop(ctx);
                  },
                  children: [
                    SortConditionOption(
                      selected: ss.data == ItemSortCondition.PriceASC,
                      option: ItemSortCondition.PriceASC.sortConditionName,
                      onTap: () {
                        onChange(ItemSortCondition.PriceASC);
                        Navigator.pop(ctx);
                      },
                    ),
                    SortConditionOption(
                      selected: ss.data == ItemSortCondition.PriceDESC,
                      option: ItemSortCondition.PriceDESC.sortConditionName,
                      onTap: () {
                        onChange(ItemSortCondition.PriceDESC);
                        Navigator.pop(ctx);
                      },
                    ),
                    SortConditionOption(
                      selected: ss.data == ItemSortCondition.NextASC,
                      option: ItemSortCondition.NextASC.sortConditionName,
                      onTap: () {
                        onChange(ItemSortCondition.NextASC);
                        Navigator.pop(ctx);
                      },
                    ),
                    SortConditionOption(
                      selected: ss.data == ItemSortCondition.NextDESC,
                      option: ItemSortCondition.NextDESC.sortConditionName,
                      onTap: () {
                        onChange(ItemSortCondition.NextDESC);
                        Navigator.pop(ctx);
                      },
                    ),
                  ],
                );
              },
            );
          }),
        );
      },
    );
  }
}

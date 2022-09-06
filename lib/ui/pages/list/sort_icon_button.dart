import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:subsuke/models/subsc.dart';
import 'package:subsuke/ui/pages/list/sort_condition_option.dart';
import 'package:subsuke/ui/pages/list/sort_condition_bottom_sheet.dart';

class SortIconButtonIOS extends StatelessWidget {
  final Stream<ItemSortCondition> stream;
  final Function(ItemSortCondition) onPressed;

  SortIconButtonIOS({required this.stream, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: stream,
      builder: (BuildContext ctx, AsyncSnapshot<ItemSortCondition> ss) {
        return CupertinoButton(
          padding: EdgeInsets.zero,
          child: Icon(
            CupertinoIcons.sort_down,
            size: 28,
            color: Theme.of(context).iconTheme.color,
          ),
          onPressed: (() {
            showModalBottomSheet(
              context: context,
              builder: (BuildContext ctx) {
                return SortConditionBottomSheet(
                  onPressClear: () {
                    onPressed(ItemSortCondition.None);
                    Navigator.pop(ctx);
                  },
                  children: [
                    SortConditionOption(
                      selected: ss.data == ItemSortCondition.PriceASC,
                      option: ItemSortCondition.PriceASC.sortConditionName,
                      onTap: () {
                        onPressed(ItemSortCondition.PriceASC);
                        Navigator.pop(ctx);
                      },
                    ),
                    SortConditionOption(
                      selected: ss.data == ItemSortCondition.PriceDESC,
                      option: ItemSortCondition.PriceDESC.sortConditionName,
                      onTap: () {
                        onPressed(ItemSortCondition.PriceDESC);
                        Navigator.pop(ctx);
                      },
                    ),
                    SortConditionOption(
                      selected: ss.data == ItemSortCondition.NextASC,
                      option: ItemSortCondition.NextASC.sortConditionName,
                      onTap: () {
                        onPressed(ItemSortCondition.NextASC);
                        Navigator.pop(ctx);
                      },
                    ),
                    SortConditionOption(
                      selected: ss.data == ItemSortCondition.NextDESC,
                      option: ItemSortCondition.NextDESC.sortConditionName,
                      onTap: () {
                        onPressed(ItemSortCondition.NextDESC);
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

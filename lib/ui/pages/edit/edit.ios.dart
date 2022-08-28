import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:subsuke/models/subsc.dart';
import 'package:subsuke/ui/components/form/row.dart';

class EditPageIOS extends StatelessWidget {
  final SubscriptionItem item;

  EditPageIOS(this.item);

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      child: CustomScrollView(
        slivers: [
          CupertinoSliverNavigationBar(
            border: null,
            backgroundColor: Theme.of(context).backgroundColor,
            largeTitle: Center(),
            leading: CupertinoNavigationBarBackButton(
                color: Theme.of(context).primaryColor),
            trailing: CupertinoButton(
              padding: EdgeInsets.zero,
              child: Text(
                "保存",
                style: TextStyle(
                    fontSize: 16, color: Theme.of(context).primaryColor),
              ),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ),
          SliverList(
            delegate: SliverChildListDelegate(
              [
                CupertinoFormSection.insetGrouped(
                  backgroundColor: Theme.of(context).backgroundColor,
                  decoration: BoxDecoration(
                    color: Theme.of(context).dialogBackgroundColor,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  children: [
                    ServiceNameInputRow(name: item.name),
                    ServicePriceInputRow(price: item.price.toString()),
                    PaymentMethodPickerRow(),
                    PaymentCyclePickerRow(),
                    PaymentNextDatePickerRow(),
                    PaymentReminderPickerRow(),
                    TrialButtonRow(),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

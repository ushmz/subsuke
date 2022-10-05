import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:subsuke/blocs/edit_screen_bloc.dart';
import 'package:subsuke/ui/components/form/row.dart';

class AddPageIOS extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final bloc = Provider.of<EditScreenBLoC>(context);

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
                print(bloc.getValues());
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
                    ServiceNameInputRow(),
                    ServicePriceInputRow(),
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

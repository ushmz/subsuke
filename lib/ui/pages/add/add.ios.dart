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
            // [INFO] Following code is ideal, but raise error while animation.
            // Error : CupertinoNavigationBarBackButton should only be used in routes that can be popped
            // leading: CupertinoNavigationBarBackButton(color: Theme.of(context).primaryColor),
            leading: GestureDetector(
              child: Icon(
                CupertinoIcons.left_chevron,
                color: Theme.of(context).primaryColor,
                size: 24,
              ),
              onTap: () => Navigator.pop(context),
            ),
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

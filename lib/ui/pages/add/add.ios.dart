import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:subsuke/blocs/edit_screen_bloc.dart';
import 'package:subsuke/blocs/payment_methods_bloc.dart';
import 'package:subsuke/models/subsc.dart';
import 'package:subsuke/ui/components/form/row.dart';

class AddPageIOS extends StatelessWidget {
  final Function(SubscriptionItem) onAdd;
  AddPageIOS({
    required this.onAdd,
  });

  @override
  Widget build(BuildContext context) {
    final bloc = Provider.of<EditScreenBLoC>(context);
    final payment = Provider.of<PaymentMethodBLoC>(context);

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
                style: TextStyle(color: Theme.of(context).primaryColor),
              ),
              onPressed: () {
                final i = bloc.getValues();
                onAdd(i);
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
                    ServiceNameInputRow(
                      onChange: (val) {
                         // TODO : If you change focus before press 'enter' key,
                         // the empty character is passed to `val`.
                        if (val == "") {
                          return;
                        }
                        bloc.setNameText(val);
                      },
                    ),
                    ServicePriceInputRow(
                      onChange: (val) {
                        var p = int.tryParse(val);
                        if (p == null) {
                          return;
                        }
                        bloc.setPriceNum(p);
                      },
                    ),
                    FutureBuilder<List<PaymentMethod>>(
                      future: payment.getAllPaymentMethods(),
                      builder: ((context, snapshot) {
                        return PaymentMethodPickerRow(
                          stream: payment.methodStream,
                          methods: snapshot.data ?? [],
                          initialItem: "",
                          onChange: (val) {
                            payment.setPaymentMethodString(val);
                            bloc.setPaymentMethod(val);
                          },
                          onChangePaymentMethod: (val) {
                            payment.setPaymentMethod(val);
                            bloc.setPaymentMethod(val.name);
                          },
                        );
                      }),
                    ),
                    PaymentCyclePickerRow(
                      stream: bloc.onChangeInterval,
                      onChange: (val) => bloc.setInterval(
                        getPaymentInterval(val),
                      ),
                    ),
                    PaymentNextDatePickerRow(
                      stream: bloc.onChangeNextTime,
                      onChange: (val) => bloc.setNextTime(val),
                    ),
                    PaymentReminderPickerRow(
                      stream: bloc.onChangeNotificationBefore,
                      onChange: (val) => bloc.setNotificationBefore(
                        NotificationBefore.values[val],
                      ),
                    ),
                    TrialButtonRow(onChange: (val) => print(val)),
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

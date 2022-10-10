import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:subsuke/blocs/edit_screen_bloc.dart';
import 'package:subsuke/blocs/payment_methods_bloc.dart';
import 'package:subsuke/models/subsc.dart';
import 'package:subsuke/ui/components/form/row.dart';

class EditPageIOS extends StatelessWidget {
  final SubscriptionItem item;
  final Function(int, SubscriptionItem) onUpdate;

  EditPageIOS({
    required this.item,
    required this.onUpdate,
  });

  @override
  Widget build(BuildContext context) {
    final bloc = Provider.of<EditScreenBLoC>(context);
    final payment = Provider.of<PaymentMethodBLoC>(context);
    bloc.setValues(item);

    return CupertinoPageScaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      navigationBar: CupertinoNavigationBar(
        border: null,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
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
              fontSize: 16,
              color: Theme.of(context).primaryColor,
            ),
          ),
          onPressed: () {
            final i = bloc.getValues();
            onUpdate(item.id, i);
            Navigator.pop(context);
          },
        ),
      ),
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 32.0),
          child: CupertinoFormSection.insetGrouped(
            decoration: BoxDecoration(
              color: Theme.of(context).dialogBackgroundColor,
              borderRadius: BorderRadius.circular(12),
            ),
            children: [
              ServiceNameInputRow(
                initialValue: item.name,
                onChange: (val) => bloc.setNameText(val),
              ),
              ServicePriceInputRow(
                initialValue: item.price.toString(),
                onChange: (val) {
                  var p = int.tryParse(val);
                  if (p == null) {
                    p = 0;
                  }
                  bloc.setPriceNum(p);
                },
              ),
              FutureBuilder<List<PaymentMethod>>(
                future: payment.getAllPaymentMethods(),
                builder: ((context, snapshot) {
                  return PaymentMethodPickerRow(
                    stream: payment.methodStream,
                    initialItem: item.paymentMethod,
                    methods: snapshot.data ?? [],
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
                onChange: (val) {
                  bloc.setNextTime(val);
                },
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
        ),
        // slivers: [
        //   SliverList( delegate: SliverChildListDelegate( [ ])),
        // ],
      ),
    );
  }
}

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:subsuke/blocs/edit_screen_bloc.dart';
import 'package:subsuke/blocs/payment_methods_bloc.dart';
import 'package:subsuke/models/subsc.dart';
import 'package:subsuke/ui/components/form/row.dart';

class AddPageIOS extends StatelessWidget {
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
            leading: CupertinoNavigationBarBackButton(
              color: Theme.of(context).primaryColor,
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            trailing: CupertinoButton(
              padding: EdgeInsets.zero,
              child: Text(
                "保存",
                style: TextStyle(color: Theme.of(context).primaryColor),
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
                    ServiceNameInputRow(
                      onChange: (val) => bloc.setNameText(val),
                    ),
                    ServicePriceInputRow(
                      onChange: (val) => bloc.setPriceNum(int.parse(val)),
                    ),
                    FutureBuilder<List<PaymentMethod>>(
                      future: payment.getAllPaymentMethods(),
                      builder: ((context, snapshot) {
                        return PaymentMethodPickerRow(
                          stream: payment.methodStream,
                          methods: snapshot.data ?? [],
                          onCanged: (val) {
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

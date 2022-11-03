import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:subsuke/blocs/edit_screen_bloc.dart';
import 'package:subsuke/db/db_provider.dart';
import 'package:subsuke/models/payment_interval.dart';
import 'package:subsuke/models/subscription_item.dart';
import 'package:subsuke/ui/components/ui_parts/icon_header.dart';

typedef TextFieldBuilder<T> = Widget Function(
  BuildContext ctx,
  AsyncSnapshot<T> ss,
);

class SubscriptionFormGroup extends StatelessWidget {
  final Function() refreshItems;
  final SubscriptionItem? item;
  SubscriptionFormGroup(this.refreshItems, {this.item});

  TextFieldBuilder<String> textInputBuilder(
    TextEditingController ctrl,
    Function(String) onChanged,
    String labelText,
  ) {
    return (BuildContext ctx, AsyncSnapshot<String> ss) {
      var value;
      switch (ss.connectionState) {
        case ConnectionState.waiting:
          value = '';
          break;
        default:
          value = ss.data;
          break;
      }
      ctrl.text = value;
      ctrl.selection =
          TextSelection(baseOffset: value.length, extentOffset: value.length);
      return TextField(
        controller: ctrl,
        decoration:
            InputDecoration(border: OutlineInputBorder(), hintText: labelText),
        onChanged: onChanged,
      );
    };
  }

  TextFieldBuilder<int> numberInputBuilder(
    TextEditingController ctrl,
    Function(String) onChanged,
    String labelText,
  ) {
    return (BuildContext ctx, AsyncSnapshot<int> ss) {
      var value;
      switch (ss.connectionState) {
        case ConnectionState.waiting:
          value = '';
          break;
        default:
          value = ss.data.toString();
          break;
      }
      ctrl.text = value;
      ctrl.selection =
          TextSelection(baseOffset: value.length, extentOffset: value.length);
      return TextField(
        keyboardType: TextInputType.number,
        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
        controller: ctrl,
        decoration:
            InputDecoration(border: OutlineInputBorder(), hintText: labelText),
        onChanged: onChanged,
      );
    };
  }

  TextFieldBuilder<DateTime> datetimeInputBuilder(
    TextEditingController ctrl,
    Function(DateTime) onChanged,
    String labelText,
  ) {
    return (BuildContext ctx, AsyncSnapshot<DateTime> ss) {
      DateTime initial;
      switch (ss.connectionState) {
        case ConnectionState.waiting:
          initial = DateTime.now();
          break;
        default:
          initial = ss.data!;
          break;
      }
      return TextField(
        keyboardType: TextInputType.datetime,
        /* inputFormatters: [FilteringTextInputFormatter.digitsOnly], */
        controller: ctrl,
        decoration: InputDecoration(
          border: OutlineInputBorder(),
          hintText: "${DateFormat('yyyy-MM-dd').format(initial)}",
        ),
        onTap: () async {
          FocusScope.of(ctx).requestFocus(new FocusNode());
          if (Platform.isIOS) {
            showCupertinoModalPopup(
              context: ctx,
              builder: (BuildContext c) => Container(
                color: Theme.of(c).scaffoldBackgroundColor,
                height: MediaQuery.of(c).size.height / 3,
                child: CupertinoTheme(
                    data:
                        CupertinoThemeData(brightness: Theme.of(c).brightness),
                    child: CupertinoDatePicker(
                      mode: CupertinoDatePickerMode.date,
                      initialDateTime: initial,
                      onDateTimeChanged: onChanged,
                    )),
              ),
            );
          } else {
            final date = await showDatePicker(
              context: ctx,
              initialDate: initial,
              firstDate: DateTime(1900),
              lastDate: DateTime(2100),
            );
            if (date != null) {
              onChanged(date);
            }
          }
        },
      );
    };
  }

  TextFieldBuilder<PaymentInterval> intervalInputBuilder(
    TextEditingController ctrl,
    Function(PaymentInterval) onChanged,
  ) {
    return (BuildContext ctx, AsyncSnapshot<PaymentInterval> ss) {
      PaymentInterval initial;
      switch (ss.connectionState) {
        case ConnectionState.waiting:
          initial = PaymentInterval.Monthly;
          break;
        default:
          initial = ss.data!;
          break;
      }
      ctrl.text = initial.getText;
      return TextField(
        keyboardType: TextInputType.text,
        /* inputFormatters: [FilteringTextInputFormatter.digitsOnly], */
        controller: ctrl,
        decoration: InputDecoration(
          border: OutlineInputBorder(),
        ),
        onTap: () async {
          FocusScope.of(ctx).requestFocus(new FocusNode());
          if (Platform.isIOS) {
            showModalBottomSheet(
                context: ctx,
                builder: (BuildContext c) {
                  return GestureDetector(
                    onTap: () => Navigator.pop(c),
                    child: Container(
                        height: MediaQuery.of(c).size.height * 0.3,
                        child: CupertinoPicker(
                          itemExtent: 40,
                          children: [
                            Text(PaymentInterval.Daily.getText),
                            Text(PaymentInterval.Weekly.getText),
                            Text(PaymentInterval.Fortnightly.getText),
                            Text(PaymentInterval.Monthly.getText),
                            Text(PaymentInterval.Yearly.getText),
                          ],
                          onSelectedItemChanged: (int index) {
                            final interval = getPaymentInterval(index + 1);
                            onChanged(interval);
                          },
                        )),
                  );
                });
          } else {
            showDialog(
                context: ctx,
                builder: (BuildContext c) {
                  return SimpleDialog(
                    title: Text('支払い周期'),
                    children: [
                      SimpleDialogOption(
                        child: Text(PaymentInterval.Daily.getText),
                        onPressed: () => onChanged(PaymentInterval.Daily),
                      ),
                      SimpleDialogOption(
                        child: Text(PaymentInterval.Weekly.getText),
                        onPressed: () => onChanged(PaymentInterval.Weekly),
                      ),
                      SimpleDialogOption(
                        child: Text(PaymentInterval.Fortnightly.getText),
                        onPressed: () => onChanged(PaymentInterval.Fortnightly),
                      ),
                      SimpleDialogOption(
                        child: Text(PaymentInterval.Monthly.getText),
                        onPressed: () => onChanged(PaymentInterval.Monthly),
                      ),
                      SimpleDialogOption(
                        child: Text(PaymentInterval.Yearly.getText),
                        onPressed: () => onChanged(PaymentInterval.Yearly),
                      ),
                    ],
                  );
                });
          }
        },
      );
    };
  }

  @override
  Widget build(BuildContext context) {
    final bloc = Provider.of<EditScreenBLoC>(context);
    if (item != null) {
      bloc.setValues(item!);
    }

    final _nameFormCtrl = TextEditingController();
    final _priceFormCtrl = TextEditingController();
    final _nextFormCtrl = TextEditingController();
    final _cycleFormCtrl = TextEditingController();
    final _paymentMethodFormCtrl = TextEditingController();
    final _noteFormCtrl = TextEditingController();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        elevation: 0,
        iconTheme: IconThemeData(color: Theme.of(context).hintColor),
        actions: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 10),
            child: TextButton(
              child: Text(
                "保存する",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).primaryColor,
                ),
              ),
              onPressed: () {
                final i = SubscriptionItem(
                  id: item?.id ?? 0,
                  name: bloc.getName,
                  price: bloc.getPrice,
                  next: bloc.getNextTime,
                  interval: bloc.getInterval,
                  note: bloc.getNote,
                  paymentMethod: "Visa *1234",
                );
                DBProvider.instance.upsertSubscriptionItem(item?.id ?? 0, i);
                refreshItems();
                Navigator.pop(context);
              },
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
              child: Container(
                height: MediaQuery.of(context).size.height,
                child: Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 10),
                      child: Column(
                        children: [
                          Text(
                            "サービス名",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          StreamBuilder(
                            stream: bloc.onChangeNameText,
                            builder: textInputBuilder(
                              _nameFormCtrl,
                              (text) => bloc.setNameText(text),
                              "サブスクリプション名",
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 10),
                      child: Column(children: [
                        IconHeader(Icons.payment, "価格"),
                        StreamBuilder(
                          stream: bloc.onChangePriceNum,
                          builder: numberInputBuilder(
                            _priceFormCtrl,
                            (text) => bloc.setPriceNum(int.tryParse(text) ?? 0),
                            "価格",
                          ),
                        ),
                      ]),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 10),
                      child: Column(children: [
                        IconHeader(Icons.note, "支払い方法"),
                        StreamBuilder(
                          stream: bloc.onChangePayment,
                          builder: textInputBuilder(
                            _paymentMethodFormCtrl,
                            (text) => bloc.setPaymentMethod(text),
                            "例）クレジットカード",
                          ),
                        ),
                      ]),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 10),
                      child: Column(
                        children: [
                          IconHeader(Icons.event_repeat, "支払日"),
                          StreamBuilder(
                            stream: bloc.onChangeNextTime,
                            builder: datetimeInputBuilder(
                              _nextFormCtrl,
                              (picked) => bloc.setNextTime(picked),
                              "支払日",
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 10),
                      child: Column(
                        children: [
                          IconHeader(Icons.event_repeat, "支払い周期"),
                          StreamBuilder(
                            stream: bloc.onChangeInterval,
                            builder: intervalInputBuilder(
                              _cycleFormCtrl,
                              (picked) {
                                bloc.setInterval(picked);
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                    Divider(
                      color: Theme.of(context).hintColor,
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 10),
                      child: Column(children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            IconHeader(Icons.note, "メモ"),
                            Spacer(),
                            Icon(Icons.open_in_full)
                          ],
                        ),
                        StreamBuilder(
                          stream: bloc.onChangeNote,
                          builder: textInputBuilder(
                            _noteFormCtrl,
                            (text) => bloc.setNote(text),
                            "何か書く",
                          ),
                        ),
                      ]),
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

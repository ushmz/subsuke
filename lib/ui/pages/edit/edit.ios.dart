import 'package:intl/intl.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:subsuke/blocs/edit_screen_bloc.dart';
import 'package:subsuke/blocs/payment_methods_bloc.dart';
import 'package:subsuke/models/subsc.dart';
import 'package:subsuke/ui/pages/add/add.ios.dart';

class EditPageIOS extends StatelessWidget {
  final SubscriptionItem item;
  EditPageIOS(this.item);

  void _showDialog(BuildContext context, Widget child) {
    showCupertinoModalPopup(
      context: context,
      builder: (BuildContext context) => Container(
        height: 216,
        padding: const EdgeInsets.only(top: 6.0),
        margin: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        color: CupertinoColors.systemBackground.resolveFrom(context),
        child: SafeArea(
          top: false,
          child: child,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final bloc = Provider.of<EditScreenBLoC>(context);
    // [TODO]
    final pm = Provider.of<PaymentMethodBLoC>(context);

    return CupertinoPageScaffold(
      child: CustomScrollView(
        slivers: [
          CupertinoSliverNavigationBar(
            border: null,
            backgroundColor: Theme.of(context).scaffoldBackgroundColor,
            largeTitle: Center(),
            trailing: CupertinoButton(
              padding: EdgeInsets.zero,
              child: Text(
                "保存",
                style: TextStyle(fontSize: 16),
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
                  children: [
                    NormarizeFormItem(
                      child: CupertinoTextFormFieldRow(
                        prefix: Text(
                          "サービス名",
                          style: TextStyle(
                            color:
                                Theme.of(context).textTheme.titleLarge!.color,
                          ),
                        ),
                        initialValue: item.name,
                        textAlign: TextAlign.end,
                        style: Theme.of(context).textTheme.bodyLarge,
                        onChanged: (value) {
                          bloc.setNameText(value);
                        },
                      ),
                    ),
                    NormarizeFormItem(
                      child: CupertinoTextFormFieldRow(
                        prefix: Text(
                          "金額",
                          style: TextStyle(
                            color:
                                Theme.of(context).textTheme.titleLarge!.color,
                          ),
                        ),
                        keyboardType: TextInputType.number,
                        initialValue: item.price.toString(),
                        textAlign: TextAlign.end,
                        style: Theme.of(context).textTheme.bodyLarge,
                        onChanged: (value) {
                          bloc.setPriceNum(int.parse(value));
                        },
                      ),
                    ),
                    StreamBuilder(
                      stream: pm.methodStream,
                      builder:
                          (BuildContext ctx, AsyncSnapshot<PaymentMethod> ss) {
                        switch (ss.connectionState) {
                          case ConnectionState.waiting:
                            return Center();
                          default:
                            return NormarizeFormItem(
                              onTap: () async {
                                final pms = await pm.getAllPaymentMethods();
                                _showDialog(
                                  context,
                                  CupertinoPicker(
                                    // If default value is set.
                                    scrollController:
                                        FixedExtentScrollController(
                                            initialItem: ss.data!.id),
                                    itemExtent: 36,
                                    onSelectedItemChanged: (int selected) {
                                      pm.setPaymentMethod(pms[selected]);
                                      bloc.setPaymentMethod(pms[selected].name);
                                    },
                                    children: pms.map((m) {
                                      return Container(
                                        height: 36,
                                        child: Center(
                                          child: Text(
                                            m.name,
                                            style: TextStyle(
                                              color: Theme.of(context)
                                                  .textTheme
                                                  .titleLarge!
                                                  .color,
                                            ),
                                          ),
                                        ),
                                      );
                                    }).toList(),
                                  ),
                                );
                              },
                              child: CupertinoFormRow(
                                prefix: Text(
                                  "支払い方法",
                                  style: TextStyle(
                                    color: Theme.of(context)
                                        .textTheme
                                        .titleLarge!
                                        .color,
                                  ),
                                ),
                                // [TODO] From bloc
                                child: Text(
                                  ss.data!.name,
                                  style: TextStyle(
                                    color: Theme.of(context)
                                        .textTheme
                                        .titleLarge!
                                        .color,
                                  ),
                                ),
                              ),
                            );
                        }
                      },
                    ),
                    StreamBuilder(
                        stream: bloc.onChangeInterval,
                        builder: (BuildContext ctx,
                            AsyncSnapshot<PaymentInterval> ss) {
                          switch (ss.connectionState) {
                            case ConnectionState.waiting:
                              return Center();
                            default:
                              return NormarizeFormItem(
                                onTap: () async {
                                  _showDialog(
                                    context,
                                    CupertinoPicker(
                                      // If default value is set.
                                      scrollController:
                                          FixedExtentScrollController(
                                              initialItem: ss.data!.intervalID),
                                      itemExtent: 36,
                                      onSelectedItemChanged: (int selected) {
                                        bloc.setInterval(
                                            getPaymentInterval(selected));
                                      },
                                      children: [
                                        PaymentInterval.Daily,
                                        PaymentInterval.Weekly,
                                        PaymentInterval.Fortnightly,
                                        PaymentInterval.Monthly,
                                        PaymentInterval.Yearly,
                                      ].map((m) {
                                        return Container(
                                          height: 36,
                                          child: Center(
                                            child: Text(
                                              m.intervalText,
                                              style: TextStyle(
                                                color: Theme.of(context)
                                                    .textTheme
                                                    .titleLarge!
                                                    .color,
                                              ),
                                            ),
                                          ),
                                        );
                                      }).toList(),
                                    ),
                                  );
                                },
                                child: CupertinoFormRow(
                                  prefix: Text(
                                    "支払いサイクル",
                                    style: TextStyle(
                                      color: Theme.of(context)
                                          .textTheme
                                          .titleLarge!
                                          .color,
                                    ),
                                  ),
                                  child: Text(
                                    ss.data!.intervalText,
                                    style:
                                        Theme.of(context).textTheme.bodyLarge,
                                  ),
                                ),
                              );
                          }
                        }),
                    StreamBuilder(
                        stream: bloc.onChangeNextTime,
                        builder:
                            (BuildContext ctx, AsyncSnapshot<DateTime> ss) {
                          switch (ss.connectionState) {
                            case ConnectionState.waiting:
                              return Center();
                            default:
                              return NormarizeFormItem(
                                onTap: () {
                                  showCupertinoModalPopup(
                                    context: ctx,
                                    builder: (BuildContext c) => Container(
                                      color:
                                          Theme.of(c).scaffoldBackgroundColor,
                                      height: MediaQuery.of(c).size.height / 3,
                                      child: CupertinoTheme(
                                        data: CupertinoThemeData(
                                            brightness: Theme.of(c).brightness),
                                        child: CupertinoDatePicker(
                                          mode: CupertinoDatePickerMode.date,
                                          initialDateTime: ss.data ?? item.next,
                                          onDateTimeChanged: (DateTime dt) {
                                            bloc.setNextTime(dt);
                                          },
                                        ),
                                      ),
                                    ),
                                  );
                                },
                                child: CupertinoFormRow(
                                  prefix: Text(
                                    "次回お支払日",
                                    style: TextStyle(
                                      color: Theme.of(ctx)
                                          .textTheme
                                          .titleLarge!
                                          .color,
                                    ),
                                  ),
                              child: Text(
                                DateFormat('yyyy-MM-dd').format(ss.data ?? item.next),
                                    style:
                                        Theme.of(context).textTheme.bodyLarge,
                                  ),
                                ),
                              );
                          }
                        }),
                    NormarizeFormItem(
                      child: CupertinoTextFormFieldRow(
                        prefix: Text(
                          "リマインド",
                          style: TextStyle(
                            color:
                                Theme.of(context).textTheme.titleLarge!.color,
                          ),
                        ),
                        textAlign: TextAlign.end,
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                    ),
                    NormarizeFormItem(
                      child: CupertinoTextFormFieldRow(
                        prefix: Text(
                          "お試し期間",
                          style: TextStyle(
                            color:
                                Theme.of(context).textTheme.titleLarge!.color,
                          ),
                        ),
                        textAlign: TextAlign.end,
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                    ),
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

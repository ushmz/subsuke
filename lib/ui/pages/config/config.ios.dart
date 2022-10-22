import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:subsuke/blocs/settings_bloc.dart';
import 'package:subsuke/notifications/notifications.dart';
import 'package:subsuke/ui/components/ui_parts/modal_picker.dart';
import 'package:subsuke/ui/pages/config/payment_method.ios.dart';

class ConfigPageIOS extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final bloc = Provider.of<SettingsBLoC>(context);
    final nf = Provider.of<NotificationRepository>(context);

    return CupertinoPageScaffold(
      child: CustomScrollView(
        slivers: [
          CupertinoSliverNavigationBar(
            border: null,
            brightness: Theme.of(context).brightness,
            backgroundColor: Theme.of(context).scaffoldBackgroundColor,
            largeTitle: Text(
              "設定",
              style: TextStyle(
                color: Theme.of(context).textTheme.titleLarge!.color,
              ),
            ),
          ),
          SliverList(
            delegate: SliverChildListDelegate([
              StreamBuilder(
                stream: bloc.onPreferenceUpdated,
                builder: (BuildContext ctx, AsyncSnapshot<void> ss) {
                  switch (ss.connectionState) {
                    case ConnectionState.waiting:
                      return Center(child: CircularProgressIndicator());
                    case ConnectionState.none:
                      return Center(child: CircularProgressIndicator());
                    default:
                      return Padding(
                        padding: EdgeInsets.symmetric(vertical: 16),
                        child: CupertinoFormSection.insetGrouped(
                          children: [
                            PaymentReminderSwitchRow(
                              value: bloc.isNotificationEnabled(),
                              onChange: (val) {
                                bloc.setNotificationEnabled(val);
                              },
                            ),
                            PaymentReminderSchedulePickerRow(
                              pickedValue: bloc.getNotificationSchedule(),
                              onChange: ((val) {
                                bloc.setNotificationSchedule(
                                  TimeOfDay(hour: val.hour, minute: val.minute),
                                );
                              }),
                            ),
                            ReminderTestButtonRow(
                              send: nf.testNotification,
                            ),
                            DefaultPaymentMethodSelectRow(
                              stream: bloc.onPaymentMethodChanged,
                              onChange: (id) {
                                bloc.setDefaultPaymentMethod(id);
                              },
                            ),
                            DefaultCarouselIndexRow(
                              stream: bloc.onCarouselIndexChanged,
                              onChange: (idx) {
                                bloc.setDefaultCarousel(idx);
                              },
                            ),
                          ],
                        ),
                      );
                  }
                },
              )
            ]),
          )
        ],
      ),
    );
  }
}

// [TODO] Put it into shared component?
class NormarizeFormItem extends StatelessWidget {
  final Function()? onTap;
  final Widget child;

  NormarizeFormItem({
    required this.child,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      type: MaterialType.transparency,
      color: Colors.white,
      child: InkWell(
        onTap: onTap,
        child: Container(
          height: 51,
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [child],
          ),
        ),
      ),
    );
  }
}

class PaymentReminderSwitchRow extends StatelessWidget {
  final bool value;
  final Function(bool) onChange;

  PaymentReminderSwitchRow({
    required this.value,
    required this.onChange,
  });

  @override
  Widget build(BuildContext context) {
    return NormarizeFormItem(
      onTap: null,
      child: CupertinoFormRow(
        prefix: Text(
          "支払日のリマインダー",
          style: TextStyle(
            color: Theme.of(context).textTheme.titleLarge!.color,
          ),
        ),
        child: CupertinoSwitch(
          value: value,
          onChanged: onChange,
        ),
      ),
    );
  }
}

extension DateTimeExtention on DateTime {
  DateTime applied(TimeOfDay time) {
    return DateTime(year, month, day, time.hour, time.minute);
  }
}

class PaymentReminderSchedulePickerRow extends StatelessWidget {
  final TimeOfDay pickedValue;
  final Function(DateTime) onChange;

  PaymentReminderSchedulePickerRow({
    required this.pickedValue,
    required this.onChange,
  });

  String getTimeString(TimeOfDay time) {
    if (time.minute < 10) {
      return "${time.hour}:0${time.minute}";
    } else {
      return "${time.hour}:${time.minute}";
    }
  }

  @override
  Widget build(BuildContext context) {
    return NormarizeFormItem(
      onTap: () {
        ModalPickerIOS.showModal(
          context,
          CupertinoTheme(
            data: CupertinoThemeData(brightness: Theme.of(context).brightness),
            child: CupertinoDatePicker(
              initialDateTime: DateTime(2022).applied(pickedValue),
              mode: CupertinoDatePickerMode.time,
              use24hFormat: true,
              onDateTimeChanged: onChange,
            ),
          ),
        );
      },
      child: CupertinoFormRow(
        prefix: Text(
          "リマインダーの時刻",
          style: TextStyle(
            color: Theme.of(context).textTheme.titleLarge!.color,
          ),
        ),
        child: Text(
          getTimeString(pickedValue),
          style: TextStyle(
            color: Theme.of(context).textTheme.titleLarge!.color,
          ),
        ),
      ),
    );
  }
}

typedef Future<void> SendTestFunc();

class ReminderTestButtonRow extends StatelessWidget {
  final SendTestFunc send;
  ReminderTestButtonRow({
    required this.send,
  });

  @override
  Widget build(BuildContext context) {
    return NormarizeFormItem(
      onTap: () {
        send();
      },
      child: CupertinoFormRow(prefix: Text("通知のテスト"), child: Center()),
    );
  }
}

class DefaultPaymentMethodSelectRow extends StatelessWidget {
  final Stream<int> stream;
  final Function(int) onChange;

  DefaultPaymentMethodSelectRow({
    required this.stream,
    required this.onChange,
  });

  @override
  Widget build(BuildContext context) {
    return NormarizeFormItem(
      onTap: () {
        Navigator.of(context).push(PaymentMethodPageIOS.route());
      },
      child: CupertinoFormRow(
        prefix: Text(
          "デフォルトの支払い方法",
          style: TextStyle(
            color: Theme.of(context).textTheme.titleLarge!.color,
          ),
        ),
        child: StreamBuilder(
          stream: stream,
          builder: (BuildContext ctx, AsyncSnapshot<int> ss) {
            final resolvedColor = Theme.of(ctx).textTheme.titleLarge!.color;
            switch (ss.connectionState) {
              case ConnectionState.waiting:
                return Text("", style: TextStyle(color: resolvedColor));
              default:
            }
            return Text(
              ss.data.toString(),
              style: TextStyle(color: resolvedColor),
            );
          },
        ),
      ),
    );
  }
}

class DefaultCarouselIndexRow extends StatelessWidget {
  final Stream<int> stream;
  final Function(int) onChange;

  DefaultCarouselIndexRow({
    required this.stream,
    required this.onChange,
  });

  String getCarouselText(int idx) {
    return [
      "1日あたり",
      "1週間あたり",
      "1月あたり",
      "1年あたり",
    ][idx];
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: stream,
      builder: (BuildContext ctx, AsyncSnapshot<int> ss) {
        final resolvedColor = Theme.of(ctx).textTheme.titleLarge!.color;
        switch (ss.connectionState) {
          case ConnectionState.waiting:
            return Text("", style: TextStyle(color: resolvedColor));
          default:
            return NormarizeFormItem(
              onTap: () {
                ModalPickerIOS.showModal(
                  context,
                  ExtendedCupertinoPicker(
                    children: [
                      PickerItemText(context, "1日あたり"),
                      PickerItemText(context, "1週間あたり"),
                      PickerItemText(context, "1月あたり"),
                      PickerItemText(context, "1年あたり"),
                    ],
                    initial: ss.data ?? 2,
                    onSelectedItemChanged: (int selected) => onChange(selected),
                  ),
                );
              },
              child: CupertinoFormRow(
                prefix: Text(
                  "合計金額のデフォルト表示",
                  style: TextStyle(
                    color: Theme.of(context).textTheme.titleLarge!.color,
                  ),
                ),
                child: Text(
                  getCarouselText(ss.data ?? 2),
                  style: TextStyle(color: resolvedColor),
                ),
              ),
            );
        }
      },
    );
  }
}

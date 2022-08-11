import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:subsuke/blocs/settings_bloc.dart';
import 'package:subsuke/ui/pages/config/payment_method.ios.dart';

extension DateTimeExtention on DateTime {
  DateTime applied(TimeOfDay time) {
    return DateTime(year, month, day, time.hour, time.minute);
  }
}

class ConfigPageIOS extends StatelessWidget {
  void _showDialog(BuildContext context, Widget child) {
    showCupertinoModalPopup<void>(
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
            ));
  }

  String getTimeString(TimeOfDay time) {
    if (time.minute < 10) {
      return "${time.hour}:0${time.minute}";
    } else {
      return "${time.hour}:${time.minute}";
    }
  }

  @override
  Widget build(BuildContext context) {
    final bloc = Provider.of<SettingsBLoC>(context);
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
                          /* header: Text("通知"), */
                          children: [
                            NormarizeFormItem(
                              onTap: null,
                              child: CupertinoFormRow(
                                prefix: Text(
                                  "支払日のリマインダー",
                                  style: TextStyle(
                                    color: Theme.of(context)
                                        .textTheme
                                        .titleLarge!
                                        .color,
                                  ),
                                ),
                                child: CupertinoSwitch(
                                  value: bloc.isNotificationEnabled(),
                                  onChanged: (bool value) {
                                    bloc.setNotificationEnabled(value);
                                  },
                                ),
                              ),
                            ),
                            NormarizeFormItem(
                              onTap: () {
                                final time = bloc.getNotificationSchedule();
                                _showDialog(
                                  ctx,
                                  CupertinoTheme(
                                    data: CupertinoThemeData(
                                        brightness:
                                            Theme.of(context).brightness),
                                    child: CupertinoDatePicker(
                                      initialDateTime:
                                          DateTime(2022).applied(time),
                                      mode: CupertinoDatePickerMode.time,
                                      use24hFormat: true,
                                      onDateTimeChanged: (DateTime newTime) {
                                        bloc.setNotificationSchedule(
                                          TimeOfDay(
                                              hour: newTime.hour,
                                              minute: newTime.minute),
                                        );
                                      },
                                    ),
                                  ),
                                );
                              },
                              child: CupertinoFormRow(
                                prefix: Text(
                                  "リマインダーの時刻",
                                  style: TextStyle(
                                    color: Theme.of(context)
                                        .textTheme
                                        .titleLarge!
                                        .color,
                                  ),
                                ),
                                child: Text(
                                  getTimeString(bloc.getNotificationSchedule()),
                                  style: TextStyle(
                                    color: Theme.of(context)
                                        .textTheme
                                        .titleLarge!
                                        .color,
                                  ),
                                ),
                              ),
                            ),
                            NormarizeFormItem(
                              onTap: () {
                                Navigator.of(context)
                                    .push(PaymentMethodPageIOS.route());
                              },
                              child: CupertinoFormRow(
                                prefix: Text(
                                  "デフォルトの支払い方法",
                                  style: TextStyle(
                                    color: Theme.of(context)
                                        .textTheme
                                        .titleLarge!
                                        .color,
                                  ),
                                ),
                                child: Text(
                                  "クレジットカード",
                                  style: TextStyle(
                                    color: Theme.of(context)
                                        .textTheme
                                        .titleLarge!
                                        .color,
                                  ),
                                ),
                              ),
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

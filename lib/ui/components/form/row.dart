import 'package:intl/intl.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:subsuke/models/subsc.dart';

class _DialogHelper {
  static void show(BuildContext context, Widget child) {
    showCupertinoModalPopup(
      context: context,
      builder: (BuildContext context) => Container(
        height: 216,
        padding: EdgeInsets.only(top: 6.0),
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
}

class _NormarizeFormItem extends StatelessWidget {
  final Function()? onTap;
  final Widget child;

  _NormarizeFormItem({
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
          /* color: Color(0xFF2C2C2E), */
          height: 48,
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

class ServiceNameInputRow extends StatelessWidget {
  final String initialValue;
  final Function(String) onChange;

  ServiceNameInputRow({required this.onChange, this.initialValue = ""});

  @override
  Widget build(BuildContext context) {
    return _NormarizeFormItem(
      child: CupertinoTextFormFieldRow(
        prefix: Text(
          "サービス名",
          style: TextStyle(
            color: Theme.of(context).textTheme.titleLarge!.color,
          ),
        ),
        textAlign: TextAlign.end,
        style: Theme.of(context).textTheme.bodyLarge,
        initialValue: initialValue,
        onChanged: onChange,
      ),
    );
  }
}

class ServicePriceInputRow extends StatelessWidget {
  final String initialValue;
  final Function(String) onChange;

  ServicePriceInputRow({required this.onChange, this.initialValue = ""});

  @override
  Widget build(BuildContext context) {
    return _NormarizeFormItem(
      child: CupertinoTextFormFieldRow(
        prefix: Text(
          "金額",
          style: TextStyle(
            color: Theme.of(context).textTheme.titleLarge!.color,
          ),
        ),
        keyboardType: TextInputType.number,
        textAlign: TextAlign.end,
        style: Theme.of(context).textTheme.bodyLarge,
        initialValue: initialValue,
        onChanged: onChange,
      ),
    );
  }
}

class PaymentMethodPickerRow extends StatelessWidget {
  final Stream<PaymentMethod> stream;
  final List<PaymentMethod> methods;
  final Function(PaymentMethod) onCanged;

  PaymentMethodPickerRow({
    required this.stream,
    required this.methods,
    required this.onCanged,
  });

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: stream,
      builder: (BuildContext ctx, AsyncSnapshot<PaymentMethod> ss) {
        switch (ss.connectionState) {
          case ConnectionState.waiting:
            return Center();
          default:
            return _NormarizeFormItem(
              onTap: () async {
                _DialogHelper.show(
                  context,
                  CupertinoPicker(
                    // If default value is set.
                    scrollController:
                        FixedExtentScrollController(initialItem: ss.data!.id),
                    itemExtent: 36,
                    onSelectedItemChanged: (int selected) {
                      onCanged(methods[selected]);
                    },
                    children: methods.map((m) {
                      return Container(
                        // [TODO]
                        height: 36,
                        child: Center(
                          child: Text(
                            m.name,
                            style: TextStyle(
                              color:
                                  Theme.of(context).textTheme.titleLarge!.color,
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
                    color: Theme.of(context).textTheme.titleLarge!.color,
                  ),
                ),
                child: Text(
                  ss.data!.name,
                  style: TextStyle(
                    color: Theme.of(context).textTheme.titleLarge!.color,
                  ),
                ),
              ),
            );
        }
      },
    );
  }
}

class PaymentCyclePickerRow extends StatelessWidget {
  final Stream<PaymentInterval> stream;
  final Function(int) onChange;

  PaymentCyclePickerRow({required this.stream, required this.onChange});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: stream,
      builder: (BuildContext ctx, AsyncSnapshot<PaymentInterval> ss) {
        switch (ss.connectionState) {
          case ConnectionState.waiting:
            return Center();
          default:
            return _NormarizeFormItem(
              onTap: () async {
                _DialogHelper.show(
                  context,
                  CupertinoPicker(
                    // If default value is set.
                    scrollController: FixedExtentScrollController(
                        initialItem: ss.data!.intervalID),
                    itemExtent: 36,
                    onSelectedItemChanged: onChange,
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
                              color:
                                  Theme.of(context).textTheme.titleLarge!.color,
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
                    color: Theme.of(context).textTheme.titleLarge!.color,
                  ),
                ),
                child: Text(
                  ss.data!.intervalText,
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
              ),
            );
        }
      },
    );
  }
}

class PaymentNextDatePickerRow extends StatelessWidget {
  final Stream<DateTime> stream;
  final Function(DateTime) onChange;

  PaymentNextDatePickerRow({required this.stream, required this.onChange});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: stream,
      builder: (BuildContext ctx, AsyncSnapshot<DateTime> ss) {
        switch (ss.connectionState) {
          case ConnectionState.waiting:
            return Center();
          default:
            return _NormarizeFormItem(
              onTap: () {
                showCupertinoModalPopup(
                  context: ctx,
                  builder: (BuildContext c) => Container(
                    color: Theme.of(c).backgroundColor,
                    height: MediaQuery.of(c).size.height / 3,
                    child: CupertinoTheme(
                      data: CupertinoThemeData(
                          brightness: Theme.of(c).brightness),
                      child: CupertinoDatePicker(
                        mode: CupertinoDatePickerMode.date,
                        initialDateTime: ss.data ?? DateTime.now(),
                        onDateTimeChanged: onChange,
                      ),
                    ),
                  ),
                );
              },
              child: CupertinoFormRow(
                prefix: Text(
                  "次回お支払日",
                  style: TextStyle(
                    color: Theme.of(ctx).textTheme.titleLarge!.color,
                  ),
                ),
                child: Text(
                  DateFormat('yyyy-MM-dd').format(ss.data!),
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
              ),
            );
        }
      },
    );
  }
}

class PaymentReminderPickerRow extends StatelessWidget {
  final Stream<NotificationBefore> stream;
  final Function(int) onChange;

  PaymentReminderPickerRow({required this.stream, required this.onChange});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: stream,
      builder: (BuildContext ctx, AsyncSnapshot<NotificationBefore> ss) {
        switch (ss.connectionState) {
          case ConnectionState.waiting:
            return Center();
          default:
            return _NormarizeFormItem(
              child: CupertinoFormRow(
                prefix: Text(
                  "リマインド",
                  style: TextStyle(
                    color: Theme.of(ctx).textTheme.titleLarge!.color,
                  ),
                ),
                child: Text(
                  ss.data!.text,
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
              ),
              onTap: () {
                showCupertinoModalPopup(
                  context: ctx,
                  builder: (BuildContext c) {
                    return Container(
                      color: Theme.of(c).backgroundColor,
                      height: MediaQuery.of(c).size.height / 3,
                      child: CupertinoTheme(
                        data: CupertinoThemeData(
                            brightness: Theme.of(c).brightness),
                        child: CupertinoPicker(
                          scrollController:
                              FixedExtentScrollController(initialItem: 0),
                          itemExtent: 36,
                          onSelectedItemChanged: onChange,
                          children: NotificationBefore.values
                              .map((e) => Center(child: Text(e.text)))
                              .toList(),
                        ),
                      ),
                    );
                  },
                );
              },
            );
        }
      },
    );
  }
}

class TrialButtonRow extends StatelessWidget {
  final Function(String) onChange;

  TrialButtonRow({required this.onChange});

  @override
  Widget build(BuildContext context) {
    return _NormarizeFormItem(
      child: CupertinoTextFormFieldRow(
        prefix: Text(
          "お試し期間",
          style: TextStyle(
            color: Theme.of(context).textTheme.titleLarge!.color,
          ),
        ),
        textAlign: TextAlign.end,
        style: Theme.of(context).textTheme.bodyLarge,
      ),
    );
  }
}

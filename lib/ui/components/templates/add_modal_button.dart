import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:provider/provider.dart';
import 'package:subsuke/blocs/edit_screen_bloc.dart';
import 'package:subsuke/blocs/payment_methods_bloc.dart';
import 'package:subsuke/blocs/subscription_item_bloc.dart';
import 'package:subsuke/ui/pages/add/add.dart';

class AddModelButtonIOS extends StatelessWidget {
  IconData getPlatformIconData() {
    if (Platform.isIOS) {
      return CupertinoIcons.plus;
    } else {
      return Icons.add;
    }
  }

  @override
  Widget build(BuildContext context) {
    final item = Provider.of<SubscriptionItemBLoC>(context);
    return CupertinoButton(
      padding: EdgeInsets.zero,
      child: Icon(CupertinoIcons.plus, size: 28, color: Theme.of(context).iconTheme.color),
      onPressed: () {
        showCupertinoModalBottomSheet(
          context: context,
          expand: true,
          useRootNavigator: true,
          builder: (BuildContext context) => MultiProvider(
            providers: [
              Provider<EditScreenBLoC>(
                create: (context) => EditScreenBLoC(),
                dispose: (context, bloc) => bloc.dispose(),
              ),
              Provider<PaymentMethodBLoC>(
                create: (context) => PaymentMethodBLoC(),
                dispose: (context, bloc) => bloc.dispose(),
              ),
            ],
            child: AddPage(() => item.getItems()),
          ),
        );
      },
    );
  }
}

class AddModelButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final item = Provider.of<SubscriptionItemBLoC>(context);
    return IconButton(
      icon: Icon(Icons.add, size: 28),
      splashRadius: 22,
      onPressed: () {
        showCupertinoModalBottomSheet(
          context: context,
          expand: true,
          useRootNavigator: true,
          builder: (BuildContext context) => MultiProvider(
            providers: [
              Provider<EditScreenBLoC>(
                create: (context) => EditScreenBLoC(),
                dispose: (context, bloc) => bloc.dispose(),
              ),
              Provider<PaymentMethodBLoC>(
                create: (context) => PaymentMethodBLoC(),
                dispose: (context, bloc) => bloc.dispose(),
              ),
            ],
            child: AddPage(() => item.getItems()),
          ),
        );
      },
    );
  }
}

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:subsuke/models/subscription_item.dart';
import 'package:subsuke/ui/pages/edit/edit.android.dart';
import 'package:subsuke/ui/pages/edit/edit.ios.dart';

class EditPage extends StatelessWidget {
  final SubscriptionItem item;
  final Function(int, SubscriptionItem) onUpdate;

  EditPage({
    required this.item,
    required this.onUpdate,
  });

  @override
  Widget build(BuildContext context) {
    if (Platform.isIOS) {
      return EditPageIOS(item: item, onUpdate: onUpdate);
    } else {
      return EditPageAndroid();
    }
  }
}

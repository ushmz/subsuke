import 'package:flutter/material.dart';
import 'package:subsuke/models/subsc.dart';
import 'package:subsuke/ui/components/templates/edit_form_group.dart';

class EditPage extends StatelessWidget {
  final SubscriptionItem item;
  final Function() refreshListItems;
  EditPage(this.item, this.refreshListItems);

  @override
  Widget build(BuildContext context) {
    // [TODO] Does it really need to be common?
    return SubscriptionFormGroup(refreshListItems, item: item);
  }
}

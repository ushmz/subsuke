import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:subsuke/blocs/edit_screen_bloc.dart';
import 'package:subsuke/blocs/subscriptions_bloc.dart';
import 'package:subsuke/models/subsucription.dart';

import 'package:subsuke/ui/components/templates/edit_form_group.dart';

typedef TextFieldBuilder<T> = Widget Function(
    BuildContext ctx, AsyncSnapshot<T> ss);

class EditPage extends StatelessWidget {
  final SubscriptionsBloc subscriptions;
  final Subscription target;
  EditPage(this.subscriptions, this.target);

  /*  追加のボタンを押したときの動作 */
  void addButtonPressed(BuildContext ctx, EditScreenBloc bloc) async {
    var name = bloc.getName;
    var next = bloc.getNextTime;
    var price = bloc.getPrice;
    var cycle = bloc.getCycle;
    await subscriptions.addSubscription(name, next, price, cycle);
    Navigator.pop(ctx);
  }

  @override
  Widget build(BuildContext context) {
    final bloc = Provider.of<EditScreenBloc>(context);
    bloc.setNameText(target.name);
    bloc.setPriceNum(target.price);
    bloc.setCycle(target.cycle);
    bloc.setNextTime(target.billingAt);
    bloc.setNote("");
    return SubscriptionEditFormGroup(() => addButtonPressed(context, bloc));
  }
}

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import 'package:subsuke/blocs/edit_screen_bloc.dart';
import 'package:subsuke/models/subsc.dart';
import 'package:subsuke/ui/components/ui_parts/icon_header.dart';

import '../../../blocs/subscription_item_bloc.dart';

typedef TextFieldBuilder<T> = Widget Function(
  BuildContext ctx,
  AsyncSnapshot<T> ss,
);

class SubscriptionEditFormGroup extends StatelessWidget {
  final Function(SubscriptionItem) actionClicked;
  final SubscriptionItem? item;

  SubscriptionEditFormGroup({required this.actionClicked, this.item});

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
          final date = await showDatePicker(
            context: ctx,
            initialDate: initial,
            firstDate: DateTime(1900),
            lastDate: DateTime(2100),
          );
          if (date != null) {
            onChanged(date);
          }
        },
      );
    };
  }

  @override
  Widget build(BuildContext context) {
    final bloc = Provider.of<EditScreenBloc>(context);
    final itemBloc = Provider.of<SubscriptionItemBloc>(context);

    final _nameEditingController = TextEditingController();
    final _priceEditingController = TextEditingController();
    final _nextEditingController = TextEditingController();
    final _cycleEditingController = TextEditingController();
    final _noteEditController = TextEditingController();

    return Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).backgroundColor,
          actions: [
            TextButton(
              child: Text(
                "保存する",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).hintColor,
                ),
              ),
              onPressed: () => {
                this.actionClicked(
                  SubscriptionItem(
                    0,
                    bloc.getName,
                    bloc.getPrice,
                    bloc.getNextTime,
                    PaymentInterval.Monthly,
                  ),
                )
              },
            ),
          ],
        ),
        body: Column(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
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
                            _nameEditingController,
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
                          _priceEditingController,
                          (text) => bloc.setPriceNum(int.tryParse(text) ?? 0),
                          "価格",
                        ),
                      ),
                    ]),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 10),
                    child: Column(children: [
                      IconHeader(Icons.event_repeat, "支払日"),
                      StreamBuilder(
                        stream: bloc.onChangeNextTime,
                        builder: datetimeInputBuilder(
                          _nextEditingController,
                          (picked) => bloc.setNextTime(picked),
                          "支払日",
                        ),
                      ),
                    ]),
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
                          _noteEditController,
                          (text) => bloc.setNote(text),
                          "何か書く",
                        ),
                      ),
                    ]),
                  )
                ],
              ),
            ),
          ],
        ));
  }
}
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:subsuke/blocs/edit_screen_bloc.dart';
import 'package:subsuke/models/subsucription.dart';

class EditScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final bloc = Provider.of<EditScreenBloc>(context);
    final Subscription item = ModalRoute.of(context).settings.arguments;
    bloc.setNameText(item.name);
    bloc.setPriceNum(item.price);
    bloc.setNextTime(item.billingAt);
    bloc.setCycle(item.cycle);

    return Scaffold(
        appBar: AppBar(
          actions: <Widget>[
            Center(
              child: TextButton(
                child: Text("保存", style: TextStyle(color: Colors.white)),
                onPressed: () {},
              ),
            )
          ],
        ),
        body: Column(
          children: [
            StreamBuilder(
                stream: bloc.onChangeNameText,
                builder: (BuildContext context, AsyncSnapshot snapshot) {
                  return Padding(
                    padding: EdgeInsets.all(10),
                    child: TextField(
                      controller: TextEditingController(text: item.name),
                      decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: "サブスクリプション名",
                          hintText: "サブスクリプション名"),
                      onChanged: (text) => bloc.setNameText(text),
                    ),
                  );
                }),
            StreamBuilder(
                stream: bloc.onChangePriceNum,
                builder: (BuildContext context, AsyncSnapshot snapshot) {
                  return Padding(
                      padding: EdgeInsets.only(top: 10, bottom: 10),
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Expanded(
                                flex: 2,
                                child: Padding(
                                    padding:
                                        EdgeInsets.only(left: 10, right: 5),
                                    child: TextField(
                                      controller: TextEditingController(
                                          text: item.price.toString()),
                                      decoration: InputDecoration(
                                          border: OutlineInputBorder(),
                                          labelText: "価格",
                                          hintText: "価格"),
                                      onChanged: (number) =>
                                          bloc.setPriceNum(int.parse(number)),
                                    ))),
                            Expanded(
                                flex: 1,
                                child: Padding(
                                    padding:
                                        EdgeInsets.only(left: 5, right: 10),
                                    child: TextField(
                                      controller: TextEditingController(
                                          text: item.cycle),
                                      decoration: InputDecoration(
                                          border: OutlineInputBorder(),
                                          labelText: "支払い周期",
                                          hintText: "支払い周期"),
                                      onChanged: (text) => bloc.setCycle(text),
                                    )))
                          ]));
                }),
            StreamBuilder(
                stream: bloc.onChangeNextTime,
                builder: (BuildContext context, AsyncSnapshot snapshot) {
                  return Padding(
                    padding: EdgeInsets.all(10),
                    child: TextField(
                      controller: TextEditingController(text: item.billingAt),
                      decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: "支払日",
                          hintText: "支払日"),
                      onChanged: (text) => bloc.setNextTime(text),
                    ),
                  );
                })
          ],
        ));
  }
}

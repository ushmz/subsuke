import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:subsuke/blocs/edit_screen_bloc.dart';
import 'package:subsuke/blocs/subscriptions_bloc.dart';

class AddPage extends StatelessWidget {
  final SubscriptionsBloc subscriptions;
  AddPage(this.subscriptions);

  @override
  Widget build(BuildContext context) {
    final bloc = Provider.of<EditScreenBloc>(context);
    final _nameEditingController = TextEditingController();
    final _priceEditingController = TextEditingController();
    final _nextEditingController = TextEditingController();
    final _cycleEditingController = TextEditingController();
    return Scaffold(
        // appBar: AppBar(
        //   actions: <Widget>[
        //     Center(
        //       child: TextButton(
        //         child: Text("保存", style: TextStyle(color: Colors.white)),
        //         onPressed: () {},
        //       ),
        //     )
        //   ],
        // ),
        body: Padding(
      padding: EdgeInsets.only(top: 20),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                  flex: 1,
                  child: InkWell(
                      child: Icon(Icons.close),
                      onTap: () {
                        Navigator.pop(context);
                      })),
              Expanded(flex: 3, child: Center(child: Text("編集"))),
              Expanded(
                  flex: 1,
                  child: Padding(
                      padding: EdgeInsets.all(10),
                      child: ElevatedButton(
                          child: Text("保存"),
                          onPressed: () async {
                            var name = bloc.getName;
                            var next = bloc.getNextTime;
                            var price = int.tryParse(bloc.getPrice) ?? 0;
                            var cycle = bloc.getCycle;
                            assert(name != null);
                            assert(next != null);
                            assert(price != null && price != 0);
                            assert(cycle != null);
                            /* await subscriptions.addSubscription( name, next, price, cycle); */
                            Navigator.pop(context);
                          })))
            ],
          ),
          Divider(
            color: Colors.white24,
          ),
          StreamBuilder(
              stream: bloc.onChangeNameText,
              builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
                var value;
                switch (snapshot.connectionState) {
                  case ConnectionState.waiting:
                    value = '';
                    break;
                  default:
                    value = snapshot.data;
                    break;
                }
                _nameEditingController.text = value;
                _nameEditingController.selection = TextSelection(
                    baseOffset: value.length, extentOffset: value.length);
                return Padding(
                  padding: EdgeInsets.all(10),
                  child: TextField(
                    controller: _nameEditingController,
                    decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: "サブスクリプション名",
                        hintText: "サブスクリプション名"),
                    onChanged: (text) => bloc.setNameText(text),
                  ),
                );
              }),
          Padding(
              padding: EdgeInsets.all(10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Expanded(
                    flex: 2,
                    child: StreamBuilder(
                        stream: bloc.onChangePriceNum,
                        builder: (BuildContext context,
                            AsyncSnapshot<String> snapshot) {
                          var value;
                          switch (snapshot.connectionState) {
                            case ConnectionState.waiting:
                              value = '';
                              break;
                            default:
                              value = snapshot.data;
                              break;
                          }
                          _priceEditingController.text = value;
                          _priceEditingController.selection = TextSelection(
                              baseOffset: value.length,
                              extentOffset: value.length);
                          return TextField(
                            controller: _priceEditingController,
                            decoration: InputDecoration(
                                border: OutlineInputBorder(),
                                labelText: "価格",
                                hintText: "価格"),
                            onChanged: (number) => bloc.setPriceNum(number),
                          );
                        }),
                  ),
                  Expanded(
                    flex: 1,
                    child: StreamBuilder(
                        stream: bloc.onChangeCycle,
                        builder: (BuildContext context,
                            AsyncSnapshot<String> snapshot) {
                          var value;
                          switch (snapshot.connectionState) {
                            case ConnectionState.waiting:
                              value = '';
                              break;
                            default:
                              value = snapshot.data;
                              break;
                          }
                          _cycleEditingController.text = value;
                          _cycleEditingController.selection = TextSelection(
                              baseOffset: value.length,
                              extentOffset: value.length);
                          return TextField(
                            controller: _cycleEditingController,
                            decoration: InputDecoration(
                                border: OutlineInputBorder(),
                                labelText: "支払い周期",
                                hintText: "支払い周期"),
                            onChanged: (text) => bloc.setCycle(text),
                          );
                        }),
                  )
                ],
              )),
          StreamBuilder(
              stream: bloc.onChangeNextTime,
              builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
                var value;
                switch (snapshot.connectionState) {
                  case ConnectionState.waiting:
                    value = '';
                    break;
                  default:
                    value = snapshot.data;
                    break;
                }

                _nextEditingController.text = value;
                _nextEditingController.selection = TextSelection(
                    baseOffset: value.length, extentOffset: value.length);
                return Padding(
                  padding: EdgeInsets.all(10),
                  child: TextField(
                    controller: _nextEditingController,
                    decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: "支払日",
                        hintText: "支払日"),
                    onChanged: (text) => bloc.setNextTime(text),
                  ),
                );
              })
        ],
      ),
    ));
  }
}

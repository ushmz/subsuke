import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:subsuke/blocs/edit_screen_bloc.dart';

class AddPageAndroid extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final bloc = Provider.of<EditScreenBLoC>(context);

    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            backgroundColor: Theme.of(context).backgroundColor,
            title: Center(),
            leading: BackButton(color: Theme.of(context).primaryColor),
            actions: [
              MaterialButton(
                padding: EdgeInsets.zero,
                child: Text(
                  "保存",
                  style: TextStyle(
                      fontSize: 16, color: Theme.of(context).primaryColor),
                ),
                onPressed: () {
                  print(bloc.getValues());
                },
              )
            ],
          ),
          SliverList(
            delegate: SliverChildListDelegate([
              Form(
                child: Column(
                  children: [
                    NormarizedFormItem(
                      child: TextFormField(
                        // validator: (value) {},
                        decoration: InputDecoration(icon: Text("サービス名")),
                      ),
                    ),
                    NormarizedFormItem(
                      child: TextFormField(
                        // validator: (value) {},
                        decoration: InputDecoration(icon: Text("金額")),
                      ),
                    ),
                    NormarizedFormItem(
                      child: TextFormField(
                        // validator: (value) {},
                        decoration: InputDecoration(icon: Text("支払い方法")),
                      ),
                    ),
                    NormarizedFormItem(
                      child: TextFormField(
                        // validator: (value) {},
                        decoration: InputDecoration(icon: Text("支払いサイクル")),
                      ),
                    ),
                    NormarizedFormItem(
                      child: TextFormField(
                        // validator: (value) {},
                        decoration: InputDecoration(icon: Text("次回お支払日")),
                      ),
                    ),
                    NormarizedFormItem(
                      child: TextFormField(
                        // validator: (value) {},
                        decoration: InputDecoration(icon: Text("リマインド")),
                      ),
                    ),
                  ],
                ),
              )
            ]),
          )
        ],
      ),
    );
  }
}

class NormarizedFormItem extends StatelessWidget {
  final Function()? onTap;
  final Widget child;
  final double height;

  NormarizedFormItem({required this.child, this.onTap, this.height = 48});

  @override
  Widget build(BuildContext context) {
    return Material(
      type: MaterialType.transparency,
      color: Colors.white,
      child: InkWell(
        onTap: onTap,
        child: Container(
          /* color: Color(0xFF2C2C2E), */
          height: height,
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

class NormarizedSelectItem extends StatelessWidget {
  final String name;
  final double height;
  NormarizedSelectItem({required this.name, this.height = 36});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      child: Center(
        child: Text(
          name,
          style: TextStyle(
            color: Theme.of(context).textTheme.titleLarge!.color,
          ),
        ),
      ),
    );
  }
}

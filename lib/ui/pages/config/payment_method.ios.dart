import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:subsuke/blocs/payment_methods_bloc.dart';
import 'package:subsuke/models/subsc.dart';

class PaymentMethodPageIOS extends StatelessWidget {
  static Route<dynamic> route() {
    return CupertinoPageRoute(
      builder: (BuildContext context) {
        return Provider<PaymentMethodBLoC>(
          create: (context) => PaymentMethodBLoC(),
          dispose: (context, bloc) => bloc.dispose(),
          child: PaymentMethodPageIOS(),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final bloc = Provider.of<PaymentMethodBLoC>(context);

    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        middle: Text(
          "支払い方法",
          style: TextStyle(
            color: Theme.of(context).textTheme.titleLarge!.color,
          ),
        ),
        trailing: Icon(CupertinoIcons.plus),
      ),
      child: StreamBuilder(
        stream: bloc.methodsStream,
        builder: (BuildContext context, AsyncSnapshot<List<PaymentMethod>> ss) {
          switch (ss.connectionState) {
            case ConnectionState.waiting:
              return CircularProgressIndicator();
            default:
              return Padding(
                padding: EdgeInsets.symmetric(vertical: 32),
                child: CupertinoFormSection.insetGrouped(
                  children: ss.data!
                      .map((m) => CupertinoFormRow(
                            prefix: Text(
                              m.name,
                              style: TextStyle(
                                color: Theme.of(context)
                                    .textTheme
                                    .titleLarge!
                                    .color,
                              ),
                            ),
                            child: Icon(CupertinoIcons.check_mark),
                          ))
                      .toList(),
                ),
              );
          }
        },
      ),
    );
  }
}

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
          height: 52,
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

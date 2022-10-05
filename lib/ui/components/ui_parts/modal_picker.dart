import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

const ITEM_EXTENT = 36.0;
const MODAL_HEIGHT = 216.0;

class PickerItemText extends Text {
  PickerItemText(BuildContext context, String text)
      : super(
          text,
          style: TextStyle(
            color: Theme.of(context).textTheme.titleLarge!.color,
          ),
        );
}

class ExtendedCupertinoPicker extends CupertinoPicker {
  ExtendedCupertinoPicker({
    required List<Widget> children,
    required Function(int) onSelectedItemChanged,
    double itemExtent = 36.0,
    int initial = 0,
  }) : super(
          scrollController: FixedExtentScrollController(initialItem: initial),
          itemExtent: itemExtent,
          onSelectedItemChanged: onSelectedItemChanged,
          children: children
              .map((c) => Container(
                    height: itemExtent,
                    child: Center(child: c),
                  ))
              .toList(),
        );
}

class ModalPickerIOS extends StatelessWidget {
  final Widget child;

  ModalPickerIOS({
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return CupertinoTheme(
      data: CupertinoThemeData(brightness: Theme.of(context).brightness),
      child: child,
    );
  }

  void show(BuildContext context) {
    showCupertinoModalPopup<void>(
      context: context,
      builder: (BuildContext ctx) {
        return Container(
          height: MODAL_HEIGHT,
          padding: EdgeInsets.only(top: 6.0),
          margin: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          color: CupertinoColors.systemBackground.resolveFrom(ctx),
          child: SafeArea(
            top: false,
            child: build(ctx),
          ),
        );
      },
    );
  }

  static void showModal(BuildContext context, Widget child) {
    showCupertinoModalPopup<void>(
      context: context,
      builder: (BuildContext ctx) {
        return Container(
          height: MODAL_HEIGHT,
          padding: EdgeInsets.only(top: 6.0),
          margin: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          color: CupertinoColors.systemBackground.resolveFrom(ctx),
          child: SafeArea(
            top: false,
            child: child,
          ),
        );
      },
    );
  }
}

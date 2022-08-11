import 'dart:io';

import 'package:flutter/material.dart';
import 'package:subsuke/ui/pages/edit/edit.ios.dart';

class EditPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    if (Platform.isIOS) {
      return EditPageIOS();
    } else {
      return Center();
    }
  }
}

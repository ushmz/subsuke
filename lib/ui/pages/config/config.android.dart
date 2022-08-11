import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:settings_ui/settings_ui.dart';
import 'package:subsuke/blocs/settings_bloc.dart';
import 'package:subsuke/ui/pages/config/about_author.dart';
import 'package:subsuke/ui/pages/config/about_app.dart';

extension DateTimeExtention on DateTime {
  DateTime applied(TimeOfDay time) {
    return DateTime(year, month, day, time.hour, time.minute);
  }
}

class ConfigPageAndroid extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final bloc = Provider.of<SettingsBLoC>(context);
    return StreamBuilder(
      stream: bloc.onPreferenceUpdated,
      builder: (BuildContext ctx, AsyncSnapshot<void> ss) {
        switch (ss.connectionState) {
          case ConnectionState.waiting:
            return Center(child: CircularProgressIndicator());
          case ConnectionState.none:
            return Center(child: CircularProgressIndicator());
          default:
            return SettingsList(
              sections: [
                SettingsSection(
                  title: Text('通知'),
                  tiles: [
                    SettingsTile.switchTile(
                      initialValue: bloc.isNotificationEnabled(),
                      activeSwitchColor: Theme.of(context).primaryColor,
                      title: Text('支払日のリマインダー'),
                      onToggle: (bool value) {
                        bloc.setNotificationEnabled(value);
                      },
                    ),
                    SettingsTile.navigation(
                      title: Text('リマインダーの時刻'),
                      value: Text(
                          '${bloc.getNotificationSchedule().format(context)}'),
                      onPressed: (BuildContext c) async {
                        if (Platform.isIOS) {
                          showCupertinoModalPopup(
                            context: c,
                            builder: (BuildContext c) => Container(
                              color: Theme.of(c).scaffoldBackgroundColor,
                              height: MediaQuery.of(c).size.height / 3,
                              child: CupertinoTheme(
                                  data: CupertinoThemeData(
                                      brightness: Theme.of(c).brightness),
                                  child: CupertinoDatePicker(
                                    mode: CupertinoDatePickerMode.time,
                                    initialDateTime: DateTime.now().applied(
                                        bloc.getNotificationSchedule()),
                                    onDateTimeChanged: (time) {
                                      bloc.setNotificationSchedule(TimeOfDay(
                                          hour: time.hour,
                                          minute: time.minute));
                                    },
                                  )),
                            ),
                          );
                        } else {
                          final time = await showTimePicker(
                            context: c,
                            initialTime: TimeOfDay.now(),
                          );
                          if (time != null) {
                            bloc.setNotificationSchedule(time);
                          }
                        }
                      },
                    )
                  ],
                ),
                SettingsSection(
                  tiles: [
                    SettingsTile.navigation(
                      title: Text("友達と共有する"),
                      onPressed: (BuildContext c) {
                        Share.share("サブスクリプションサービスを管理するアプリ");
                      },
                    ),
                    SettingsTile.navigation(
                      title: Text("作者について"),
                      onPressed: (BuildContext c) {
                        Navigator.push(
                          c,
                          MaterialPageRoute(
                            builder: ((context) => AboutAuthorPaeg()),
                          ),
                        );
                      },
                    ),
                    SettingsTile.navigation(
                      title: Text("このアプリについて"),
                      onPressed: (BuildContext c) {
                        Navigator.push(
                          c,
                          MaterialPageRoute(
                            builder: ((context) => AboutAppPaeg()),
                          ),
                        );
                      },
                    ),
                    SettingsTile.navigation(title: Text("Buy me a coffie")),
                  ],
                )
              ],
            );
        }
      },
    );
  }
}

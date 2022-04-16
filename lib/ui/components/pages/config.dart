import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:settings_ui/settings_ui.dart';
import 'package:subsuke/blocs/settings_bloc.dart';

import 'package:subsuke/models/settings.dart';

class ConfigPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final bloc = Provider.of<SettingsBloc>(context);
    return StreamBuilder(
      stream: bloc.onSettingsChanged,
      builder: (BuildContext ctx, AsyncSnapshot<SettingStates> ss) {
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
                      initialValue: ss.data!.isNotificationEnabled,
                      activeSwitchColor: Theme.of(context).primaryColor,
                      title: Text('支払日のリマインダー'),
                      onToggle: (bool value) {
                        bloc.setNotificationEnabled(ss.data!, value);
                      },
                    ),
                    SettingsTile.navigation(
                      title: Text('リマインダーの時刻'),
                      value: Text(
                          '${bloc.getNotificationSchedule().format(context)}'),
                    )
                  ],
                )
              ],
            );
        }
      },
    );
  }
}

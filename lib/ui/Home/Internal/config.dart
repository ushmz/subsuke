import 'package:flutter/material.dart';
import 'package:settings_ui/settings_ui.dart';

class ConfigPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var isToggled = false;
    return SettingsList(
      // backgroundColor: Theme.of(context).backgroundColor,
      sections: [
        SettingsSection(
          title: Text('Section1'),
          tiles: [
            SettingsTile(
              title: Text('Tile1'),
              description: Text('Subtitle1'),
              leading: Icon(Icons.settings),
              onPressed: (BuildContext context) {},
            ),
            SettingsTile.switchTile(
                initialValue: true,
                activeSwitchColor: Theme.of(context).primaryColor,
                title: Text('Switch'),
                onToggle: (bool value) => isToggled = value,
                enabled: isToggled)
          ],
        ),
        SettingsSection(
          title: Text('Notification'),
          tiles: [
            SettingsTile.switchTile(
                initialValue: true,
                activeSwitchColor: Theme.of(context).primaryColor,
                title: Text('Payment reminder'),
                onToggle: (bool value) => isToggled = value,
                enabled: isToggled)
          ],
        )
      ],
    );
  }
}

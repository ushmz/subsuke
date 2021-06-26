import 'package:flutter/material.dart';
import 'package:settings_ui/settings_ui.dart';

class ConfigPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var isToggled = false;
    return SettingsList(
      sections: [
        SettingsSection(
          title: 'Section1',
          tiles: [
            SettingsTile(
              title: 'Tile1',
              subtitle: 'Subtitle1',
              leading: Icon(Icons.settings),
              onPressed: (BuildContext context) {},
            ),
            SettingsTile.switchTile(
                switchActiveColor: Theme.of(context).primaryColor,
                title: 'Switch',
                subtitle: 'Switch1',
                onToggle: (bool value) => isToggled = value,
                switchValue: isToggled)
          ],
        ),
        SettingsSection(
          title: 'Notification',
          tiles: [
            SettingsTile.switchTile(
                switchActiveColor: Theme.of(context).primaryColor,
                title: 'Payment reminder',
                onToggle: (bool value) => isToggled = value,
                switchValue: isToggled)
          ],
        )
      ],
    );
  }
}

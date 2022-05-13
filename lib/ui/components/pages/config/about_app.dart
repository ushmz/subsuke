import 'package:flutter/material.dart';
import 'package:settings_ui/settings_ui.dart';
import 'package:url_launcher/url_launcher.dart';

class AboutAppPaeg extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final resolvedTheme = Theme.of(context);
    return Scaffold(
        appBar: AppBar(
          title: Text(
            'Subsuke',
            style: TextStyle(
              color: resolvedTheme.appBarTheme.foregroundColor,
            ),
          ),
          backgroundColor: resolvedTheme.appBarTheme.backgroundColor,
        ),
        body: SettingsList(
          sections: [
            SettingsSection(tiles: [
              SettingsTile.navigation(
                title: Text("Term of use"),
                onPressed: (BuildContext c) {
                  launchUrl(Uri.parse("https://subsuke.app/tou"));
                },
              ),
              SettingsTile.navigation(
                title: Text("Privacy policy"),
                onPressed: (BuildContext c) {
                  launchUrl(Uri.parse("https://subsuke.app/pp"));
                },
              ),
              SettingsTile.navigation(
                title: Text("Attributions & Licenses"),
                onPressed: (BuildContext c) {
                  showAboutDialog(
                    context: c,
                    applicationVersion: "1.0.0",
                    applicationIcon: Image(
                      image: AssetImage("assets/icons/subsuke.png"),
                      width: MediaQuery.of(c).size.width * 0.15,
                    ),
                  );
                },
              )
            ]),
          ],
        ));
  }
}

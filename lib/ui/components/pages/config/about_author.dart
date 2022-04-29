import 'package:flutter/material.dart';
import 'package:settings_ui/settings_ui.dart';
import 'package:url_launcher/url_launcher.dart';

class AboutAuthorPaeg extends StatelessWidget {
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
                title: Text("Github"),
                value: Text("@ushmz"),
                onPressed: (BuildContext c) {
                  launchUrl(Uri.parse("https://github.com/ushmz"));
                },
              ),
              SettingsTile.navigation(
                title: Text("Twitter"),
                value: Text("@__ushmz"),
                onPressed: (BuildContext c) {
                  launchUrl(Uri.parse("https://twitter.com/__ushmz"));
                },
              ),
            ]),
          ],
        ));
  }
}

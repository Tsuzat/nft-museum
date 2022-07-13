import 'package:flutter_web_browser/flutter_web_browser.dart';
import 'package:flutter/material.dart';

openBrowserTab({required String url}) async {
  await FlutterWebBrowser.openWebPage(
    url: url,
    customTabsOptions: const CustomTabsOptions(
      colorScheme: CustomTabsColorScheme.dark,
      defaultColorSchemeParams: CustomTabsColorSchemeParams(
        toolbarColor: Color.fromRGBO(32, 34, 37, 1),
      ),
      shareState: CustomTabsShareState.on,
      instantAppsEnabled: true,
      showTitle: true,
      urlBarHidingEnabled: true,
    ),
  );
}
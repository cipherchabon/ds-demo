import 'package:flutter/material.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:widgetbook_workspace/main.directories.g.dart';

void main() {
  runApp(const MyApp());
}

@App()
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Widgetbook.material(
      directories: directories,
      addons: [
        ViewportAddon([...AndroidViewports.all, ...IosViewports.all]),
        MaterialThemeAddon(
          themes: [
            WidgetbookTheme(name: 'Light', data: ThemeData.light()),
            WidgetbookTheme(name: 'Dark', data: ThemeData.dark()),
          ],
        ),
        LocalizationAddon(
          locales: [Locale('es', 'VE')],
          localizationsDelegates: [
            GlobalWidgetsLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
        ),
        AlignmentAddon(),
        GridAddon(),
        TextScaleAddon(),
        // InspectorAddon(enabled: true),
        // ZoomAddon(),
      ],
    );
  }
}

import 'dart:developer';

import 'package:audio_service/audio_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:just_audio/just_audio.dart';
import 'package:koin/koin.dart';
import 'package:union_player_app/di/di.dart';
import 'package:union_player_app/repository/schedule_repository_impl.dart';
import 'package:union_player_app/screen_init/init_page.dart';
import 'player/player_task.dart';
import 'screen_init/init_page.dart';
import 'utils/constants/constants.dart';
import 'utils/localizations/app_localizations_delegate.dart';
import 'utils/ui/app_theme.dart';

late final Koin koin;

void main() {
  koin = startKoin((app) {
    app.printLogger(level: Level.debug);
    app.module(appModule);
  }).koin;

  WidgetsFlutterBinding.ensureInitialized();

  runApp(MaterialApp(
      debugShowCheckedModeBanner: false,
      localizationsDelegates: [
        const AppLocalizationsDelegate(),
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: [
        const Locale('en', 'US'),
        const Locale('ru', 'RU'),
        const Locale('be', 'BY'),
      ],
      localeResolutionCallback: (Locale? locale, Iterable<Locale> supportedLocales) {
        for (Locale supportedLocale in supportedLocales) {
          if (supportedLocale.languageCode == locale?.languageCode ||
              supportedLocale.countryCode == locale?.countryCode) {
            return supportedLocale;
          }
        }
        return supportedLocales.first;
      },
      title: 'Union Radio 1 Player',
      theme: createAppTheme(),
      home: AudioServiceWidget(child: _createWidgetByStream())));
}

Widget _createWidgetByStream() => StreamBuilder<bool>(
    stream: AudioService.runningStream, builder: (context, snapshot) => _createWidget(context, snapshot));

Widget _createWidget(BuildContext context, AsyncSnapshot<bool> snapshot) {
  log("_createWidget() -> snapshot.connectionState = ${snapshot.connectionState}", name: LOG_TAG);
  if (snapshot.connectionState == ConnectionState.active) {

    if (AudioService.running) {

      log("AudioService is running -> start InitPage", name: LOG_TAG);
      return InitPage();

    } else {

      log("AudioService is not running -> start AudioService -> start SizedBox", name: LOG_TAG);

      AudioService.start(
        backgroundTaskEntrypoint: _audioPlayerTaskEntrypoint,
        androidArtDownscaleSize: const Size(200.0, 200.0),
        androidNotificationChannelName: AUDIO_NOTIFICATION_CHANNEL_NAME,
        androidNotificationColor: Colors.lightGreenAccent.value,
        androidNotificationIcon: AUDIO_NOTIFICATION_ICON,
        androidShowNotificationBadge: true,
      );

      return SizedBox();

    }

  } else {

    log("start SizedBox", name: LOG_TAG);
    return SizedBox();

  }
}

void _audioPlayerTaskEntrypoint() async {
  AudioServiceBackground.run(() => koin.get<PlayerTask>());
}

import 'package:just_audio/just_audio.dart';
import 'package:koin/koin.dart';
import 'package:union_player_app/model/system_data/system_data.dart';
import 'package:union_player_app/repository/schedule_repository_impl.dart';
import 'package:union_player_app/screen_app/app_bloc.dart';
import 'package:union_player_app/screen_app/app_page.dart';
import 'package:union_player_app/screen_feedback/feedback_bloc.dart';
import 'package:union_player_app/screen_feedback/feedback_page.dart';
import 'package:union_player_app/screen_main/main_bloc.dart';
import 'package:union_player_app/screen_main/main_page.dart';
import 'package:union_player_app/screen_schedule/schedule_bloc.dart';
import 'package:union_player_app/screen_schedule/schedule_page.dart';
import 'package:union_player_app/screen_settings/settings_page.dart';
import 'package:union_player_app/utils/app_logger.dart';
import 'package:union_player_app/utils/ui/pages/info_page.dart';
import 'package:union_player_app/utils/ui/pages/loading_page.dart';

final appModule = Module()
  ..factoryWithParam((scope, List<String> strings) => InfoPage(strings: strings))
  ..factoryWithParam((scope, String title) => LoadingPage(title: title))
  ..single((scope) => AppBloc(scope.get(), scope.get(), scope.get()))
  ..single((scope) => AppLogger())
  ..single((scope) => AppPage())
  ..single((scope) => AudioPlayer())
  ..single((scope) => FeedbackBloc(scope.get(), scope.get()))
  ..single((scope) => FeedbackPage(scope.get()))
  ..single((scope) => MainBloc(scope.get()))
  ..single((scope) => MainPage())
  ..single((scope) => ScheduleBloc(scope.get<ScheduleRepositoryImpl>(), scope.get()))
  ..single((scope) => SchedulePage())
  ..single((scope) => ScheduleRepositoryImpl(scope.get(), scope.get()))
  ..single((scope) => SettingsPage())
  ..single((scope) => SystemData());

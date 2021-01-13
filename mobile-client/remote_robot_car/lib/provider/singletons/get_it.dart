import 'package:remoterobotcar/bloc/app_bloc/app_bloc.dart';
import 'package:remoterobotcar/bloc/mqtt_bloc/mqtt_bloc.dart';
import 'package:remoterobotcar/bloc/update_data_bloc/bloc.dart';
import 'package:remoterobotcar/bloc/vosk_bloc/vosk_bloc.dart';
import 'package:remoterobotcar/configs/shared_preferences/local_provider.dart';
import 'package:remoterobotcar/provider/mqtt/mqtt_service.dart';
import 'package:get_it/get_it.dart';
import 'package:remoterobotcar/provider/voice_controller/voice_controller_provider.dart';

GetIt locator = GetIt.instance;

void setupLocator() {
  locator.registerLazySingleton<MQTTService>(() => MQTTService());

  locator.registerLazySingleton(() => AppBloc());
  locator.registerLazySingleton(() => MQTTBloc());
  locator.registerLazySingleton(() => UpdateDataBloc());
  locator.registerLazySingleton(() => VoskBloc(locator()));

  locator.registerLazySingleton<VoiceControllerProvider>(
      () => VoiceControllerProvider());

  locator.registerLazySingleton<LocalProvider>(() => SharedPrefsProviderImpl());
}

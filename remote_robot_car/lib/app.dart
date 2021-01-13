import 'package:remoterobotcar/bloc/app_bloc/bloc.dart';
import 'package:remoterobotcar/bloc/mqtt_bloc/bloc.dart';
import 'package:remoterobotcar/provider/singletons/get_it.dart';
import 'package:remoterobotcar/views/input_ip_address/input_ip_page.dart';
import 'package:remoterobotcar/views/router/route_name.dart';
import 'package:remoterobotcar/views/router/router.dart';
import 'package:remoterobotcar/views/splash/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'bloc/vosk_bloc/vosk_bloc.dart';
import 'configs/values/values.dart';

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        FocusScopeNode currentFocus = FocusScope.of(context);
        if (!currentFocus.hasPrimaryFocus && currentFocus.focusedChild != null) {
          FocusManager.instance.primaryFocus.unfocus();
        }
      },
      child: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (_) => locator<AppBloc>()..add(AppStarted()),
          ),
          BlocProvider(
              create: (context) => locator<VoskBloc>()..add(InitVoskEvent())),
        ],
        child: MaterialApp(
          title: 'Robot Car',
          initialRoute: RouteName.myApp,
          onGenerateRoute: router(),
          debugShowCheckedModeBanner: false,
          theme: AppTheme.themeDefault,
          home: BlocBuilder<AppBloc, AppState>(
            builder: (context, state) {
              ScreenUtil.init(context, width: 375, height: 812);
              if (state is AppAuthenticated) {
                return BlocProvider(
                    create: (context) => locator<MQTTBloc>(),
                    child: InputIPPage());
              }
              return SplashScreen();
            },
          ),
        ),
      ),
    );
  }
}

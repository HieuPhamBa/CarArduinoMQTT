import 'dart:async';

import 'package:remoterobotcar/bloc/mqtt_bloc/bloc.dart';
import 'package:remoterobotcar/views/router/route_name.dart';
import 'package:remoterobotcar/views/splash/splash_screen.dart';
import 'package:remoterobotcar/views/widgets/widgets/error_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ConnectMQTTWidget extends StatelessWidget {
  final String ipAddress;

  ConnectMQTTWidget(this.ipAddress);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer<MQTTBloc, MQTTState>(
        listener: (context, state) {
          if (state is ConnectedMQTT) {
            Timer(Duration(milliseconds: 1500), () {
              Navigator.pushReplacementNamed(context, RouteName.home);
            });
          }
        },
        builder: (context, state) {
          if (state is ErrorState) {
            return AppErrorWidget(
              iconData: Icons.cloud_off,
              mess: 'Lỗi kết nối',
              function: () => BlocProvider.of<MQTTBloc>(context)
                  .add(ConnectMQTTService(ipAddress)),
            );
          } else if (state is DisconnectedMQTT) {
            return AppErrorWidget(
              iconData: Icons.cloud_off,
              mess: 'Đã ngắt kết nối !',
              function: () => BlocProvider.of<MQTTBloc>(context)
                  .add(ConnectMQTTService(ipAddress)),
            );
          }

          return SplashScreen();
        },
      ),
    );
  }
}

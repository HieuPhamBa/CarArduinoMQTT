import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:loading/indicator/ball_pulse_indicator.dart';
import 'package:loading/loading.dart';
import 'package:remoterobotcar/bloc/update_data_bloc/bloc.dart';
import 'package:remoterobotcar/bloc/vosk_bloc/vosk_bloc.dart';
import 'package:remoterobotcar/configs/constants/control_remote_constants.dart';
import 'package:remoterobotcar/configs/constants/icon_constants.dart';
import 'package:remoterobotcar/model/mqtt/message.dart';
import 'package:remoterobotcar/views/home/widgets/settings_dialog.dart';
import 'package:remoterobotcar/views/widgets/widgets/exit_dialog.dart';

class ButtonGroupWidget extends StatelessWidget {
  void _settings(
    BuildContext context,
  ) {
    showDialog(
        context: context,
        builder: (context) =>
            BlocBuilder<VoskBloc, VoskState>(builder: (context, state) {
              if (state is VoskInited) {
                return SettingsDialog(true);
              } else if (state is VoskStopped) {
                return SettingsDialog(false);
              } else if (state is VoskError) {
                return SettingsDialog(null);
              }

              return Loading(
                  indicator: BallPulseIndicator(),
                  size: ScreenUtil().setWidth(50),
                  color: Colors.blue);
            }));
  }

  @override
  Widget build(BuildContext context) {
    final sc = MediaQuery.of(context).size;

    return Stack(
      children: [
        Align(
            alignment: Alignment.centerRight,
            child: IconButton(
              icon: Icon(
                Icons.exit_to_app,
                color: Colors.black,
              ),
              onPressed: () {
                showDialog(context: context, builder: (c) => ExitAlertDialog());
              },
            )),
        Align(
          alignment: Alignment.centerLeft,
          child: IconButton(
            icon: Icon(
              Icons.settings,
              color: Colors.black,
            ),
            onPressed: () => _settings(context),
          ),
        ),
        Center(
          child: SizedBox(
            height: sc.width / 2,
            width: sc.width / 2,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buttonWidget(
                        context,
                        IconConstants.goAheadLeft,
                        () => _remoteRobot(
                              context,
                              ControlRemoteConstants.goAheadLeft,
                            )),
                    _buttonWidget(
                        context,
                        IconConstants.goAhead,
                        () => _remoteRobot(
                              context,
                              ControlRemoteConstants.goAhead,
                            )),
                    _buttonWidget(
                        context,
                        IconConstants.goAheadRight,
                        () => _remoteRobot(
                              context,
                              ControlRemoteConstants.goAheadRight,
                            )),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buttonWidget(
                        context,
                        IconConstants.goLeft,
                        () => _remoteRobot(
                              context,
                              ControlRemoteConstants.goLeft,
                            )),
                    GestureDetector(
                        child: Icon(
                          Icons.stop,
                          size: 68,
                          color: Colors.red,
                        ),
                        onTap: () =>
                            _remoteRobot(context, ControlRemoteConstants.stop)),
                    _buttonWidget(
                        context,
                        IconConstants.goRight,
                        () => _remoteRobot(
                              context,
                              ControlRemoteConstants.goRight,
                            )),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buttonWidget(
                        context,
                        IconConstants.goBackLeft,
                        () => _remoteRobot(
                              context,
                              ControlRemoteConstants.goBackLeft,
                            )),
                    _buttonWidget(
                        context,
                        IconConstants.goBack,
                        () => _remoteRobot(
                              context,
                              ControlRemoteConstants.goBack,
                            )),
                    _buttonWidget(
                        context,
                        IconConstants.goBackRight,
                        () => _remoteRobot(
                              context,
                              ControlRemoteConstants.goBackRight,
                            )),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buttonWidget(BuildContext context, String icon, Function callBack) {
    return IconButton(
        icon: SvgPicture.asset(
          icon,
//          color: Colors.blue,
        ),
        onPressed: callBack);
  }

  void _remoteRobot(BuildContext context, String message) {
    BlocProvider.of<UpdateDataBloc>(context)
        .add(RemoteDevice(message: Message(mess: message)));
  }
}

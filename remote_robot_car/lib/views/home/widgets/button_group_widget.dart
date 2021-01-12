import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:remoterobotcar/bloc/update_data_bloc/bloc.dart';
import 'package:remoterobotcar/configs/constants/control_remote_constants.dart';
import 'package:remoterobotcar/configs/constants/icon_constants.dart';
import 'package:remoterobotcar/model/mqtt/message.dart';

class ButtonGroupWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final sc = MediaQuery.of(context).size;

    return Padding(
      padding: const EdgeInsets.only(top: 8.0),
      child: SizedBox(
        height: sc.width / 2.5,
        width: sc.width / 2.5,
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
    );
  }

  Widget _buttonWidget(BuildContext context, String icon, Function callBack) {
    return IconButton(
        icon: SvgPicture.asset(
          icon,
          color: Colors.blue,
        ),
        onPressed: callBack);
  }

  void _remoteRobot(BuildContext context, String message) {
    BlocProvider.of<UpdateDataBloc>(context)
        .add(RemoteDevice(message: Message(mess: message)));
  }
}

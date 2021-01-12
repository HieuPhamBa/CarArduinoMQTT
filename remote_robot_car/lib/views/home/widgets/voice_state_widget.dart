import 'package:avatar_glow/avatar_glow.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:remoterobotcar/bloc/update_data_bloc/update_data_bloc.dart';
import 'package:remoterobotcar/bloc/update_data_bloc/update_data_event.dart';
import 'package:remoterobotcar/bloc/vosk_bloc/vosk_bloc.dart';
import 'package:remoterobotcar/configs/constants/control_remote_constants.dart';
import 'package:remoterobotcar/configs/constants/vosk_constants.dart';
import 'package:remoterobotcar/model/mqtt/message.dart';
import 'package:remoterobotcar/provider/voice_controller/voice_controller_provider.dart';

class MyPhoneListenerWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 52,
      alignment: Alignment.center,
      child: BlocBuilder<VoskBloc, VoskState>(
        builder: (context, state) {
          if (state is VoskInited) {
            return VoiceContentWidget();
          }
          return Text(
            'Voice recognition is not available',
            style: Theme.of(context)
                .primaryTextTheme
                .caption
                .copyWith(color: Colors.grey),
          );
        },
      ),
    );
  }
}

class VoiceContentWidget extends StatefulWidget {
  @override
  _VoiceContentWidgetState createState() => _VoiceContentWidgetState();
}

class _VoiceContentWidgetState extends State<VoiceContentWidget> {
  String text = "Say 'Ok Sunday'";

  void _remoteRobot(String message) {
    BlocProvider.of<UpdateDataBloc>(context)
        .add(RemoteDevice(message: Message(mess: message)));
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    VoiceControllerProvider.wakeupStreamChannel
        .receiveBroadcastStream()
        .listen((data) {
      print(data);
      if (data.toString().contains("WAKEUP")) {
        setState(() {
          text = "Listening...";
        });
      } else if (data.toString().contains("LISTENING")) {
        setState(() {
          text = "Say '${VoskConstants.wakeup}'";
        });
      } else {
        final action = data.toString();
        setState(() {
          // Xét điều  khiển
          if (action.contains(VoskConstants.turnLeft) |
              action.contains(VoskConstants.turnLive)) {
            _remoteRobot(ControlRemoteConstants.goLeft);
            text = VoskConstants.turnLeft;
          } else if (action.contains(VoskConstants.turnRight)) {
            _remoteRobot(ControlRemoteConstants.goRight);
            text = VoskConstants.turnRight;
          } else if (action.contains(VoskConstants.goAhead)) {
            _remoteRobot(ControlRemoteConstants.goAhead);
            text = VoskConstants.goAhead;
          } else if (action.contains(VoskConstants.goBack)) {
            _remoteRobot(ControlRemoteConstants.goBack);
            text = VoskConstants.goBack;
          } else if (action.contains(VoskConstants.stop)) {
            _remoteRobot(ControlRemoteConstants.stop);
            text = VoskConstants.stop;
          } else {
            //Hủy bỏ hành động
            if (action.contains(VoskConstants.cancel)) {
              text = "Cancel action";
            } else {
              text = "Don't understand";
            }
          }
        });
      }
    }).onError((err) {
      setState(() {
        text = "Voice recognition is not available";
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        AvatarGlow(
          animate: true,
          glowColor: Colors.blue,
          endRadius: 45.0,
          duration: const Duration(milliseconds: 2000),
          repeatPauseDuration: const Duration(milliseconds: 100),
          repeat: true,
          child: Icon(
            Icons.mic,
            color: Colors.white,
          ),
        ),
        Text(
          text,
          style: Theme.of(context)
              .primaryTextTheme
              .caption
              .copyWith(color: Colors.grey),
        ),
      ],
    );
  }
}

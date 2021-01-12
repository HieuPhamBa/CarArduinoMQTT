import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/screenutil.dart';
import 'package:loading/indicator/ball_pulse_indicator.dart';
import 'package:loading/loading.dart';
import 'package:remoterobotcar/bloc/update_data_bloc/bloc.dart';
import 'package:remoterobotcar/bloc/vosk_bloc/vosk_bloc.dart';
import 'package:remoterobotcar/views/home/widgets/button_group_widget.dart';
import 'package:remoterobotcar/views/home/widgets/settings_dialog.dart';
import 'package:remoterobotcar/views/home/widgets/voice_state_widget.dart';

class HomeWidget extends StatelessWidget {
  final scaffoldKey = GlobalKey<ScaffoldState>();

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
    return WillPopScope(
      onWillPop: () => showDialog<bool>(
        context: context,
        builder: (c) => _exitDialog(c),
      ),
      child: Scaffold(
          key: scaffoldKey,
          body: SafeArea(
              child: BlocListener<UpdateDataBloc, UpdateDataState>(
                  listener: (context, state) {
                    if (state is FailedData) {
                      showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                                title: Text('Error'),
                                content: Text(state.error),
                                actions: [
                                  RaisedButton(
                                    onPressed: () => Navigator.pop(context),
                                    child: Text('OK'),
                                  )
                                ],
                              ));
                    }
                  },
                  child: _bodyWidget(context)))),
    );
  }

  Widget _bodyWidget(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Stack(
        children: [
          Align(
              alignment: Alignment.topRight,
              child: _groupSettingsButton(context)),
          Align(alignment: Alignment.topCenter, child: MyPhoneListenerWidget()),
          Align(alignment: Alignment.center, child: ButtonGroupWidget()),
        ],
      ),
    );
  }

  Widget _groupSettingsButton(BuildContext context) {
    return Column(
      children: [
        IconButton(
          icon: Icon(
            Icons.exit_to_app,
            color: Colors.black,
          ),
          onPressed: () {
            showDialog(context: context, builder: (c) => _exitDialog(c));
          },
        ),
        IconButton(
          icon: Icon(
            Icons.settings,
            color: Colors.black,
          ),
          onPressed: () => _settings(context),
        ),
      ],
    );
  }

  Widget _exitDialog(BuildContext c) {
    return AlertDialog(
      elevation: 5,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(16))),
      title: Text('Warning'),
      content: Text('Do you really want to exit?'),
      actions: [
        FlatButton(
          child: Text('Yes'),
          onPressed: () => Navigator.pop(c, true),
        ),
        FlatButton(
          child: Text('No'),
          onPressed: () => Navigator.pop(c, false),
        ),
      ],
    );
  }
}

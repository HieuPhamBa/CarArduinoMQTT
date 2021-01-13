import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:remoterobotcar/bloc/update_data_bloc/bloc.dart';
import 'package:remoterobotcar/views/home/widgets/button_group_widget.dart';
import 'package:remoterobotcar/views/home/widgets/voice_state_widget.dart';
import 'package:remoterobotcar/views/widgets/widgets/exit_dialog.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class HomeWidget extends StatelessWidget {
  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () => showDialog<bool>(
        context: context,
        builder: (c) => ExitAlertDialog(),
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
    final sc = MediaQuery.of(context).size;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          SizedBox(height: sc.height / 2, child: MyPhoneListenerWidget()),
          SizedBox(height: 250.h, child: ButtonGroupWidget()),
          SizedBox(
            height: 52.h,
          ),
        ],
      ),
    );
  }
}

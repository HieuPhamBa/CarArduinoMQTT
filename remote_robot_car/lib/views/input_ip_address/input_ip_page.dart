import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:remoterobotcar/bloc/mqtt_bloc/bloc.dart';
import 'package:remoterobotcar/views/router/route_name.dart';
import 'package:remoterobotcar/views/widgets/dialogs/alert_dialog.dart';
import 'package:remoterobotcar/views/widgets/dialogs/loading_dialog.dart';

class InputIPPage extends StatefulWidget {
  @override
  _InputIPPageState createState() => _InputIPPageState();
}

class _InputIPPageState extends State<InputIPPage> {
  final _formKey = GlobalKey<FormState>();
  final _textController = TextEditingController();

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: BlocListener<MQTTBloc, MQTTState>(
        listener: (context, state) {
          if (state is LoadingState) {
            LoadingDialog.show(
              context,
            );
          }
          if (state is ConnectedMQTT) {
            Timer(Duration(milliseconds: 1500), () {
              Navigator.pushReplacementNamed(context, RouteName.home);
            });
          }
          if (state is ErrorState) {
            AppAlertDialog.showAlert(context, 'Notification',
                'Error! An error occurred. Please try again later');
          } else if (state is DisconnectedMQTT) {
            AppAlertDialog.showAlert(context, 'Notification', 'Disconnected');
          }
        },
        child: _buildBody(),
      )),
    );
  }

  Widget _buildBody() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32),
      child: Center(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextFormField(
                controller: _textController,
                keyboardType: TextInputType.text,
                validator: (value) {
                  if (!value.contains(RegExp(
                      r'^((25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.){3}(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)$'))) {
                    return 'Invalid';
                  }
                  return null;
                },
                decoration: InputDecoration(
                    hintText: 'IP address...',
                    hintStyle: TextStyle(color: Colors.grey)),
              ),
              SizedBox(
                height: 16,
              ),
              RaisedButton(
                color: Colors.blueAccent,
                onPressed: _buttonOnPressed,
                child: Text(
                  'Go',
                  style: TextStyle(color: Colors.white),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  void _buttonOnPressed() {
    if (_formKey.currentState.validate()) {
      BlocProvider.of<MQTTBloc>(context)
          .add(ConnectMQTTService(_textController.text.trim()));
    }
  }
}

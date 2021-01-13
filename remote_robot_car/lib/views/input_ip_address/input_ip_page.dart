import 'package:flutter/material.dart';
import 'package:remoterobotcar/views/router/route_name.dart';

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
          child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32),
        child: Center(
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextFormField(
                  controller: _textController,
                  validator: (value) {
                    if (!value.contains(RegExp(
                        r'^((25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.){3}(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)$'))) {
                      return 'Invalid';
                    }
                    return null;
                  },
                  decoration: InputDecoration(hintText: 'IP address...'),
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
      )),
    );
  }

  void _buttonOnPressed() {
    if (_formKey.currentState.validate()) {
      Navigator.pushReplacementNamed(context, RouteName.connectMQTT,
          arguments: {'ip': _textController.text.trim()});
    }
  }
}

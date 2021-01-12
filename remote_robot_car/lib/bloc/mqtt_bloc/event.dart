import 'package:equatable/equatable.dart';
import 'package:remoterobotcar/model/mqtt/message.dart';

abstract class MQTTEvent extends Equatable{
  @override
  // TODO: implement props
  List<Object> get props => [];
}

//class InitMQTTService extends MQTTEvent{}

class DisconnectMQTTT extends MQTTEvent{}

class ConnectMQTTService extends MQTTEvent{

  @override
  // TODO: implement props
  List<Object> get props => [];

}

class SendMessage extends MQTTEvent{
  final Message message;

  SendMessage({this.message}) : assert(message!=null);

  @override
  // TODO: implement props
  List<Object> get props => [message];
}
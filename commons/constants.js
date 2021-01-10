const MQTT_PORT = 1883
const PUBLISH_MESSAGE = 'Client \x1b[31m {0} \x1b[0m has published {1} on {2} to broker {3}'
const SUBSCRIBE_MESSAGE = 'MQTT client \x1b[32m {0} \x1b[0m subscribed to topics: {1} from broker {2}'

const AUTH_SUCCESS_MESSAGE = 'Client {0} login success'
const AUTH_FAILSE_MESSAGE = 'Client {0} login failse'

const CLEINT_CONNECTED_MESSAGE = 'Client {0} connected'
const CLEINT_DISCONNECTED_MESSAGE = 'Client {0} disconnected'

export default {
  MQTT_PORT,
  PUBLISH_MESSAGE,
  SUBSCRIBE_MESSAGE,
  AUTH_SUCCESS_MESSAGE,
  AUTH_FAILSE_MESSAGE,
  CLEINT_CONNECTED_MESSAGE,
  CLEINT_DISCONNECTED_MESSAGE,
}

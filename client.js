let mqtt = require('mqtt')

const SERVER = 'mqtt://192.168.1.138:5000'
const TOPIC = 'main'
const username = 'robotCar'
const password = '1234567890'
const clientId = "mqttjs01234a"

const options = {
  clientId, username, password, clean: true
};

const client = mqtt.connect(SERVER, options)

// helper function to log date+text to console:
const log = (text) => {
  console.log(`[${new Date().toLocaleString()}] ${text}`)
}


// on connection event:
client.on(
  'connect',
  (message) => {
    log(`Connected to ${SERVER}`)
    client.subscribe('main')
    client.publish('main', 'Hi there!')

  }
)

// on message received event:
client.on(
  'message',
  (topic, message) => {
    log(`Message received on topic ${topic}: ${message.toString()}`)
  }
)


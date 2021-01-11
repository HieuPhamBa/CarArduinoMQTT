import { connect } from 'mqtt'

const SERVER = 'mqtt:local:1883'
const TOPIC = 'testtopic/1'
const username = 'robotCar'
const password = '1234567890'
const clientId = "mqttjs01234a"

const options = {
  clientId, username, password, clean: true
}

const client = connect(SERVER, options)

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
	client.end()
  }
)



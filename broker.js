import stringFormat from './commons/helpers.js'
import { default as Constanst} from './commons/constants.js'

import aedes from 'aedes'
import net from 'net'
import http from 'http'
import { Console } from 'console'
import fs from 'fs'


const tls_options = {
	key: fs.readFileSync('./cert/privkey.pem'),
	cert: fs.readFileSync('./cert/cert.pem'),
	requestCert: false,
	rejectUnauthorized: false
};

const aedesServer = aedes()
const server = net.createServer(aedesServer.handle)
const httpServer = http.createServer(tls_options)

const {
  MQTT_PORT,
  PUBLISH_MESSAGE,
  SUBSCRIBE_MESSAGE,
  AUTH_SUCCESS_MESSAGE,
  AUTH_FAILSE_MESSAGE,
  CLEINT_CONNECTED_MESSAGE,
  CLEINT_DISCONNECTED_MESSAGE,
} = Constanst

const wsPort = 8883 

// helper function to log date+text to console:
const log = (text) => {
  console.log(`[${new Date().toLocaleString()}] ${text}`)
}

aedesServer.authenticate = function (client, username, password, callback) {
  var error = null
  var isAuth = false
  var message = ''

  if (username == 'robotCar' && password == '1234567890') {
    isAuth = true
    message = AUTH_SUCCESS_MESSAGE
  } else {
    error = new Error('Auth error')
    error.returnCode = 4

    message = AUTH_FAILSE_MESSAGE
  }

  message = stringFormat(message, client.id)
  console.log(message)

  callback(error, isAuth)
}

// client connection event:
aedesServer.on('client', (client) => {
  const message = stringFormat(CLEINT_CONNECTED_MESSAGE, client.id)
  console.log(message)
})

aedesServer.authorizeSubscribe = function (client, sub, callback) {
  const brokerId = aedesServer.id
  const clientId = client.id

  const topic = sub.topic 

  const message = stringFormat(SUBSCRIBE_MESSAGE, clientId, topic, brokerId)

  console.log(message)

  callback(null, sub)
}

aedesServer.authorizePublish = function (client, packet, callback) {
  const brokerId = aedesServer.id
  const clientId = client.id

  const topic = packet.topic
  const messPubs = packet.payload.toString()

  const message = stringFormat(PUBLISH_MESSAGE, clientId, brokerId, messPubs, topic, brokerId)

  console.log(message)

  callback(null)
}

//client disconnection event:
aedesServer.on('clientDisconnect', (client) => {
  const message = stringFormat(CLEINT_DISCONNECTED_MESSAGE, client.id)
  console.log(message)
})

httpServer.listen(wsPort, function () {
  console.log('websocket server listening on port ', wsPort)
})

const listener = server.listen(MQTT_PORT, '0.0.0.0', function () {
  const serverAddress = listener.address().address + ':' + listener.address().port
  console.log(`server listening on ${serverAddress}`)
})
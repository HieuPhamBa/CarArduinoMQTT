import stringFormat from '../commons/helpers.js'
import { default as Constanst } from '../commons/constants.js'

import aedes from 'aedes'

import log from './log.config.js'

const aedesServer = aedes()

const {
  PUBLISH_MESSAGE,
  SUBSCRIBE_MESSAGE,
  AUTH_SUCCESS_MESSAGE,
  AUTH_FAILSE_MESSAGE,
  CLEINT_CONNECTED_MESSAGE,
  CLEINT_DISCONNECTED_MESSAGE,
} = Constanst

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
  log(message)

  callback(error, isAuth)
}

// client connection event:
aedesServer.on('client', (client) => {
  const message = stringFormat(CLEINT_CONNECTED_MESSAGE, client.id)
  log(message)
})

aedesServer.authorizeSubscribe = function (client, sub, callback) {
  const brokerId = aedesServer.id
  const clientId = client.id

  const topic = sub.topic

  const message = stringFormat(SUBSCRIBE_MESSAGE, clientId, topic, brokerId)

  log(message)

  callback(null, sub)
}

aedesServer.authorizePublish = function (client, packet, callback) {
  const brokerId = aedesServer.id
  const clientId = client.id

  const topic = packet.topic
  const messPubs = packet.payload.toString()

  const message = stringFormat(PUBLISH_MESSAGE, clientId, brokerId, messPubs, topic, brokerId)

  log(message)

  callback(null)
}

//client disconnection event:
aedesServer.on('clientDisconnect', (client) => {
  const message = stringFormat(CLEINT_DISCONNECTED_MESSAGE, client.id)
  log(message)
})

export default aedesServer

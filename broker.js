import { default as Constanst } from './commons/constants.js'

import net from 'net'
import http from 'http'
import fs from 'fs'

import aedesServer from './configs/broker.config.js'

import log from './configs/log.config.js'

const {
  WS_PORT,
  MQTT_PORT,
} = Constanst

const tls_options = {
  key: fs.readFileSync('./cert/privkey.pem'),
  cert: fs.readFileSync('./cert/cert.pem'),
  requestCert: false,
  rejectUnauthorized: false
};

const mqttServer = net.createServer(aedesServer.handle)
const httpServer = http.createServer(tls_options, aedesServer.handle)

const wsListener = httpServer.listen(WS_PORT, function () {
  const serverAddress = wsListener.address().address + ':' + wsListener.address().port
  log(`websocket server listening on ${serverAddress} `)
})

const mqttListener = mqttServer.listen(MQTT_PORT, function () {
  const serverAddress = mqttListener.address().address + ':' + mqttListener.address().port
  log(`mqtt server listening on ${serverAddress}`)
})
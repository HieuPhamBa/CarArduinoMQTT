var aedes = require('aedes')()
var server = require('net').createServer(aedes.handle)

const PORT = 5000
const TOPIC = 'main'

// helper function to log date+text to console:
const log = (text) => {
  console.log(`[${new Date().toLocaleString()}] ${text}`)
}

aedes.authenticate = function (client, username, password, callback) {
  var error = null
  var isAuth = false

  if(username == 'robotCar'&& password =='1234567890'){
    isAuth = true
    message='test ok'
    console.log( `Client ${client.id} login success`)
  }else{
    error = new Error('Auth error')
    error.returnCode = 4
  }

  callback(error, isAuth)
}

// client connection event:
aedes.on('client', (client) => {
   // let message = `Client ${client.id} just connected`
   let message = `Client ${client.id} just connected`
    log(message)
    aedes.publish({
      cmd: 'publish',
      qos: 2,
      topic: 'main',
      payload: message,
      retain: false
    })
  }
)


aedes.on('subscribe', function (subscriptions, client) {
  console.log('MQTT client \x1b[32m' + (client ? client.id : client) +
          '\x1b[0m subscribed to topics: ' + subscriptions.map(s => s.topic).join('\n'), 'from broker', aedes.id) 
})

aedes.on('unsubscribe', function (subscriptions, client) {
  console.log('MQTT client \x1b[32m' + (client ? client.id : client) +
          '\x1b[0m unsubscribed to topics: ' + subscriptions.join('\n'), 'from broker', aedes.id)
})


aedes.on('publish', async function (packet, client) {
  console.log('Client \x1b[31m' + (client ? client.id : 'BROKER_' + aedes.id) + '\x1b[0m has published', packet.payload.toString(), 'on', packet.topic, 'to broker', aedes.id)
})


//client disconnection event:
aedes.on('clientDisconnect', (client) => {
    message = `Client ${client.id} just DISconnected`
    log(message)
    aedes.publish({
      cmd: 'publish',
      qos: 2,
      topic: 'main',
      payload: message,
      retain: false
    })
  }
)

server.listen(PORT, function () {
  log(`server listening on port ${PORT}`)
})
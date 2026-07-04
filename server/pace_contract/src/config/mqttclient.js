const mqtt = require('mqtt');
require('dotenv').config();

const options = {
  username: process.env.HIVEMQ_USERNAME,
  password: process.env.HIVEMQ_PASSWORD,
  rejectUnauthorized: true // Essential for HiveMQ Cloud TLS connections
};

const mqttClient = mqtt.connect(process.env.HIVEMQ_BROKER_URL, options);

mqttClient.on('connect', () => {
  console.log('⚡ Connected seamlessly to HiveMQ Broker!');
});

mqttClient.on('error', (err) => {
  console.error('MQTT Connection Error:', err);
});

module.exports = mqttClient;
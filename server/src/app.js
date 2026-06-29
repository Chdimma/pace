const express = require('express');
const cors = require('cors');

const healthRoutes = require('./routes/health');
const authRoutes = require('./routes/auth');
const solanaRoutes = require('./routes/solana');
const mqttRoutes = require('./routes/mqtt');
const postureRoutes = require('./routes/posture');

const app = express();

app.use(cors());
app.use(express.json());

app.get('/', (req, res) => {
  res.json({
    name: 'Pace backend',
    status: 'online',
    version: '1.0.0'
  });
});

app.use('/api/health', healthRoutes);
app.use('/api/auth', authRoutes);
app.use('/api/solana', solanaRoutes);
app.use('/api/mqtt', mqttRoutes);
app.use('/api/posture', postureRoutes);

module.exports = app;

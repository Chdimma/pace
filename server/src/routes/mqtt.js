const express = require('express');
const router = express.Router();

router.post('/publish', (req, res) => {
  const { topic, payload } = req.body;

  if (!topic || !payload) {
    return res.status(400).json({ error: 'topic and payload are required' });
  }

  res.json({ success: true, message: 'MQTT publish request accepted', topic, payload });
});

module.exports = router;

const express = require('express');
const { query } = require('../config/db');
const router = express.Router();

router.post('/events', async (req, res) => {
  try {
    const { userId, score, postureStatus } = req.body;

    if (!userId || score == null || !postureStatus) {
      return res.status(400).json({ error: 'userId, score, and postureStatus are required' });
    }

    const inserted = await query(
      `INSERT INTO posture_events (user_id, score, posture_status)
       VALUES ($1, $2, $3)
       RETURNING id, user_id, score, posture_status, created_at`,
      [userId, score, postureStatus]
    );

    return res.status(201).json({ success: true, event: inserted[0] });
  } catch (error) {
    return res.status(500).json({ error: 'Failed to save posture event', details: error.message });
  }
});

router.get('/events/:userId', async (req, res) => {
  try {
    const rows = await query(
      'SELECT id, user_id, score, posture_status, created_at FROM posture_events WHERE user_id = $1 ORDER BY created_at DESC LIMIT 20',
      [req.params.userId]
    );

    return res.json({ success: true, events: rows });
  } catch (error) {
    return res.status(500).json({ error: 'Failed to fetch posture events', details: error.message });
  }
});

module.exports = router;

const crypto = require('crypto');
const { query } = require('../config/db');

function hashPassword(password) {
  return crypto.createHash('sha256').update(password).digest('hex');
}

async function loginUser(req, res) {
  try {
    const { email, password } = req.body;

    if (!email || !password) {
      return res.status(400).json({ error: 'Email and password are required' });
    }

    const result = await query(
      'SELECT * FROM users WHERE email = $1 AND password_hash = $2',
      [email, hashPassword(password)]
    );

    if (result.length === 0) {
      return res.status(401).json({ error: 'Invalid credentials' });
    }

    const user = result[0];
    return res.json({
      success: true,
      user: {
        id: user.id,
        name: user.name,
        email: user.email,
        username: user.username,
        phoneNumber: user.phone_number,
      }
    });
  } catch (error) {
    return res.status(500).json({ error: 'Login failed', details: error.message });
  }
}

async function signupUser(req, res) {
  try {
    const { name, email, password, username, phoneNumber } = req.body;

    if (!name || !email || !password || !username) {
      return res.status(400).json({ error: 'Name, email, password, and username are required' });
    }

    const existing = await query('SELECT id FROM users WHERE email = $1 OR username = $2', [email, username]);
    if (existing.length > 0) {
      return res.status(409).json({ error: 'User already exists' });
    }

    const inserted = await query(
      `INSERT INTO users (name, email, username, phone_number, password_hash)
       VALUES ($1, $2, $3, $4, $5)
       RETURNING id, name, email, username, phone_number`,
      [name, email, username, phoneNumber || null, hashPassword(password)]
    );

    return res.status(201).json({ success: true, user: inserted[0] });
  } catch (error) {
    return res.status(500).json({ error: 'Signup failed', details: error.message });
  }
}

async function getCurrentUser(req, res) {
  return res.json({ success: true, user: req.user || null });
}

module.exports = { loginUser, signupUser, getCurrentUser };

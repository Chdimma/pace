const crypto = require('crypto');
const jwt = require('jsonwebtoken');
const { query } = require('../config/db');

function hashPassword(password) {
  return crypto.createHash('sha256').update(password).digest('hex');
}

function signToken(user) {
  return jwt.sign({ id: user.id, email: user.email, username: user.username }, process.env.JWT_SECRET || 'dev-secret', {
    expiresIn: '7d',
  });
}

async function loginUser(req, res) {
  try {
    const { email, phoneNumber, password } = req.body;
    const identifierEmail = email || null;
    const identifierPhone = phoneNumber || null;

    if (!password || (!identifierEmail && !identifierPhone)) {
      return res.status(400).json({ error: 'Email or phone number and password are required' });
    }

    let queryText = 'SELECT id, name, email, username, phone_number FROM users WHERE password_hash = $1';
    const queryParams = [hashPassword(password)];

    if (identifierEmail && identifierPhone) {
      queryText += ' AND (email = $2 OR phone_number = $3)';
      queryParams.push(identifierEmail, identifierPhone);
    } else if (identifierEmail) {
      queryText += ' AND email = $2';
      queryParams.push(identifierEmail);
    } else {
      queryText += ' AND phone_number = $2';
      queryParams.push(identifierPhone);
    }

    const result = await query(queryText, queryParams);

    if (result.length === 0) {
      return res.status(401).json({ error: 'Invalid credentials' });
    }

    const user = result[0];
    return res.json({
      success: true,
      token: signToken(user),
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
    const identifierEmail = email || null;
    const identifierPhone = phoneNumber || null;

    if (!name || (!identifierEmail && !identifierPhone) || !password || !username) {
      return res.status(400).json({ error: 'Name, identifier, password, and username are required' });
    }

    const existing = await query(
      'SELECT id FROM users WHERE email = $1 OR phone_number = $2 OR username = $3',
      [identifierEmail, identifierPhone, username]
    );
    if (existing.length > 0) {
      return res.status(409).json({ error: 'User already exists' });
    }

    const inserted = await query(
      `INSERT INTO users (name, email, username, phone_number, password_hash)
       VALUES ($1, $2, $3, $4, $5)
       RETURNING id, name, email, username, phone_number`,
      [name, identifierEmail, username, identifierPhone, hashPassword(password)]
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

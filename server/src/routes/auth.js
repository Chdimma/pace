const express = require('express');
const { loginUser, signupUser, getCurrentUser } = require('../controllers/authController');
const authenticate = require('../middleware/auth');
const router = express.Router();

router.post('/login', loginUser);
router.post('/signup', signupUser);
router.get('/me', authenticate, getCurrentUser);

module.exports = router;

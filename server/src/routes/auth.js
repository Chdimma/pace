const express = require('express');
const { loginUser, signupUser, getCurrentUser } = require('../controllers/authController');
const router = express.Router();

router.post('/login', loginUser);
router.post('/signup', signupUser);
router.get('/me', getCurrentUser);

module.exports = router;

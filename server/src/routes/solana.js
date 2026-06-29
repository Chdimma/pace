const express = require('express');
const { getHealth, getBalance } = require('../controllers/solanaController');
const router = express.Router();

router.get('/health', getHealth);
router.get('/balance/:address', getBalance);

module.exports = router;

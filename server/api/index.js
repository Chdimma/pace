require('dotenv').config();
const app = require('../src/app');

// Vercel serverless expects a handler function. Wrap the Express app
// so unhandled errors are correctly surfaced by the platform.
module.exports = (req, res) => {
	return app(req, res);
};

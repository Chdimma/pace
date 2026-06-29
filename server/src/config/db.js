const { neon } = require('@neondatabase/serverless');

const sql = process.env.DATABASE_URL ? neon(process.env.DATABASE_URL) : null;

async function query(text, params = []) {
  if (!sql) {
    throw new Error('DATABASE_URL is not set');
  }

  return sql(text, params);
}

module.exports = { query };

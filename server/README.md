# Pace Backend

This backend is designed to run on Vercel from the same domain as the frontend.

## Local development

1. Install dependencies:
   npm install
2. Create a .env file from .env.example and add your Neon connection string.
3. Start the server:
   npm run dev

## Neon SQL

Run the SQL in [sql/init.sql](sql/init.sql) in your Neon database to create the users and posture_events tables.

## Vercel deployment

1. Deploy the frontend from the project root.
2. Deploy the backend from the server folder.
3. For a single-domain setup, the API should be available at /api/* on the same host.
4. Set these environment variables in Vercel:
   - DATABASE_URL
   - SOLANA_RPC_URL
   - JWT_SECRET

# Pace Backend

## Local development

1. Install dependencies:
   npm install
2. Create a .env file from .env.example and add your Neon connection string.
3. Start the server:
   npm run dev

## Neon SQL

Run the SQL in [sql/init.sql](sql/init.sql) in your Neon database to create the users and posture_events tables.

## Vercel deployment

1. Set the project root to the server folder.
2. Add the environment variables in Vercel:
   - DATABASE_URL
   - SOLANA_RPC_URL
3. Deploy.

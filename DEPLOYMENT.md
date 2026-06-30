# Pace Deployment Guide

## Frontend Deployment (pace-fawn.vercel.app)
- Project root: the root of this repo
- Build command: `bash vercel.sh`
- Output directory: `build/web`
- No environment variables needed for the frontend

## Backend Deployment (separate Vercel project)
Deploy the `server` folder as a separate Vercel project:

1. Create a new Vercel project from [server](server) folder
2. Set these environment variables:
   - `DATABASE_URL`: Your Neon PostgreSQL connection string
   - `SOLANA_RPC_URL`: https://api.devnet.solana.com (or your RPC endpoint)
   - `JWT_SECRET`: Any random secret string
   - `NODE_ENV`: production

3. Once deployed, you'll get a URL like `https://pace-backend.vercel.app`

## Connect Frontend to Backend
After the backend is deployed, update the frontend API URLs:
- In [lib/services/auth_service.dart](../lib/services/auth_service.dart), change:
  ```
  static const String baseUrl = 'https://pace-backend.vercel.app/api/auth';
  ```
- In [lib/services/mqtt_service.dart](../lib/services/mqtt_service.dart), change:
  ```
  static const String baseUrl = 'https://pace-backend.vercel.app/api/mqtt';
  ```

Then redeploy the frontend.

## Test the Backend
Visit: `https://pace-backend.vercel.app/` - you should see a JSON response.

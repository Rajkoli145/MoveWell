import type { NextFunction, Request, Response } from 'express';
import type { DecodedIdToken } from 'firebase-admin/auth';
import { adminAuth } from './firebase.js';

declare global {
  namespace Express {
    interface Request {
      firebaseUser?: DecodedIdToken;
    }
  }
}

export async function requireFirebaseUser(
  req: Request,
  res: Response,
  next: NextFunction,
): Promise<void> {
  // Flutter sends: Authorization: Bearer <Firebase ID token>.
  const authorization = req.header('authorization');
  if (!authorization?.startsWith('Bearer ')) {
    res.status(401).json({ error: 'A Firebase bearer token is required.' });
    return;
  }

  try {
    // Verify the token and make the authenticated user available to every API
    // route that runs after this middleware.
    req.firebaseUser = await adminAuth.verifyIdToken(authorization.slice(7), true);
    next();
  } catch {
    res.status(401).json({ error: 'The Firebase token is invalid, expired, or revoked.' });
  }
}

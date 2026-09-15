import { applicationDefault, getApps, initializeApp } from 'firebase-admin/app';
import { getAuth } from 'firebase-admin/auth';
import { getFirestore } from 'firebase-admin/firestore';

// Reuse the Admin app during hot reloads; otherwise create it using the
// service-account path supplied in GOOGLE_APPLICATION_CREDENTIALS.
const app = getApps()[0] ?? initializeApp({
  credential: applicationDefault(),
  projectId: process.env.FIREBASE_PROJECT_ID,
});

// Admin Auth verifies user tokens; Firestore stores protected app data.
export const adminAuth = getAuth(app);
export const db = getFirestore(app);

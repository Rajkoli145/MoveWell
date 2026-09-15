import cors from 'cors';
import express, { type ErrorRequestHandler } from 'express';
import helmet from 'helmet';
import { FieldValue } from 'firebase-admin/firestore';
import { ZodError } from 'zod';
import { requireFirebaseUser } from './auth-middleware.js';
import { db } from './firebase.js';
import {
  profileUpdateSchema,
  routineCreateSchema,
  routineFavoriteSchema,
  workoutSessionCreateSchema,
  dailyWaterSchema,
} from './profile-schema.js';

export const app = express();

// A comma-separated allow-list lets local Flutter web builds call this API.
const allowedOrigins = (process.env.ALLOWED_ORIGINS ?? '')
  .split(',')
  .map((origin) => origin.trim())
  .filter(Boolean);

// Basic production-minded HTTP protections and a small JSON request limit.
app.disable('x-powered-by');
app.use(helmet());
app.use(cors({
  origin: allowedOrigins.length === 0 ? true : allowedOrigins,
  credentials: false,
}));
app.use(express.json({ limit: '64kb' }));

app.get('/health', (_req, res) => {
  // Unauthenticated probe used to confirm that the server is reachable.
  res.json({ status: 'ok', service: 'movewell-backend' });
});

// Every route below this line requires a valid Firebase ID token.
app.use('/api', requireFirebaseUser);

app.post('/api/users/sync', async (req, res, next) => {
  try {
    const user = req.firebaseUser!;
    const ref = db.collection('users').doc(user.uid);
    const snapshot = await ref.get();
    const authProvider = user.firebase?.sign_in_provider ?? 'unknown';

    // First login creates a complete default profile so every Flutter screen
    // has safe values before the onboarding form is submitted.
    if (!snapshot.exists) {
      await ref.set({
        uid: user.uid,
        fullName: user.name ?? 'MoveWell User',
        email: user.email ?? '',
        subtitle: 'Stay consistent, stay better.',
        avatarPath: user.picture ?? '',
        dateOfBirth: '',
        gender: '',
        height: 172,
        heightUnit: 'cm',
        weight: 60,
        weightUnit: 'kg',
        age: 25,
        activityLevel: '',
        goal: '',
        language: 'English',
        theme: 'Light',
        notificationsEnabled: true,
        onboardingComplete: false,
        authProvider,
        createdAt: FieldValue.serverTimestamp(),
        updatedAt: FieldValue.serverTimestamp(),
        lastLoginAt: FieldValue.serverTimestamp(),
      });
    } else {
      // Existing users only receive login/provider metadata updates.
      await ref.set({
        email: user.email ?? snapshot.data()?.email ?? '',
        authProvider,
        lastLoginAt: FieldValue.serverTimestamp(),
      }, { merge: true });
    }

    const current = await ref.get();
    res.json({ data: current.data() });
  } catch (error) {
    next(error);
  }
});

app.get('/api/profile', async (req, res, next) => {
  try {
    const snapshot = await db.collection('users').doc(req.firebaseUser!.uid).get();
    if (!snapshot.exists) {
      res.status(404).json({ error: 'Profile not found. Call /api/users/sync first.' });
      return;
    }
    res.json({ data: snapshot.data() });
  } catch (error) {
    next(error);
  }
});

app.put('/api/profile', async (req, res, next) => {
  try {
    // Zod rejects invalid or unexpected profile fields before Firestore writes.
    const profile = profileUpdateSchema.parse(req.body);
    const user = req.firebaseUser!;
    const ref = db.collection('users').doc(user.uid);
    await ref.set({
      ...profile,
      uid: user.uid,
      email: user.email ?? '',
      updatedAt: FieldValue.serverTimestamp(),
    }, { merge: true });
    const current = await ref.get();
    res.json({ data: current.data() });
  } catch (error) {
    next(error);
  }
});

app.get('/api/routines', async (req, res, next) => {
  try {
    const snapshot = await db
      .collection('users')
      .doc(req.firebaseUser!.uid)
      .collection('routines')
      .orderBy('createdAt', 'desc')
      .get();
    res.json({
      data: snapshot.docs.map((document) => ({ id: document.id, ...document.data() })),
    });
  } catch (error) {
    next(error);
  }
});

app.post('/api/routines', async (req, res, next) => {
  try {
    const routine = routineCreateSchema.parse(req.body);
    // Routines are a subcollection, so each user can only own their own data.
    const ref = db
      .collection('users')
      .doc(req.firebaseUser!.uid)
      .collection('routines')
      .doc();
    await ref.set({
      ...routine,
      favorite: false,
      createdAt: FieldValue.serverTimestamp(),
      updatedAt: FieldValue.serverTimestamp(),
    });
    const created = await ref.get();
    res.status(201).json({ data: { id: created.id, ...created.data() } });
  } catch (error) {
    next(error);
  }
});

app.patch('/api/routines/:routineId/favorite', async (req, res, next) => {
  try {
    const { favorite } = routineFavoriteSchema.parse(req.body);
    const ref = db
      .collection('users')
      .doc(req.firebaseUser!.uid)
      .collection('routines')
      .doc(req.params.routineId);
    const existing = await ref.get();
    if (!existing.exists) {
      res.status(404).json({ error: 'Routine not found.' });
      return;
    }
    await ref.update({ favorite, updatedAt: FieldValue.serverTimestamp() });
    const updated = await ref.get();
    res.json({ data: { id: updated.id, ...updated.data() } });
  } catch (error) {
    next(error);
  }
});

function weekKey(date: string) {
  // Convert a calendar date to an ISO-like week ID, e.g. 2026-W38.
  const value = new Date(`${date}T12:00:00Z`);
  const day = value.getUTCDay() || 7;
  value.setUTCDate(value.getUTCDate() + 4 - day);
  const yearStart = new Date(Date.UTC(value.getUTCFullYear(), 0, 1));
  const week = Math.ceil((((value.getTime() - yearStart.getTime()) / 86400000) + 1) / 7);
  return `${value.getUTCFullYear()}-W${week.toString().padStart(2, '0')}`;
}

function challengeResponse(data: FirebaseFirestore.DocumentData | undefined) {
  // Store only completed date lists in Firestore; calculate display progress
  // here so changing a goal later does not require rewriting historical data.
  const movementDays = (data?.movementDays as string[] | undefined) ?? [];
  const hydrationDays = (data?.hydrationDays as string[] | undefined) ?? [];
  const morningWorkoutDays = (data?.morningWorkoutDays as string[] | undefined) ?? [];
  return {
    weekKey: data?.weekKey ?? '',
    challenges: [
      { id: 'move-5-days', title: 'Move 5 Days This Week', description: 'Complete any workout on five days.', icon: 'run', progress: movementDays.length, goal: 5, days: movementDays },
      { id: 'hydration-streak', title: 'Hydration Streak', description: 'Reach your water goal on seven days.', icon: 'water', progress: hydrationDays.length, goal: 7, days: hydrationDays },
      { id: 'morning-momentum', title: 'Morning Momentum', description: 'Finish a workout before noon three times.', icon: 'sun', progress: morningWorkoutDays.length, goal: 3, days: morningWorkoutDays },
    ],
  };
}

app.get('/api/dashboard', async (req, res, next) => {
  try {
    const localDate = typeof req.query.date === 'string' && /^\d{4}-\d{2}-\d{2}$/.test(req.query.date)
      ? req.query.date
      : new Date().toISOString().slice(0, 10);
    const userRef = db.collection('users').doc(req.firebaseUser!.uid);
    // These documents are independent, so read them concurrently.
    const [challenge, metric] = await Promise.all([
      userRef.collection('challengeProgress').doc(weekKey(localDate)).get(),
      userRef.collection('dailyMetrics').doc(localDate).get(),
    ]);
    res.json({ data: { ...challengeResponse(challenge.data()), waterGlasses: metric.data()?.waterGlasses ?? 0 } });
  } catch (error) { next(error); }
});

app.post('/api/workout-sessions', async (req, res, next) => {
  try {
    const session = workoutSessionCreateSchema.parse(req.body);
    const userRef = db.collection('users').doc(req.firebaseUser!.uid);
    const challengeRef = userRef.collection('challengeProgress').doc(weekKey(session.localDate));
    const sessionRef = userRef.collection('workoutSessions').doc();
    // arrayUnion avoids counting the same calendar day twice.
    const updates: FirebaseFirestore.DocumentData = {
      weekKey: weekKey(session.localDate),
      movementDays: FieldValue.arrayUnion(session.localDate),
      updatedAt: FieldValue.serverTimestamp(),
    };
    if (session.completedInMorning) updates.morningWorkoutDays = FieldValue.arrayUnion(session.localDate);
    // Save the session and its challenge progress atomically.
    const batch = db.batch();
    batch.set(sessionRef, { ...session, completedAt: FieldValue.serverTimestamp() });
    batch.set(challengeRef, updates, { merge: true });
    await batch.commit();
    const challenge = await challengeRef.get();
    res.status(201).json({ data: { sessionId: sessionRef.id, ...challengeResponse(challenge.data()) } });
  } catch (error) { next(error); }
});

app.put('/api/daily-water', async (req, res, next) => {
  try {
    const water = dailyWaterSchema.parse(req.body);
    const userRef = db.collection('users').doc(req.firebaseUser!.uid);
    const challengeRef = userRef.collection('challengeProgress').doc(weekKey(water.localDate));
    await userRef.collection('dailyMetrics').doc(water.localDate).set({
      waterGlasses: water.glasses,
      updatedAt: FieldValue.serverTimestamp(),
    }, { merge: true });
    // Reaching eight glasses adds today to the hydration challenge; dropping
    // below the goal removes it again.
    await challengeRef.set({
      weekKey: weekKey(water.localDate),
      hydrationDays: water.glasses >= 8
        ? FieldValue.arrayUnion(water.localDate)
        : FieldValue.arrayRemove(water.localDate),
      updatedAt: FieldValue.serverTimestamp(),
    }, { merge: true });
    const challenge = await challengeRef.get();
    res.json({ data: { waterGlasses: water.glasses, ...challengeResponse(challenge.data()) } });
  } catch (error) { next(error); }
});

app.use((_req, res) => {
  res.status(404).json({ error: 'Route not found.' });
});

const errorHandler: ErrorRequestHandler = (error, _req, res, _next) => {
  // Return validation details to the app, but avoid exposing server internals.
  if (error instanceof ZodError) {
    res.status(400).json({
      error: 'Request validation failed.',
      details: error.issues.map((issue) => ({
        field: issue.path.join('.'),
        message: issue.message,
      })),
    });
    return;
  }

  console.error(error);
  res.status(500).json({ error: 'An unexpected server error occurred.' });
};

app.use(errorHandler);

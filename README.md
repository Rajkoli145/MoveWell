# MoveWell

MoveWell is a Flutter fitness app with a separate TypeScript backend. Firebase Authentication owns user identity (email/password and Google), while the backend verifies Firebase ID tokens and stores each user's complete profile in Cloud Firestore.

## What is implemented

- Email/password registration and login
- Google login on Android, iOS, and web
- Firebase password-reset emails and persistent auth sessions
- Authenticated profile creation/read/update through `backend/`
- Firestore persistence for onboarding, body metrics, preferences, goals, profile metadata, and login metadata
- Real profile saves, goal updates, profile restoration, and logout
- Server-side validation and strict per-user document ownership

The app never sends a Firebase Admin credential to the client. Every API request carries the signed-in user's short-lived Firebase ID token, which the backend verifies before using that token's `uid` as the Firestore document ID.

## 1. Create the Firebase project

1. Create a Firebase project and add Android, iOS, and web apps.
2. Use Android package name `com.example.movewell` and the iOS bundle ID configured in Xcode, or change those identifiers in this project before registering the apps.
3. In Firebase Console → Authentication → Sign-in method, enable **Email/Password** and **Google**.
4. Add your Android debug/release SHA-1 and SHA-256 fingerprints to the Firebase Android app.
5. Create a Firestore database.
6. Deploy the deny-by-default client rules from `backend/firestore.rules`. All profile access goes through the Admin SDK backend.

To enable profile-photo uploads, open **Databases & Storage → Storage**, create the default bucket, then publish the rules in `backend/storage.rules`. The rules permit each signed-in user to write only a small image under their own `users/{uid}/avatar/` folder.

Firebase's native Google flow also needs platform registration:

- Android: use the Web OAuth client ID as `GOOGLE_SERVER_CLIENT_ID`.
- iOS: add the iOS OAuth client's reversed client ID as a URL scheme in `ios/Runner/Info.plist`, then provide the normal iOS client ID as `GOOGLE_IOS_CLIENT_ID`.
- Web: add your app domain to Firebase Authentication's authorized domains.

## 2. Run the backend

Node.js 22 or newer is required.

```bash
cd backend
cp .env.example .env
npm install
npm run dev
```

For local development, download a Firebase service-account JSON file, keep it outside the repository, and set its absolute path in `GOOGLE_APPLICATION_CREDENTIALS`. In Cloud Run or another Google Cloud runtime, prefer Application Default Credentials and set only `FIREBASE_PROJECT_ID`.

Useful backend commands:

```bash
npm test
npm run typecheck
npm run build
```

API routes:

- `GET /health` — public health check
- `POST /api/users/sync` — create or refresh the authenticated user's record
- `GET /api/profile` — fetch the authenticated user's profile
- `PUT /api/profile` — validate and save the complete profile

All `/api/*` routes require `Authorization: Bearer <Firebase ID token>`.

## 3. Configure and run Flutter

Copy the example build-time configuration:

```bash
cp config/firebase.example.json config/firebase.local.json
```

Fill it with the values from Firebase Console → Project settings → Your apps, then run:

```bash
flutter pub get
flutter run --dart-define-from-file=config/firebase.local.json
```

`BACKEND_URL` defaults to `http://10.0.2.2:8080` on the Android emulator and `http://127.0.0.1:8080` on other native targets. Set it to your computer's LAN IP for a physical phone, or to the deployed HTTPS API URL for production.

Do not commit `config/firebase.local.json`, `.env`, or any service-account file. Firebase web API keys identify the Firebase project but are not server credentials; backend authorization still depends on verified ID tokens and the Admin service identity.

## Firestore data layout

Profiles are stored at `users/{firebaseUid}`. Authentication-derived fields (`uid`, `email`, and provider) are controlled by the backend. User-editable values include name, avatar URL, date of birth, gender, height, weight, age, activity level, fitness goal, language, theme, notification preference, and onboarding status. The backend also maintains `createdAt`, `updatedAt`, and `lastLoginAt` timestamps.

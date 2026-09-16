import { z } from 'zod';

const boundedText = (max: number) => z.string().trim().max(max);

export const profileUpdateSchema = z.object({
  fullName: boundedText(100).min(1),
  subtitle: boundedText(180),
  avatarPath: boundedText(2048),
  dateOfBirth: boundedText(40),
  gender: boundedText(40),
  height: z.number().int().min(50).max(300),
  heightUnit: z.enum(['cm', 'ft']),
  weight: z.number().min(10).max(500),
  weightUnit: z.enum(['kg', 'lb']),
  age: z.number().int().min(13).max(120),
  activityLevel: boundedText(80),
  goal: boundedText(100),
  language: boundedText(40),
  theme: z.enum(['Light', 'Dark', 'System']),
  notificationsEnabled: z.boolean(),
  onboardingComplete: z.boolean(),
}).strict();

export type ProfileUpdate = z.infer<typeof profileUpdateSchema>;

export const routineCreateSchema = z.object({
  title: boundedText(100).min(1),
  level: z.enum(['Beginner', 'Intermediate', 'Advanced']),
  durationMinutes: z.number().int().min(5).max(240),
  exercises: z.array(boundedText(120).min(1)).max(30).default([]),
}).strict();

export const routineFavoriteSchema = z.object({
  favorite: z.boolean(),
}).strict();

const localDate = z.string().regex(/^\d{4}-\d{2}-\d{2}$/, 'Use YYYY-MM-DD.');

export const workoutSessionCreateSchema = z.object({
  workoutTitle: boundedText(100).min(1),
  routineId: boundedText(160).nullable().optional(),
  durationMinutes: z.number().int().min(1).max(300),
  exerciseCount: z.number().int().min(1).max(50),
  exercises: z.array(boundedText(120).min(1)).max(50).default([]),
  localDate,
  completedInMorning: z.boolean(),
}).strict();

export const dailyWaterSchema = z.object({
  glasses: z.number().int().min(0).max(30),
  localDate,
}).strict();

// A manual check-in is available for habits that happen away from the app,
// such as a walk or an early-morning movement session.
export const challengeCheckInSchema = z.object({
  challengeId: z.enum(['move-5-days', 'morning-momentum']),
  localDate,
  completed: z.boolean(),
}).strict();

import assert from 'node:assert/strict';
import { describe, it } from 'node:test';
import { profileUpdateSchema, workoutSessionCreateSchema } from '../src/profile-schema.js';

const validProfile = {
  fullName: 'Asha Rao',
  subtitle: 'Stronger every day',
  avatarPath: '',
  dateOfBirth: '12 Jun 2000',
  gender: 'Female',
  height: 165,
  heightUnit: 'cm',
  weight: 58,
  weightUnit: 'kg',
  age: 26,
  activityLevel: 'Moderately Active',
  goal: 'Build Strength',
  language: 'English',
  theme: 'Light',
  notificationsEnabled: true,
  onboardingComplete: true,
};

describe('profileUpdateSchema', () => {
  it('accepts a complete valid profile', () => {
    assert.equal(profileUpdateSchema.parse(validProfile).fullName, 'Asha Rao');
  });

  it('rejects impossible measurements and unknown fields', () => {
    assert.equal(profileUpdateSchema.safeParse({ ...validProfile, height: 900 }).success, false);
    assert.equal(profileUpdateSchema.safeParse({ ...validProfile, role: 'admin' }).success, false);
  });
});

describe('workoutSessionCreateSchema', () => {
  it('accepts a preset workout without a custom routine id', () => {
    assert.equal(workoutSessionCreateSchema.parse({
      workoutTitle: 'Full Body Strength',
      routineId: null,
      durationMinutes: 30,
      exerciseCount: 4,
      exercises: ['Squat', 'Push-up', 'Lunge', 'Plank'],
      localDate: '2026-09-15',
      completedInMorning: true,
    }).routineId, null);
  });
});

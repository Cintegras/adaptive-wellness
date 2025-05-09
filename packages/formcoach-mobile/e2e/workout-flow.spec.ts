import { test, expect } from '@playwright/test';
import { login } from './helpers/login';

test.describe('Workout Flow', () => {
  test('user can create and complete a workout', async ({ page }) => {
    // Login
    await login(page, 'testuser@formcoach.dev');
    
    // Navigate to workout plans
    await page.goto('/workout-plans');
    
    // Create a new plan
    await page.click('text=Create New Plan');
    await page.fill('input[placeholder="Enter plan name"]', 'E2E Test Plan');
    
    // Add an exercise
    await page.click('text=Add Exercise');
    await page.fill('input[placeholder="Exercise name"]', 'Push-ups');
    await page.fill('input[placeholder="Sets"]', '3');
    await page.fill('input[placeholder="Reps"]', '10');
    
    // Save the plan
    await page.click('button:has-text("Save Plan")');
    
    // Verify plan was created
    await page.waitForURL('**/workout-plans');
    await expect(page.locator('text=E2E Test Plan')).toBeVisible();
    
    // Start the workout
    await page.click('text=E2E Test Plan');
    await page.click('text=Start Workout');
    
    // Complete the workout
    await page.click('text=Complete Workout');
    
    // Verify workout appears in history
    await page.goto('/workout-history');
    await expect(page.locator('text=E2E Test Plan')).toBeVisible();
  });
});
import { test, expect } from '@playwright/test'

test.describe('Basic tests', () => {
  test.beforeEach(async ({ page }) => {
    await page.goto('/')
  })

  test('page loads successfully', async ({ page }) => {
    await expect(page).toHaveTitle(/Content Automation Platform/)
    await expect(page.getByRole('heading', { name: 'Dashboard' })).toBeVisible()
  })

  test('navigation works', async ({ page }) => {
    // Navigate to Analytics page using the sidebar link
    await page.getByRole('navigation').getByRole('link', { name: 'Analytics' }).click()
    await expect(page).toHaveURL(/.*analytics/)

    // Navigate back to Dashboard
    await page.getByRole('navigation').getByRole('link', { name: 'Dashboard' }).click()
    await expect(page).toHaveURL(/.*\/$/)
  })

  test('responsive design works', async ({ page }) => {
    await page.setViewportSize({ width: 375, height: 667 }) // Mobile
    await expect(page.locator('.mobile-menu')).toBeVisible()

    await page.setViewportSize({ width: 1200, height: 800 }) // Desktop
    await expect(page.locator('.mobile-menu')).not.toBeVisible()
    await expect(page.getByRole('navigation')).toBeVisible()
  })
})

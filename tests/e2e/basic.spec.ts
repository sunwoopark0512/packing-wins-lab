import { test, expect } from '@playwright/test'

test.describe('Basic tests', () => {
  test.beforeEach(async ({ page }) => {
    await page.goto('/')
  })

  test('page loads successfully', async ({ page }) => {
    await expect(page).toHaveTitle(/Content Automation Platform/)
    await expect(page.locator('h1')).toBeVisible()
  })

  test('navigation works', async ({ page }) => {
    await page.click('text=Dashboard')
    await expect(page).toHaveURL(/.*dashboard/)

    await page.click('text=Settings')
    await expect(page).toHaveURL(/.*settings/)
  })

  test('responsive design works', async ({ page }) => {
    await page.setViewportSize({ width: 375, height: 667 }) // Mobile
    await expect(page.locator('.mobile-menu')).toBeVisible()

    await page.setViewportSize({ width: 1200, height: 800 }) // Desktop
    await expect(page.locator('.desktop-nav')).toBeVisible()
  })

  test('form submission works', async ({ page }) => {
    await page.click('text=Create Content')
    await page.fill('[data-testid="content-title"]', 'Test Content')
    await page.fill('[data-testid="content-body"]', 'This is test content')
    await page.click('text=Submit')

    await expect(page.locator('.success-message')).toBeVisible()
  })
})

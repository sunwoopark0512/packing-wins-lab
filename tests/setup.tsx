import '@testing-library/jest-dom'
import React from 'react'
import { beforeAll, afterEach, vi } from 'vitest'

// Mock IntersectionObserver
global.IntersectionObserver = class IntersectionObserver {
  constructor() {}
  disconnect() {}
  observe() {}
  unobserve() {}
}

// Mock ResizeObserver
global.ResizeObserver = class ResizeObserver {
  constructor() {}
  disconnect() {}
  observe() {}
  unobserve() {}
}

// Mock matchMedia
Object.defineProperty(window, 'matchMedia', {
  writable: true,
  value: (query: string) => ({
    matches: false,
    media: query,
    onchange: null,
    addListener: () => {},
    removeListener: () => {},
    addEventListener: () => {},
    removeEventListener: () => {},
    dispatchEvent: () => {},
  }),
})

// Mock react-router-dom
const mockLocation = { pathname: '/', search: '', hash: '', state: null }
const mockNavigate = vi.fn()

vi.mock('react-router-dom', async (importOriginal) => {
  const actual = await importOriginal<typeof import('react-router-dom')>()
  return {
    ...actual,
    BrowserRouter: ({ children }: { children: React.ReactNode }) =>
      React.createElement('div', null, children),
    Routes: ({ children }: { children: React.ReactNode }) =>
      React.createElement('div', null, children),
    Route: ({ children }: { children: React.ReactNode }) =>
      React.createElement('div', null, children),
    useLocation: () => mockLocation,
    useNavigate: () => mockNavigate,
  }
})

// Mock fetch
beforeAll(() => {
  global.fetch = vi.fn()
})

// Cleanup after each test
afterEach(() => {
  vi.clearAllMocks()
})

// Setup tests
beforeAll(() => {
  // Add any global test setup here
})

/// <reference types="vitest" />
import { defineConfig } from 'vite'
import react from '@vitejs/plugin-react-swc'
import { resolve } from 'path'

export default defineConfig({
  plugins: [react()],
  resolve: {
    alias: {
      '@': resolve(__dirname, 'src'),
    }
  },
  test: {
    globals: true,
    environment: 'jsdom',
    setupFiles: './tests/setup.tsx',
    exclude: ['**/node_modules/**', '**/dist/**', '**/e2e/**', 'tests/e2e/**'],
    coverage: {
      provider: 'v8',
      exclude: ['**/node_modules/**', '**/dist/**', '**/e2e/**', 'tests/e2e/**', 'vite.config.ts', 'vitest.config.ts', '.eslintrc.cjs']
    }
  }
})
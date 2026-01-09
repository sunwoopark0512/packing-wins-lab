import { render, screen } from '@testing-library/react'
import { describe, it, expect } from 'vitest'
import App from '@/App'

describe('App Component', () => {
  it('renders without crashing', () => {
    render(<App />)
    expect(screen.getAllByText(/Content Automation/i)[0]).toBeInTheDocument()
  })
})
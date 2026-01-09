import { create } from 'zustand'
import { Content, Platform, DashboardStats, FilterOptions, Notification } from '@/types'

interface AppState {
  contents: Content[]
  platforms: Platform[]
  stats: DashboardStats
  filters: FilterOptions
  notifications: Notification[]
  darkMode: boolean
  sidebarOpen: boolean

  // Actions
  setContents: (contents: Content[]) => void
  addContent: (content: Content) => void
  updateContent: (id: string, content: Partial<Content>) => void
  deleteContent: (id: string) => void
  setFilters: (filters: FilterOptions) => void
  setDarkMode: (enabled: boolean) => void
  toggleSidebar: () => void
  addNotification: (notification: Omit<Notification, 'id' | 'timestamp' | 'read'>) => void
  markNotificationAsRead: (id: string) => void
  clearNotifications: () => void
}

const useStore = create<AppState>((set) => ({
  contents: [],
  platforms: [
    { id: 'twitter', name: 'Twitter', icon: '🐦', color: '#1DA1F2', connected: true },
    { id: 'linkedin', name: 'LinkedIn', icon: '💼', color: '#0077B5', connected: true },
    { id: 'facebook', name: 'Facebook', icon: '📘', color: '#4267B2', connected: false },
    { id: 'instagram', name: 'Instagram', icon: '📸', color: '#E4405F', connected: true },
    { id: 'blog', name: 'Blog', icon: '📝', color: '#6366F1', connected: true },
  ],
  stats: {
    totalContent: 0,
    published: 0,
    scheduled: 0,
    drafts: 0,
    platforms: 5,
    totalViews: 0,
    totalEngagement: 0,
    growthRate: 0,
  },
  filters: {},
  notifications: [],
  darkMode: false,
  sidebarOpen: true,

  setContents: (contents) => {
    const published = contents.filter((c) => c.status === 'published').length
    const scheduled = contents.filter((c) => c.status === 'scheduled').length
    const drafts = contents.filter((c) => c.status === 'draft').length
    const totalViews = contents.reduce((sum, c) => sum + (c.analytics?.views || 0), 0)
    const totalEngagement = contents.reduce((sum, c) => sum + (c.analytics?.engagement || 0), 0)

    set((state) => ({
      contents,
      stats: {
        ...state.stats,
        totalContent: contents.length,
        published,
        scheduled,
        drafts,
        totalViews,
        totalEngagement,
        growthRate: Math.round((published / (contents.length || 1)) * 100),
      },
    }))
  },

  addContent: (content) => {
    set((state) => ({
      contents: [...state.contents, content],
    }))
    set((state) => {
      const total = state.contents.length
      const published = state.contents.filter((c) => c.status === 'published').length
      return {
        stats: {
          ...state.stats,
          totalContent: total,
          published,
          growthRate: Math.round((published / (total || 1)) * 100),
        },
      }
    })
  },

  updateContent: (id, updates) => {
    set((state) => ({
      contents: state.contents.map((content) =>
        content.id === id ? { ...content, ...updates, updatedAt: new Date() } : content,
      ),
    }))
  },

  deleteContent: (id) => {
    set((state) => ({
      contents: state.contents.filter((content) => content.id !== id),
    }))
  },

  setFilters: (filters) => set({ filters }),

  setDarkMode: (enabled) => {
    set({ darkMode: enabled })
    if (enabled) {
      document.documentElement.classList.add('dark')
    } else {
      document.documentElement.classList.remove('dark')
    }
  },

  toggleSidebar: () => set((state) => ({ sidebarOpen: !state.sidebarOpen })),

  addNotification: (notification) => {
    const id = Date.now().toString()
    set((state) => ({
      notifications: [{ ...notification, id, timestamp: new Date(), read: false }, ...state.notifications],
    }))
  },

  markNotificationAsRead: (id) => {
    set((state) => ({
      notifications: state.notifications.map((n) => (n.id === id ? { ...n, read: true } : n)),
    }))
  },

  clearNotifications: () => set({ notifications: [] }),
}))

export default useStore

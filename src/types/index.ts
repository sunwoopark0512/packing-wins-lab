export interface Content {
  id: string
  title: string
  body: string
  status: 'draft' | 'published' | 'scheduled'
  platform: string
  createdAt: Date
  updatedAt: Date
  publishedAt?: Date
  author: string
  tags: string[]
  analytics?: {
    views: number
    clicks: number
    shares: number
    engagement: number
  }
}

export interface Platform {
  id: string
  name: string
  icon: string
  color: string
  connected: boolean
}

export interface DashboardStats {
  totalContent: number
  published: number
  scheduled: number
  drafts: number
  platforms: number
  totalViews: number
  totalEngagement: number
  growthRate: number
}

export interface ChartData {
  labels: string[]
  datasets: {
    label: string
    data: number[]
    backgroundColor?: string
    borderColor?: string
  }[]
}

export interface FilterOptions {
  status?: string[]
  platform?: string[]
  dateRange?: {
    start: Date
    end: Date
  }
  author?: string
  tags?: string[]
  search?: string
}

export interface ExportOptions {
  format: 'csv' | 'json' | 'pdf'
  includeAnalytics: boolean
  dateRange?: {
    start: Date
    end: Date
  }
}

export interface Notification {
  id: string
  type: 'success' | 'error' | 'warning' | 'info'
  title: string
  message: string
  timestamp: Date
  read: boolean
}

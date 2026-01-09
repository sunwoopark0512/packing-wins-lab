import React, { useEffect, useState } from 'react'
import { Plus, Filter, TrendingUp, Users, FileText, Calendar, Download } from 'lucide-react'
import useStore from '@/store/useStore'
import { PieChart, BarChart, LineChart } from '@/components/Charts'
import FilterPanel from '@/components/FilterPanel'
import ExportModal from '@/components/ExportModal'
import { generateDummyChartData } from '@/utils/charts'
import { Content } from '@/types'

const Dashboard: React.FC = () => {
  const { contents, stats, platforms, filters, setFilters, addContent, addNotification } = useStore()
  const [showFilters, setShowFilters] = useState(false)
  const [showExport, setShowExport] = useState(false)
  const [recentActivity, setRecentActivity] = useState<Content[]>([])

  useEffect(() => {
    // Generate dummy data
    const dummyContents: Content[] = Array.from({ length: 25 }, (_, i) => ({
      id: `content-${i}`,
      title: [
        'Understanding Modern Web Development',
        'The Future of AI in Content Creation',
        'Best Practices for Social Media',
        'Content Marketing Strategies 2024',
        'Building Scalable Applications',
        'UX Design Principles',
        'API Development Guide',
        'Cloud Computing Trends',
        'Data Science Fundamentals',
        'Cybersecurity Best Practices',
      ][i % 10],
      body: 'This is sample content for demonstration purposes...',
      // eslint-disable-next-line @typescript-eslint/no-explicit-any
      status: ['draft', 'published', 'scheduled'][i % 3] as any,
      platform: ['Twitter', 'LinkedIn', 'Facebook', 'Instagram', 'Blog'][i % 5],
      createdAt: new Date(Date.now() - i * 24 * 60 * 60 * 1000),
      updatedAt: new Date(Date.now() - i * 12 * 60 * 60 * 1000),
      publishedAt: i % 3 === 1 ? new Date(Date.now() - i * 24 * 60 * 60 * 1000) : undefined,
      author: ['John Doe', 'Jane Smith', 'Bob Wilson', 'Alice Brown'][i % 4],
      tags: ['News', 'Tutorial', 'Update', 'Promotion'][i % 4].split(','),
      analytics:
        i % 3 === 1
          ? {
            views: Math.floor(Math.random() * 5000) + 1000,
            clicks: Math.floor(Math.random() * 500) + 100,
            shares: Math.floor(Math.random() * 100) + 10,
            engagement: Math.floor(Math.random() * 200) + 50,
          }
          : undefined,
    }))

    setFilters({})
    addContent(dummyContents[0])
    addNotification({
      type: 'success',
      title: 'Dashboard Loaded',
      message: 'Your data has been successfully loaded.',
    })

    // Set recent activity (last 5 items)
    setRecentActivity(dummyContents.slice(0, 5))

    // For demo, update store with all contents
    // In real app, this would be done by fetching from API
    useStore.setState({ contents: dummyContents })
  }, [])

  const chartData = generateDummyChartData()

  const platformData = platforms
    .map((platform) => ({
      platform: platform.name,
      count: contents.filter((c) => c.platform === platform.name).length,
    }))
    .filter((item) => item.count > 0)

  const filteredContents = contents.filter((content) => {
    if (filters.status && !filters.status.includes(content.status)) return false
    if (filters.platform && !filters.platform.includes(content.platform)) return false
    if (filters.search && !content.title.toLowerCase().includes(filters.search.toLowerCase())) return false
    if (filters.tags && !filters.tags.some((tag) => content.tags.includes(tag))) return false
    if (filters.author && content.author !== filters.author) return false
    if (filters.dateRange) {
      const contentDate = content.createdAt
      if (filters.dateRange.start && contentDate < filters.dateRange.start) return false
      if (filters.dateRange.end && contentDate > filters.dateRange.end) return false
    }
    return true
  })

  return (
    <div className="min-h-screen bg-gray-50 dark:bg-gray-900">
      <div className="p-6 lg:p-8">
        {/* Header */}
        <div className="flex flex-col md:flex-row md:items-center md:justify-between gap-4 mb-8">
          <div>
            <h1 className="text-3xl font-bold text-gray-900 dark:text-white">Dashboard</h1>
            <p className="text-gray-600 dark:text-gray-400 mt-1">
              Welcome back! Here's what's happening with your content.
            </p>
          </div>
          <div className="flex gap-3">
            <button
              onClick={() => setShowFilters(true)}
              className="btn btn-secondary flex items-center gap-2"
            >
              <Filter size={20} />
              Filters
              {Object.keys(filters).length > 0 && (
                <span className="px-2 py-0.5 text-xs font-medium bg-[var(--primary)] text-white rounded-full">
                  {Object.keys(filters).length}
                </span>
              )}
            </button>
            <button onClick={() => setShowExport(true)} className="btn btn-secondary flex items-center gap-2">
              <Download size={20} />
              Export
            </button>
            <button className="btn btn-primary flex items-center gap-2">
              <Plus size={20} />
              Create Content
            </button>
          </div>
        </div>

        {/* KPI Cards */}
        <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-6 mb-8">
          <div className="card">
            <div className="flex items-center justify-between mb-4">
              <div className="p-3 bg-blue-100 dark:bg-blue-900 rounded-lg">
                <FileText size={24} className="text-blue-600 dark:text-blue-400" />
              </div>
              <span className="text-sm font-medium text-green-600 dark:text-green-400 flex items-center gap-1">
                <TrendingUp size={16} />
                +{stats.growthRate}%
              </span>
            </div>
            <h3 className="text-2xl font-bold text-gray-900 dark:text-white">{stats.totalContent}</h3>
            <p className="text-sm text-gray-600 dark:text-gray-400">Total Content</p>
          </div>

          <div className="card">
            <div className="flex items-center justify-between mb-4">
              <div className="p-3 bg-green-100 dark:bg-green-900 rounded-lg">
                <Users size={24} className="text-green-600 dark:text-green-400" />
              </div>
              <span className="text-sm font-medium text-green-600 dark:text-green-400 flex items-center gap-1">
                <TrendingUp size={16} />
                +12%
              </span>
            </div>
            <h3 className="text-2xl font-bold text-gray-900 dark:text-white">{stats.totalViews.toLocaleString()}</h3>
            <p className="text-sm text-gray-600 dark:text-gray-400">Total Views</p>
          </div>

          <div className="card">
            <div className="flex items-center justify-between mb-4">
              <div className="p-3 bg-purple-100 dark:bg-purple-900 rounded-lg">
                <TrendingUp size={24} className="text-purple-600 dark:text-purple-400" />
              </div>
              <span className="text-sm font-medium text-green-600 dark:text-green-400 flex items-center gap-1">
                <TrendingUp size={16} />
                +8%
              </span>
            </div>
            <h3 className="text-2xl font-bold text-gray-900 dark:text-white">
              {stats.totalEngagement.toLocaleString()}
            </h3>
            <p className="text-sm text-gray-600 dark:text-gray-400">Engagement</p>
          </div>

          <div className="card">
            <div className="flex items-center justify-between mb-4">
              <div className="p-3 bg-orange-100 dark:bg-orange-900 rounded-lg">
                <Calendar size={24} className="text-orange-600 dark:text-orange-400" />
              </div>
              <span className="text-sm font-medium text-blue-600 dark:text-blue-400">This Month</span>
            </div>
            <h3 className="text-2xl font-bold text-gray-900 dark:text-white">{stats.published}</h3>
            <p className="text-sm text-gray-600 dark:text-gray-400">Published</p>
          </div>
        </div>

        {/* Charts */}
        <div className="grid grid-cols-1 lg:grid-cols-2 gap-6 mb-8">
          <div className="card">
            <h3 className="text-lg font-bold text-gray-900 dark:text-white mb-4">Content Status</h3>
            <PieChart
              data={[
                { label: 'Drafts', value: stats.drafts, color: '#fbbf24' },
                { label: 'Published', value: stats.published, color: '#10b981' },
                { label: 'Scheduled', value: stats.scheduled, color: '#3b82f6' },
              ]}
            />
          </div>

          <div className="card">
            <h3 className="text-lg font-bold text-gray-900 dark:text-white mb-4">Platform Distribution</h3>
            <BarChart
              data={platformData.map((item) => ({
                label: item.platform,
                value: item.count,
                color: platforms.find((p) => p.name === item.platform)?.color,
              }))}
              height={300}
              width={600}
            />
          </div>
        </div>

        <div className="card mb-8">
          <h3 className="text-lg font-bold text-gray-900 dark:text-white mb-4">Engagement Over Time</h3>
          <LineChart
            data={chartData.engagement.labels.map((label: string, i: number) => ({
              label,
              // eslint-disable-next-line @typescript-eslint/no-explicit-any
              value: (chartData.engagement.datasets[0].data as any[])[i] || 0,
            }))}
            height={300}
            width={1000}
            color="#667eea"
          />
        </div>

        {/* Recent Activity */}
        <div className="card">
          <div className="flex items-center justify-between mb-6">
            <h3 className="text-lg font-bold text-gray-900 dark:text-white">Recent Activity</h3>
            <button className="text-sm text-[var(--primary)] hover:underline">View All</button>
          </div>
          <div className="space-y-4">
            {recentActivity.map((item) => (
              <div
                key={item.id}
                className="flex items-center justify-between p-4 bg-gray-50 dark:bg-gray-900 rounded-lg hover:bg-gray-100 dark:hover:bg-gray-800 transition-colors cursor-pointer"
              >
                <div className="flex-1">
                  <h4 className="font-medium text-gray-900 dark:text-white">{item.title}</h4>
                  <div className="flex items-center gap-4 mt-1 text-sm text-gray-600 dark:text-gray-400">
                    <span>{item.platform}</span>
                    <span>•</span>
                    <span>{item.author}</span>
                    <span>•</span>
                    <span>{item.createdAt.toLocaleDateString()}</span>
                  </div>
                </div>
                <div className="flex items-center gap-2">
                  <span
                    className={`px-3 py-1 rounded-full text-xs font-medium ${item.status === 'published'
                      ? 'bg-green-100 text-green-800 dark:bg-green-900 dark:text-green-300'
                      : item.status === 'scheduled'
                        ? 'bg-blue-100 text-blue-800 dark:bg-blue-900 dark:text-blue-300'
                        : 'bg-yellow-100 text-yellow-800 dark:bg-yellow-900 dark:text-yellow-300'
                      }`}
                  >
                    {item.status}
                  </span>
                  {item.analytics && (
                    <div className="flex items-center gap-3 text-sm text-gray-600 dark:text-gray-400">
                      <span className="flex items-center gap-1">
                        <Users size={16} />
                        {item.analytics.views}
                      </span>
                      <span className="flex items-center gap-1">
                        <TrendingUp size={16} />
                        {item.analytics.engagement}
                      </span>
                    </div>
                  )}
                </div>
              </div>
            ))}
          </div>
        </div>
      </div>

      {/* Filter Panel */}
      <FilterPanel isOpen={showFilters} onClose={() => setShowFilters(false)} filters={filters} onFiltersChange={setFilters} />

      {/* Export Modal */}
      <ExportModal isOpen={showExport} onClose={() => setShowExport(false)} data={filteredContents} />
    </div>
  )
}

export default Dashboard

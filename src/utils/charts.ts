/* eslint-disable @typescript-eslint/no-explicit-any */
// import { ChartData } from 'chart.js'

/**
 * Prepare data for content status distribution chart
 */
export const prepareStatusChartData = (
  drafts: number,
  published: number,
  scheduled: number
): any => {
  return {
    labels: ['Drafts', 'Published', 'Scheduled'],
    datasets: [
      {
        label: 'Content Status',
        data: [drafts, published, scheduled],
        backgroundColor: ['#fbbf24', '#10b981', '#3b82f6'],
        borderColor: ['#f59e0b', '#059669', '#2563eb'],
        borderWidth: 2,
      },
    ],
  }
}

/**
 * Prepare data for platform distribution chart
 */
export const preparePlatformChartData = (
  platformData: { platform: string; count: number }[]
): any => {
  return {
    labels: platformData.map((item) => item.platform),
    datasets: [
      {
        label: 'Content by Platform',
        data: platformData.map((item) => item.count),
        backgroundColor: ['#1DA1F2', '#0077B5', '#4267B2', '#E4405F', '#6366F1'],
        borderColor: ['#1a8cd8', '#005885', '#365899', '#cc3963', '#5558d3'],
        borderWidth: 2,
      },
    ],
  }
}

/**
 * Prepare data for engagement over time chart
 */
export const prepareEngagementChartData = (
  data: { date: string; views: number; engagement: number }[]
): any => {
  return {
    labels: data.map((item) => item.date),
    datasets: [
      {
        label: 'Views',
        data: data.map((item) => item.views),
        borderColor: '#667eea',
        backgroundColor: 'rgba(102, 126, 234, 0.1)',
        fill: true,
        tension: 0.4,
      },
      {
        label: 'Engagement',
        data: data.map((item) => item.engagement),
        borderColor: '#764ba2',
        backgroundColor: 'rgba(118, 75, 162, 0.1)',
        fill: true,
        tension: 0.4,
      },
    ],
  }
}

/**
 * Prepare data for content growth chart
 */
export const prepareGrowthChartData = (
  data: { date: string; total: number; published: number }[]
): any => {
  return {
    labels: data.map((item) => item.date),
    datasets: [
      {
        label: 'Total Content',
        data: data.map((item) => item.total),
        borderColor: '#10b981',
        backgroundColor: 'rgba(16, 185, 129, 0.1)',
        fill: true,
        tension: 0.4,
      },
      {
        label: 'Published',
        data: data.map((item) => item.published),
        borderColor: '#3b82f6',
        backgroundColor: 'rgba(59, 130, 246, 0.1)',
        fill: true,
        tension: 0.4,
      },
    ],
  }
}

/**
 * Generate dummy data for charts
 */
export const generateDummyChartData = () => {
  const last30Days = Array.from({ length: 30 }, (_, i) => {
    const date = new Date()
    date.setDate(date.getDate() - (29 - i))
    return date.toLocaleDateString('en-US', { month: 'short', day: 'numeric' })
  })

  const engagementData = last30Days.map((date) => ({
    date,
    views: Math.floor(Math.random() * 1000) + 500,
    engagement: Math.floor(Math.random() * 200) + 50,
  }))

  const growthData = last30Days.map((date, i) => ({
    date,
    total: (i + 1) * 3,
    published: Math.floor((i + 1) * 2.5),
  }))

  return {
    engagement: prepareEngagementChartData(engagementData),
    growth: prepareGrowthChartData(growthData),
  }
}

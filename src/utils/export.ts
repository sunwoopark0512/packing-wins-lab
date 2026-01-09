import { Content, ExportOptions } from '@/types'

/**
 * Export data to CSV format
 */
export const exportToCSV = (data: Content[], filename: string = 'export.csv') => {
  if (!data.length) return

  const headers = [
    'Title',
    'Status',
    'Platform',
    'Author',
    'Created',
    'Updated',
    'Views',
    'Engagement',
  ]
  const rows = data.map((item) => [
    `"${item.title.replace(/"/g, '""')}"`,
    item.status,
    item.platform,
    item.author,
    item.createdAt.toISOString(),
    item.updatedAt.toISOString(),
    item.analytics?.views || 0,
    item.analytics?.engagement || 0,
  ])

  const csvContent = [headers.join(','), ...rows.map((row) => row.join(','))].join('\n')
  downloadFile(csvContent, filename, 'text/csv;charset=utf-8;')
}

/**
 * Export data to JSON format
 */
export const exportToJSON = (data: Content[], filename: string = 'export.json') => {
  const jsonContent = JSON.stringify(data, null, 2)
  downloadFile(jsonContent, filename, 'application/json;charset=utf-8;')
}

/**
 * Export data to PDF format (basic text-based PDF)
 * For production, consider using libraries like jsPDF or react-pdf
 */
export const exportToPDF = (data: Content[], filename: string = 'export.pdf') => {
  const title = 'Content Export Report'
  const date = new Date().toLocaleString()

  let pdfContent = `${title}\n\n`
  pdfContent += `Generated: ${date}\n`
  pdfContent += `Total Items: ${data.length}\n\n`
  pdfContent += `${'='.repeat(80)}\n\n`

  data.forEach((item, index) => {
    pdfContent += `[${index + 1}] ${item.title}\n`
    pdfContent += `${`-`.repeat(80)}\n`
    pdfContent += `Status: ${item.status}\n`
    pdfContent += `Platform: ${item.platform}\n`
    pdfContent += `Author: ${item.author}\n`
    pdfContent += `Created: ${item.createdAt.toLocaleString()}\n`
    pdfContent += `Updated: ${item.updatedAt.toLocaleString()}\n`
    if (item.analytics) {
      pdfContent += `Views: ${item.analytics.views}\n`
      pdfContent += `Engagement: ${item.analytics.engagement}\n`
    }
    pdfContent += `Tags: ${item.tags.join(', ')}\n\n`
    pdfContent += `${item.body.substring(0, 200)}${item.body.length > 200 ? '...' : ''}\n\n`
    pdfContent += `${'='.repeat(80)}\n\n`
  })

  // Note: This creates a text file with .pdf extension
  // For proper PDF generation, use jsPDF or react-pdf
  downloadFile(pdfContent, filename.replace('.pdf', '.txt'), 'text/plain;charset=utf-8;')

  console.warn(
    'Note: PDF export currently generates a text file. Use jsPDF for proper PDF generation.'
  )
}

/**
 * Generic function to download a file
 */
const downloadFile = (content: string, filename: string, mimeType: string) => {
  const blob = new Blob([content], { type: mimeType })
  const url = URL.createObjectURL(blob)
  const link = document.createElement('a')
  link.href = url
  link.download = filename
  document.body.appendChild(link)
  link.click()
  document.body.removeChild(link)
  URL.revokeObjectURL(url)
}

/**
 * Export data based on format selection
 */
export const exportData = (data: Content[], options: ExportOptions) => {
  const timestamp = new Date().toISOString().split('T')[0]

  switch (options.format) {
    case 'csv':
      exportToCSV(data, `content-export-${timestamp}.csv`)
      break
    case 'json':
      exportToJSON(data, `content-export-${timestamp}.json`)
      break
    case 'pdf':
      exportToPDF(data, `content-export-${timestamp}.pdf`)
      break
    default:
      throw new Error(`Unsupported export format: ${options.format}`)
  }
}

/**
 * Filter data based on date range
 */
export const filterByDateRange = (data: Content[], start?: Date, end?: Date) => {
  if (!start && !end) return data

  return data.filter((item) => {
    const itemDate = item.createdAt
    if (start && itemDate < start) return false
    if (end && itemDate > end) return false
    return true
  })
}

/**
 * Filter data based on export options
 */
export const getFilteredExportData = (data: Content[], options: ExportOptions) => {
  let filteredData = [...data]

  // Apply date range filter
  if (options.dateRange) {
    filteredData = filterByDateRange(filteredData, options.dateRange.start, options.dateRange.end)
  }

  // Remove analytics if not requested
  if (!options.includeAnalytics) {
    filteredData = filteredData.map((item) => ({
      ...item,
      analytics: undefined,
    }))
  }

  return filteredData
}

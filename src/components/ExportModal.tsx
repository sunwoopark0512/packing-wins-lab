import React, { useState } from 'react'
import { Download, FileDown, FileText, FileJson, Check, Calendar, X } from 'lucide-react'
import { ExportOptions, Content } from '@/types'
import { exportData, getFilteredExportData } from '@/utils/export'

interface ExportModalProps {
  isOpen: boolean
  onClose: () => void
  data: Content[]
}

const ExportModal: React.FC<ExportModalProps> = ({ isOpen, onClose, data }) => {
  const [format, setFormat] = useState<'csv' | 'json' | 'pdf'>('csv')
  const [includeAnalytics, setIncludeAnalytics] = useState(true)
  const [dateRange, setDateRange] = useState<{ start?: Date; end?: Date }>({})
  const [isExporting, setIsExporting] = useState(false)
  const [showSuccess, setShowSuccess] = useState(false)

  if (!isOpen) return null

  const handleExport = async () => {
    setIsExporting(true)

    try {
      const exportOptions: ExportOptions = {
        format,
        includeAnalytics,
        dateRange: dateRange.start && dateRange.end ? dateRange : undefined,
      }

      const filteredData = getFilteredExportData(data, exportOptions)
      exportData(filteredData, exportOptions)

      setShowSuccess(true)
      setTimeout(() => {
        setShowSuccess(false)
        onClose()
      }, 2000)
    } catch (error) {
      console.error('Export failed:', error)
      alert('Export failed. Please try again.')
    } finally {
      setIsExporting(false)
    }
  }

  const exportFormats = [
    {
      value: 'csv' as const,
      label: 'CSV',
      icon: FileText,
      description: 'Spreadsheet compatible format',
    },
    {
      value: 'json' as const,
      label: 'JSON',
      icon: FileJson,
      description: 'Developer-friendly format',
    },
    { value: 'pdf' as const, label: 'PDF', icon: FileDown, description: 'Print-ready document' },
  ]

  return (
    <div className='fixed inset-0 bg-black bg-opacity-50 z-50 flex items-center justify-center p-4'>
      <div className='bg-white dark:bg-gray-800 rounded-xl shadow-2xl w-full max-w-lg animate-fade-in'>
        {/* Success state */}
        {showSuccess ? (
          <div className='p-12 text-center'>
            <div className='w-20 h-20 mx-auto mb-4 bg-green-100 dark:bg-green-900 rounded-full flex items-center justify-center'>
              <Check size={40} className='text-green-600 dark:text-green-400' />
            </div>
            <h3 className='text-xl font-bold text-gray-900 dark:text-white mb-2'>
              Export Successful!
            </h3>
            <p className='text-gray-600 dark:text-gray-400'>Your file has been downloaded.</p>
          </div>
        ) : (
          <>
            {/* Header */}
            <div className='p-6 border-b border-gray-200 dark:border-gray-700 flex items-center justify-between'>
              <div className='flex items-center gap-2'>
                <Download size={20} className='text-[var(--primary)]' />
                <h2 className='text-lg font-bold text-gray-900 dark:text-white'>Export Data</h2>
              </div>
              <button
                onClick={onClose}
                className='p-2 rounded-lg hover:bg-gray-100 dark:hover:bg-gray-700 transition-colors'
              >
                <X size={20} className='text-gray-500' />
              </button>
            </div>

            {/* Content */}
            <div className='p-6 space-y-6'>
              {/* Format Selection */}
              <div>
                <label className='block text-sm font-medium text-gray-700 dark:text-gray-300 mb-3'>
                  Export Format
                </label>
                <div className='grid grid-cols-3 gap-3'>
                  {exportFormats.map((item) => {
                    const Icon = item.icon
                    return (
                      <button
                        key={item.value}
                        onClick={() => setFormat(item.value)}
                        className={`p-4 rounded-lg border-2 transition-all text-center ${
                          format === item.value
                            ? 'border-[var(--primary)] bg-[var(--primary)] bg-opacity-10'
                            : 'border-gray-200 dark:border-gray-700 hover:border-gray-300 dark:hover:border-gray-600'
                        }`}
                      >
                        <Icon
                          size={24}
                          className={`mx-auto mb-2 ${format === item.value ? 'text-[var(--primary)]' : 'text-gray-500'}`}
                        />
                        <div className='text-sm font-medium text-gray-900 dark:text-white'>
                          {item.label}
                        </div>
                      </button>
                    )
                  })}
                </div>
              </div>

              {/* Include Analytics */}
              <div>
                <label className='flex items-center justify-between cursor-pointer'>
                  <span className='text-sm font-medium text-gray-700 dark:text-gray-300'>
                    Include Analytics Data
                  </span>
                  <div className='relative'>
                    <input
                      type='checkbox'
                      checked={includeAnalytics}
                      onChange={(e) => setIncludeAnalytics(e.target.checked)}
                      className='sr-only'
                    />
                    <div
                      className={`w-11 h-6 rounded-full transition-colors ${
                        includeAnalytics ? 'bg-[var(--primary)]' : 'bg-gray-300 dark:bg-gray-600'
                      }`}
                    >
                      <div
                        className={`w-5 h-5 bg-white rounded-full shadow transition-transform ${
                          includeAnalytics ? 'translate-x-5' : 'translate-x-0.5'
                        }`}
                      />
                    </div>
                  </div>
                </label>
                <p className='text-xs text-gray-500 dark:text-gray-400 mt-1'>
                  Include views, engagement, and other analytics metrics
                </p>
              </div>

              {/* Date Range */}
              <div>
                <label className='flex items-center gap-2 text-sm font-medium text-gray-700 dark:text-gray-300 mb-3'>
                  <Calendar size={16} />
                  Date Range (Optional)
                </label>
                <div className='grid grid-cols-2 gap-3'>
                  <div>
                    <label className='block text-xs text-gray-500 dark:text-gray-400 mb-1'>
                      From
                    </label>
                    <input
                      type='date'
                      value={dateRange.start?.toISOString().split('T')[0] || ''}
                      onChange={(e) =>
                        setDateRange({
                          ...dateRange,
                          start: e.target.value ? new Date(e.target.value) : undefined,
                        })
                      }
                      className='input'
                    />
                  </div>
                  <div>
                    <label className='block text-xs text-gray-500 dark:text-gray-400 mb-1'>
                      To
                    </label>
                    <input
                      type='date'
                      value={dateRange.end?.toISOString().split('T')[0] || ''}
                      onChange={(e) =>
                        setDateRange({
                          ...dateRange,
                          end: e.target.value ? new Date(e.target.value) : undefined,
                        })
                      }
                      className='input'
                    />
                  </div>
                </div>
              </div>

              {/* Preview */}
              <div className='bg-gray-50 dark:bg-gray-900 rounded-lg p-4'>
                <div className='text-sm text-gray-600 dark:text-gray-400 space-y-1'>
                  <p>
                    <span className='font-medium'>Total items:</span> {data.length}
                  </p>
                  <p>
                    <span className='font-medium'>Format:</span> {format.toUpperCase()}
                  </p>
                  <p>
                    <span className='font-medium'>Analytics:</span>{' '}
                    {includeAnalytics ? 'Included' : 'Excluded'}
                  </p>
                </div>
              </div>
            </div>

            {/* Footer */}
            <div className='p-6 border-t border-gray-200 dark:border-gray-700'>
              <button
                onClick={handleExport}
                disabled={isExporting || data.length === 0}
                className='w-full btn btn-primary flex items-center justify-center gap-2'
              >
                {isExporting ? (
                  <>
                    <div className='w-4 h-4 border-2 border-white border-t-transparent rounded-full animate-spin' />
                    Exporting...
                  </>
                ) : (
                  <>
                    <Download size={20} />
                    Export {data.length} Items
                  </>
                )}
              </button>
            </div>
          </>
        )}
      </div>
    </div>
  )
}

export default ExportModal

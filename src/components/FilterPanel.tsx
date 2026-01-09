import React, { useState } from 'react'
import { Filter, X, Calendar, Tag, User, Search } from 'lucide-react'
import { FilterOptions } from '@/types'

interface FilterPanelProps {
  filters: FilterOptions
  onFiltersChange: (filters: FilterOptions) => void
  isOpen: boolean
  onClose: () => void
}

const FilterPanel: React.FC<FilterPanelProps> = ({ filters, onFiltersChange, isOpen, onClose }) => {
  const [searchTerm, setSearchTerm] = useState(filters.search || '')

  const statuses = [
    { value: 'draft', label: 'Draft', color: 'bg-yellow-100 text-yellow-800' },
    { value: 'published', label: 'Published', color: 'bg-green-100 text-green-800' },
    { value: 'scheduled', label: 'Scheduled', color: 'bg-blue-100 text-blue-800' },
  ]

  const platforms = ['Twitter', 'LinkedIn', 'Facebook', 'Instagram', 'Blog']
  const tags = ['News', 'Tutorial', 'Update', 'Promotion', 'Announcement']
  const authors = ['John Doe', 'Jane Smith', 'Bob Wilson', 'Alice Brown']

  const handleStatusChange = (status: string) => {
    const currentStatuses = filters.status || []
    const newStatuses = currentStatuses.includes(status)
      ? currentStatuses.filter((s) => s !== status)
      : [...currentStatuses, status]

    onFiltersChange({ ...filters, status: newStatuses })
  }

  const handlePlatformChange = (platform: string) => {
    const currentPlatforms = filters.platform || []
    const newPlatforms = currentPlatforms.includes(platform)
      ? currentPlatforms.filter((p) => p !== platform)
      : [...currentPlatforms, platform]

    onFiltersChange({ ...filters, platform: newPlatforms })
  }

  const handleTagChange = (tag: string) => {
    const currentTags = filters.tags || []
    const newTags = currentTags.includes(tag) ? currentTags.filter((t) => t !== tag) : [...currentTags, tag]

    onFiltersChange({ ...filters, tags: newTags })
  }

  const handleAuthorChange = (author: string) => {
    onFiltersChange({ ...filters, author: filters.author === author ? undefined : author })
  }

  const handleSearchChange = (value: string) => {
    setSearchTerm(value)
    onFiltersChange({ ...filters, search: value || undefined })
  }

  const clearAllFilters = () => {
    setSearchTerm('')
    onFiltersChange({})
  }

  const activeFiltersCount = Object.keys(filters).length + (filters.search ? 1 : 0)

  if (!isOpen) return null

  return (
    <div className="fixed inset-0 bg-black bg-opacity-50 z-50 flex items-start justify-end p-4">
      <div className="bg-white dark:bg-gray-800 rounded-xl shadow-2xl w-96 max-h-[calc(100vh-2rem)] overflow-y-auto animate-fade-in">
        {/* Header */}
        <div className="sticky top-0 bg-white dark:bg-gray-800 p-6 border-b border-gray-200 dark:border-gray-700 flex items-center justify-between">
          <div className="flex items-center gap-2">
            <Filter size={20} className="text-[var(--primary)]" />
            <h2 className="text-lg font-bold text-gray-900 dark:text-white">Filters</h2>
            {activeFiltersCount > 0 && (
              <span className="px-2 py-0.5 text-xs font-medium bg-[var(--primary)] text-white rounded-full">
                {activeFiltersCount}
              </span>
            )}
          </div>
          <button
            onClick={onClose}
            className="p-2 rounded-lg hover:bg-gray-100 dark:hover:bg-gray-700 transition-colors"
          >
            <X size={20} className="text-gray-500" />
          </button>
        </div>

        {/* Content */}
        <div className="p-6 space-y-6">
          {/* Search */}
          <div>
            <label className="flex items-center gap-2 text-sm font-medium text-gray-700 dark:text-gray-300 mb-2">
              <Search size={16} />
              Search
            </label>
            <input
              type="text"
              value={searchTerm}
              onChange={(e) => handleSearchChange(e.target.value)}
              placeholder="Search by title..."
              className="input"
            />
          </div>

          {/* Status Filter */}
          <div>
            <label className="flex items-center gap-2 text-sm font-medium text-gray-700 dark:text-gray-300 mb-2">
              <Tag size={16} />
              Status
            </label>
            <div className="flex flex-wrap gap-2">
              {statuses.map((status) => (
                <button
                  key={status.value}
                  onClick={() => handleStatusChange(status.value)}
                  className={`px-3 py-1.5 rounded-lg text-sm font-medium transition-all ${
                    filters.status?.includes(status.value)
                      ? status.color
                      : 'bg-gray-100 dark:bg-gray-700 text-gray-600 dark:text-gray-300 hover:bg-gray-200 dark:hover:bg-gray-600'
                  }`}
                >
                  {status.label}
                </button>
              ))}
            </div>
          </div>

          {/* Platform Filter */}
          <div>
            <label className="flex items-center gap-2 text-sm font-medium text-gray-700 dark:text-gray-300 mb-2">
              <User size={16} />
              Platform
            </label>
            <div className="space-y-2">
              {platforms.map((platform) => (
                <label key={platform} className="flex items-center gap-2 cursor-pointer">
                  <input
                    type="checkbox"
                    checked={filters.platform?.includes(platform)}
                    onChange={() => handlePlatformChange(platform)}
                    className="w-4 h-4 text-[var(--primary)] rounded focus:ring-[var(--primary)]"
                  />
                  <span className="text-sm text-gray-700 dark:text-gray-300">{platform}</span>
                </label>
              ))}
            </div>
          </div>

          {/* Tag Filter */}
          <div>
            <label className="text-sm font-medium text-gray-700 dark:text-gray-300 mb-2">Tags</label>
            <div className="flex flex-wrap gap-2">
              {tags.map((tag) => (
                <button
                  key={tag}
                  onClick={() => handleTagChange(tag)}
                  className={`px-3 py-1.5 rounded-lg text-sm font-medium transition-all ${
                    filters.tags?.includes(tag)
                      ? 'bg-[var(--primary)] text-white'
                      : 'bg-gray-100 dark:bg-gray-700 text-gray-600 dark:text-gray-300 hover:bg-gray-200 dark:hover:bg-gray-600'
                  }`}
                >
                  {tag}
                </button>
              ))}
            </div>
          </div>

          {/* Author Filter */}
          <div>
            <label className="text-sm font-medium text-gray-700 dark:text-gray-300 mb-2">Author</label>
            <select
              value={filters.author || ''}
              onChange={(e) => handleAuthorChange(e.target.value)}
              className="input"
            >
              <option value="">All Authors</option>
              {authors.map((author) => (
                <option key={author} value={author}>
                  {author}
                </option>
              ))}
            </select>
          </div>

          {/* Date Range */}
          <div>
            <label className="flex items-center gap-2 text-sm font-medium text-gray-700 dark:text-gray-300 mb-2">
              <Calendar size={16} />
              Date Range
            </label>
            <div className="grid grid-cols-2 gap-2">
              <input
                type="date"
                value={filters.dateRange?.start?.toISOString().split('T')[0] || ''}
                onChange={(e) =>
                  onFiltersChange({
                    ...filters,
                    dateRange: {
                      ...filters.dateRange,
                      start: new Date(e.target.value),
                    },
                  })
                }
                className="input"
              />
              <input
                type="date"
                value={filters.dateRange?.end?.toISOString().split('T')[0] || ''}
                onChange={(e) =>
                  onFiltersChange({
                    ...filters,
                    dateRange: {
                      ...filters.dateRange,
                      end: new Date(e.target.value),
                    },
                  })
                }
                className="input"
              />
            </div>
          </div>
        </div>

        {/* Footer */}
        <div className="sticky bottom-0 bg-white dark:bg-gray-800 p-6 border-t border-gray-200 dark:border-gray-700 flex gap-2">
          <button
            onClick={clearAllFilters}
            className="flex-1 btn btn-secondary"
            disabled={activeFiltersCount === 0}
          >
            Clear All
          </button>
          <button onClick={onClose} className="flex-1 btn btn-primary">
            Apply Filters
          </button>
        </div>
      </div>
    </div>
  )
}

export default FilterPanel

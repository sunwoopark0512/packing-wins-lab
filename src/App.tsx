import React from 'react'
import { Routes, Route } from 'react-router-dom'
import Navigation from '@/components/Navigation'
import Dashboard from '@/pages/Dashboard'
import useStore from '@/store/useStore'
import { Bell, X } from 'lucide-react'

const App: React.FC = () => {
  const { notifications, markNotificationAsRead, clearNotifications, darkMode } = useStore()

  return (
    <div className={`min-h-screen ${darkMode ? 'dark' : ''}`}>
      <div className='flex min-h-screen bg-gray-50 dark:bg-gray-900'>
        {/* Sidebar */}
        <Navigation />

        {/* Main Content */}
        <div className='flex-1 lg:ml-0'>
          {/* Top Bar */}
          <header className='bg-white dark:bg-gray-800 border-b border-gray-200 dark:border-gray-700 px-6 py-4'>
            <div className='flex items-center justify-between'>
              <div className='flex items-center gap-2'>
                <h1 className='text-xl font-bold text-gray-900 dark:text-white'>
                  Content Automation
                </h1>
              </div>

              <div className='flex items-center gap-4'>
                {/* Notifications */}
                <div className='relative'>
                  <button className='p-2 rounded-lg hover:bg-gray-100 dark:hover:bg-gray-700 transition-colors'>
                    <Bell size={20} className='text-gray-600 dark:text-gray-400' />
                    {notifications.some((n) => !n.read) && (
                      <span className='absolute top-1 right-1 w-2 h-2 bg-red-500 rounded-full' />
                    )}
                  </button>

                  {/* Notifications Dropdown */}
                  {notifications.length > 0 && (
                    <div className='absolute right-0 mt-2 w-80 bg-white dark:bg-gray-800 rounded-lg shadow-xl border border-gray-200 dark:border-gray-700 z-50'>
                      <div className='p-4 border-b border-gray-200 dark:border-gray-700 flex items-center justify-between'>
                        <h3 className='font-semibold text-gray-900 dark:text-white'>
                          Notifications
                        </h3>
                        <button
                          onClick={clearNotifications}
                          className='text-sm text-[var(--primary)] hover:underline'
                        >
                          Clear all
                        </button>
                      </div>
                      <div className='max-h-96 overflow-y-auto'>
                        {notifications.slice(0, 5).map((notification) => (
                          <div
                            key={notification.id}
                            onClick={() => markNotificationAsRead(notification.id)}
                            className={`p-4 border-b border-gray-200 dark:border-gray-700 cursor-pointer hover:bg-gray-50 dark:hover:bg-gray-900 transition-colors ${
                              !notification.read ? 'bg-blue-50 dark:bg-blue-900/20' : ''
                            }`}
                          >
                            <div className='flex items-start justify-between'>
                              <div className='flex-1'>
                                <p className='font-medium text-gray-900 dark:text-white text-sm'>
                                  {notification.title}
                                </p>
                                <p className='text-sm text-gray-600 dark:text-gray-400 mt-1'>
                                  {notification.message}
                                </p>
                                <p className='text-xs text-gray-500 dark:text-gray-500 mt-2'>
                                  {notification.timestamp.toLocaleString()}
                                </p>
                              </div>
                              <button
                                onClick={(e) => {
                                  e.stopPropagation()
                                  markNotificationAsRead(notification.id)
                                }}
                                className='ml-2 text-gray-400 hover:text-gray-600 dark:hover:text-gray-300'
                              >
                                <X size={16} />
                              </button>
                            </div>
                          </div>
                        ))}
                      </div>
                    </div>
                  )}
                </div>

                {/* User Avatar */}
                <div className='w-10 h-10 rounded-full bg-gradient-to-r from-[var(--primary)] to-[var(--primary-dark)] flex items-center justify-center text-white font-bold'>
                  JD
                </div>
              </div>
            </div>
          </header>

          {/* Page Content */}
          <main>
            <Routes>
              <Route path='/' element={<Dashboard />} />
              <Route path='/dashboard' element={<Dashboard />} />
              <Route
                path='/content'
                element={
                  <div className='p-8'>
                    <div className='card'>
                      <h2 className='text-2xl font-bold text-gray-900 dark:text-white mb-4'>
                        Content Management
                      </h2>
                      <p className='text-gray-600 dark:text-gray-400'>
                        Content page coming soon...
                      </p>
                    </div>
                  </div>
                }
              />
              <Route
                path='/analytics'
                element={
                  <div className='p-8'>
                    <div className='card'>
                      <h2 className='text-2xl font-bold text-gray-900 dark:text-white mb-4'>
                        Analytics
                      </h2>
                      <p className='text-gray-600 dark:text-gray-400'>
                        Analytics page coming soon...
                      </p>
                    </div>
                  </div>
                }
              />
              <Route
                path='/settings'
                element={
                  <div className='p-8'>
                    <div className='card'>
                      <h2 className='text-2xl font-bold text-gray-900 dark:text-white mb-4'>
                        Settings
                      </h2>
                      <p className='text-gray-600 dark:text-gray-400'>
                        Settings page coming soon...
                      </p>
                    </div>
                  </div>
                }
              />
            </Routes>
          </main>
        </div>
      </div>
    </div>
  )
}

export default App

import React from 'react'

interface PieChartProps {
  data: { label: string; value: number; color: string }[]
  size?: number
}

export const PieChart: React.FC<PieChartProps> = ({ data, size = 200 }) => {
  const total = data.reduce((sum, item) => sum + item.value, 0)
  let currentAngle = 0

  const slices = data.map((item) => {
    const percentage = item.value / total
    const angle = percentage * 2 * Math.PI
    const x1 = size / 2 + (size / 2 - 10) * Math.cos(currentAngle)
    const y1 = size / 2 + (size / 2 - 10) * Math.sin(currentAngle)
    const x2 = size / 2 + (size / 2 - 10) * Math.cos(currentAngle + angle)
    const y2 = size / 2 + (size / 2 - 10) * Math.sin(currentAngle + angle)
    const largeArcFlag = percentage > 0.5 ? 1 : 0

    currentAngle += angle

    return {
      ...item,
      pathData: `M ${size / 2} ${size / 2} L ${x1} ${y1} A ${size / 2 - 10} ${size / 2 - 10} 0 ${largeArcFlag} 1 ${x2} ${y2} Z`,
      percentage: (percentage * 100).toFixed(1),
    }
  })

  return (
    <div className="flex items-center gap-6">
      <svg width={size} height={size} viewBox={`0 0 ${size} ${size}`}>
        {slices.map((slice, index) => (
          <path key={index} d={slice.pathData} fill={slice.color} stroke="white" strokeWidth="2" />
        ))}
      </svg>
      <div className="space-y-2">
        {slices.map((slice, index) => (
          <div key={index} className="flex items-center gap-2 text-sm">
            <div className="w-3 h-3 rounded-full" style={{ backgroundColor: slice.color }} />
            <span className="text-gray-600 dark:text-gray-300">
              {slice.label}: {slice.percentage}%
            </span>
          </div>
        ))}
      </div>
    </div>
  )
}

interface BarChartProps {
  data: { label: string; value: number; color?: string }[]
  height?: number
  width?: number
}

export const BarChart: React.FC<BarChartProps> = ({ data, height = 300, width = 600 }) => {
  const maxValue = Math.max(...data.map((d) => d.value))
  const barWidth = (width - 100) / data.length - 20
  const chartHeight = height - 60

  return (
    <svg width={width} height={height}>
      {/* Y-axis */}
      <line x1={60} y1={30} x2={60} y2={chartHeight} stroke="#9ca3af" strokeWidth={1} />
      {/* X-axis */}
      <line x1={60} y1={chartHeight} x2={width - 20} y2={chartHeight} stroke="#9ca3af" strokeWidth={1} />

      {/* Bars */}
      {data.map((item, index) => {
        const barHeight = (item.value / maxValue) * (chartHeight - 50)
        const x = 80 + index * ((width - 100) / data.length)
        const y = chartHeight - barHeight

        return (
          <g key={index}>
            <rect
              x={x}
              y={y}
              width={barWidth}
              height={barHeight}
              fill={item.color || '#667eea'}
              rx={4}
              className="hover:opacity-80 transition-opacity cursor-pointer"
            />
            <text x={x + barWidth / 2} y={y - 5} textAnchor="middle" fontSize={12} fill="#6b7280">
              {item.value}
            </text>
            <text x={x + barWidth / 2} y={chartHeight + 20} textAnchor="middle" fontSize={11} fill="#6b7280">
              {item.label}
            </text>
          </g>
        )
      })}
    </svg>
  )
}

interface LineChartProps {
  data: { label: string; value: number }[]
  height?: number
  width?: number
  color?: string
}

export const LineChart: React.FC<LineChartProps> = ({ data, height = 300, width = 600, color = '#667eea' }) => {
  const maxValue = Math.max(...data.map((d) => d.value))
  const minValue = Math.min(...data.map((d) => d.value))
  const chartWidth = width - 100
  const chartHeight = height - 60

  const points = data
    .map((item, index) => {
      const x = 60 + (index / (data.length - 1)) * chartWidth
      const y = chartHeight - ((item.value - minValue) / (maxValue - minValue || 1)) * (chartHeight - 50)
      return `${x},${y}`
    })
    .join(' ')

  const areaPoints = `60,${chartHeight} ${points} ${60 + chartWidth},${chartHeight}`

  return (
    <svg width={width} height={height}>
      {/* Grid lines */}
      {[0, 25, 50, 75, 100].map((percent) => {
        const y = chartHeight - (percent / 100) * (chartHeight - 50)
        return (
          <line key={percent} x1={60} y1={y} x2={width - 20} y2={y} stroke="#e5e7eb" strokeWidth={1} strokeDasharray="4" />
        )
      })}

      {/* Area under line */}
      <polygon
        points={areaPoints}
        fill={color}
        fillOpacity="0.1"
        className="transition-opacity hover:fill-opacity-20"
      />

      {/* Line */}
      <polyline
        points={points}
        fill="none"
        stroke={color}
        strokeWidth={2}
        className="transition-all hover:stroke-width-[3]"
      />

      {/* Data points */}
      {data.map((item, index) => {
        const x = 60 + (index / (data.length - 1)) * chartWidth
        const y = chartHeight - ((item.value - minValue) / (maxValue - minValue || 1)) * (chartHeight - 50)

        return (
          <g key={index}>
            <circle cx={x} cy={y} r={4} fill={color} className="hover:r-6 transition-all cursor-pointer" />
            <text x={x} y={y - 10} textAnchor="middle" fontSize={10} fill="#6b7280">
              {item.value}
            </text>
            <text x={x} y={chartHeight + 20} textAnchor="middle" fontSize={10} fill="#6b7280">
              {item.label}
            </text>
          </g>
        )
      })}
    </svg>
  )
}

import './globals.css'
import type { Metadata } from 'next'

export const metadata: Metadata = {
  title: 'Monitoring Test Dashboard',
  description: 'Test dashboard for Prometheus and Grafana monitoring',
}

export default function RootLayout({
  children,
}: {
  children: React.ReactNode
}) {
  return (
    <html lang="ko">
      <body>{children}</body>
    </html>
  )
}


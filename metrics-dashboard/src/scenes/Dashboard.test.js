// src/components/Dashboard.test.js
import React from 'react';
import { render, screen } from '@testing-library/react';
import Dashboard from './Dashboard';

describe('Dashboard Component', () => {
  const mockMetricsData = [
    { id: 'Metric1', value: 100 }, 
    { id: 'Metric2', value: 200 }
  ];

  test('renders metric ids', () => {
    render(<Dashboard metricsData={mockMetricsData} />);
    expect(screen.getByText('Metric1')).toBeInTheDocument();
    expect(screen.getByText('Metric2')).toBeInTheDocument();
  });
});

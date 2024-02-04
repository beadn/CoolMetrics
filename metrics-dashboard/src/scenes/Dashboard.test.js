import React from 'react';
import { render, waitFor } from '@testing-library/react';
import axios from 'axios';
import Dashboard from './Dashboard';

// Mock axios
jest.mock('axios');

describe('Dashboard', () => {
  it('fetches metrics data and displays it', async () => {
    // Mocking the axios.get method to return a successful response
    axios.get.mockResolvedValue({
      data: {
        data: [
          {
            id: "510",
            type: "metric",
            attributes: {
              name: "disk-usage",
              timestamp: "2024-01-05T20:38:08.928Z",
              value: "95.0"
            }
          },
          {
            id: "511",
            type: "metric",
            attributes: {
              name: "memory-usage",
              timestamp: "2024-01-05T20:38:08.928Z",
              value: "22.0"
            }
          }
        ]
      }
    });

    const { findByText } = render(<Dashboard />);

    // Wait for the axios data to be displayed
    const firstMetricId = await findByText("510");
    expect(firstMetricId).toBeInTheDocument();

    const secondMetricId = await findByText("511");
    expect(secondMetricId).toBeInTheDocument();
  });
});

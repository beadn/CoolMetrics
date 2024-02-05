import React from 'react';
import { render, waitFor, screen } from '@testing-library/react';
import axios from 'axios';
import Dashboard from './Dashboard';
import { createTheme, ThemeProvider } from '@mui/material/styles';
import { themeSettings } from '../theme'; 
import { act } from 'react-dom/test-utils';

// Mock axios
jest.mock('axios');

// Function to render the component within the ThemeProvider
const renderWithTheme = (ui, { themeMode = 'dark', ...options } = {}) => {
  const theme = createTheme(themeSettings(themeMode)); // Create a theme with 'dark' or 'light' mode
  return render(<ThemeProvider theme={theme}>{ui}</ThemeProvider>, options);
};


const mockData = {
  data: {
    data: [
      { id: '1', type: 'metric', attributes: { name: 'Metric 1', timestamp: '2024-01-01T00:00:00Z', value: '100' } }
    ]
  }
};

const mockData2 = {
  data: {
    data: [
      { id: '1', type: 'metric', attributes: { name: 'Metric 2', timestamp: '2024-01-01T00:00:00Z', value: '100' } }
    ]
  }
};
describe('Dashboard', () => {

  it('renders without crashing', async () => {
    axios.get.mockResolvedValue({ data: { data: [] } });
    
    await act(async () => {
      renderWithTheme(<Dashboard />);
    });

    await waitFor(() => {
      expect(screen.getByText('DASHBOARD')).toBeInTheDocument();
    });
  });


  it('fetches and displays metrics data', async () => {
    axios.get.mockResolvedValue(mockData);

    await act(async () => {
      renderWithTheme(<Dashboard />);
    });
    await waitFor(() => {
      expect(screen.getByText('Metric 1')).toBeInTheDocument();
    });
  });

  it('displays an error message on fetch failure', async () => {
    axios.get.mockRejectedValue(new Error(422,'Network error'));

    await act(async () => {
      renderWithTheme(<Dashboard />);
    });
    await waitFor(() => {
      expect(screen.getByText('Error fetching data. Please try again.')).toBeInTheDocument();
    });
  });


  it('updates displayed data when time frame changes', async () => {


    axios.get.mockResolvedValueOnce(mockData); // Mock the initial fetch
    // Initial render with 'minute' time frame
    const { rerender } = renderWithTheme(<Dashboard initialTimeFrame="minute" />);
    await waitFor(() => {
      expect(axios.get).toHaveBeenLastCalledWith(expect.any(String), {
        params: { time_frame: 'minute' },
      });
    });
    
    await waitFor(() => {
      expect(screen.getByText('Metric 1')).toBeInTheDocument();
    });
    // Change the time frame to 'hour' and mock the fetch response for this time frame
    axios.get.mockResolvedValueOnce(mockData2); // Mock the fetch for the 'hour' time frame

    // Rerender with 'hour' time frame to simulate changing the time frame
    rerender(<Dashboard initialTimeFrame="hour" />);

    await waitFor(() => {
      expect(axios.get).toHaveBeenLastCalledWith(expect.any(String), {
        params: { time_frame: 'hour' },
      });
    });

    await waitFor(() => {
      expect(screen.getByText('Metric 2')).toBeInTheDocument();
    });
  });

 });

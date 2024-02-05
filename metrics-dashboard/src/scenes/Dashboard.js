import React, { useState, useEffect } from 'react';
import axios from 'axios';
import { Box, Grid, FormControl, Select, MenuItem, Typography, useTheme } from '@mui/material';
import { tokens } from "../theme";
import Header from "../components/Header";
import { useCallback } from 'react';

const Dashboard = () => {
  
  const theme = useTheme();
  const colors = tokens(theme.palette.mode);
  const [timeFrame, setTimeFrame] = useState('24h');
  const [metricsData, setMetricsData] = useState([]);
  const fetchMetrics = async () => {
    try {
      const response = await axios.get(`http://localhost:3000/api/v1/metrics`, {
        params: { time_frame: 'day'}});
      setMetricsData(Object.values(response.data));
    } catch (error) {
      console.error("Failed to fetch metrics:", error);
    }
  };

  useEffect(() => {
    fetchMetrics();
  }, []);

  return (
    <Box m="20px"> 
      <Box display="flex" justifyContent="space-between" alignItems="center">
        <Header title="DASHBOARD" subtitle="Welcome to your fancy metrics" />
      </Box>

      <Grid container spacing={2}>
        {metricsData.map((metricData, index) => (
          <Grid item xs={6} key={index}>
            <Box height="300px">
              <Typography variant="h5" color={colors.greenAccent[400]} alignContent={"center"} textAlign={"center"}>
                {metricData.id}
              </Typography>
            </Box>
          </Grid>
        ))}
      </Grid>
    </Box>
  );
};

export default Dashboard;


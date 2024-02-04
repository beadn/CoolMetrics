import React, { useEffect, useState } from 'react';
import { Box, Grid, Typography } from '@mui/material';
import axios from 'axios'; 

const Dashboard = () => {
  const [metricsData, setMetricsData] = useState([]);

  useEffect(() => {
    const fetchMetrics = async () => {
      try {
        const response = await axios.get('http://localhost:3000/api/v1/metrics');
        setMetricsData(Object.values(response.data));
      } catch (error) {
        console.error("Failed to fetch metrics:", error);

      }
    };

    fetchMetrics();
  }, []); 

  return (
    <Box>
      <Grid container spacing={2}>
        {metricsData.map((metricData, index) => (
          <Grid item xs={6} key={index}>
            <Box height="300px">
              <Typography variant="h5" alignContent={"center"} textAlign={"center"} color="common.white">
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

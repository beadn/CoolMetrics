import React from 'react';
import { Box, Grid,  Typography } from '@mui/material';


const Dashboard = ({ metricsData = [] }) => {
  return (
    <Box>
      <Grid container spacing={2}>
        {metricsData.map((metricData, index) => (
          <Grid item xs={6} key={index}>
            <Box height="300px">
              <Typography variant="h5" alignContent={"center"} textAlign={"center"}>
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
import React, { useState, useEffect, useCallback, useMemo } from 'react';
import axios from 'axios';
import { Box, Grid, FormControl, Select, MenuItem, Typography, useTheme } from '@mui/material';
import { tokens } from "../theme";
import Header from "../components/Header";
import LineChart from "../components/LineChart";

const Dashboard = ({ initialTimeFrame = 'minute' }) => {
  const [timeFrame, setTimeFrame] = useState(initialTimeFrame);
  const theme = useTheme();
  const colors = tokens(theme.palette.mode);
  const [metricsData, setMetricsData] = useState([]);
  const [fetchError, setFetchError] = useState(false);

  const processData = (apiData) => {
    const formattedData = {};

    if(apiData==null||apiData.data==null) 
    return Object.values(formattedData);;
  
    apiData.data.forEach(item => {
      const { name, timestamp, value } = item.attributes;
      
      if (!formattedData[name]) {
        formattedData[name] = { id: name, data: [] };
      }
      var date = new Date(timestamp);
      formattedData[name].data.push({ x: date, y: value });
    });
  
    return Object.values(formattedData);
  };


  const fetchData = useCallback(async () => {
    try {
      const response = await axios.get(`http://localhost:3000/api/v1/metrics`, {
        params: { time_frame: timeFrame }
      });
      setMetricsData(processData(response.data)); // Adjust based on the structure of your response
    } catch (error) {
      console.log(error);
      setFetchError(true); 
    }
  }, [timeFrame]); 

  useEffect(() => {
    fetchData(); // Fetch data initially
  
    const intervalId = setInterval(fetchData,  60000); // Fetch data every 60 minutes (3600000 ms)
  
    return () => clearInterval(intervalId); // Cleanup interval on unmount
  }, [timeFrame, fetchData]); 

  const handleTimeFrameChange = (event) => {
    setTimeFrame(event.target.value);
  };

  const xAxisFormat = useMemo(() => (timeFrame === 'day' ? '%d/%m/%y' : '%H:%M'), [timeFrame]);

  return (
    <Box m="20px">
      <Box display="flex" justifyContent="space-between" alignItems="center">
        <Header title="DASHBOARD" subtitle="Welcome to your cool metrics" />
        <FormControl variant="outlined" size="small">
          <Select data-testid="timeframe-select" value={timeFrame} onChange={handleTimeFrameChange}>
            <MenuItem  value="minute">Minute</MenuItem>
            <MenuItem  value="hour">Hour</MenuItem>
            <MenuItem  value="day">Day</MenuItem>
           </Select>
        </FormControl>
      </Box>
      {fetchError && <Typography color="error">Error fetching data. Please try again.</Typography>}
      <Grid container spacing={2}>
        {metricsData.map((metricData, index) => (
          <Grid item xs={6} key={index}>
            <Box height="300px" mt="20px">
            <LineChart data={[metricData]} xAxisFormat={xAxisFormat} />
            <Typography variant="h5" color={colors.greenAccent[400]} alignContent="center" textAlign="center" >
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

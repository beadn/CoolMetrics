import React from 'react';
import { ResponsiveLine } from '@nivo/line';
import { useTheme } from '@mui/material';
import { tokens } from '../theme';

const LineChart = ({ data, xAxisFormat = '%H:%M', isDashboard = false }) => {
  const theme = useTheme();
  const colors = tokens(theme.palette.mode);

  
  return (
    <ResponsiveLine
    data={data}
    theme={{
      axis: {
        domain: {
          line: {
            stroke: colors.grey[100],
          },
        },
        legend: {
          text: {
            fill: colors.grey[100],
          },
        },
        ticks: {
          line: {
            stroke: colors.grey[100],
            strokeWidth: 1,
          },
          text: {
            fill: colors.grey[100],
          },
        },
      },
      legends: {
        text: {
          fill: colors.grey[100],
        },
      },
      tooltip: {
        container: {
          color: colors.primary[500],
        },
      },
    }}
    colors={isDashboard ? { datum: "color" } : { scheme: "nivo" }} // added
    margin={{ top: 50, right: 110, bottom: 50, left: 60 }}
    xScale={{ type: 'time', format: 'native', precision: 'minute' }}
    yScale={{ type: 'linear', min: 'auto', max: 'auto', stacked: false, reverse: false }}
    curve="monotoneX"
    yFormat=" >-.2f"
    axisTop={null}
    axisRight={null}
    axisBottom={{
      orient: 'bottom',
      tickSize: 5,
      tickPadding: 5,
      tickRotation: 0,
      legendOffset: 36,
      legendPosition: 'middle',
      format: xAxisFormat // Format the time on the x-axis
    }}
    axisLeft={{
      orient: "left",
      tickValues: 5, // added
      tickSize: 3,
      tickPadding: 5,
      tickRotation: 0,
      legendOffset: -40,
      legendPosition: "middle",
    }}
    enableGridX={false}
    enableGridY={false}
    pointSize={8}
    pointColor={{ theme: "background" }}
    pointBorderWidth={2}
    pointBorderColor={{ from: "serieColor" }}
    pointLabelYOffset={-12}
    useMesh={true}
  />
);
};

export default LineChart;

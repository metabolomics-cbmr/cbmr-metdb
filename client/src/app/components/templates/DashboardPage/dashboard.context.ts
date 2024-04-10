import React from 'react';
import { DASHBOARD_DATA } from '../../../shared/constants/dashboard';

const DashboardContext = React.createContext({
  dashboardData: DASHBOARD_DATA,
  getDashboardData: () => {},
});

export default DashboardContext;

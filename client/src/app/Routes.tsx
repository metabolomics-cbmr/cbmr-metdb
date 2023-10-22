import React from 'react';
import { BrowserRouter as Router, Switch, Route } from 'react-router-dom';
import Admin from './components/templates/Admin';
import DashboardPage from './components/templates/DashboardPage';
import InvestigationFormPage from './components/templates/InvestigationFormPage';
// import LoginPage from './components/templates/LoginPage';
import RecordsPage from './components/templates/RecordsPage';
import ResultsLog from './components/templates/ResultsLog';
import ResultsRetrieval from './components/templates/ResultsRetrieval';
import Settings from './components/templates/Settings';

export const ROUTES = {
  DASHBOARD: '/',
  // LOGIN: '/',
  DOE: '/doe',
  ADMIN: '/admin',
  RESULTS_RETRIEVAL: '/results/:id',
  RESULTS: '/results',
  RECORDS: '/records/:recordName',
  SETTINGS: '/settings',
};

const Routes = () => (
  <Router>
    <Switch>
      <Route path={ROUTES.DOE}>
        <InvestigationFormPage />
      </Route>
      <Route path={ROUTES.RESULTS_RETRIEVAL}>
        <ResultsRetrieval />
      </Route>
      <Route path={ROUTES.RESULTS}>
        <ResultsLog />
      </Route>
      <Route path={ROUTES.RECORDS}>
        <RecordsPage />
      </Route>
      <Route path={ROUTES.ADMIN}>
        <Admin />
      </Route>
      <Route path={ROUTES.SETTINGS}>
        <Settings />
      </Route>
      <Route path={ROUTES.DASHBOARD}>
        <DashboardPage />
      </Route>
      {/* <Route path="/">
        <LoginPage />
      </Route> */}
    </Switch>
  </Router>
);

export default Routes;

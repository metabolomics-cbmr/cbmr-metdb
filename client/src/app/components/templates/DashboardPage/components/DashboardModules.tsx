import React from 'react';
import { Row } from 'react-bootstrap';
import SearchBar from '../../../atoms/SearchBar';
import { SectionTitle } from '../Dashboard.style';
import DashboardDoeModule from './DashboardDoeModule';
import DashboardResultsModule from './DashboardResultsModule';

const DashboardModules = () => {
  return (
    <React.Fragment>
      <SectionTitle>
        Modules
        <SearchBar />
      </SectionTitle>
      <Row className="dashboard-modules">
        <DashboardDoeModule />
        <DashboardResultsModule />
      </Row>
    </React.Fragment>
  );
};

export default DashboardModules;

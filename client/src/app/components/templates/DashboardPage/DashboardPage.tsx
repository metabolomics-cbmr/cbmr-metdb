import React, { useEffect, useState } from 'react';
import MainLayout from '../../layouts/MainLayout';
import Header from '../../organisms/Header';
import './Dashboard.style.scss';
import * as S from './Dashboard.style';
import { Col, Row } from 'react-bootstrap';
import { DASHBOARD_DATA } from '../../../shared/constants/dashboard';
import { getDashboardDataAPI } from '../../../shared/utils/api.utils';
import DashboardSidebar from './components/DashboardSidebar';
import DashboardContext from './dashboard.context';
import DashboardMissingData from './components/DashboardMissingData';
import DashboardModules from './components/DashboardModules';
import DashboardStats from './components/DashboardStats';

const DashboardBottomRow = () => {
  return (
    <>
      <S.Separator className="my-4"></S.Separator>
      <Row>
        <Col>
          <DashboardStats />
        </Col>
        <Col>
          <DashboardMissingData />
        </Col>
      </Row>
    </>
  );
};

const Dashboard = (props) => {
  const [dashboardData, setDashboardData] = useState(DASHBOARD_DATA);
  const getDashboardData = async () => {
    const dashboardData = await getDashboardDataAPI();
    setDashboardData(dashboardData);
  };
  useEffect(() => {
    getDashboardData();
  }, []);
  return (
    <DashboardContext.Provider value={{ dashboardData, getDashboardData }}>
      <S.Dashboard>
        <Header pageTitle="Dashboard" />
        <DashboardModules />
        <DashboardBottomRow />
        <S.Separator className="my-4"></S.Separator>
      </S.Dashboard>
    </DashboardContext.Provider>
  );
};

const DashboardPage = () => (
  <div className="dashboard">
    <MainLayout sidebar={<DashboardSidebar />} content={<Dashboard />} />
  </div>
);

export default DashboardPage;

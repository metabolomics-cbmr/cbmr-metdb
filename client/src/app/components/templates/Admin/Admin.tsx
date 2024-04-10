import React from 'react';
import Card from '../../atoms/Card';
import SearchBar from '../../atoms/SearchBar';
import MainLayout from '../../layouts/MainLayout';
import Header from '../../organisms/Header';
import DashboardSidebar from '../DashboardPage/components/DashboardSidebar';
import { SectionTitle } from '../DashboardPage/Dashboard.style';
import './Admin.style.scss';
import PgAdminLogo from '../../../../assets/images/pg-admin-logo.png';
import LogsLogo from '../../../../assets/images/1024px-File_alt_font_awesome.svg.png';
import styled from 'styled-components';

const ADMIN_MODULES = [
  {
    logo: PgAdminLogo,
    title: 'PgAdmin',
    description: 'Explore and Query the Database',
    href: '/pgadmin/',
  },
  {
    logo: LogsLogo,
    title: 'Inspect',
    description: 'Diagnose Issue with System Logs',
    href: '/logs/',
  },
];

const AdminModuleCard = styled(Card)`
  max-width: 400px;
  width: 100%;
  height: 150px;
  display: inline-flex;
  justify-content: space-between;
  align-items: center;
  cursor: pointer;
`;

const AdminModule = ({ logo, title, description, href }) => {
  const onClick = () => {
    window.location.href = window.location.origin + href;
  };
  return (
    <AdminModuleCard className="m-3" onClick={onClick}>
      <img src={logo} className="w-25 m-auto" alt="" />
      <div className="p-5">
        <h6 className="text-secondary font-weight-bold">{title}</h6>
        <p className="text-muted mb-0">{description}</p>
      </div>
    </AdminModuleCard>
  );
};

const AdminPage = () => {
  return (
    <div className="admin__content">
      <Header pageTitle="Admin" />
      <SectionTitle>
        Modules
        <SearchBar />
      </SectionTitle>
      <div className="d-flex">
        {ADMIN_MODULES.map((adminModule) => (
          <AdminModule
            logo={adminModule.logo}
            title={adminModule.title}
            description={adminModule.description}
            href={adminModule.href}
          />
        ))}
      </div>
    </div>
  );
};

const Admin = (props) => (
  <div className="admin">
    <MainLayout sidebar={<DashboardSidebar />} content={<AdminPage />} />
  </div>
);

export default Admin;

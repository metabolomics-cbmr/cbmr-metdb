import React, { useEffect } from 'react';
import { useHistory, useParams } from 'react-router';
import { ROUTES } from '../../../Routes';
import MainLayout from '../../layouts/MainLayout';
import Header from '../../organisms/Header';
import DashboardSidebar from '../DashboardPage/components/DashboardSidebar';
import { SectionTitle } from '../DashboardPage/Dashboard.style';
import './RecordsPage.style.scss';
import AllCompounds from './RecordTypes/AllCompounds';

const RecordNotFound = () => (
  <>
    <Header pageTitle="Metabolomics" />
    <SectionTitle>No Page found for that record</SectionTitle>
  </>
);

const Records = () => {
  const { recordName } = useParams<any>();
  const history = useHistory();

  const isRecordNameValid = recordName;

  useEffect(() => {
    if (!isRecordNameValid) {
      alert('Please specify record name');
      history.push(ROUTES.DASHBOARD);
    }
  }, [isRecordNameValid, history]);

  return (
    (isRecordNameValid && <AllCompounds recordName={recordName} />) || (
      <RecordNotFound />
    )
  );
};

const RecordsPage = (props) => {
  return (
    <div className="records-page">
      <MainLayout sidebar={<DashboardSidebar />} content={<Records />} />
    </div>
  );
};

export default RecordsPage;

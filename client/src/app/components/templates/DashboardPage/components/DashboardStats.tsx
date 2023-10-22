import { Row, Col } from 'react-bootstrap';
import API_URLS from '../../../../shared/constants/api.const';
import Card from '../../../atoms/Card';
import DashboardContext from '../dashboard.context';
import DasboardStatsCard from './DashboardStatsCard';
import * as S from '../Dashboard.style';
import DashboardStatsUpload from './DashboardStatsUpload';
import { useHistory } from 'react-router';
import { useState } from 'react';
import FileName from '../../../atoms/FileName';
import MS2FileInfo from '../../../organisms/MS2FileInfo';
import { ROUTES } from '../../../../Routes';
import TableLayout from '../../../layouts/TableLayout';

const MS1Records = ({ dashboardData, getDashboardData }) => {
  return (
    <DashboardStatsUpload
      title="Number of MS1 Data Records"
      uploadUrl={API_URLS.UPLOAD_MS1}
      count={dashboardData.STATS.TOTAL_MS1}
      onFileUpload={getDashboardData}
      fileUploadTitle="Upload MS1 Data File"
    ></DashboardStatsUpload>
  );
};

const MS2Records = ({ dashboardData, getDashboardData }) => {
  return (
    <DashboardStatsUpload
      title="Number of MS2 Data Records"
      count={dashboardData.STATS.TOTAL_MS2}
      uploadUrl={API_URLS.UPLOAD_MS2}
      onFileUpload={getDashboardData}
      fileUploadTitle="Upload MS2 Data File"
    ></DashboardStatsUpload>
  );
};

const TotalCompounds = ({ dashboardData }) => {
  const history = useHistory();
  const navigateToRecords = () =>
    history.push(ROUTES.RECORDS.replace(':recordName', 'TOTAL_COMPOUNDS'));
  return (
    <DasboardStatsCard
      title="Total Number of Compounds"
      count={dashboardData.STATS.TOTAL_COMPOUNDS}
      bottomTipClick={navigateToRecords}
      bottomTipText="View Compounds"
    ></DasboardStatsCard>
  );
};

const RecentlyUploadedMS2 = ({ MS2, onClick }) => (
  <>
    <S.Separator style={{ margin: '0 -15px' }} className="my-2" />
    <S.RecentlyUploadedMS2 onClick={onClick}>
      <FileName>{MS2}</FileName>
    </S.RecentlyUploadedMS2>
  </>
);

const RecentMS2Data = ({ dashboardData }) => {
  const [MS2FileId, setMs2FileId] = useState<string>('');
  return (
    <>
      <Card className="mb-2  dashboard__stats-card">
        <S.DashboardStatsTileTitle>
          Recently Uploaded MS2 Data
        </S.DashboardStatsTileTitle>
        {Object.entries(dashboardData.HISTORY.LAST_THREE_MS2).map(
          ([key, MS2]) => (
            <RecentlyUploadedMS2
              MS2={MS2}
              key={key}
              onClick={() => setMs2FileId(key)}
            />
          ),
        )}
      </Card>
      {MS2FileId && (
        <MS2FileInfo
          ms2FileId={MS2FileId}
          onClose={() => {
            setMs2FileId('');
          }}
        />
      )}
    </>
  );
};

const DashboardStats = () => {
  return (
    <DashboardContext.Consumer>
      {({ dashboardData, getDashboardData }) => (
        <Row className="">
          <Col>
            <TableLayout title="Library Data" thead={[]}>
              <MS1Records
                dashboardData={dashboardData}
                getDashboardData={getDashboardData}
              />
              <MS2Records
                dashboardData={dashboardData}
                getDashboardData={getDashboardData}
              />
            </TableLayout>
          </Col>
          <Col className="pt-5">
            <TotalCompounds dashboardData={dashboardData} />
            <RecentMS2Data dashboardData={dashboardData} />
          </Col>
        </Row>
      )}
    </DashboardContext.Consumer>
  );
};

export default DashboardStats;

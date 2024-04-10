import MainLayout from '../../layouts/MainLayout';
import Header from '../../organisms/Header';
import DashboardSidebar from '../DashboardPage/components/DashboardSidebar';
import './Settings.style.scss';
import Tab from 'react-bootstrap/Tab';
import Tabs from 'react-bootstrap/Tabs';
import UnknownCompoundDetectionSettings from './Components/UnknownCompoundDetectionSettings/UnknownCompoundDetectionSettings';

const SettingsPage = () => {
  return (
    <div className="settings-page__inner">
      <Header pageTitle="Settings" />
      <Tabs defaultActiveKey={'unknownCompoundDetection'}>
        <Tab
          eventKey="unknownCompoundDetection"
          title="Unknown Compound Detection"
        >
          <UnknownCompoundDetectionSettings />
        </Tab>
      </Tabs>
    </div>
  );
};

const Settings = (props) => {
  return (
    <div className="settings-page">
      <MainLayout sidebar={<DashboardSidebar />} content={<SettingsPage />} />
    </div>
  );
};

export default Settings;

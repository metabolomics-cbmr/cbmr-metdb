import MainLayout from '../../layouts/MainLayout';
import Header from '../../organisms/Header';
import DashboardSidebar from '../DashboardPage/components/DashboardSidebar';
import './ResultsLog.style.scss';
import arrowLeft from '../../../../assets/images/arrow-left.svg';
import useResultsLog from './hooks/ResultsLog.hook';
import ResultsLogDataTable from './components/ResultsLogDataTable';

const ResultsLogPage = () => {
  const { results, history } = useResultsLog();

  return (
    <>
      <Header
        pageTitle={
          <>
            <img
              className="arrow-left mr-2"
              src={arrowLeft}
              alt=""
              onClick={history.goBack}
            />
            Metabolomics
          </>
        }
      />
      {/* <ResultsLogTable results={results} history={history} /> */}
      <ResultsLogDataTable results={results} />
    </>
  );
};

const ResultsLog = (props) => {
  return (
    <div className="results-log-page">
      <MainLayout sidebar={<DashboardSidebar />} content={<ResultsLogPage />} />
    </div>
  );
};

export default ResultsLog;

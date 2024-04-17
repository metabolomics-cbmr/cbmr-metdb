import { Col } from 'react-bootstrap';
import { useHistory } from 'react-router';
import { ROUTES } from '../../../../Routes';
import { BASE_URL } from '../../../../shared/constants/api.const';
import DashboardContext from '../dashboard.context';
import BottomTip from './BottomTip';
import DashboardModule from './DashboardModule';

const DashboardResultsModule = () => {
  const history = useHistory();

  const navigateToResults = () => {
    history.push(ROUTES.RESULTS);
  };
  return (
    <Col sm={12} md={12} lg={6} xl={6} key={2}>
      <DashboardModule
        index={2}
        title="Results Retrieval"
        description="Check the results of your completed experiments. <br/> You can download them in csv <br/>or other compatible formats <br/>or you can use our analytics online."
        tooltipId="results_tooltip"
        bottomControls={
          <></>
          // <BottomTip
          //   text="View Results"
          //   onClick={() => {
          //     navigateToResults();
          //   }}
          // />
        }
        onClick={navigateToResults}
        moduleImage={
          <DashboardContext.Consumer>
            {({ dashboardData }) =>
              dashboardData.GRAPH?.link ? (
                <img
                  src={`${BASE_URL}${dashboardData.GRAPH?.link}`}
                  alt="graph"
                  className="w-100"
                />
              ) : (
                'Results'
              )
            }
          </DashboardContext.Consumer>
        }
      />
    </Col>
  );
};

export default DashboardResultsModule;

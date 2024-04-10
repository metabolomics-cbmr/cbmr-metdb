import { useHistory } from 'react-router';
import { ROUTES } from '../../../../Routes';
import { MISSING_COMPOUNDS } from '../../../../shared/constants/missing-files';
import Card from '../../../atoms/Card';
import DashboardContext from '../dashboard.context';

const MissingCompoundsRow = ({ index, missingCompound, count }) => {
  const history = useHistory();
  const navigateToRecords = () =>
    history.push(ROUTES.RECORDS.replace(':recordName', missingCompound));

  const missingCompoundString = missingCompound
    .replace('MISSING_', '')
    .replace('KEY', ' key');
  const type = missingCompoundString
    ? `Number of Compounds where ${missingCompoundString} is missing`
    : '';
  return (
    <tr
      className={`${
        index < MISSING_COMPOUNDS.length - 1 ? 'border-bottom' : ''
      } table__row--hoverable`}
      onClick={navigateToRecords}
    >
      <td className="p-3 text-center table-text">{index + 1}</td>
      <td className="p-3 table-text">{type}</td>
      <td className="p-3 table-text">{count}</td>
    </tr>
  );
};

const DashboardMissingData = () => {
  return (
    <div className="d-flex flex-wrap">
      <div className="d-flex justify-content-between w-100 mb-3">
        <span className="table-header-text">Missing Data</span>
        {/* <span className="view-all">View All</span> */}
      </div>
      <Card className="p-0 w-100">
        <table className="w-100">
          <thead>
            <tr className="border-bottom">
              <th className="p-3 text-center">Sr. No.</th>
              <th className="p-3">Type</th>
              <th className="p-3">Missing Compounds</th>
            </tr>
          </thead>
          <tbody>
            <DashboardContext.Consumer>
              {({ dashboardData }) => {
                const missingEntries = Object.entries(
                  dashboardData.MISSING_DATA,
                ).length
                  ? Object.entries(dashboardData.MISSING_DATA)
                  : new Array(5).fill(['', '']);
                return missingEntries.map(([missingCompound, count], index) => (
                  <MissingCompoundsRow
                    key={missingCompound}
                    missingCompound={missingCompound}
                    count={count}
                    index={index}
                  />
                ));
              }}
            </DashboardContext.Consumer>
          </tbody>
        </table>
      </Card>
    </div>
  );
};

export default DashboardMissingData;

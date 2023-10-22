import { ROUTES } from '../../../../Routes';
import { ResultLog } from '../../../../shared/model/results.model';
import FileName from '../../../atoms/FileName';
import SearchBar from '../../../atoms/SearchBar';
import TableLayout from '../../../layouts/TableLayout';
import BottomTip from '../../DashboardPage/components/BottomTip';
import { History } from 'history';
import useResultsLogSearch from '../hooks/ResultsLogSearch.hook';

const columns = [
  <th className="p-3">#</th>,
  <th className="p-3">Comparison Id</th>,
  <th className="p-3">File Name</th>,
  <th className="p-3">File Format</th>,
  <th className="p-3">Comparison Date</th>,
  <th className="p-3">View Results</th>,
];

const ResultLogRow = ({
  resultLogEntry,
  index,
  navigateToResult,
}: {
  resultLogEntry: ResultLog;
  index: number;
  navigateToResult: any;
}) => (
  <tr key={resultLogEntry.id} className="border-bottom table__row--hoverabl">
    <th className="p-3" scope="row">
      {index + 1}
    </th>
    <td className="p-3 text-info font-weight-bold text-right">
      {resultLogEntry.id}
    </td>
    <td className="p-3">
      <FileName>{resultLogEntry.file_name}</FileName>
    </td>
    <td className="p-3">{resultLogEntry.file_format}</td>
    <td className="p-3">{resultLogEntry.import_date}</td>
    <td className="p-3 text-primary">
      <BottomTip
        text="View"
        onClick={() => navigateToResult(resultLogEntry.id)}
      ></BottomTip>
    </td>
  </tr>
);

const ResultsLogTable = ({
  results,
  history,
}: {
  results: ResultLog[];
  history: History<any>;
}) => {
  const navigateToResult = (resultId: any) => {
    history.push(ROUTES.RESULTS_RETRIEVAL.replace(':id', resultId));
  };

  const { filteredResults, onSearch } = useResultsLogSearch(results);

  return (
    <>
      <div className="d-flex justify-content-end">
        <SearchBar onSearch={onSearch} />
      </div>
      <TableLayout title="Results of Previous Comparisons" thead={columns}>
        {filteredResults.map((resultLogEntry, index) => (
          <ResultLogRow
            resultLogEntry={resultLogEntry}
            index={index}
            navigateToResult={navigateToResult}
          />
        ))}
      </TableLayout>
    </>
  );
};

export default ResultsLogTable;

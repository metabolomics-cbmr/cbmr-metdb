import DataTable from 'react-data-table-component';
import { useHistory } from 'react-router';
import { ROUTES } from '../../../../Routes';
import { ResultLog } from '../../../../shared/model/results.model';
import Card from '../../../atoms/Card';
import { formatFileName } from '../../../atoms/FileName/FileName';
import SearchBar from '../../../atoms/SearchBar';
import BottomTip from '../../DashboardPage/components/BottomTip';
import useResultsLogSearch from '../hooks/ResultsLogSearch.hook';
import { exportUnknownCompoundDetectionToExcel } from '../../../../shared/utils/api.utils';

const ResultsLogDataTable = ({ results }: { results: ResultLog[] }) => {
  const history = useHistory();

  const handleExportDataToExcel = (resultId: number) => {
    exportUnknownCompoundDetectionToExcel(resultId, false);
  };

  const columns = [
    {
      name: '#',
      cell: (row: ResultLog, index, column) => index + 1,
    },
    {
      name: 'Comparison Id',
      selector: (row: ResultLog) => row.id,
      sortable: true,
    },
    {
      name: 'File Name',
      selector: (row: ResultLog) => formatFileName(row.file_name),
      sortable: true,
    },
    {
      name: 'File Format',
      selector: (row: ResultLog) => row.file_format,
      sortable: true,
    },
    {
      name: 'Comparison Date',
      selector: (row: ResultLog) => row.import_date,
      sortable: true,
    },
    {
      name: 'View Results',
      cell: (row: ResultLog) => (
        <BottomTip
          text="View"
          onClick={() => navigateToResult(row.id)}
        ></BottomTip>
      ),
    },
    {
      name: 'Export to Excel',
      cell: (row: ResultLog) => (
        <BottomTip
          text="Export"
          onClick={() => handleExportDataToExcel(row.id)}
        ></BottomTip>
      ),
    },
  ];

  const navigateToResult = (resultId: any) => {
    history.push(ROUTES.RESULTS_RETRIEVAL.replace(':id', resultId));
  };

  const { filteredResults, onSearch } = useResultsLogSearch(results);

  return (
    <>
      <div className="d-flex justify-content-end">
        <SearchBar onSearch={onSearch} />
      </div>
      <div className="d-flex flex-wrap">
        <div className="d-flex justify-content-between w-100 mb-3">
          <span className="table-header-text">
            Results of Previous Comparisons
          </span>
        </div>
        <Card className="p-0 w-100">
          <DataTable
            columns={columns}
            data={filteredResults}
            highlightOnHover
          />
        </Card>
      </div>
    </>
  );
};

export default ResultsLogDataTable;

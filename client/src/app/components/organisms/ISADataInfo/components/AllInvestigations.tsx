import { useState } from 'react';
import DataTable from 'react-data-table-component';
import { useHistory } from 'react-router';
import { ISADataDetails } from '../../../../shared/model/isadata-details.model';
import Card from '../../../atoms/Card';
import ErrorBoundary from '../../../organisms/ErrorBoundary';
import { SectionTitle } from '../../../templates/DashboardPage/Dashboard.style';
import  useISADataInfo  from '../useISADataInfo.hook';
import './AllInvestigations.style.scss';
import { ROUTES } from '../../../../Routes';

const SubTitle = () => {
  const subtitle = "Investigations";
  return <SectionTitle>{subtitle}</SectionTitle>;
};

const getColumns = () => {
 

  return (
     [
        {
          name: '#',
          cell: (row, index) => index + 1,  //RDT provides index by default
          width:"100px",
        },
        {
          name: 'Investigation Id',
          selector: (row: ISADataDetails) => row['investigation_id'],
          width:"150px",
          cell: (row) => <div className="invid-align noclick" >{row["investigation_id"]}</div>

          
        },
        {
          name: 'Title',
          selector: (row: ISADataDetails) => row['title'],
          cell: (row) => <div className="text-wrap noclick">{row["title"]}</div>        },
        {
            name: 'Description',
            selector: (row: ISADataDetails) => row['description'],
            width:"50%",
            cell: (row) => <div className="text-wrap noclick">{row["description"]}</div>

            
            
          }
  
      ]
  )
};

const AllInvestigations = () => {
  const [page, setPage] = useState(1);
  const [rowsPerPage, setRowsPerPage] = useState(10);

  const history = useHistory();

  const navigateToRecords = (row) => {
    history.push(ROUTES.ISADATA_RETRIEVAL.replace(':id', row["investigation_id"]));
  }



  const {
    records: allCompounds,
    loading,
    totalRecords,
  } = useISADataInfo<ISADataDetails[]>(
    [],
    `${page},${rowsPerPage}`,
  );

  const columns = getColumns();

  return (
    <ErrorBoundary>
      <SubTitle />
      <Card className="w-100 p-5" >
        <div className="d-flex justify-content-between w-100 mb-3">
          <span className="table-header-text">Output</span>
        </div>
        <DataTable
          columns={columns}
          data={allCompounds}
          pagination
          paginationServer
          paginationTotalRows={totalRecords}
          progressPending={loading}
          onChangeRowsPerPage={setRowsPerPage}
          onChangePage={setPage}
          highlightOnHover 
          onRowClicked ={navigateToRecords}
        />
      </Card>
    </ErrorBoundary>
  );
};

export default AllInvestigations;

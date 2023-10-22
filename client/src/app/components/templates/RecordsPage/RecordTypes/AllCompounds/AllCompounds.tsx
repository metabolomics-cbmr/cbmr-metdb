import { useState } from 'react';
import DataTable from 'react-data-table-component';
import { useHistory } from 'react-router';
import { AllCompoundsRecord } from '../../../../../shared/model/records.model';
import Card from '../../../../atoms/Card';
import ErrorBoundary from '../../../../organisms/ErrorBoundary';
import Header from '../../../../organisms/Header';
import { SectionTitle } from '../../../DashboardPage/Dashboard.style';
import { useRecords } from '../../records.hook';
import './AllCompounds.style.scss';
import arrowLeft from '../../../../../../assets/images/arrow-left.svg';

const EXPANDED_COMPOUND_DESC_ORDER_MAP = {
  'Compound Name': 'Compound Name',
  name_corrected: 'Name Corrected',
  polarity: 'Polarity',
  'Molecular Formula': 'Molecular Formula',
  'Mono Molecular Mass': 'Mono Molecular Mass',
  'Has Adduct H?': 'Has Adduct H?',
  'Has Adduct Na?': 'Has Adduct Na?',
  'Has Adduct K?': 'Has Adduct K?',
  'Has Adduct Fa?': 'Has Adduct Fa?',
  'Has Fragment Loss H2O': 'Has Fragment Loss H2O',
  'Has Fragment Loss HCOOH?': 'Has Fragment Loss HCOOH?',
  'Has Fragment Loss Fa?': 'Has Fragment Loss Fa?',
  'PubChem Id': 'PubChem Id',
  'PubChem Url': 'PubChem Url',
  'PubChem SId': 'PubChem SId',
  'Extra PubChem Ids': 'Extra PubChem Ids',
  cas: 'CAS',
  'KEGG Id': 'KEGG Id',
  'HMDB YMDB Id': 'HMDB YMDB Id',
  'METLIN Id': 'METLIN Id',
  chebi: 'CheBi',
  SMILES: 'SMILES',
  'Canonical SMILES': 'Canonical SMILES',
  'InChi Key': 'InChi Key',
  'Class Chemical Taxonomy': 'Class Chemical Taxonomy',
  'Sub Class Chemical Taxonomy': 'Sub Class Chemical Taxonomy',
  'Supplier Category No': 'Supplier Category No',
  'Supplier Product Name': 'Supplier Product Name',
  'Biospecimen Locations': 'Biospecimen Locations',
  'Tissue Locations': 'Tissue Locations',
};

const ExpandedCompound = ({ data }: { data: AllCompoundsRecord }) => {
  return (
    <table className="table m-5">
      <thead>
        <th>Description</th>
        <th>Value</th>
      </thead>
      <tbody>
        {Object.entries(EXPANDED_COMPOUND_DESC_ORDER_MAP).map(
          ([key, description]) => (
            <tr>
              <th scope="row" className="text-capitalize">
                {description}
              </th>
              <td>{data?.[key]}</td>
            </tr>
          ),
        )}
      </tbody>
    </table>
  );
};

const SubTitle = ({ recordName }) => {
  const subtitle = recordName.includes('MISSING')
    ? `Number of Compounds where ${recordName
        .replace('MISSING_', '')
        .replace('KEY', ' key')} is missing`
    : recordName === 'TOTAL_COMPOUNDS'
    ? 'Total Number of Compounds'
    : recordName.replace(/_/g, ' ');
  return <SectionTitle>{subtitle}</SectionTitle>;
};

const getColumns = (recordName) => {
  return recordName === 'MISSING_MS2'
    ? [
        {
          name: 'Compound Name',
          selector: (row: AllCompoundsRecord) => row['Compound Name'],
          sortable: true,
        },
        {
          name: 'ion',
          selector: (row: AllCompoundsRecord) => row['ion'],
        },
        {
          name: 'File Name',
          selector: (row: AllCompoundsRecord) => row['File Name'],
        },
      ]
    : [
        {
          name: 'Compound Name',
          selector: (row: AllCompoundsRecord) => row['Compound Name'],
          sortable: true,
        },
        {
          name: 'PubChem Id',
          selector: (row: AllCompoundsRecord) => row['PubChem Id'],
        },
        {
          name: 'PubChem Url',
          cell: (row: AllCompoundsRecord) => (
            <a
              href={row['PubChem Url']}
              target="_blank"
              rel="noreferrer"
              className="cursor-pointer"
            >
              {row['PubChem Url']}
            </a>
          ),
        },
        {
          name: 'Molecular Formula',
          selector: (row: AllCompoundsRecord) => row['Molecular Formula'],
        },
        {
          name: 'Smiles',
          selector: (row: AllCompoundsRecord) => row['smiles'],
        },
      ];
};

const AllCompounds = ({ recordName }) => {
  const [page, setPage] = useState(1);
  const [rowsPerPage, setRowsPerPage] = useState(10);

  const history = useHistory();

  const {
    records: allCompounds,
    loading,
    totalRecords,
  } = useRecords<AllCompoundsRecord[]>(
    [],
    recordName,
    `${page},${rowsPerPage}`,
  );

  const columns = getColumns(recordName);

  return (
    <ErrorBoundary>
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
      <SubTitle recordName={recordName} />
      <Card className="w-100 p-5">
        <div className="d-flex justify-content-between w-100 mb-3">
          <span className="table-header-text">Output</span>
        </div>
        <DataTable
          columns={columns}
          data={allCompounds}
          expandableRows
          expandableRowsComponent={ExpandedCompound}
          pagination
          paginationServer
          paginationTotalRows={totalRecords}
          progressPending={loading}
          onChangeRowsPerPage={setRowsPerPage}
          onChangePage={setPage}
          highlightOnHover
        />
      </Card>
    </ErrorBoundary>
  );
};

export default AllCompounds;
